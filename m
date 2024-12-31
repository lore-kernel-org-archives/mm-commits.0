Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C1C134D4
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 01:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735609217; cv=none; b=aR2LsmUyOE3eUTGgsQ9Jr8zi1oZimQGcsAgqefXMVbX/Kr6F72XN4eOAmdX+dCWtQMVD2e6fmpO6FllUJ6VmuQDCXaep6jxulnFysbrxaieutif/Pt7c8r54mm1K0az+YqbJxMo17xX+2U5m8BlqiClJuDLRkFLrwlo2n+iE6bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735609217; c=relaxed/simple;
	bh=ahAe4yn6Kg7BDPbuMFUTzciUdyrvoIeY7Jm5pzUg620=;
	h=Date:To:From:Subject:Message-Id; b=U0XT3GHiTqIeeeE4zm2h+hxeb985lqhw9KBPsYosLXCQIs32wS6U7qUmFHqykHzALN0OyjnhexBdAiBoeUW5gFuPvnsxv6O9tUl5wUOMYkbuNQEG4IcYYNHDPrkDC5sX/1ekLFjh/coSHw/3AuEffaaXyl98OjWW9D5PqK2JvGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UF6/jBZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UF6/jBZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B12DC4CED0;
	Tue, 31 Dec 2024 01:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735609216;
	bh=ahAe4yn6Kg7BDPbuMFUTzciUdyrvoIeY7Jm5pzUg620=;
	h=Date:To:From:Subject:From;
	b=UF6/jBZ5WCQWoW3xE/uSs7mV0UjD71D1G/FyKHrLoHMYQa7w3UiMDJp83qZLMKG0U
	 uJJ9bYfmtRfam/03yOVCqEWgTxKbvX7iUTiTg33FpdUL2/t+9tJNN5DzC+9H0rmJHn
	 vQ91Y0/AftFKw6KWsvYmY7UskLQUMv4FuQsr98ag=
Date: Mon, 30 Dec 2024 17:40:15 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ocfs2-fix-directory-entry-check-in-ocfs2_search_dirblock.patch removed from -mm tree
Message-Id: <20241231014016.5B12DC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix directory entry check in ocfs2_search_dirblock()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-directory-entry-check-in-ocfs2_search_dirblock.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: fix directory entry check in ocfs2_search_dirblock()
Date: Tue, 19 Nov 2024 20:07:45 +0300

Syzbot has reported the following KASAN splat:

BUG: KASAN: slab-use-after-free in ocfs2_search_dirblock+0x26b/0x830
Read of size 1 at addr ffff888012009982 by task repro/5388
...
Call Trace:
 <TASK>
 dump_stack_lvl+0x241/0x360
 ? __pfx_dump_stack_lvl+0x10/0x10
 ? __pfx__printk+0x10/0x10
 ? _printk+0xd5/0x120
 ? __virt_addr_valid+0x183/0x530
 ? __virt_addr_valid+0x183/0x530
 print_report+0x169/0x550
 ? __virt_addr_valid+0x183/0x530
 ? __virt_addr_valid+0x183/0x530
 ? __virt_addr_valid+0x45f/0x530
 ? __phys_addr+0xba/0x170
 ? ocfs2_search_dirblock+0x26b/0x830
 kasan_report+0x143/0x180
 ? ocfs2_search_dirblock+0x26b/0x830
 ocfs2_search_dirblock+0x26b/0x830
 ? ocfs2_read_inode_block+0x14c/0x1e0
 ? __pfx_ocfs2_search_dirblock+0x10/0x10
 ? validate_chain+0x11e/0x5900
 ocfs2_find_entry+0x1169/0x2780
 ? mark_lock+0x9a/0x350
 ? __lock_acquire+0x137a/0x2040
 ? __pfx_ocfs2_find_entry+0x10/0x10
 ? __pfx_lock_acquire+0x10/0x10
 ? ocfs2_inode_lock_full_nested+0x17b/0x1c10
 ? __pfx_lock_release+0x10/0x10
 ? do_raw_spin_lock+0x14f/0x370
 ? do_raw_spin_unlock+0x58/0x8b0
 ? _raw_spin_unlock+0x28/0x50
 ? ocfs2_inode_lock_full_nested+0xb2f/0x1c10
 ? __pfx_ocfs2_inode_lock_full_nested+0x10/0x10
 ocfs2_find_files_on_disk+0xff/0x360
 ocfs2_lookup_ino_from_name+0xb1/0x1e0
 ? __pfx_ocfs2_lookup_ino_from_name+0x10/0x10
 ocfs2_lookup+0x292/0xa60
 ? __pfx_ocfs2_lookup+0x10/0x10
 ? from_kgid+0x1a7/0x730
 ? make_vfsgid+0x46/0x90
 ? HAS_UNMAPPED_ID+0xf9/0x150
 ? inode_permission+0xff/0x460
 ? __pfx_ocfs2_permission+0x10/0x10
 ? bpf_lsm_inode_create+0x9/0x10
 ? security_inode_create+0xc2/0x110
 ? __pfx_ocfs2_lookup+0x10/0x10
 path_openat+0x11ce/0x3470
 ? __pfx_path_openat+0x10/0x10
 do_filp_open+0x235/0x490
 ? __pfx_do_filp_open+0x10/0x10
 ? _raw_spin_unlock+0x28/0x50
 ? alloc_fd+0x5a1/0x640
 do_sys_openat2+0x13e/0x1d0
 ? mntput_no_expire+0xc2/0x850
 ? __pfx_do_sys_openat2+0x10/0x10
 ? __pfx_mntput_no_expire+0x10/0x10
 __x64_sys_openat+0x247/0x2a0
 ? __pfx___x64_sys_openat+0x10/0x10
 ? do_syscall_64+0x100/0x230
 ? do_syscall_64+0xb6/0x230
 do_syscall_64+0xf3/0x230
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
...
 </TASK>

This happens when 'ocfs2_search_dirblock()' makes an attempt to jump over
(presumably invalid) on-disk directory entry which size exceeds
'sizeof(struct ocfs2_dir_entry)', thus touching memory used by others
(including the previously freed one).  So just bail out if such a
directory entry is found.

Link: https://lkml.kernel.org/r/20241119170745.464799-1-dmantipov@yandex.ru
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Reported-by: syzbot+b9704899e166798d57c9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b9704899e166798d57c9
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/dir.c~ocfs2-fix-directory-entry-check-in-ocfs2_search_dirblock
+++ a/fs/ocfs2/dir.c
@@ -378,7 +378,7 @@ static inline int ocfs2_search_dirblock(
 
 		/* prevent looping on a bad block */
 		de_len = le16_to_cpu(de->rec_len);
-		if (de_len <= 0) {
+		if (de_len <= 0 || de_len > sizeof(*de)) {
 			ret = -1;
 			goto bail;
 		}
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-miscellaneous-spelling-fixes.patch

