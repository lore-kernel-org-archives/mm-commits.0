Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3192572;
	Tue, 12 Nov 2024 01:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731374451; cv=none; b=bQS2HbImwb3/I/tImCufEtkXNHsWMq4lBXlYtkt82UR3mX2GSbvYmRar5OUmRRyTgq36wLi/O84CF/4T6aboQB2vtgMKOX6+50xP3VFHZpRjtcmpNOZRIHfBbsmKts4Q6UJMdsPVadNba5Gg0QKwlBDQzFAklU0NVGKTFWRmZ/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731374451; c=relaxed/simple;
	bh=zSb9IKa+244x4TLao4u3CEiY39d3JYeUTVikw6ag4jM=;
	h=Date:To:From:Subject:Message-Id; b=ay3mcV8x9o8tkv4+ZS9o8QeOCtiQwlPB1/5wezGmnxyccL9LDFwutXqRFNXh0NnMvKDYR3Zx8GH6k90REL4zfVWYCEKKdMJQuOfdmUKM+KBnY3+6DiGZPRmgPEEuwnADWOy7ZSPkUPWpyOc1X57xqQPhRYlDpym4qPLFhVqTkfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hyo0N+Hh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hyo0N+Hh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F99C4CECF;
	Tue, 12 Nov 2024 01:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731374450;
	bh=zSb9IKa+244x4TLao4u3CEiY39d3JYeUTVikw6ag4jM=;
	h=Date:To:From:Subject:From;
	b=hyo0N+HhQzBxkYCqkhNLxuTjRZINoK3KorZN/QZdULopf4b3I/z98POADYIMgoA65
	 yODkdkzVCmSD3wlYIesYLoe736wF9soo4xsKO58V08hS9VmMRgY1R9P9LQMN6Ca5/4
	 zUfO8nxAJux56ZYf3KIux/0Uish616/k8ATwbFUo=
Date: Mon, 11 Nov 2024 17:20:50 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-fix-ubsan-warning-in-ocfs2_verify_volume.patch removed from -mm tree
Message-Id: <20241112012050.C5F99C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix UBSAN warning in ocfs2_verify_volume()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-ubsan-warning-in-ocfs2_verify_volume.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: fix UBSAN warning in ocfs2_verify_volume()
Date: Wed, 6 Nov 2024 12:21:00 +0300

Syzbot has reported the following splat triggered by UBSAN:

UBSAN: shift-out-of-bounds in fs/ocfs2/super.c:2336:10
shift exponent 32768 is too large for 32-bit type 'int'
CPU: 2 UID: 0 PID: 5255 Comm: repro Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-3.fc41 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x241/0x360
 ? __pfx_dump_stack_lvl+0x10/0x10
 ? __pfx__printk+0x10/0x10
 ? __asan_memset+0x23/0x50
 ? lockdep_init_map_type+0xa1/0x910
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420
 ocfs2_fill_super+0xf9c/0x5750
 ? __pfx_ocfs2_fill_super+0x10/0x10
 ? __pfx_validate_chain+0x10/0x10
 ? __pfx_validate_chain+0x10/0x10
 ? validate_chain+0x11e/0x5920
 ? __lock_acquire+0x1384/0x2050
 ? __pfx_validate_chain+0x10/0x10
 ? string+0x26a/0x2b0
 ? widen_string+0x3a/0x310
 ? string+0x26a/0x2b0
 ? bdev_name+0x2b1/0x3c0
 ? pointer+0x703/0x1210
 ? __pfx_pointer+0x10/0x10
 ? __pfx_format_decode+0x10/0x10
 ? __lock_acquire+0x1384/0x2050
 ? vsnprintf+0x1ccd/0x1da0
 ? snprintf+0xda/0x120
 ? __pfx_lock_release+0x10/0x10
 ? do_raw_spin_lock+0x14f/0x370
 ? __pfx_snprintf+0x10/0x10
 ? set_blocksize+0x1f9/0x360
 ? sb_set_blocksize+0x98/0xf0
 ? setup_bdev_super+0x4e6/0x5d0
 mount_bdev+0x20c/0x2d0
 ? __pfx_ocfs2_fill_super+0x10/0x10
 ? __pfx_mount_bdev+0x10/0x10
 ? vfs_parse_fs_string+0x190/0x230
 ? __pfx_vfs_parse_fs_string+0x10/0x10
 legacy_get_tree+0xf0/0x190
 ? __pfx_ocfs2_mount+0x10/0x10
 vfs_get_tree+0x92/0x2b0
 do_new_mount+0x2be/0xb40
 ? __pfx_do_new_mount+0x10/0x10
 __se_sys_mount+0x2d6/0x3c0
 ? __pfx___se_sys_mount+0x10/0x10
 ? do_syscall_64+0x100/0x230
 ? __x64_sys_mount+0x20/0xc0
 do_syscall_64+0xf3/0x230
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f37cae96fda
Code: 48 8b 0d 51 ce 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1e ce 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007fff6c1aa228 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fff6c1aa240 RCX: 00007f37cae96fda
RDX: 00000000200002c0 RSI: 0000000020000040 RDI: 00007fff6c1aa240
RBP: 0000000000000004 R08: 00007fff6c1aa280 R09: 0000000000000000
R10: 00000000000008c0 R11: 0000000000000206 R12: 00000000000008c0
R13: 00007fff6c1aa280 R14: 0000000000000003 R15: 0000000001000000
 </TASK>

