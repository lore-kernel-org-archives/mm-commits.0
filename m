From: akpm@linux-foundation.org
Subject: [folded] fork-use-vma_pages-to-simplify-the-code-fix.patch removed from -mm tree
Date: Mon, 30 Jul 2012 14:26:38 -0700
Message-ID: <20120730212639.9211F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:64943 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2G3V0l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jul 2012 17:26:41 -0400
Received: by eekd4 with SMTP id d4so247837eek.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 14:26:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, shijie8@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fork-use-vma_pages-to-simplify-the-code-fix
has been removed from the -mm tree.  Its filename was
     fork-use-vma_pages-to-simplify-the-code-fix.patch

This patch was dropped because it was folded into fork-use-vma_pages-to-simplify-the-code.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fork-use-vma_pages-to-simplify-the-code-fix

initialise `len' at its definition site

Cc: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/fork.c~fork-use-vma_pages-to-simplify-the-code-fix kernel/fork.c
--- a/kernel/fork.c~fork-use-vma_pages-to-simplify-the-code-fix
+++ a/kernel/fork.c
@@ -388,8 +388,8 @@ static int dup_mmap(struct mm_struct *mm
 		}
 		charge = 0;
 		if (mpnt->vm_flags & VM_ACCOUNT) {
-			unsigned long len;
-			len = vma_pages(mpnt);
+			unsigned long len = vma_pages(mpnt);
+
 			if (security_vm_enough_memory_mm(oldmm, len)) /* sic */
 				goto fail_nomem;
 			charge = len;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kernel-sysc-avoid-argv_freenull.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight.patch
firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
minixfs-fix-block-limit-check.patch
kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch
include-linux-aioh-cpp-c-conversions.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch

