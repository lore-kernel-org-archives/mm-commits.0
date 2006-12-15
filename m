From: akpm@osdl.org
Subject: + procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch added to -mm tree
Date: Thu, 14 Dec 2006 17:52:54 -0800
Message-ID: <200612150152.kBF1qteG003437@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50583 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965050AbWLOBx5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 20:53:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, ebiederm@xmission.com, oleg@tv-sign.ru


The patch titled
     procfs: fix race between proc_readdir and remove_proc_entry
has been added to the -mm tree.  Its filename is
     procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: procfs: fix race between proc_readdir and remove_proc_entry
From: "Darrick J. Wong" <djwong@us.ibm.com>

While running a insmod/rmmod loop with the mptsas driver (vanilla 2.6.19,
IBM Intellistation Z30, SAS1064E controller if it matters), I encountered
the following messages from the kernel:

[53092.441412] general protection fault: 0000 [1] PREEMPT SMP
[53092.447058] CPU 4
[53092.449108] Modules linked in: mptbase scsi_transport_sas ext2 ext3 jbd mbcache nbd acpi_cpufreq processor cpufreq_userspace cpufreq_stats
 cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative dm_mod md_mod ipv6 fuse ata_generic sg sd_mod ata_piix libata mousedev ts
dev serio_raw evdev floppy rtc snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm ohci1394 generic ieee1394 piix scsi_mod snd_time
r ide_core ehci_hcd uhci_hcd snd usbcore soundcore snd_page_alloc shpchp pci_hotplug unix
[53092.495003] Pid: 570, comm: udevd Not tainted 2.6.19-dic64 #6
[53092.500753] RIP: 0010:[<ffffffff801fafc5>]  [<ffffffff801fafc5>] proc_readdir+0x110/0x186
[53092.508968] RSP: 0018:ffff8100be829e78  EFLAGS: 00010246
[53092.514289] RAX: 0000000000000000 RBX: 6b6b6b6b6b6b6b6b RCX: 000000002218b2b5
[53092.521429] RDX: ffffffff801fafc5 RSI: 0000000000000001 RDI: ffff810092cf7e48
[53092.528564] RBP: ffff8100be829eb8 R08: 0000000000000002 R09: 0000000000000000
[53092.535700] R10: ffff810092cf7e48 R11: 0000000000000028 R12: ffff810005934a08
[53092.542836] R13: 0000000000000002 R14: ffff810092cf7e48 R15: ffffffff8013b9e6
[53092.549972] FS:  00002b19f2a14d70(0000) GS:ffff8100059b3898(0000) knlGS:0000000000000000
[53092.558067] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[53092.563817] CR2: 000000000051108c CR3: 00000000bedb9000 CR4: 00000000000006e0
[53092.570954] Process udevd (pid: 570, threadinfo ffff8100be828000, task ffff8100befc0080)
[53092.579048] Stack:  0000000000000246 ffff8100be829f38 ffffffff80474ea0 0000000000000000
[53092.587179]  ffff810092cf7e48 ffffffff8013b9e6 ffff8100be829f38 ffffffff8013b9e6
[53092.594679]  ffff8100be829ee8 ffffffff8014e93e ffff810092cf7e48 ffff81000593a8a8
[53092.601971] Call Trace:
[53092.604644]  [<ffffffff8014e93e>] proc_root_readdir+0x32/0x68
[53092.610397]  [<ffffffff80135abb>] vfs_readdir+0x65/0x9a
[53092.615628]  [<ffffffff801d966b>] sys_getdents64+0x7a/0xc1
[53092.621123]  [<ffffffff8015e11e>] system_call+0x7e/0x83
[53092.627195] DWARF2 unwinder stuck at system_call+0x7e/0x83
[53092.632681]
[53092.634189] Leftover inexact backtrace:
[53092.634191]
[53092.643162]
[53092.644663]
[53092.644665] Code: 44 8b 4b 10 0f b7 53 04 44 8b 03 49 8b 4e 38 48 8b 73 08 48
[53092.653935] RIP  [<ffffffff801fafc5>] proc_readdir+0x110/0x186
[53092.659798]  RSP <ffff8100be829e78>

The slab poison value in %rbx is suspicious, so I dug into the
relevant code:

0xffffffff801fafc5 <proc_readdir+272>:  mov    0x10(%rbx),%r9d
0xffffffff801fafc9 <proc_readdir+276>:  movzwl 0x4(%rbx),%edx
0xffffffff801fafcd <proc_readdir+280>:  mov    (%rbx),%r8d
0xffffffff801fafd0 <proc_readdir+283>:  mov    0x38(%r14),%rcx
0xffffffff801fafd4 <proc_readdir+287>:  mov    0x8(%rbx),%rsi
0xffffffff801fafd8 <proc_readdir+291>:  mov    0xffffffffffffffc8(%rbp),%rdi
0xffffffff801fafdc <proc_readdir+295>:  shr    $0xc,%r9d
0xffffffff801fafe0 <proc_readdir+299>:  callq  *%r15

This corresponds to this code in proc_readdir near
fs/proc/generic.c:480.  It looks like %rbx corresponds to the
"de" pointer:

spin_unlock(&proc_subdir_lock);
if (filldir(dirent, de->name, de->namelen, filp->f_pos,
            de->low_ino, de->mode >> 12) < 0)
	goto out;
spin_lock(&proc_subdir_lock);
filp->f_pos++;
de = de->next;

I believe what's happening here is that proc_readdir drops proc_subdir_lock
to call filldir() on the /proc/mpt directory at the same time mptbase is
being unloaded.  The unload causes the removal of /proc/mpt, which means
that de is overwritten with the slab poison value as it is being freed.  We
reacquire the lock and try to grab the next value of de, but by then the
next pointer has been lost, and we crash.

I think an acceptable fix is to de_get() the proc_dir_entry count before
the unlock and de_put() it after the unlock.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/generic.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/proc/generic.c~procfs-fix-race-between-proc_readdir-and-remove_proc_entry fs/proc/generic.c
--- a/fs/proc/generic.c~procfs-fix-race-between-proc_readdir-and-remove_proc_entry
+++ a/fs/proc/generic.c
@@ -429,7 +429,7 @@ struct dentry *proc_lookup(struct inode 
 int proc_readdir(struct file * filp,
 	void * dirent, filldir_t filldir)
 {
-	struct proc_dir_entry * de;
+	struct proc_dir_entry *de, *next;
 	unsigned int ino;
 	int i;
 	struct inode *inode = filp->f_path.dentry->d_inode;
@@ -477,13 +477,16 @@ int proc_readdir(struct file * filp,
 
 			do {
 				/* filldir passes info to user space */
+				de_get(de);
 				spin_unlock(&proc_subdir_lock);
 				if (filldir(dirent, de->name, de->namelen, filp->f_pos,
 					    de->low_ino, de->mode >> 12) < 0)
 					goto out;
 				spin_lock(&proc_subdir_lock);
 				filp->f_pos++;
-				de = de->next;
+				next = de->next;
+				de_put(de);
+				de = next;
 			} while (de);
 			spin_unlock(&proc_subdir_lock);
 	}
_

Patches currently in -mm which might be from djwong@us.ibm.com are

libata-simulate-report-luns-for-atapi-devices.patch
git-sas.patch
git-sas-kconfig-fix.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch

