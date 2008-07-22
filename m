From: akpm@linux-foundation.org
Subject: - proc-fix-proc-pagemap-some-more.patch removed from -mm tree
Date: Tue, 22 Jul 2008 14:32:20 -0700
Message-ID: <200807222132.m6MLWKw2018703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755579AbYGVVdF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 17:33:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, snakebyte@gmx.de, stable@kernel.org, vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: fix /proc/*/pagemap some more
has been removed from the -mm tree.  Its filename was
     proc-fix-proc-pagemap-some-more.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: fix /proc/*/pagemap some more
From: Alexey Dobriyan <adobriyan@gmail.com>

struct pagemap_walk was placed on stack, some hooks are initialized, the rest
(->pgd_entry, ->pud_entry, ->pte_entry) are valid but junk.

Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: <stable@kernel.org> [2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~proc-fix-proc-pagemap-some-more fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-fix-proc-pagemap-some-more
+++ a/fs/proc/task_mmu.c
@@ -636,7 +636,7 @@ static ssize_t pagemap_read(struct file 
 	struct pagemapread pm;
 	int pagecount;
 	int ret = -ESRCH;
-	struct mm_walk pagemap_walk;
+	struct mm_walk pagemap_walk = {};
 	unsigned long src;
 	unsigned long svpfn;
 	unsigned long start_vaddr;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
cifs-switch-to-seq_files.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proc-always-do-release.patch
proc-always-do-release-fix.patch
proc-remove-pathetic-remount-code.patch
proc-move-kconfig-to-fs-proc-kconfig.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch
slb-drop-kmem-cache-argument-from-constructor.patch
slb-drop-kmem-cache-argument-from-constructor-fix.patch
use-warn-in-fs-proc.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

