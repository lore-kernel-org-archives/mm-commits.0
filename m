From: akpm@linux-foundation.org
Subject: + fbcon_set_all_vcs-fix-kernel-crash-when-switching-the-rotated-consoles.patch added to -mm tree
Date: Wed, 15 Oct 2008 15:18:40 -0700
Message-ID: <200810152218.m9FMIfRv012931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753698AbYJOWTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 18:19:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, krzysztof.h1@poczta.fm, stable@kernel.org


The patch titled
     fbcon_set_all_vcs: fix kernel crash when switching the rotated consoles
has been added to the -mm tree.  Its filename is
     fbcon_set_all_vcs-fix-kernel-crash-when-switching-the-rotated-consoles.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbcon_set_all_vcs: fix kernel crash when switching the rotated consoles
From: Oleg Nesterov <oleg@tv-sign.ru>

echo 3 >> /sys/class/graphics/fbcon/rotate_all, then switch to another
console. Result:

	BUG: unable to handle kernel paging request at ffffc20005d00000
	IP: [bitfill_aligned+149/265] bitfill_aligned+0x95/0x109
	PGD 7e228067 PUD 7e229067 PMD 7bc1f067 PTE 0
	Oops: 0002 [1] SMP
	CPU 1
	Modules linked in: [...a lot...]
	Pid: 10, comm: events/1 Not tainted 2.6.26.5-45.fc9.x86_64 #1
	RIP: 0010:[bitfill_aligned+149/265]  [bitfill_aligned+149/265] bitfill_aligned+0x95/0x109
	RSP: 0018:ffff81007d811bc8  EFLAGS: 00010216
	RAX: ffffc20005d00000 RBX: 0000000000000000 RCX: 0000000000000400
	RDX: 0000000000000000 RSI: ffffc20005d00000 RDI: ffffffffffffffff
	RBP: ffff81007d811be0 R08: 0000000000000400 R09: 0000000000000040
	R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000010000
	R13: ffffffff811632f0 R14: 0000000000000006 R15: ffff81007cb85400
	FS:  0000000000000000(0000) GS:ffff81007e004780(0000) knlGS:0000000000000000
	CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
	CR2: ffffc20005d00000 CR3: 0000000000201000 CR4: 00000000000006e0
	DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
	DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
	Process events/1 (pid: 10, threadinfo ffff81007d810000, task ffff81007d808000)
	Stack:  ffff81007c9d75a0 0000000000000000 0000000000000000 ffff81007d811c80
	 ffffffff81163a61 ffff810000000000 ffffffff8115f9c8 0000001000000000
	 0000000100aaaaaa 000000007cd0d4a0 fffffd8a00000800 0001000000000000
	Call Trace:
	 [cfb_fillrect+523/798] cfb_fillrect+0x20b/0x31e
	 [soft_cursor+416/436] ? soft_cursor+0x1a0/0x1b4
	 [ccw_clear_margins+205/263] ccw_clear_margins+0xcd/0x107
	 [fbcon_clear_margins+59/61] fbcon_clear_margins+0x3b/0x3d
	 [fbcon_switch+1291/1466] fbcon_switch+0x50b/0x5ba
	 [redraw_screen+261/481] redraw_screen+0x105/0x1e1
	 [ccw_cursor+0/1869] ? ccw_cursor+0x0/0x74d
	 [complete_change_console+48/190] complete_change_console+0x30/0xbe
	 [change_console+115/120] change_console+0x73/0x78
	 [console_callback+0/292] ? console_callback+0x0/0x124
	 [console_callback+97/292] console_callback+0x61/0x124
	 [schedule_delayed_work+25/30] ? schedule_delayed_work+0x19/0x1e
	 [run_workqueue+139/282] run_workqueue+0x8b/0x11a
	 [worker_thread+221/238] worker_thread+0xdd/0xee
	 [autoremove_wake_function+0/56] ? autoremove_wake_function+0x0/0x38
	 [worker_thread+0/238] ? worker_thread+0x0/0xee
	 [kthread+73/118] kthread+0x49/0x76
	 [child_rip+10/18] child_rip+0xa/0x12
	 [kthread+0/118] ? kthread+0x0/0x76
	 [child_rip+0/18] ? child_rip+0x0/0x12

Because fbcon_set_all_vcs()->FBCON_SWAP() uses display->rotate == 0 instead
of fbcon_ops->rotate, and vc_resize() has no effect because it is called with
new_cols/rows == ->vc_cols/rows.

Tested on 2.6.26.5-45.fc9.x86_64, but
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git seems to
have the same problem.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: <stable@kernel.org>	[2.6.27.x, 2.6.26.x, maybe 2.6.25.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon_set_all_vcs-fix-kernel-crash-when-switching-the-rotated-consoles drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon_set_all_vcs-fix-kernel-crash-when-switching-the-rotated-consoles
+++ a/drivers/video/console/fbcon.c
@@ -2977,8 +2977,8 @@ static void fbcon_set_all_vcs(struct fb_
 		p = &fb_display[vc->vc_num];
 		set_blitting_type(vc, info);
 		var_to_display(p, &info->var, info);
-		cols = FBCON_SWAP(p->rotate, info->var.xres, info->var.yres);
-		rows = FBCON_SWAP(p->rotate, info->var.yres, info->var.xres);
+		cols = FBCON_SWAP(ops->rotate, info->var.xres, info->var.yres);
+		rows = FBCON_SWAP(ops->rotate, info->var.yres, info->var.xres);
 		cols /= vc->vc_font.width;
 		rows /= vc->vc_font.height;
 		vc_resize(vc, cols, rows);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-simplify-de_thread-exit_itimers-path.patch
fbcon_set_all_vcs-fix-kernel-crash-when-switching-the-rotated-consoles.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
add-config_core_dump_default_elf_headers.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch
pid_ns-de_thread-kill-the-now-unneeded-child_reaper-change.patch
pid_ns-kill-the-now-unused-task_child_reaper.patch

