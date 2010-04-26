From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-prepare-migration.patch removed from -mm tree
Date: Mon, 26 Apr 2010 10:25:58 -0400
Message-ID: <201004261727.o3QHRWSW009041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753041Ab0DZR16 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 13:27:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     memcg: fix prepare migration
has been removed from the -mm tree.  Its filename was
     memcg-fix-prepare-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix prepare migration
From: Andrea Arcangeli <aarcange@redhat.com>

If a signal is pending (task being killed by sigkill)
__mem_cgroup_try_charge will write NULL into &mem, and css_put will oops
on null pointer dereference.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
IP: [<ffffffff810fc6cc>] mem_cgroup_prepare_migration+0x7c/0xc0
PGD a5d89067 PUD a5d8a067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/platform/microcode/firmware/microcode/loading
CPU 0
Modules linked in: nfs lockd nfs_acl auth_rpcgss sunrpc acpi_cpufreq pcspkr sg [last unloaded: microcode]

Pid: 5299, comm: largepages Tainted: G        W  2.6.34-rc3 #3 Penryn1600SLI-110dB/To Be Filled By O.E.M.
RIP: 0010:[<ffffffff810fc6cc>]  [<ffffffff810fc6cc>] mem_cgroup_prepare_migration+0x7c/0xc0

[nishimura@mxp.nes.nec.co.jp: fix merge issues]
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-prepare-migration mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-prepare-migration
+++ a/mm/memcontrol.c
@@ -2429,11 +2429,11 @@ int mem_cgroup_prepare_migration(struct 
 	}
 	unlock_page_cgroup(pc);
 
+	*ptr = mem;
 	if (mem) {
-		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false);
+		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, ptr, false);
 		css_put(&mem->css);
 	}
-	*ptr = mem;
 	return ret;
 }
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
define-madv_hugepage.patch
mincore-cleanups.patch
mincore-break-do_mincore-into-logical-pieces.patch
mincore-pass-ranges-as-startend-address-pairs.patch
mincore-do-nested-page-table-walks.patch
mmcompaction-memory-compaction-core.patch
mm-document-follow_page.patch

