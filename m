From: akpm@linux-foundation.org
Subject: + fb-convert-lock-unlock_kernel-into-local-fb-mutex-fix.patch added to -mm tree
Date: Fri, 03 Oct 2008 14:46:21 -0700
Message-ID: <200810032146.m93LkLWq017392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307AbYJCVq6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 17:46:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: righi.andrea@gmail.com, krzysztof.h1@poczta.fm


The patch titled
     fb: fix NULL pointer BUG dereference in fb_open()
has been added to the -mm tree.  Its filename is
     fb-convert-lock-unlock_kernel-into-local-fb-mutex-fix.patch

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
Subject: fb: fix NULL pointer BUG dereference in fb_open()
From: Andrea Righi <righi.andrea@gmail.com>

Accessing to an unregistered fb device raises the following bug, because
mutex_unlock() is called on fb_info->lock, but fb_info is NULL.

Also use a better coding style.

[ 5371.204475] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[ 5371.204490] IP: [<ffffffff8048186b>] __mutex_unlock_slowpath+0x4b/0x180
[ 5371.204509] PGD 4e26f067 PUD 3b33d067 PMD 0
[ 5371.204521] Oops: 0002 [11] PREEMPT SMP
[ 5371.204532] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
[ 5371.204542] CPU 0
[ 5371.204548] Modules linked in: fbcon tileblit font bitblit softcursor af_packet rfcomm l2cap kvm_intel kvm i915 drm acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_conservative cpufreq_ondemand cpufreq_powersave freq_table container sbs sbshc dm_mod arc4 snd_hda_intel ecb snd_pcm_oss cryptomgr aead crypto_blkcipher crypto_algapi snd_pcm iwlagn iwlcore btusb snd_timer led_class iTCO_wdt iTCO_vendor_support snd bluetooth mac80211 soundcore psmouse snd_page_alloc cfg80211 video output battery intel_agp button ac evdev dcdbas ext3 jbd mbcache sg sd_mod piix ata_piix libata uhci_hcd ehci_hcd scsi_mod dock usbcore tg3 libphy thermal processor fan fuse
[ 5371.204725] Pid: 23005, comm: lshw Tainted: G      D   2.6.27-rc5-mm1 #44
[ 5371.204731] RIP: 0010:[<ffffffff8048186b>]  [<ffffffff8048186b>] __mutex_unlock_slowpath+0x4b/0x180
[ 5371.204744] RSP: 0018:ffff88003b07dcc8  EFLAGS: 00010046
[ 5371.204750] RAX: 0000000000000100 RBX: 0000000000000008 RCX: 0000000000000000
[ 5371.204756] RDX: ffff880064f84420 RSI: 0000000000000001 RDI: ffffffff80481862
[ 5371.204762] RBP: ffff88003b07dce8 R08: 0000000000000000 R09: 0000000000000001
[ 5371.204767] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[ 5371.204773] R13: 0000000000000010 R14: 0000000000000246 R15: ffff8800686a3000
[ 5371.204780] FS:  00007f671f22a6f0(0000) GS:ffffffff805cd940(0000) knlGS:0000000000000000
[ 5371.204786] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 5371.204792] CR2: 0000000000000010 CR3: 000000004e26c000 CR4: 00000000000026e0
[ 5371.204797] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5371.204803] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5371.204810] Process lshw (pid: 23005, threadinfo ffff88003b07c000, task ffff880064f84420)
[ 5371.204815] Stack:  00000000ffffffed 0000000000000000 0000000000000008 ffffffff802c3030
[ 5371.204833]  ffff88003b07dcf8 ffffffff804819a9 ffff88003b07dd38 ffffffff8037c1f3
[ 5371.204847]  ffffffff802c3030 0000000000000000 ffff88007f043380 ffff88004e0b3a00
[ 5371.204861] Call Trace:
[ 5371.204871]  [<ffffffff802c3030>] ? chrdev_open+0x0/0x1f0
[ 5371.204880]  [<ffffffff804819a9>] mutex_unlock+0x9/0x10
[ 5371.204889]  [<ffffffff8037c1f3>] fb_open+0xc3/0x160
[ 5371.204895]  [<ffffffff802c3030>] ? chrdev_open+0x0/0x1f0
[ 5371.204902]  [<ffffffff802c3030>] ? chrdev_open+0x0/0x1f0
[ 5371.204909]  [<ffffffff802c3122>] chrdev_open+0xf2/0x1f0
[ 5371.204916]  [<ffffffff80483f70>] ? _spin_unlock+0x30/0x60
[ 5371.204923]  [<ffffffff802c3030>] ? chrdev_open+0x0/0x1f0
[ 5371.204932]  [<ffffffff802be2fd>] __dentry_open+0x10d/0x360
[ 5371.204941]  [<ffffffff802bf5e7>] nameidata_to_filp+0x57/0x70
[ 5371.204949]  [<ffffffff802cc452>] do_filp_open+0x1d2/0x8d0
[ 5371.204958]  [<ffffffff802d5626>] ? alloc_fd+0x116/0x140
[ 5371.204966]  [<ffffffff802be10e>] do_sys_open+0x5e/0xf0
[ 5371.204973]  [<ffffffff802be1cb>] sys_open+0x1b/0x20
[ 5371.204982]  [<ffffffff8020b87b>] system_call_fastpath+0x16/0x1b
[ 5371.204987] Code: 24 10 4c 89 74 24 18 48 63 80 48 e0 ff ff a9 00 ff ff 4f 0f 85 03 01 00 00 9c 41 5e fa e8 ce 00 de ff 4c 8d 6b 08 b8 00 01 00 00 <f0> 66 0f c1 43 08 38 e0 74 07 f3 90 8a 43 08 eb f5 48 3b 5b 60
[ 5371.205012] RIP  [<ffffffff8048186b>] __mutex_unlock_slowpath+0x4b/0x180
[ 5371.205012]  RSP <ffff88003b07dcc8>
[ 5371.205012] CR2: 0000000000000010
[ 5371.205012] ---[ end trace 062ee5b290243187 ]---

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/fbmem.c~fb-convert-lock-unlock_kernel-into-local-fb-mutex-fix drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-convert-lock-unlock_kernel-into-local-fb-mutex-fix
+++ a/drivers/video/fbmem.c
@@ -1346,12 +1346,12 @@ fb_open(struct inode *inode, struct file
 
 	if (fbidx >= FB_MAX)
 		return -ENODEV;
-	if (!(info = registered_fb[fbidx]))
+	info = registered_fb[fbidx];
+	if (!info)
 		request_module("fb%d", fbidx);
-	if (!(info = registered_fb[fbidx])) {
-		res = -ENODEV;
-		goto out;
-	}
+	info = registered_fb[fbidx];
+	if (!info)
+		return -ENODEV;
 	mutex_lock(&info->lock);
 	if (!try_module_get(info->fbops->owner)) {
 		res = -ENODEV;
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

cpufreq-bug-using-smp_processor_id-in-preemptible-code.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-fix-task_lock-recursive-locking-v2.patch

