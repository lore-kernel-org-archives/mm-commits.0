From: akpm@linux-foundation.org
Subject: + tidy-up-usermode-helper-waiting-a-bit-fix.patch added to -mm tree
Date: Fri, 11 May 2007 13:38:26 -0700
Message-ID: <200705112038.l4BKcQv6026124@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757326AbXEKUjS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 16:39:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, johannes@sipsolutions.net


The patch titled
     tidy-up-usermode-helper-waiting-a-bit fix
has been added to the -mm tree.  Its filename is
     tidy-up-usermode-helper-waiting-a-bit-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tidy-up-usermode-helper-waiting-a-bit fix
From: Jeremy Fitzhardinge <jeremy@goop.org>

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
loop_probe-fix-return-value.patch
x86-use-elfnoteh-to-generate-vsyscall-notes.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
i386-move-common-parts-of-smp-into-their-own-file.patch
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
add-kstrndup.patch
add-argv_split.patch
split-usermodehelper-setup-from-execution.patch
add-common-orderly_poweroff.patch
tidy-up-usermode-helper-waiting-a-bit.patch
tidy-up-usermode-helper-waiting-a-bit-fix.patch
lguest-the-guest-code.patch
