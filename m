From: akpm@linux-foundation.org
Subject: - fbdev-fix-recursive-notifier-and-locking-when-fbdev-console-is-blanked.patch removed from -mm tree
Date: Tue, 07 Oct 2008 16:38:51 -0700
Message-ID: <200810072338.m97Ncp7f009446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753AbYJGXiz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Oct 2008 19:38:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, dbaryshkov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: fix recursive notifier and locking when fbdev console is blanked
has been removed from the -mm tree.  Its filename was
     fbdev-fix-recursive-notifier-and-locking-when-fbdev-console-is-blanked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: fix recursive notifier and locking when fbdev console is blanked
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix infinite recursive notifier in the fbdev layer.  This causes recursive
locking.  Dmitry Baryshkov found the problem and confirmed that the patch
fixes the bug.

After doing
# echo 1 > /sys/class/graphics/fb0/blank
I got the following in my kernel log:

=============================================
[ INFO: possible recursive locking detected ]
2.6.27-rc6-00086-gda63874-dirty #97
---------------------------------------------
echo/1564 is trying to acquire lock:
 ((fb_notifier_list).rwsem){..--}, at: [<c005a384>] __blocking_notifier_call_chain+0x38/0x6c

but task is already holding lock:
 ((fb_notifier_list).rwsem){..--}, at: [<c005a384>] __blocking_notifier_call_chain+0x38/0x6c

other info that might help us debug this:
2 locks held by echo/1564:
 #0:  (&buffer->mutex){--..}, at: [<c00ddde0>] sysfs_write_file+0x30/0x80
 #1:  ((fb_notifier_list).rwsem){..--}, at: [<c005a384>] __blocking_notifier_call_chain+0x38/0x6c

stack backtrace:
[<c0029fe4>] (dump_stack+0x0/0x14) from [<c0060ce0>] (print_deadlock_bug+0xa4/0xd0)
[<c0060c3c>] (print_deadlock_bug+0x0/0xd0) from [<c0060e54>] (check_deadlock+0x148/0x17c)
 r6:c397a1e0 r5:c397a530 r4:c04fcf98
[<c0060d0c>] (check_deadlock+0x0/0x17c) from [<c00637e8>] (validate_chain+0x3c4/0x4f0)
[<c0063424>] (validate_chain+0x0/0x4f0) from [<c0063efc>] (__lock_acquire+0x5e8/0x6b4)
[<c0063914>] (__lock_acquire+0x0/0x6b4) from [<c006402c>] (lock_acquire+0x64/0x78)
[<c0063fc8>] (lock_acquire+0x0/0x78) from [<c0316ca8>] (down_read+0x4c/0x60)
 r7:00000009 r6:ffffffff r5:c0427a40 r4:c005a384
[<c0316c5c>] (down_read+0x0/0x60) from [<c005a384>] (__blocking_notifier_call_chain+0x38/0x6c)
 r5:c0427a40 r4:c0427a74
[<c005a34c>] (__blocking_notifier_call_chain+0x0/0x6c) from [<c005a3d8>] (blocking_notifier_call_chain+0x20/0x28)
 r8:00000009 r7:c086d640 r6:c3967940 r5:00000000 r4:c38984b8
[<c005a3b8>] (blocking_notifier_call_chain+0x0/0x28) from [<c014baa0>] (fb_notifier_call_chain+0x1c/0x24)
[<c014ba84>] (fb_notifier_call_chain+0x0/0x24) from [<c014c18c>] (fb_blank+0x64/0x70)
[<c014c128>] (fb_blank+0x0/0x70) from [<c0155978>] (fbcon_blank+0x114/0x1bc)
 r5:00000001 r4:c38984b8
[<c0155864>] (fbcon_blank+0x0/0x1bc) from [<c0170ea8>] (do_blank_screen+0x1e0/0x2a0)
[<c0170cc8>] (do_blank_screen+0x0/0x2a0) from [<c0154024>] (fbcon_fb_blanked+0x74/0x94)
 r5:c3967940 r4:00000001
[<c0153fb0>] (fbcon_fb_blanked+0x0/0x94) from [<c0154228>] (fbcon_event_notify+0x100/0x12c)
 r5:fffffffe r4:c39bc194
[<c0154128>] (fbcon_event_notify+0x0/0x12c) from [<c005a0d4>] (notifier_call_chain+0x38/0x7c)
[<c005a09c>] (notifier_call_chain+0x0/0x7c) from [<c005a3a0>] (__blocking_notifier_call_chain+0x54/0x6c)
 r8:c3b51ea0 r7:00000009 r6:ffffffff r5:c0427a40 r4:c0427a74
