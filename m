From: akpm@linux-foundation.org
Subject: + mm-consider-the-entire-user-address-space-during-node-migration.patch added to -mm tree
Date: Wed, 19 May 2010 12:38:09 -0700
Message-ID: <201005191938.o4JJc9Wp031821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110Ab0ESTjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 15:39:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, balbir@in.ibm.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, nishimura@mxp.nes.nec.co.jp


The patch titled
     mm: consider the entire user address space during node migration
has been added to the -mm tree.  Its filename is
     mm-consider-the-entire-user-address-space-during-node-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: consider the entire user address space during node migration
From: Greg Thelen <gthelen@google.com>

Use mm->task_size instead of TASK_SIZE to ensure that the entire user
address space is migrated.  mm->task_size is independent of the calling
task context.  TASK SIZE may be dependant on the address space size of the
calling process.  Usage of TASK_SIZE can lead to partial address space
migration if the calling process was 32 bit and the migrating process was
64 bit.

Here is the test script used on 64 system with a 32 bit echo process:

  mount -t cgroup none /cgroup -o cpuset
  cd /cgroup

  mkdir 0
  echo 1 > 0/cpuset.cpus
  echo 0 > 0/cpuset.mems
  echo 1 > 0/cpuset.memory_migrate

  mkdir 1
  echo 1 > 1/cpuset.cpus
  echo 1 > 1/cpuset.mems
  echo 1 > 1/cpuset.memory_migrate

  echo $$ > 0/tasks
  64_bit_process &
  pid=$!

  echo $pid > 1/tasks   # This does not migrate all process pages without
                        # this patch.  If 64 bit echo is used or this patch is
                        # applied, then the full address space of $pid is
                        # migrated.

To check memory migration, I watched:
  grep MemUsed /sys/devices/system/node/node*/meminfo

Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-consider-the-entire-user-address-space-during-node-migration mm/mempolicy.c
--- a/mm/mempolicy.c~mm-consider-the-entire-user-address-space-during-node-migration
+++ a/mm/mempolicy.c
@@ -928,7 +928,7 @@ static int migrate_to_node(struct mm_str
 	nodes_clear(nmask);
 	node_set(source, nmask);
 
-	check_range(mm, mm->mmap->vm_start, TASK_SIZE, &nmask,
+	check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
 
 	if (!list_empty(&pagelist))
_

Patches currently in -mm which might be from gthelen@google.com are

linux-next.patch
sparsemem-on-no-vmemmap-path-put-mem_map-on-node-high-too.patch
mm-consider-the-entire-user-address-space-during-node-migration.patch

