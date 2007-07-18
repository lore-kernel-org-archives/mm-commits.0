From: akpm@linux-foundation.org
Subject: - tidy-up-usermode-helper-waiting-a-bit-fix.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:52:36 -0700
Message-ID: <200707181852.l6IIqaYu023691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48109 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759495AbXGRSxt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:53:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, johannes@sipsolutions.net, mm-commits@vger.kernel.org


The patch titled
     tidy-up-usermode-helper-waiting-a-bit fix
has been removed from the -mm tree.  Its filename was
     tidy-up-usermode-helper-waiting-a-bit-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tidy-up-usermode-helper-waiting-a-bit fix
From: Jeremy Fitzhardinge <jeremy@goop.org>

Some fix for xencleanup-tidy-up-usermode-helper-waiting-a-bit.patch

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kmod.c~tidy-up-usermode-helper-waiting-a-bit-fix kernel/kmod.c
--- a/kernel/kmod.c~tidy-up-usermode-helper-waiting-a-bit-fix
+++ a/kernel/kmod.c
@@ -243,7 +243,7 @@ static void __call_usermodehelper(struct
 	/* CLONE_VFORK: wait until the usermode helper has execve'd
 	 * successfully We need the data structures to stay around
 	 * until that is done.  */
-	if (wait == UMH_WAIT_PROC)
+	if (wait == UMH_WAIT_PROC || wait == UMH_NO_WAIT)
 		pid = kernel_thread(wait_for_helper, sub_info,
 				    CLONE_FS | CLONE_FILES | SIGCHLD);
 	else
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
fix-the-softlockup-watchdog-to-actually-work.patch
git-kbuild.patch
fix-x86_64-mm-xen-xen-smp-guest-support.patch
fix-x86_64-mm-xen-xen-event-channels.patch
i386-minor-nx-handling-adjustment.patch
x86-fix-iounmaps-use-of-vm_structs-size-field.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
lguest-the-guest-code.patch
