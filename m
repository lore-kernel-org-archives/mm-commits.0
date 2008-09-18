From: akpm@linux-foundation.org
Subject: + rtc-fix-kernel-panic-on-second-use-of-sigio-nofitication.patch added to -mm tree
Date: Wed, 17 Sep 2008 17:46:51 -0700
Message-ID: <200809180046.m8I0kpxt006551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752498AbYIRArX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 20:47:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, alessandro.zummo@towertech.it, dbrownell@users.sourceforge.net, stable@kernel.org


The patch titled
     rtc: fix kernel panic on second use of SIGIO nofitication
has been added to the -mm tree.  Its filename is
     rtc-fix-kernel-panic-on-second-use-of-sigio-nofitication.patch

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
Subject: rtc: fix kernel panic on second use of SIGIO nofitication
From: Marcin Slusarz <marcin.slusarz@gmail.com>

When userspace uses SIGIO notification and forgets to disable it before
closing file descriptor, rtc->async_queue contains stale pointer to struct
file.  When user space enables again SIGIO notification in different
process, kernel dereferences this (poisoned) pointer and crashes.

So disable SIGIO notification on close.

Kernel panic:
(second run of qemu (requires echo 1024 > /sys/class/rtc/rtc0/max_user_freq))

general protection fault: 0000 [1] PREEMPT
CPU 0
Modules linked in: af_packet snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq usbhid tuner tea5767 tda8290 tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761 tda9875 uhci_hcd ehci_hcd usbcore bttv snd_via82xx snd_ac97_codec ac97_bus snd_pcm snd_timer ir_common compat_ioctl32 snd_page_alloc videodev v4l1_compat snd_mpu401_uart snd_rawmidi v4l2_common videobuf_dma_sg videobuf_core snd_seq_device snd btcx_risc soundcore tveeprom i2c_viapro
Pid: 5781, comm: qemu-system-x86 Not tainted 2.6.27-rc6 #363
RIP: 0010:[<ffffffff8024f891>]  [<ffffffff8024f891>] __lock_acquire+0x3db/0x73f
RSP: 0000:ffffffff80674cb8  EFLAGS: 00010002
RAX: ffff8800224c62f0 RBX: 0000000000000046 RCX: 0000000000000002
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8800224c62f0
RBP: ffffffff80674d08 R08: 0000000000000002 R09: 0000000000000001
R10: ffffffff80238941 R11: 0000000000000001 R12: 0000000000000000
R13: 6b6b6b6b6b6b6b6b R14: ffff88003a450080 R15: 0000000000000000
FS:  00007f98b69516f0(0000) GS:ffffffff80623200(0000) knlGS:00000000f7cc86d0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000a87000 CR3: 0000000022598000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process qemu-system-x86 (pid: 5781, threadinfo ffff880028812000, task ffff88003a450080)
Stack:  ffffffff80674cf8 0000000180238440 0000000200000002 0000000000000000
 ffff8800224c62f0 0000000000000046 0000000000000000 0000000000000002
 0000000000000002 0000000000000000 ffffffff80674d68 ffffffff8024fc7a
Call Trace:
 <IRQ>  [<ffffffff8024fc7a>] lock_acquire+0x85/0xa9
 [<ffffffff8029cb62>] ? send_sigio+0x2a/0x184
 [<ffffffff80491d1f>] _read_lock+0x3e/0x4a
 [<ffffffff8029cb62>] ? send_sigio+0x2a/0x184
 [<ffffffff8029cb62>] send_sigio+0x2a/0x184
 [<ffffffff8024fb97>] ? __lock_acquire+0x6e1/0x73f
 [<ffffffff8029cd4d>] ? kill_fasync+0x2c/0x4e
 [<ffffffff8029cd10>] __kill_fasync+0x54/0x65
 [<ffffffff8029cd5b>] kill_fasync+0x3a/0x4e
 [<ffffffff80402896>] rtc_update_irq+0x9c/0xa5
 [<ffffffff80404640>] cmos_interrupt+0xae/0xc0
 [<ffffffff8025d1c1>] handle_IRQ_event+0x25/0x5a
 [<ffffffff8025e5e4>] handle_edge_irq+0xdd/0x123
 [<ffffffff8020da34>] do_IRQ+0xe4/0x144
 [<ffffffff8020bad6>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8026fdc2>] ? __alloc_pages_internal+0xe7/0x3ad
 [<ffffffff8033fe67>] ? clear_page_c+0x7/0x10
 [<ffffffff8026fc10>] ? get_page_from_freelist+0x385/0x450
 [<ffffffff8026fdc2>] ? __alloc_pages_internal+0xe7/0x3ad
 [<ffffffff80280aac>] ? anon_vma_prepare+0x2e/0xf6
 [<ffffffff80279400>] ? handle_mm_fault+0x227/0x6a5
 [<ffffffff80494716>] ? do_page_fault+0x494/0x83f
 [<ffffffff8049251d>] ? error_exit+0x0/0xa9

Code: cc 41 39 45 28 74 24 e8 5e 1d 0f 00 85 c0 0f 84 6a 03 00 00 83 3d 8f a9 aa 00 00 be 47 03 00 00 0f 84 6a 02 00 00 e9 53 03 00 00 <41> ff 85 38 01 00 00 45 8b be 90 06 00 00 41 83 ff 2f 76 24 e8
RIP  [<ffffffff8024f891>] __lock_acquire+0x3db/0x73f
 RSP <ffffffff80674cb8>
---[ end trace 431877d860448760 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-dev.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-dev.c~rtc-fix-kernel-panic-on-second-use-of-sigio-nofitication drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-fix-kernel-panic-on-second-use-of-sigio-nofitication
+++ a/drivers/rtc/rtc-dev.c
@@ -422,6 +422,12 @@ done:
 	return err;
 }
 
+static int rtc_dev_fasync(int fd, struct file *file, int on)
+{
+	struct rtc_device *rtc = file->private_data;
+	return fasync_helper(fd, file, on, &rtc->async_queue);
+}
+
 static int rtc_dev_release(struct inode *inode, struct file *file)
 {
 	struct rtc_device *rtc = file->private_data;
@@ -434,16 +440,13 @@ static int rtc_dev_release(struct inode 
 	if (rtc->ops->release)
 		rtc->ops->release(rtc->dev.parent);
 
+	if (file->f_flags & FASYNC)
+		rtc_dev_fasync(-1, file, 0);
+
 	clear_bit_unlock(RTC_DEV_BUSY, &rtc->flags);
 	return 0;
 }
 
-static int rtc_dev_fasync(int fd, struct file *file, int on)
-{
-	struct rtc_device *rtc = file->private_data;
-	return fasync_helper(fd, file, on, &rtc->async_queue);
-}
