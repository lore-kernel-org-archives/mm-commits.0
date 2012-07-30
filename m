From: akpm@linux-foundation.org
Subject: [folded] minixfs-fix-block-limit-check-fix.patch removed from -mm tree
Date: Mon, 30 Jul 2012 14:26:04 -0700
Message-ID: <20120730212605.1B39C5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:43638 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752524Ab2G3V0H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2012 17:26:07 -0400
Received: by lagr15 with SMTP id r15so245269lag.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 14:26:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, phcoder@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: minixfs-fix-block-limit-check-fix
has been removed from the -mm tree.  Its filename was
     minixfs-fix-block-limit-check-fix.patch

This patch was dropped because it was folded into minixfs-fix-block-limit-check.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: minixfs-fix-block-limit-check-fix

fix up code layout, use local `sb'

Cc: Vladimir Serbinenko <phcoder@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/itree_v2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/minix/itree_v2.c~minixfs-fix-block-limit-check-fix fs/minix/itree_v2.c
--- a/fs/minix/itree_v2.c~minixfs-fix-block-limit-check-fix
+++ a/fs/minix/itree_v2.c
@@ -32,8 +32,8 @@ static int block_to_path(struct inode * 
 	if (block < 0) {
 		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
 			block, bdevname(sb->s_bdev, b));
-    } else if ((u64) block * (u64) sb->s_blocksize
-           >= minix_sb(inode->i_sb)->s_max_size) {
+	} else if ((u64)block * (u64)sb->s_blocksize >=
+			minix_sb(sb)->s_max_size) {
 		if (printk_ratelimit())
 			printk("MINIX-fs: block_to_path: "
 			       "block %ld too big on dev %s\n",
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
fork-use-vma_pages-to-simplify-the-code-fix.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch
include-linux-aioh-cpp-c-conversions.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch

