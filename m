From: akpm@linux-foundation.org
Subject: + mm-memcontrol-exclude-root-from-checks-in-mem_cgroup_low.patch
 added to -mm tree
Date: Mon, 05 Jun 2017 14:50:19 -0700
Message-ID: <5935d21b.nMKZJpbL8yAMRpuU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52202 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751213AbdFEVuU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2017 17:50:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sean.j.christopherson@intel.com, bsingharora@gmail.com, hannes@cmpxchg.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol: exclude @root from checks in mem_cgroup_low
has been added to the -mm tree.  Its filename is
     mm-memcontrol-exclude-root-from-checks-in-mem_cgroup_low.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-exclude-root-from-checks-in-mem_cgroup_low.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-exclude-root-from-checks-in-mem_cgroup_low.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: mm/memcontrol: exclude @root from checks in mem_cgroup_low

Make @root exclusive in mem_cgroup_low; it is never considered low when
looked at directly and is not checked when traversing the tree.  In
effect, @root is handled identically to how root_mem_cgroup was previously
handled by mem_cgroup_low.

If @root is not excluded from the checks, a cgroup underneath @root will
never be considered low during targeted reclaim of @root, e.g.  due to
memory.current > memory.high, unless @root is misconfigured to have
memory.low > memory.high.

Excluding @root enables using memory.low to prioritize memory usage
between cgroups within a subtree of the hierarchy that is limited by
memory.high or memory.max, e.g.  when ROOT owns @root's controls but
delegates the @root directory to a USER so that USER can create and
administer children of @root.

For example, given cgroup A with children B and C:

    A
   / \
  B   C

and

  1. A/memory.current > A/memory.high
  2. A/B/memory.current < A/B/memory.low
  3. A/C/memory.current >= A/C/memory.low

As 'A' is high, i.e.  triggers reclaim from 'A', and 'B' is low, we should
reclaim from 'C' until 'A' is no longer high or until we can no longer
reclaim from 'C'.  If 'A', i.e.  @root, isn't excluded by mem_cgroup_low
when reclaming from 'A', then 'B' won't be considered low and we will
reclaim indiscriminately from both 'B' and 'C'.

Here is the test I used to confirm the bug and the patch.

20:00:55@sjchrist-vm ? ~ $ cat ~/.bin/memcg_low_test
#!/bin/bash

x62mb=$((62<<20))
x66mb=$((66<<20))
x94mb=$((94<<20))
x98mb=$((98<<20))

setup() {
    set -e

    if [[ -n $DEBUG ]]; then
        set -x
    fi

    trap teardown EXIT HUP INT TERM

    if [[ ! -e /mnt/1gb.swap ]]; then
        sudo fallocate -l 1G /mnt/1gb.swap > /dev/null
        sudo mkswap /mnt/1gb.swap > /dev/null
    fi
    if ! swapon --show=NAME | grep -q "/mnt/1gb.swap"; then
        sudo swapon /mnt/1gb.swap
    fi

    if [[ ! -e /cgroup/cgroup.controllers ]]; then
        sudo mount -t cgroup2 none /cgroup
    fi

    grep -q memory /cgroup/cgroup.controllers

    sudo sh -c "echo '+memory' > /cgroup/cgroup.subtree_control"

    sudo mkdir /cgroup/A && sudo chown $USER:$USER /cgroup/A
    sudo sh -c "echo '+memory' > /cgroup/A/cgroup.subtree_control"
    sudo sh -c "echo '96m' > /cgroup/A/memory.high"

    mkdir /cgroup/A/0
    mkdir /cgroup/A/1

    echo 64m > /cgroup/A/0/memory.low
}

teardown() {
    set +e

    trap - EXIT HUP INT TERM

    if [[ -z $1 ]]; then
        printf "\n"
        printf "%0.s*" {1..35}
        printf "\nFAILED!\n\n"
        tail /cgroup/A/**/memory.current
        printf "%0.s*" {1..35}
        printf "\n\n"
    fi

    ps | grep stress | tr -s ' ' | cut -f 2 -d ' ' | xargs -I % kill %

    sleep 2

    if [[ -e /cgroup/A/0 ]]; then
        rmdir /cgroup/A/0
    fi
    if [[ -e /cgroup/A/1 ]]; then
        rmdir /cgroup/A/1
    fi
    if [[ -e /cgroup/A ]]; then
        sudo rmdir /cgroup/A
    fi
}


