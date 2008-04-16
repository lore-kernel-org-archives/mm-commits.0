From: akpm@linux-foundation.org
Subject: - fbdev-fix-proc-fb-oops-after-module-removal.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:54:48 -0700
Message-ID: <200804162254.m3GMsmCM011054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755247AbYDPWzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 18:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, adaplas@pol.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: fix /proc/fb oops after module removal
has been removed from the -mm tree.  Its filename was
     fbdev-fix-proc-fb-oops-after-module-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: fix /proc/fb oops after module removal
From: Alexey Dobriyan <adobriyan@gmail.com>

/proc/fb is not removed during rmmod.

Steps to reproduce:

	modprobe fb
	rmmod fb
	ls /proc

BUG: unable to handle kernel paging request at ffffffffa0094370
IP: [<ffffffff802b92a1>] proc_get_inode+0x101/0x130
PGD 203067 PUD 207063 PMD 17e758067 PTE 0
Oops: 0000 [1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:05:02.0/resource
CPU 1
Modules linked in: nf_conntrack_irc xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables x_tables vfat fat usbhid ehci_hcd uhci_hcd usbcore sr_mod cdrom [last unloaded: fb]
Pid: 21205, comm: ls Not tainted 2.6.25-rc8-mm2 #14
RIP: 0010:[<ffffffff802b92a1>]  [<ffffffff802b92a1>] proc_get_inode+0x101/0x130
RSP: 0018:ffff81017c4bfc78  EFLAGS: 00010246
RAX: 0000000000008000 RBX: ffff8101787f5470 RCX: 0000000048011ccc
RDX: ffffffffa0094320 RSI: ffff810006ad43b0 RDI: ffff81017fc2cc00
RBP: ffff81017e450300 R08: 0000000000000002 R09: ffff81017c5d1000
R10: 0000000000000000 R11: 0000000000000246 R12: ffff81016b903a28
R13: ffff81017f822020 R14: ffff81017c4bfd58 R15: ffff81017f822020
FS:  00007f08e71696f0(0000) GS:ffff81017fc06480(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffa0094370 CR3: 000000017e54a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ls (pid: 21205, threadinfo ffff81017c4be000, task ffff81017de48770)
Stack:  ffff81017c5d1000 00000000ffffffea ffff81017e450300 ffffffff802bdd1e
 ffff81017f802258 ffff81017c4bfe48 ffff81016b903a28 ffff81017f822020
 ffff81017c4bfd48 ffffffff802b9ba0 ffff81016b903a28 ffff81017f802258
Call Trace:
 [<ffffffff802bdd1e>] ? proc_lookup_de+0x8e/0x100
 [<ffffffff802b9ba0>] ? proc_root_lookup+0x20/0x60
 [<ffffffff802882a7>] ? do_lookup+0x1b7/0x210
 [<ffffffff8028883d>] ? __link_path_walk+0x53d/0x7f0
 [<ffffffff80295eb8>] ? mntput_no_expire+0x28/0x130
 [<ffffffff80288b4a>] ? path_walk+0x5a/0xc0
 [<ffffffff80288dd3>] ? do_path_lookup+0x83/0x1c0
 [<ffffffff80287785>] ? getname+0xe5/0x210
 [<ffffffff80289adb>] ? __user_walk_fd+0x4b/0x80
 [<ffffffff8028236c>] ? vfs_lstat_fd+0x2c/0x70
 [<ffffffff8028bf1e>] ? filldir+0xae/0xf0
 [<ffffffff802b92e9>] ? de_put+0x9/0x50
 [<ffffffff8029633d>] ? mnt_want_write+0x2d/0x80
 [<ffffffff8029339f>] ? touch_atime+0x1f/0x170
 [<ffffffff802b9b1d>] ? proc_root_readdir+0x7d/0xa0
 [<ffffffff802825e7>] ? sys_newlstat+0x27/0x50
 [<ffffffff8028bffb>] ? vfs_readdir+0x9b/0xd0
 [<ffffffff8028c0fe>] ? sys_getdents+0xce/0xe0
 [<ffffffff8020b39b>] ? system_call_after_swapgs+0x7b/0x80

Code: b7 83 b2 00 00 00 25 00 f0 00 00 3d 00 80 00 00 74 19 48 89 93 f0 00 00 00 48 89 df e8 39 9a fd ff 48 89 d8 48 83 c4 08 5b 5d c3 <48> 83 7a 50 00 48 c7 c0 60 16 45 80 48 c7 c2 40 17 45 80 48 0f
RIP  [<ffffffff802b92a1>] proc_get_inode+0x101/0x130
 RSP <ffff81017c4bfc78>
CR2: ffffffffa0094370
---[ end trace c71hiarjan8ab739 ]---

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
"Antonino A. Daplas" <adaplas@pol.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/fbmem.c~fbdev-fix-proc-fb-oops-after-module-removal drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-fix-proc-fb-oops-after-module-removal
+++ a/drivers/video/fbmem.c
@@ -1521,6 +1521,7 @@ module_init(fbmem_init);
 static void __exit
 fbmem_exit(void)
 {
+	remove_proc_entry("fb", NULL);
 	class_destroy(fb_class);
 	unregister_chrdev(FB_MAJOR, "fb");
 }
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-dvb.patch
tags-add-menuconfig-symbols-as-well.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
remove-the-macro-get_personality.patch
nv-drop-useless-module-ifdefs.patch
nv-drop-useless-config_pci-checks.patch
nv-fix-sparse-noise.patch
fb-convert-proc-fb-to-seq_file-interface.patch
fb-convert-proc-fb-to-seq_file-interface-checkpatch-fixes.patch
ipmi-remove-write_proc-code.patch
procfs-mem-permission-cleanup.patch
proc-simplify-locking-in-remove_proc_entry.patch
proc-less-special-case-in-xlate-code.patch
proc-drop-several-pde-valid-invalid-checks.patch
proc-remove-proc_bus.patch
proc-remove-proc_root_fs.patch
proc-remove-proc_root_driver.patch
proc-remove-proc_root-from-drivers.patch
proc-convert-proc-tty-ldiscs-to-seq_file-interface.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
nfsd-use-proc_create-to-setup-de-proc_fops.patch
nfs-use-proc_create-to-setup-de-proc_fops.patch
afs-use-non-racy-method-for-proc-entries-creation.patch
ext4-use-non-racy-method-for-proc-entries-creation.patch
reiserfs-use-non-racy-method-for-proc-entries-creation.patch
jbd2-use-non-racy-method-for-proc-entries-creation.patch
sysvipc-use-non-racy-method-for-proc-entries-creation.patch
mm-use-non-racy-method-for-proc-swaps-creation.patch
sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch
zorro-use-non-racy-method-for-proc-entries-creation.patch
samples-use-non-racy-method-for-proc-marker-example-creation.patch
scsi-use-non-racy-method-for-proc-entries-creation.patch
usb-use-non-racy-method-for-proc-entries-creation.patch
s390-use-non-racy-method-for-proc-entries-creation.patch
arm-use-non-racy-method-for-proc-davinci_clocks-creation.patch
avr32-proc-use-non-racy-method-for-proc-tlb-creation.patch
cris-use-non-racy-method-for-proc-system_profile-creation.patch
ia64-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-pcxl_dma-creation.patch
powerpc-use-non-racy-method-for-proc-entries-creation.patch
acpi-use-non-racy-method-for-proc-entries-creation.patch
netdev-use-non-racy-method-for-proc-entries-creation.patch
isdn-use-non-racy-method-for-proc-entries-creation.patch
kernel-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

