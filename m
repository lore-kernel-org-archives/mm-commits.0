From: akpm@linux-foundation.org
Subject: + protect-tty-drivers-list-with-tty_mutex.patch added to -mm tree
Date: Sat, 24 Mar 2007 23:27:33 -0800
Message-ID: <200703250727.l2P7RXcK022772@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34952 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbXCYH2R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 03:28:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, alan@lxorguk.ukuu.org.uk


The patch titled
     Protect tty drivers list with tty_mutex
has been added to the -mm tree.  Its filename is
     protect-tty-drivers-list-with-tty_mutex.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Protect tty drivers list with tty_mutex
From: Alexey Dobriyan <adobriyan@sw.ru>

Additions and removal from tty_drivers list were just done as well as
iterating on it for /proc/tty/drivers generation.

testing: modprobe/rmmod loop of simple module which does nothing but
tty_register_driver() vs cat /proc/tty/drivers loop

BUG: unable to handle kernel paging request at virtual address 6b6b6b6b
 printing eip:
c01cefa7
*pde = 00000000
Oops: 0000 [#1]
PREEMPT
last sysfs file: devices/pci0000:00/0000:00:1d.7/usb5/5-0:1.0/bInterfaceProtocol
Modules linked in: ohci_hcd af_packet e1000 ehci_hcd uhci_hcd usbcore xfs
CPU:    0
EIP:    0060:[<c01cefa7>]    Not tainted VLI
EFLAGS: 00010297   (2.6.21-rc4-mm1 #4)
EIP is at vsnprintf+0x3a4/0x5fc
eax: 6b6b6b6b   ebx: f6cb50f2   ecx: 6b6b6b6b   edx: fffffffe
esi: c0354700   edi: f6cb6000   ebp: 6b6b6b6b   esp: f31f5e68
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process cat (pid: 31864, ti=f31f4000 task=c1998030 task.ti=f31f4000)
Stack: 00000000 c0103f20 c013003a c0103f20 00000000 f6cb50da 0000000a 00000f0e
       f6cb50f2 00000010 00000014 ffffffff ffffffff 00000007 c0354753 f6cb50f2
       f73e39dc f73e39dc 00000001 c0175416 f31f5ed8 f31f5ed4 0ee00000 f32090bc
Call Trace:
 [<c0103f20>] restore_nocheck+0x12/0x15
 [<c013003a>] mark_held_locks+0x6d/0x86
 [<c0103f20>] restore_nocheck+0x12/0x15
 [<c0175416>] seq_printf+0x2e/0x52
 [<c0192895>] show_tty_range+0x35/0x1f3
 [<c0175416>] seq_printf+0x2e/0x52
 [<c0192add>] show_tty_driver+0x8a/0x1d9
 [<c01758f6>] seq_read+0x70/0x2ba
 [<c0175886>] seq_read+0x0/0x2ba
 [<c018d8e6>] proc_reg_read+0x63/0x9f
 [<c015e764>] vfs_read+0x7d/0xb5
 [<c018d883>] proc_reg_read+0x0/0x9f
 [<c015eab1>] sys_read+0x41/0x6a
 [<c0103e4e>] sysenter_past_esp+0x5f/0x99
 =======================
Code: 00 8b 4d 04 e9 44 ff ff ff 8d 4d 04 89 4c 24 50 8b 6d 00 81 fd ff 0f 00 00 b8 a4 c1 35 c0 0f 46 e8 8b 54 24 2c 89 e9 89 c8 eb 06 <80> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 89 c6 8b 44 24 28 89
EIP: [<c01cefa7>] vsnprintf+0x3a4/0x5fc SS:ESP 0068:f31f5e68

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    5 ++++-
 fs/proc/proc_tty.c    |    3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/char/tty_io.c~protect-tty-drivers-list-with-tty_mutex drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~protect-tty-drivers-list-with-tty_mutex
+++ a/drivers/char/tty_io.c
@@ -3771,7 +3771,9 @@ int tty_register_driver(struct tty_drive
 	if (!driver->put_char)
 		driver->put_char = tty_default_put_char;
 	
+	mutex_lock(&tty_mutex);
 	list_add(&driver->tty_drivers, &tty_drivers);
+	mutex_unlock(&tty_mutex);
 	
 	if ( !(driver->flags & TTY_DRIVER_DYNAMIC_DEV) ) {
 		for(i = 0; i < driver->num; i++)
@@ -3797,8 +3799,9 @@ int tty_unregister_driver(struct tty_dri
 
 	unregister_chrdev_region(MKDEV(driver->major, driver->minor_start),
 				driver->num);
-
+	mutex_lock(&tty_mutex);
 	list_del(&driver->tty_drivers);
+	mutex_unlock(&tty_mutex);
 
 	/*
 	 * Free the termios and termios_locked structures because
diff -puN fs/proc/proc_tty.c~protect-tty-drivers-list-with-tty_mutex fs/proc/proc_tty.c
--- a/fs/proc/proc_tty.c~protect-tty-drivers-list-with-tty_mutex
+++ a/fs/proc/proc_tty.c
@@ -108,6 +108,8 @@ static void *t_start(struct seq_file *m,
 {
 	struct list_head *p;
 	loff_t l = *pos;
+
+	mutex_lock(&tty_mutex);
 	list_for_each(p, &tty_drivers)
 		if (!l--)
 			return list_entry(p, struct tty_driver, tty_drivers);
@@ -124,6 +126,7 @@ static void *t_next(struct seq_file *m, 
 
 static void t_stop(struct seq_file *m, void *v)
 {
+	mutex_unlock(&tty_mutex);
 }
 
 static struct seq_operations tty_drivers_op = {
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
git-cpufreq.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
proc-remove-pathetic-deleted-warn_on.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-oom_score-oops-re-badness.patch
protect-tty-drivers-list-with-tty_mutex.patch
