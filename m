From: akpm@linux-foundation.org
Subject: - uml-remove-map_cb.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:38:39 -0800
Message-ID: <200802052238.m15McKDt012941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54469 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762647AbYBEWmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, jreiser@BitWagon.com, mm-commits@vger.kernel.org


The patch titled
     uml: remove map_cb
has been removed from the -mm tree.  Its filename was
     uml-remove-map_cb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: remove map_cb
From: Jeff Dike <jdike@addtoit.com>

John Reiser noticed that a physical memory region was being mapped twice.

This patch fixes that, and it inlines the responsible function, as that had
only one caller.

Cc: John Reiser <jreiser@BitWagon.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/mem.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN arch/um/kernel/mem.c~uml-remove-map_cb arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~uml-remove-map_cb
+++ a/arch/um/kernel/mem.c
@@ -36,11 +36,6 @@ int kmalloc_ok = 0;
 /* Used during early boot */
 static unsigned long brk_end;
 
-static void map_cb(void *unused)
-{
-	map_memory(brk_end, __pa(brk_end), uml_reserved - brk_end, 1, 1, 0);
-}
-
 #ifdef CONFIG_HIGHMEM
 static void setup_highmem(unsigned long highmem_start,
 			  unsigned long highmem_len)
@@ -68,8 +63,7 @@ void __init mem_init(void)
 	 * to be turned on.
 	 */
 	brk_end = (unsigned long) UML_ROUND_UP(sbrk(0));
-	map_cb(NULL);
-	initial_thread_cb(map_cb, NULL);
+	map_memory(brk_end, __pa(brk_end), uml_reserved - brk_end, 1, 1, 0);
 	free_bootmem(__pa(brk_end), uml_reserved - brk_end);
 	uml_reserved = brk_end;
 
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
