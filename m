From: akpm@linux-foundation.org
Subject: [folded-merged] procfs-add-vmflags-field-in-smaps-output-v4-fix.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:47:11 -0800
Message-ID: <20121217234712.453F282004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:53908 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab2LQXrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:47:14 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so714810yhl.5
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:47:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, gorcunov@openvz.org, sfr@canb.auug.org.au, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-add-vmflags-field-in-smaps-output-v4-fix
has been removed from the -mm tree.  Its filename was
     procfs-add-vmflags-field-in-smaps-output-v4-fix.patch

This patch was dropped because it was folded into procfs-add-vmflags-field-in-smaps-output-v4.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-add-vmflags-field-in-smaps-output-v4-fix

remove unneeded brakes per sfr, avoid using bloaty for_each_set_bit()

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/proc/task_mmu.c~procfs-add-vmflags-field-in-smaps-output-v4-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-add-vmflags-field-in-smaps-output-v4-fix
+++ a/fs/proc/task_mmu.c
@@ -535,7 +535,7 @@ static void show_smap_vma_flags(struct s
 		/*
 		 * In case if we meet a flag we don't know about.
 		 */
-		[0 ... (BITS_PER_LONG-1)] = { "??" },
+		[0 ... (BITS_PER_LONG-1)] = "??",
 
 		[ilog2(VM_READ)]	= "rd",
 		[ilog2(VM_WRITE)]	= "wr",
@@ -568,10 +568,11 @@ static void show_smap_vma_flags(struct s
 	size_t i;
 
 	seq_puts(m, "VmFlags: ");
-	for_each_set_bit(i, &vma->vm_flags, BITS_PER_LONG) {
-		seq_printf(m, "%c%c ",
-			   mnemonics[i][0],
-			   mnemonics[i][1]);
+	for (i = 0; i < BITS_PER_LONG; i++) {
+		if (vma->vm_flags & (1UL << i)) {
+			seq_printf(m, "%c%c ",
+				   mnemonics[i][0], mnemonics[i][1]);
+		}
 	}
 	seq_putc(m, '\n');
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
create-non-empty-arch-x86-include-uapi-asm-files.patch
mm-memoryc-suppress-warning.patch
lseek-the-whence-argument-is-called-whence.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch
backlight-add-of_find_backlight_by_node-function.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch

