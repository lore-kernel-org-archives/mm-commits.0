From: akpm@linux-foundation.org
Subject: + hfsplus-check-hfs_bnode_find-return-value.patch added to -mm tree
Date: Wed, 27 Aug 2008 16:52:02 -0700
Message-ID: <200808272352.m7RNq2oC029481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753690AbYH0XwR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 19:52:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: snakebyte@gmx.de, zippel@linux-m68k.org


The patch titled
     hfsplus: check hfs_bnode_find return value
has been added to the -mm tree.  Its filename is
     hfsplus-check-hfs_bnode_find-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfsplus: check hfs_bnode_find return value
From: Eric Sesterhenn <snakebyte@gmx.de>

Another bug triggered with a corrupted image, this time running fsx on it.

[ 8898.458022] BUG: unable to handle kernel paging request at fffffff8
[ 8898.458022] IP: [<c023028c>] hfs_bnode_split+0x216/0x280
[ 8898.458022] *pde = 00008067 *pte = 00000000
[ 8898.458022] Oops: 0002 [#1] PREEMPT DEBUG_PAGEALLOC
[ 8898.458022] Modules linked in:
[ 8898.458022]
[ 8898.458022] Pid: 30558, comm: fsx Not tainted (2.6.27-rc4-00131-g83097ac-dirty #33)
[ 8898.458022] EIP: 0060:[<c023028c>] EFLAGS: 00010246 CPU: 0
[ 8898.458022] EIP is at hfs_bnode_split+0x216/0x280
[ 8898.458022] EAX: 00000002 EBX: fffffff4 ECX: 00000000 EDX: c6b48be6
[ 8898.458022] ESI: c6ac25a0 EDI: c6ac26c0 EBP: c6b48c00 ESP: c6b48bc4
[ 8898.458022]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[ 8898.458022] Process fsx (pid: 30558, ti=c6b48000 task=c6a06700 task.ti=c6b48000)
[ 8898.458022] Stack: c6a93950 00000010 00000fd8 00000fb8 00000830 000007ac 00000000 00000822
[ 8898.458022]        00000fb8 00000200 01ff0000 00001000 00000fb8 c6ac26c0 00000fb6 c6b48c4c
[ 8898.458022]        c02303ca 000000f8 c6b48c68 c6b48e70 0000000f c6ac26c0 c6a93950 00000000
[ 8898.458022] Call Trace:
[ 8898.458022]  [<c02303ca>] ? hfsplus_brec_insert+0xd4/0x2bc
[ 8898.458022]  [<c022d7be>] ? hfsplus_create_cat+0x30c/0x38f
[ 8898.458022]  [<c013dc3a>] ? trace_hardirqs_on+0xb/0xd
[ 8898.458022]  [<c017cd20>] ? check_bytes_and_report+0x21/0x8f
[ 8898.458022]  [<c017d8a3>] ? __slab_alloc+0xb1/0x503
[ 8898.458022]  [<c017dfc5>] ? kmem_cache_alloc+0x4e/0xba
[ 8898.458022]  [<c06ade04>] ? sub_preempt_count+0x9d/0xab
[ 8898.458022]  [<c013dc3a>] ? trace_hardirqs_on+0xb/0xd
[ 8898.458022]  [<c06abe19>] ? _spin_unlock+0x27/0x3c
[ 8898.458022]  [<c019ad34>] ? __mark_inode_dirty+0x12f/0x137
[ 8898.458022]  [<c06ade04>] ? sub_preempt_count+0x9d/0xab
[ 8898.458022]  [<c06abe19>] ? _spin_unlock+0x27/0x3c
[ 8898.458022]  [<c022e3db>] ? hfsplus_create+0x35/0x7a
[ 8898.458022]  [<c01889ee>] ? vfs_create+0xa6/0x114
[ 8898.458022]  [<c018ac61>] ? do_filp_open+0x1ad/0x62f
[ 8898.458022]  [<c06abe19>] ? _spin_unlock+0x27/0x3c
[ 8898.458022]  [<c0193632>] ? alloc_fd+0xbf/0xc9
[ 8898.458022]  [<c06ade04>] ? sub_preempt_count+0x9d/0xab
[ 8898.458022]  [<c0193632>] ? alloc_fd+0xbf/0xc9
[ 8898.458022]  [<c0180249>] ? do_sys_open+0x42/0xb8
[ 8898.458022]  [<c0180301>] ? sys_open+0x1e/0x26
[ 8898.458022]  [<c01038bd>] ? sysenter_do_call+0x12/0x31
[ 8898.458022]  =======================
[ 8898.458022] Code: c2 89 f8 66 89 55 f0 8d 55 e6 e8 63 ed ff ff 8b 56 0c 83 c4 14 85 d2 74 3f 8b 45 c4 e8 f5 f1 ff ff 31 c9 8d 55 e6 89 c3 8b 46 08 <89> 43 04 89 d8 6a 0e e8 1d ee ff ff 8b 43 04 8d 55 e6 0f c8 31
[ 8898.458022] EIP: [<c023028c>] hfs_bnode_split+0x216/0x280 SS:ESP 0068:c6b48bc4
[ 8898.458022] ---[ end trace 552e26de6e943a04 ]---

Problem is caused by not checking and propagating the return valie of
hfs_bnode_find()

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/brec.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/hfsplus/brec.c~hfsplus-check-hfs_bnode_find-return-value fs/hfsplus/brec.c
--- a/fs/hfsplus/brec.c~hfsplus-check-hfs_bnode_find-return-value
+++ a/fs/hfsplus/brec.c
@@ -304,6 +304,8 @@ static struct hfs_bnode *hfs_bnode_split
 	/* update next bnode header */
 	if (new_node->next) {
 		struct hfs_bnode *next_node = hfs_bnode_find(tree, new_node->next);
+		if (IS_ERR(next_node))
+			return next_node;
 		next_node->prev = new_node->this;
 		hfs_bnode_read(next_node, &node_desc, 0, sizeof(node_desc));
 		node_desc.prev = cpu_to_be32(next_node->prev);
_

Patches currently in -mm which might be from snakebyte@gmx.de are

linux-next.patch
hfsplus-fix-buffer-overflow-with-a-corrupted-image.patch
hfsplus-check-read_mapping_page-return-value.patch
hfsplus-fix-another-bug-when-reading-a-corrupted-image.patch
hfsplus-check-hfs_bnode_find-return-value.patch

