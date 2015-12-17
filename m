From: akpm@linux-foundation.org
Subject: + documentation-cgroup-add-memoryswapcurrentmax-description.patch added to -mm tree
Date: Thu, 17 Dec 2015 13:59:57 -0800
Message-ID: <5673305d.T0ZoxWSQyJ7l6IkZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828AbbLQV76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Dec 2015 16:59:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: cgroup: add memory.swap.{current,max} description
has been added to the -mm tree.  Its filename is
     documentation-cgroup-add-memoryswapcurrentmax-description.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-cgroup-add-memoryswapcurrentmax-description.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-cgroup-add-memoryswapcurrentmax-description.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: Documentation: cgroup: add memory.swap.{current,max} description

The rationale of separate swap counter is given by Johannes Weiner.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroup.txt |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff -puN Documentation/cgroup.txt~documentation-cgroup-add-memoryswapcurrentmax-description Documentation/cgroup.txt
--- a/Documentation/cgroup.txt~documentation-cgroup-add-memoryswapcurrentmax-description
+++ a/Documentation/cgroup.txt
@@ -819,6 +819,22 @@ PAGE_SIZE multiple when read back.
 		the cgroup.  This may not exactly match the number of
 		processes killed but should generally be close.
 
+  memory.swap.current
+
+	A read-only single value file which exists on non-root
+	cgroups.
+
+	The total amount of swap currently being used by the cgroup
+	and its descendants.
+
+  memory.swap.max
+
+	A read-write single value file which exists on non-root
+	cgroups.  The default is "max".
+
+	Swap usage hard limit.  If a cgroup's swap usage reaches this
+	limit, anonymous meomry of the cgroup will not be swapped out.
+
 
 5-2-2. General Usage
 
@@ -1291,3 +1307,20 @@ allocation from the slack available in o
 system than killing the group.  Otherwise, memory.max is there to
 limit this type of spillover and ultimately contain buggy or even
 malicious applications.
+
+The combined memory+swap accounting and limiting is replaced by real
+control over swap space.
+
+The main argument for a combined memory+swap facility in the original
+cgroup design was that global or parental pressure would always be
+able to swap all anonymous memory of a child group, regardless of the
+child's own (possibly untrusted) configuration.  However, untrusted
+groups can sabotage swapping by other means - such as referencing its
+anonymous memory in a tight loop - and an admin can not assume full
+swappability when overcommitting untrusted jobs.
+
+For trusted jobs, on the other hand, a combined counter is not an
+intuitive userspace interface, and it flies in the face of the idea
+that cgroup controllers should account and limit specific physical
+resources.  Swap space is a resource like all others in the system,
+and that's why unified hierarchy allows distributing it separately.
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

revert-kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
revert-gfp-add-__gfp_noaccount.patch
memcg-only-account-kmem-allocations-marked-as-__gfp_account.patch
slab-add-slab_account-flag.patch
vmalloc-allow-to-account-vmalloc-to-memcg.patch
account-certain-kmem-allocations-to-memcg.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2.patch
memcg-do-not-allow-to-disable-tcp-accounting-after-limit-is-set.patch
mm-add-page_check_address_transhuge-helper.patch
mm-add-page_check_address_transhuge-helper-fix.patch
mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2.patch
net-drop-tcp_memcontrolc.patch
mm-memcontrol-charge-swap-to-cgroup2.patch
mm-vmscan-pass-memcg-to-get_scan_count.patch
mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online.patch
swaph-move-memcg-related-stuff-to-the-end-of-the-file.patch
mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit.patch
mm-free-swap-cache-aggressively-if-memcg-swap-is-full.patch
documentation-cgroup-add-memoryswapcurrentmax-description.patch

