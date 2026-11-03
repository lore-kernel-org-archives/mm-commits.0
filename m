Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675982;
	b=pJDYi4IKYkKBxRhI39Uy8mHy/4a+EZ4xm+aofCEovWbC4BPzv2ISVFNZ8vwAHdmoQL7Z
	 OcVs0fVtdeOR61dsMJpSU1GTkTBVLBtBDio08igOdBjgU5ptvWVwyNre4jZybjuUV+8YX
	 BFQlQu51X9epAXV9rixgNZGOsPCrvIRY1Tk0Ly/ytRI+D7bwoBFQhhVQX0giSDfpgEwBK
	 gDKvJX2M+ct4XD3sz9xQJ+XnIu5L1jEi5TjS+xhSnO4jAsmXRi4N35JvBt/myU4D2aARz
	 fguE7e+MtNTWy0+KtVWVD7QejZP5RV0gM+g43hAblHHrwKQqNAwWAS5W2V2Tj4OKSWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675982;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=vlx9ThM+Vi20WjpWyaHCvOlfQT10gVNTdZ6aV4BY38E=;
	b=GxPXn9CbHErz8uDnSEx3PHwX21w0MAH9bMqNJsOi4oBrUWFMz8HvRatRp45hfhVI3Qqm
	 ey7EfwefT/vltlnD5Z0cSRg5hkABZRbzz9lL6p3FMOroJL1NM3VevDuGOQLwA8W574eny
	 X+OFyClTCwa5/v2BmxDDCB8YWlFb8xgIxayZEXi30But6XHDg2ipikC36QM/F9nWPoBWf
	 ra87NTyb3LaspbxC94CfO/R4q/4jVtwXiCDNRT2MSodhynXojrKosJk0uMBswRnIuK6Xq
	 moICbWHGXdaoVnu5zGKwyIA0J55WPoyzASrHqE2o9sjFbDrCsqzizJW2OFHsbkjO64w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mmFe+iFs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A879606A329;
	Tue,  3 Nov 2026 03:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mmFe+iFs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6831F0093A;
	Tue,  3 Nov 2026 03:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793675981;
	bh=vlx9ThM+Vi20WjpWyaHCvOlfQT10gVNTdZ6aV4BY38E=;
	h=Date:To:From:Subject;
	b=mmFe+iFse06BuiIKxffT6p1DfHR2ixM6IUQC2cuwHBFUJTWeOzL/yVBxXAv92h+Lv
	 yp7Q6cV5zo1ism8r5++F/HXQGB/MulpsjQwo99K5ZJIywt/+cipire1L+h/PTg/39q
	 J9HdvwGb9CTYnr4TiPI6LpaBp1YLazND+7pb9E7k=
Date: Mon, 02 Nov 2026 19:19:41 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,
	jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-block.patch removed from -mm tree
Message-Id: <20261103031941.CE6831F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: do not read the entry array of an empty xattr block
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-block.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: do not read the entry array of an empty xattr block
Date: Sat, 24 Oct 2026 23:10:12 +0800

ocfs2_cp_xattr_block_to_bucket() sizes the name and value area it has to
carry over from the block's last entry, so an empty block makes it read
xh_entries[-1].  That lands on the header, where xe_name_offset overlaps
xh_name_value_len, and block storage never maintains that field, so it
reads as 0 and the copy runs from the header to the end of the block.

The bucket that comes out has xh_count 0 but a name_value_len of
blocksize less the header, and a matching xh_free_start that claims
those bytes are in use -- nearly the whole bucket with the common 4K
block size -- while the last block of the bucket holds a copy of the old
block's bytes.  Nothing but a trace event reads xh_name_value_len, the
copied bytes came from the same inode and were wiped before the entry
was removed, and ocfs2_defrag_xattr_bucket() recomputes xh_free_start,
so this corrupts the header rather than leaking anything.

Leave the bucket empty instead, carrying over the hash the block was
keyed by, since ocfs2_add_new_xattr_bucket() and
ocfs2_xattr_bucket_find() both read xh_entries[0] of an empty bucket.
That read is the exception ocfs2_xa_remove_entry() documents rather than
a new out of bounds access.

A block reaches the conversion empty when truncating an external value
back fails partway through: the "reusing" and "overwriting" callers of
ocfs2_xa_cleanup_value_truncate() remove the entry without setting
ctxt->set_abort, so ocfs2_xattr_block_set() sees a plain -ENOSPC and
converts.  The "growing" caller does set it, and the block form makes a
single attempt with no defragment and retry in between, so that is the
only route here.

Link: https://lore.kernel.org/20261024151012.1059683-7-joseph.qi@linux.alibaba.com
Fixes: 012255961c9e ("ocfs2: Enable xattr set in index btree")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/xattr.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/fs/ocfs2/xattr.c~ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-block
+++ a/fs/ocfs2/xattr.c
@@ -4705,6 +4705,21 @@ static void ocfs2_cp_xattr_block_to_buck
 		memset(bucket_block(bucket, i), 0, blocksize);
 
 	/*
+	 * An empty block has no names or values to carry over, and the
+	 * xh_entries[count - 1] below would be xh_entries[-1].  Leave the
+	 * bucket empty, but carry over the hash ocfs2_xa_remove_entry() left
+	 * in the block's xh_entries[0] so that the bucket still holds the key
+	 * it is looked up by.
+	 */
+	if (!count) {
+		xh->xh_num_buckets = cpu_to_le16(1);
+		xh->xh_free_start = cpu_to_le16(OCFS2_XATTR_BUCKET_SIZE);
+		xh->xh_entries[0].xe_name_hash =
+			xb_xh->xh_entries[0].xe_name_hash;
+		return;
+	}
+
+	/*
 	 * Since the xe_name_offset is based on ocfs2_xattr_header,
 	 * there is a offset change corresponding to the change of
 	 * ocfs2_xattr_header's position.
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


