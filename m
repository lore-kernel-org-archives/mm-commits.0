Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6669C3D9552
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 20:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785876142; cv=none; b=gPZ4bbeBHRLyHa+HrJRlW86mFjAPYOUcmsFWs/TGg6jkncBg81MVJ63q2fLUn5jvRt85hpXueYj4IWAU3Un23FSHM82fxxMd2OHIzJh/MR8kc0lCA/JKIBIum9S/8ZEWleXxqYn6clConsmabl/Yrj9CUA4zbrYM1in5XsmqJJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785876142; c=relaxed/simple;
	bh=ifPEGsn8Kw7k7P3PMlEjSzCUkjFYi4rQw4WQ4mMG6C8=;
	h=Date:To:From:Subject:Message-Id; b=TzFSXLR8E82w8MFIIxAk1KP5hsUy6j+W3eWKK13eao52TWLBj4hD2i+ph3zm7CDVfxJWrwcp0LVLGsDzW1eVOOQ6kp7uAgCu83+ZFpdjPQWX9WHEuaxdHYPzCbuNOtgfBJ7aevKsPRi7NJ8vFWCvyYPEtv6q9l5G4VRo8J9IEE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1qOsOA16; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1qOsOA16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D851F000E9;
	Tue,  4 Aug 2026 20:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785876141;
	bh=WTD8YELFJI9uH0OdKjdIHbl2vlMT2MwgQFjcWXY4wz0=;
	h=Date:To:From:Subject;
	b=1qOsOA16lY5gp8dSsmacBItl/8A9Z7Kyeb5m9psQSBaK0oeWx3C+l/ZjZ3idHioxt
	 ziz61Yxs1k8JZkgnRNGoK5hLxGQmhrhBTLN92lbWOofRp3fmCFZ5VcusFAqKmbuVAY
	 fNPR374gO+pLYLAQuQHdhSZLC39ZJW7gmcVMaSk0=
Date: Tue, 04 Aug 2026 13:42:20 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,gality369@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-dio-orphan-slot-during-inode-read.patch added to mm-nonmm-unstable branch
Message-Id: <20260804204221.02D851F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate DIO orphan slot during inode read
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-dio-orphan-slot-during-inode-read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-dio-orphan-slot-during-inode-read.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: ZhengYuan Huang <gality369@gmail.com>
Subject: ocfs2: validate DIO orphan slot during inode read
Date: Mon, 3 Aug 2026 11:00:07 +0800

[BUG]
A corrupted append-DIO dinode (high byte at offset 0xa1
corrupted from 0 to 1) can carry an i_dio_orphaned_slot
outside the mounted filesystem slot range and trigger a
use-after-free error:

BUG: KASAN: slab-use-after-free in ocfs2_get_system_file_inode+0x780/0x820 fs/ocfs2/sysfile.c:102
Read of size 8 at addr ffff88800b767c00 by task kworker/u8:3/85
Call Trace:
 ...
 ocfs2_get_system_file_inode+0x780/0x820 fs/ocfs2/sysfile.c:102
 ocfs2_wipe_inode+0x292/0xf70 fs/ocfs2/inode.c:840
 ocfs2_delete_inode fs/ocfs2/inode.c:1155 [inline]
 ocfs2_evict_inode+0x6c9/0x1170 fs/ocfs2/inode.c:1295
 evict+0x38e/0x8f0 fs/inode.c:810
 iput_final fs/inode.c:1914 [inline]
 iput fs/inode.c:1966 [inline]
 iput+0x55b/0x8b0 fs/inode.c:1926
 ocfs2_recover_orphans+0x610/0xe40 fs/ocfs2/journal.c:2374
 ocfs2_complete_recovery+0x5af/0xd00 fs/ocfs2/journal.c:1373
 ...

[CAUSE]
ocfs2_del_inode_from_orphan() uses i_dio_orphaned_slot to index the
slot-local system inode cache. The dinode validator does not check
this active slot, so an out-of-range value produces an invalid cache
entry pointer that is dereferenced as an inode pointer.

[FIX]
Reject an active i_dio_orphaned_slot outside the slot range during
dinode validation, before DIO orphan recovery can consume it.

Link: https://lore.kernel.org/20260803030007.3993199-3-gality369@gmail.com
Fixes: 06ee5c75b575 ("ocfs2: add functions to add and remove inode in orphan dir")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-validate-dio-orphan-slot-during-inode-read
+++ a/fs/ocfs2/inode.c
@@ -1536,6 +1536,14 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	if ((le32_to_cpu(di->i_flags) & OCFS2_DIO_ORPHANED_FL) &&
+	    le16_to_cpu(di->i_dio_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: DIO orphaned slot %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_dio_orphaned_slot));
+		goto bail;
+	}
+
 	/*
 	 * Reject dinodes whose i_mode does not name one of the seven
 	 * canonical POSIX file types.  ocfs2_populate_inode() copies
_

Patches currently in -mm which might be from gality369@gmail.com are

ocfs2-validate-orphan-slot-during-inode-read.patch
ocfs2-validate-dio-orphan-slot-during-inode-read.patch

