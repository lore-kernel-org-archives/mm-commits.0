Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CAB2FDC3D
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 00:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765759387; cv=none; b=mnabe54VWe4FCYzl3P53xKU8wId9XvRTdnMGGujdLZZVgqw/seJhfArfJiYbF1Ef6tBPWYgbgAkrWUtNny13l1BJlbklrzTux25JlUT0mOOrLl/0KPvucPPKhaKPyaSdGM3+hElS1gazF+/Vwbghhn1aUPl/YS0REgcKxVdZ93Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765759387; c=relaxed/simple;
	bh=y7JZAm2ZDU10ZWj9P3/mqcyQetCOkSt23etYgGkLnRQ=;
	h=Date:To:From:Subject:Message-Id; b=t0nXa79/jGFlfY4rynhCGHoU34r+X05x3/oZ2Rjyh8OhVJGDutePk3J49uNP1j4APTihQMRdKUpK2xsHUnsNrFOAXzCoW3F2kfArzntzXy2EBYlDTJUQfXKYN4d24bxUbSinKnaKLgbAsEmIMmr5xianpqU2fc0p4DdJH9jzTj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nq5Jg3hG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nq5Jg3hG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3119C4CEF1;
	Mon, 15 Dec 2025 00:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765759386;
	bh=y7JZAm2ZDU10ZWj9P3/mqcyQetCOkSt23etYgGkLnRQ=;
	h=Date:To:From:Subject:From;
	b=nq5Jg3hGYWMsH7zLEVNs/GAMB8Yfrs7fo/YZPGsFxFztwtvBgVcBKnviafV8F6GXP
	 o50gOPTVPDWUPrhbBuvA8XSm54yaOgtUi5o/mDM4dWva3fziXUCKviYA0thLiojnNY
	 rIjFSKdTjrmLxe9XUhFB38y3FVgaMoRyW/8lV3WY=
Date: Sun, 14 Dec 2025 16:43:06 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-inline-data-i_size-during-inode-read.patch added to mm-nonmm-unstable branch
Message-Id: <20251215004306.C3119C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate inline data i_size during inode read
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-inline-data-i_size-during-inode-read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-inline-data-i_size-during-inode-read.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: ocfs2: validate inline data i_size during inode read
Date: Fri, 12 Dec 2025 10:51:32 +0530

When reading an inode from disk, ocfs2_validate_inode_block() performs
various sanity checks but does not validate the size of inline data.  If
the filesystem is corrupted, an inode's i_size can exceed the actual
inline data capacity (id_count).

This causes ocfs2_dir_foreach_blk_id() to iterate beyond the inline data
buffer, triggering a use-after-free when accessing directory entries from
freed memory.

In the syzbot report:
  - i_size was 1099511627576 bytes (~1TB)
  - Actual inline data capacity (id_count) is typically <256 bytes
  - A garbage rec_len (54648) caused ctx->pos to jump out of bounds
  - This triggered a UAF in ocfs2_check_dir_entry()

Fix by adding a validation check in ocfs2_validate_inode_block() to ensure
inodes with inline data have i_size <= id_count.  This catches the
corruption early during inode read and prevents all downstream code from
operating on invalid data.

Link: https://lkml.kernel.org/r/20251212052132.16750-1-kartikey406@gmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c897823f699449cc3eb4
Tested-by: syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20251211115231.3560028-1-kartikey406@gmail.com/T/ [v1]
Link: https://lore.kernel.org/all/20251212040400.6377-1-kartikey406@gmail.com/T/ [v2]
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-validate-inline-data-i_size-during-inode-read
+++ a/fs/ocfs2/inode.c
@@ -1494,12 +1494,25 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
-	if ((le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) &&
-	    le32_to_cpu(di->i_clusters)) {
-		rc = ocfs2_error(sb, "Invalid dinode %llu: %u clusters\n",
-				 (unsigned long long)bh->b_blocknr,
-				 le32_to_cpu(di->i_clusters));
-		goto bail;
+	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
+		struct ocfs2_inline_data *data = &di->id2.i_data;
+
+		if (le32_to_cpu(di->i_clusters)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: %u clusters\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le32_to_cpu(di->i_clusters));
+			goto bail;
+		}
+
+		if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 (unsigned long long)le64_to_cpu(di->i_size),
+					 le16_to_cpu(data->id_count));
+			goto bail;
+		}
 	}
 
 	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
_

Patches currently in -mm which might be from kartikey406@gmail.com are

mm-vmscan-always-allow-writeback-during-memcg-reclaim.patch
ocfs2-validate-i_refcount_loc-when-refcount-flag-is-set.patch
ocfs2-validate-inline-data-i_size-during-inode-read.patch

