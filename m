From: akpm@linux-foundation.org
Subject: + shmem-initialize-struct-shmem_sb_info-to-zero.patch added to -mm tree
Date: Mon, 21 Sep 2009 12:53:29 -0700
Message-ID: <200909211953.n8LJrTwY025422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587AbZIUTxp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 15:53:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, hugh.dickins@tiscali.co.uk, mingo@elte.hu, vegard.nossum@gmail.com


The patch titled
     shmem: initialize struct shmem_sb_info to zero
has been added to the -mm tree.  Its filename is
     shmem-initialize-struct-shmem_sb_info-to-zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: shmem: initialize struct shmem_sb_info to zero
From: Pekka Enberg <penberg@cs.helsinki.fi>

Fixes the following kmemcheck false positive (the compiler is using
a 32-bit mov to load the 16-bit sbinfo->mode in shmem_fill_super):

[    0.337000] Total of 1 processors activated (3088.38 BogoMIPS).
[    0.352000] CPU0 attaching NULL sched-domain.
[    0.360000] WARNING: kmemcheck: Caught 32-bit read from uninitialized
memory (9f8020fc)
[    0.361000]
a44240820000000041f6998100000000000000000000000000000000ff030000
[    0.368000]  i i i i i i i i i i i i i i i i u u u u i i i i i i i i i i u
u
[    0.375000]                                                          ^
[    0.376000]
[    0.377000] Pid: 9, comm: khelper Not tainted (2.6.31-tip #206) P4DC6
[    0.378000] EIP: 0060:[<810a3a95>] EFLAGS: 00010246 CPU: 0
[    0.379000] EIP is at shmem_fill_super+0xb5/0x120
[    0.380000] EAX: 00000000 EBX: 9f845400 ECX: 824042a4 EDX: 8199f641
[    0.381000] ESI: 9f8020c0 EDI: 9f845400 EBP: 9f81af68 ESP: 81cd6eec
[    0.382000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.383000] CR0: 8005003b CR2: 9f806200 CR3: 01ccd000 CR4: 000006d0
[    0.384000] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    0.385000] DR6: ffff4ff0 DR7: 00000400
[    0.386000]  [<810c25fc>] get_sb_nodev+0x3c/0x80
[    0.388000]  [<810a3514>] shmem_get_sb+0x14/0x20
[    0.390000]  [<810c207f>] vfs_kern_mount+0x4f/0x120
[    0.392000]  [<81b2849e>] init_tmpfs+0x7e/0xb0
[    0.394000]  [<81b11597>] do_basic_setup+0x17/0x30
[    0.396000]  [<81b11907>] kernel_init+0x57/0xa0
[    0.398000]  [<810039b7>] kernel_thread_helper+0x7/0x10
[    0.400000]  [<ffffffff>] 0xffffffff
[    0.402000] khelper used greatest stack depth: 2820 bytes left
[    0.407000] calling  init_mmap_min_addr+0x0/0x10 @ 1
[    0.408000] initcall init_mmap_min_addr+0x0/0x10 returned 0 after 0 usecs

Reported-by: Ingo Molnar <mingo@elte.hu>
Analysed-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/shmem.c~shmem-initialize-struct-shmem_sb_info-to-zero mm/shmem.c
--- a/mm/shmem.c~shmem-initialize-struct-shmem_sb_info-to-zero
+++ a/mm/shmem.c
@@ -2311,17 +2311,14 @@ int shmem_fill_super(struct super_block 
 	int err = -ENOMEM;
 
 	/* Round up to L1_CACHE_BYTES to resist false sharing */
-	sbinfo = kmalloc(max((int)sizeof(struct shmem_sb_info),
+	sbinfo = kzalloc(max((int)sizeof(struct shmem_sb_info),
 				L1_CACHE_BYTES), GFP_KERNEL);
 	if (!sbinfo)
 		return -ENOMEM;
 
-	sbinfo->max_blocks = 0;
-	sbinfo->max_inodes = 0;
 	sbinfo->mode = S_IRWXUGO | S_ISVTX;
 	sbinfo->uid = current_fsuid();
 	sbinfo->gid = current_fsgid();
-	sbinfo->mpol = NULL;
 	sb->s_fs_info = sbinfo;
 
 #ifdef CONFIG_TMPFS
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
proc-kcore-work-around-a-bug.patch
repeatable-slab-corruption-with-ltp-msgctl08.patch
linux-next.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls.patch
mm-kmem_cache_create-make-it-easier-to-catch-null-cache-names.patch
revert-proc-kcore-work-around-a-bug.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
page-allocator-split-per-cpu-list-into-one-list-per-migrate-type.patch
page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp.patch
shmem-initialize-struct-shmem_sb_info-to-zero.patch
move-magic-numbers-into-magich.patch
move-magic-numbers-into-magich-update.patch
slab-leaks3-default-y.patch