For a really damaged superblock, the value of 'i_super.s_blocksize_bits'
may exceed the maximum possible shift for an underlying 'int'.  So add an
extra check whether the aforementioned field represents the valid block
size, which is 512 bytes, 1K, 2K, or 4K.

Link: https://lkml.kernel.org/r/20241106092100.2661330-1-dmantipov@yandex.ru
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+56f7cd1abe4b8e475180@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=56f7cd1abe4b8e475180
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/super.c~ocfs2-fix-ubsan-warning-in-ocfs2_verify_volume
+++ a/fs/ocfs2/super.c
@@ -2319,6 +2319,7 @@ static int ocfs2_verify_volume(struct oc
 			       struct ocfs2_blockcheck_stats *stats)
 {
 	int status = -EAGAIN;
+	u32 blksz_bits;
 
 	if (memcmp(di->i_signature, OCFS2_SUPER_BLOCK_SIGNATURE,
 		   strlen(OCFS2_SUPER_BLOCK_SIGNATURE)) == 0) {
@@ -2333,11 +2334,15 @@ static int ocfs2_verify_volume(struct oc
 				goto out;
 		}
 		status = -EINVAL;
-		if ((1 << le32_to_cpu(di->id2.i_super.s_blocksize_bits)) != blksz) {
+		/* Acceptable block sizes are 512 bytes, 1K, 2K and 4K. */
+		blksz_bits = le32_to_cpu(di->id2.i_super.s_blocksize_bits);
+		if (blksz_bits < 9 || blksz_bits > 12) {
 			mlog(ML_ERROR, "found superblock with incorrect block "
-			     "size: found %u, should be %u\n",
-			     1 << le32_to_cpu(di->id2.i_super.s_blocksize_bits),
-			       blksz);
+			     "size bits: found %u, should be 9, 10, 11, or 12\n",
+			     blksz_bits);
+		} else if ((1 << le32_to_cpu(blksz_bits)) != blksz) {
+			mlog(ML_ERROR, "found superblock with incorrect block "
+			     "size: found %u, should be %u\n", 1 << blksz_bits, blksz);
 		} else if (le16_to_cpu(di->id2.i_super.s_major_rev_level) !=
 			   OCFS2_MAJOR_REV_LEVEL ||
 			   le16_to_cpu(di->id2.i_super.s_minor_rev_level) !=
_

Patches currently in -mm which might be from dmantipov@yandex.ru are