[<c005a34c>] (__blocking_notifier_call_chain+0x0/0x6c) from [<c005a3d8>] (blocking_notifier_call_chain+0x20/0x28)
 r8:00000001 r7:c3a7e000 r6:00000000 r5:00000000 r4:c38984b8
[<c005a3b8>] (blocking_notifier_call_chain+0x0/0x28) from [<c014baa0>] (fb_notifier_call_chain+0x1c/0x24)
[<c014ba84>] (fb_notifier_call_chain+0x0/0x24) from [<c014c18c>] (fb_blank+0x64/0x70)
[<c014c128>] (fb_blank+0x0/0x70) from [<c014e450>] (store_blank+0x54/0x7c)
 r5:c38984b8 r4:c3b51ec4
[<c014e3fc>] (store_blank+0x0/0x7c) from [<c017981c>] (dev_attr_store+0x28/0x2c)
 r8:00000001 r7:c042bf80 r6:c39eba10 r5:c3967c30 r4:c38e0140
[<c01797f4>] (dev_attr_store+0x0/0x2c) from [<c00ddaac>] (flush_write_buffer+0x54/0x68)
[<c00dda58>] (flush_write_buffer+0x0/0x68) from [<c00dde08>] (sysfs_write_file+0x58/0x80)
 r8:c3b51f78 r7:c3bcb070 r6:c39eba10 r5:00000001 r4:00000001
[<c00dddb0>] (sysfs_write_file+0x0/0x80) from [<c009de04>] (vfs_write+0xb8/0x148)
[<c009dd4c>] (vfs_write+0x0/0x148) from [<c009e384>] (sys_write+0x44/0x70)
 r7:00000004 r6:c3bcb070 r5:00000000 r4:00000000
[<c009e340>] (sys_write+0x0/0x70) from [<c0025d00>] (ret_fast_syscall+0x0/0x2c)
 r6:4001b000 r5:00000001 r4:401dc658

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Reported-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Testted-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/video/console/fbcon.c~fbdev-fix-recursive-notifier-and-locking-when-fbdev-console-is-blanked drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbdev-fix-recursive-notifier-and-locking-when-fbdev-console-is-blanked
+++ a/drivers/video/console/fbcon.c
@@ -2400,11 +2400,15 @@ static int fbcon_blank(struct vc_data *v
 
  	if (!fbcon_is_inactive(vc, info)) {
 		if (ops->blank_state != blank) {
+			int ret = 1;
+
 			ops->blank_state = blank;
 			fbcon_cursor(vc, blank ? CM_ERASE : CM_DRAW);
 			ops->cursor_flash = (!blank);
 
-			if (fb_blank(info, blank))
+			if (info->fbops->fb_blank)
+				ret = info->fbops->fb_blank(blank, info);
+			if (ret)
 				fbcon_generic_blank(vc, info, blank);
 		}
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

git-tip.patch
git-arm.patch
git-sparc.patch
git-sound.patch
fb-metronome-printk-format-warning.patch
mm-rewrite-vmap-layer-fix-fix-fix-fix.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch
viafb-accelc-accelh-update.patch
viafb-viafbdevc-update.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch
neofb-kill-some-redundant-code.patch
vga16fb-remove-open_lock-mutex.patch
neofb-remove-open_lock-mutex.patch
tdfxfb-do-not-make-changes-to-default-tdfx_fix.patch
intelfb-support-945gme-as-used-in-asus-eee-901.patch
cirrusfb-remove-information-about-memory-size-during-mode-change.patch
cirrusfb-simplify-clock-calculation.patch
cirrusfb-remove-24-bpp-mode.patch
cirrusfb-drop-device-pointers-from-cirrusfb_info.patch
cirrusfb-use-modedb-and-add-mode_option-parameter-2nd-rev.patch
cirrusfb-add-__devinit-attribute-to-probing-functions.patch
cirrusfb-eliminate-crt-registers-from-global-structure.patch
cirrusfb-eliminate-crt-registers-from-global-structure-fix-up-debug-printk-types.patch
cirrusfb-drop-clock-fields-from-cirrusfb_regs-structure.patch
cirrusfb-add-noaccel-module-parameter.patch
cirrusfb-fix-16bpp-modes.patch
cirrusfb-do-not-change-mclk-for-alpine-chips.patch
atmel_lcdfb-disallow-setting-larger-resolution-than-the-framebuffer-memory-can-handle.patch
vgacon-vgacon_scrolldelta-simplification.patch
fbdev-ignore-vesa-modes-if-framebuffer-does-not-support-them.patch

