From: akpm@linux-foundation.org
Subject: + nfs-fix-oops-re-sysctls-and-v4-support.patch added to -mm tree
Date: Fri, 17 Aug 2007 11:41:16 -0700
Message-ID: <200708171841.l7HIfG5w024055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753973AbXHQSmo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 14:42:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, akpm@linux-foundation.org, bfields@fieldses.org, trond.myklebust@fys.uio.no


The patch titled
     nfs: fix oops re sysctls and V4 support
has been added to the -mm tree.  Its filename is
     nfs-fix-oops-re-sysctls-and-v4-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nfs: fix oops re sysctls and V4 support
From: Alexey Dobriyan <adobriyan@gmail.com>

NFS unregisters sysctls only if V4 support is compiled in.  However, sysctl
table is not V4 specific, so unregister it always.

Steps to reproduce:

	[build nfs.ko with CONFIG_NFS_V4=n]
	modrobe nfs
	rmmod nfs
	ls /proc/sys

Unable to handle kernel paging request at ffffffff880661c0 RIP:
 [<ffffffff802af8e3>] proc_sys_readdir+0xd3/0x350
PGD 203067 PUD 207063 PMD 7e216067 PTE 0
Oops: 0000 [1] SMP
CPU 1
Modules linked in: lockd nfs_acl sunrpc
Pid: 3335, comm: ls Not tainted 2.6.23-rc3-bloat #2
RIP: 0010:[<ffffffff802af8e3>]  [<ffffffff802af8e3>] proc_sys_readdir+0xd3/0x350
RSP: 0018:ffff81007fd93e78  EFLAGS: 00010286
RAX: ffffffff880661c0 RBX: ffffffff80466370 RCX: ffffffff880661c0
RDX: 00000000000014c0 RSI: ffff81007f3ad020 RDI: ffff81007efd8b40
RBP: 0000000000000018 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: ffffffff802a8570 R12: ffffffff880661c0
R13: ffff81007e219640 R14: ffff81007efd8b40 R15: ffff81007ded7280
FS:  00002ba25ef03060(0000) GS:ffff81007ff81258(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffff880661c0 CR3: 000000007dfaf000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ls (pid: 3335, threadinfo ffff81007fd92000, task ffff81007d8a0000)
Stack:  ffff81007f3ad150 ffffffff80283f30 ffff81007fd93f48 ffff81007efd8b40
 ffff81007ee00440 0000000422222222 0000000200035593 ffffffff88037e9a
 2222222222222222 ffffffff80466500 ffff81007e416400 ffff81007e219640
Call Trace:
 [<ffffffff80283f30>] filldir+0x0/0xf0
 [<ffffffff80283f30>] filldir+0x0/0xf0
 [<ffffffff802840c7>] vfs_readdir+0xa7/0xc0
 [<ffffffff80284376>] sys_getdents+0x96/0xe0
 [<ffffffff8020bb3e>] system_call+0x7e/0x83

Code: 41 8b 14 24 85 d2 74 dc 49 8b 44 24 08 48 85 c0 74 e7 49 3b
RIP  [<ffffffff802af8e3>] proc_sys_readdir+0xd3/0x350
 RSP <ffff81007fd93e78>
CR2: ffffffff880661c0
Kernel panic - not syncing: Fatal exception

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfs/super.c~nfs-fix-oops-re-sysctls-and-v4-support fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-fix-oops-re-sysctls-and-v4-support
+++ a/fs/nfs/super.c
@@ -345,8 +345,8 @@ void __exit unregister_nfs_fs(void)
 	unregister_shrinker(&acl_shrinker);
 #ifdef CONFIG_NFS_V4
 	unregister_filesystem(&nfs4_fs_type);
-	nfs_unregister_sysctl();
 #endif
+	nfs_unregister_sysctl();
 	unregister_filesystem(&nfs_fs_type);
 }
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

nfs-fix-oops-re-sysctls-and-v4-support.patch
ifdef-struct-task_structsecurity.patch
faster-ext2_clear_inode.patch
fs-proc-mmuc-headers-butchery.patch
remove-sysctlh-from-fsh.patch
epcac-reformat-comments-and-coding-style-improvements.patch
shrink-struct-task_structoomkilladj.patch
remove-struct-task_structio_wait.patch
revert-faster-ext2_clear_inode.patch