stress_test() {
    sudo sh -c "echo $$ > /cgroup/A/$1/cgroup.procs"
    stress --vm 1 --vm-bytes 64M --vm-keep > /dev/null &

    sudo sh -c "echo $$ > /cgroup/A/$2/cgroup.procs"
    stress --vm 1 --vm-bytes 64M --vm-keep > /dev/null &

    sudo sh -c "echo $$ > /cgroup/cgroup.procs"

    sleep 1

    # A/0 should be consuming more memory than A/1
    [[ $(cat /cgroup/A/0/memory.current) -ge $(cat /cgroup/A/1/memory.current) ]]

    # A/0 should be consuming ~64mb
    [[ $(cat /cgroup/A/0/memory.current) -ge $x62mb ]] && [[ $(cat /cgroup/A/0/memory.current) -le $x66mb ]]

    # A should cumulatively be consuming ~96mb
    [[ $(cat /cgroup/A/memory.current) -ge $x94mb ]] && [[ $(cat /cgroup/A/memory.current) -le $x98mb ]]

    # Stop the stressors
    ps | grep stress | tr -s ' ' | cut -f 2 -d ' ' | xargs -I % kill %
}


teardown 1
setup

for ((i=1;i<=$1;i++)); do
    printf "ITERATION $i of $1 - stress_test 0 1"
    stress_test 0 1
    printf "\x1b[2K\r"

    printf "ITERATION $i of $1 - stress_test 1 0"
    stress_test 1 0
    printf "\x1b[2K\r"

    printf "ITERATION $i of $1 - PASSED\n"
done

teardown 1


echo PASSED!


20:11:26@sjchrist-vm ? ~ $ memcg_low_test 10


Link: http://lkml.kernel.org/r/1496434412-21005-1-git-send-email-sean.j.christopherson@intel.com
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   50 +++++++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-exclude-root-from-checks-in-mem_cgroup_low mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-exclude-root-from-checks-in-mem_cgroup_low
+++ a/mm/memcontrol.c
@@ -5317,38 +5317,52 @@ struct cgroup_subsys memory_cgrp_subsys
 
 /**
  * mem_cgroup_low - check if memory consumption is below the normal range
- * @root: the highest ancestor to consider
+ * @root: the top ancestor of the sub-tree being checked
  * @memcg: the memory cgroup to check
  *
  * Returns %true if memory consumption of @memcg, and that of all
- * configurable ancestors up to @root, is below the normal range.
+ * ancestors up to (but not including) @root, is below the normal range.
+ *
+ * @root is exclusive; it is never low when looked at directly and isn't
+ * checked when traversing the hierarchy.
+ *
+ * Excluding @root enables using memory.low to prioritize memory usage
+ * between cgroups within a subtree of the hierarchy that is limited by
+ * memory.high or memory.max.
+ *
+ * For example, given cgroup A with children B and C:
+ *
+ *    A
+ *   / \
+ *  B   C
+ *
+ * and
+ *
+ *  1. A/memory.current > A/memory.high
+ *  2. A/B/memory.current < A/B/memory.low
+ *  3. A/C/memory.current >= A/C/memory.low
+ *
+ * As 'A' is high, i.e. triggers reclaim from 'A', and 'B' is low, we
+ * should reclaim from 'C' until 'A' is no longer high or until we can
+ * no longer reclaim from 'C'.  If 'A', i.e. @root, isn't excluded by
+ * mem_cgroup_low when reclaming from 'A', then 'B' won't be considered
+ * low and we will reclaim indiscriminately from both 'B' and 'C'.
  */
 bool mem_cgroup_low(struct mem_cgroup *root, struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_disabled())
 		return false;
 
-	/*
-	 * The toplevel group doesn't have a configurable range, so
-	 * it's never low when looked at directly, and it is not
-	 * considered an ancestor when assessing the hierarchy.
-	 */
-
-	if (memcg == root_mem_cgroup)
-		return false;
-
-	if (page_counter_read(&memcg->memory) >= memcg->low)
+	if (!root)
+		root = root_mem_cgroup;
+	if (memcg == root)
 		return false;
 
-	while (memcg != root) {
-		memcg = parent_mem_cgroup(memcg);
-
-		if (memcg == root_mem_cgroup)
-			break;
