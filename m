Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675981;
	b=3axCX3V71UZFN55Um24UzyochCSaz5+F0oGDT/Ze0zLlXfVlk0Vvly9w8U3KT7eJ2KcR
	 U90ke3G2VA9KpE5XKcx1b8T0f+U5hfbgttGCXdii0zywA0BUhmKxmKFvW0GBO6E8iKvWt
	 ZmquIuaJvPwrUjHjmcMgrAHUuxUfxkbAP89fuMpFai7r9/wL2Ps6mRaKyPwIeIiH8qMyH
	 o5L7NUF2vwmjruTAhqdSXd737zchEuju7KrFxHhgiDTb25cw4rm0xxvlaV++TpZOGNs/e
	 8fa6aRNhgZl3YjW2pFbp1FLX4Q+C1AJk6IRj7ClEy7ENiApmxQRw81sEyMgIA17rQJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675981;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=oPA5bNC7FBZdLqrw4MsMCOHa3PVILGkEnT50jHSkeJw=;
	b=Myy2I3+JGZBRVeboDhKI1qyjTVerWOAjkhLTUx9C/Id3FZevOACqpvKclpv+ShkMFaDH
	 yp039G4d4CdALThooR6ERRAAAzlIvEfGedFtE7HyJpiZjjF9fNO5TcqSPIJnEzQdgHGiD
	 nw+sRierMmoRft7TrHGd9TAbnmJZAh98Jo7SffBNP0KMs+gMqPZY/IwZeB9ZNGRcvJ4WD
	 A1mzHEZOvgBo1Ng/1Mzn1WX0z2RgtjkTxu64XX1a3/nK9dASIT7C4UbdznbK8zrWA9cCc
	 yqP/GPZnnX0LHj0ENtBHYrHIyQkVbRJYX/Ip42A3uRk91JTEn4kHsyL5fqPx2RDibaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="hbJ/tQV6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0E5606A333;
	Tue,  3 Nov 2026 03:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hbJ/tQV6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96211F000C1;
	Tue,  3 Nov 2026 03:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793675980;
	bh=oPA5bNC7FBZdLqrw4MsMCOHa3PVILGkEnT50jHSkeJw=;
	h=Date:To:From:Subject;
	b=hbJ/tQV69EI1t0XGKTP5wXQ58lmF2ywO6vhXqqlBS+18/Z2inknYbWLgx9YXgKyA8
	 bUfp/dFpERrM6y33Ac54Q1VaH2dugGt60q9LtUROLuTHLYyqzUt5FgjAmnYnnCDzFh
	 OPTZIEkBPv48rkJKA9AMezJrKfGmSuDR1BqP0DeI=
Date: Mon, 02 Nov 2026 19:19:40 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,
	jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] ocfs2-do-not-index-before-the-entry-array-when-dividing-an-empty-bucket.patch removed from -mm tree
Message-Id: <20261103031940.A96211F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: do not index before the entry array when dividing an empty bucket
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-index-before-the-entry-array-when-dividing-an-empty-bucket.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: do not index before the entry array when dividing an empty bucket
Date: Sat, 24 Oct 2026 23:10:11 +0800

ocfs2_divide_xattr_bucket() appends an empty bucket carrying a sentinel
hash when the source bucket has no divide position, taking that hash
from xh_entries[start - 1].  ocfs2_xattr_find_divide_pos() returns count
when every entry shares one hash, and its loop does not run at all for
count < 2, so an empty bucket comes back with start == count == 0 and
the read is xh_entries[-1].

That is outside the __counted_by_le(xh_count) bounds of xh_entries[] and
lands on the header, so the value picked up is
xh_count | xh_free_start << 16.  One above it is written into the new
bucket's xh_entries[0] and committed, which leaves a bucket whose first
hash does not follow the bucket before it.  ocfs2_xattr_bucket_find()
binary searches on xh_entries[0], so the broken key hides the range the
sentinel was meant to cover: getxattr() answers -ENODATA for an
attribute that is stored, and an insert can go to the wrong bucket and
leave two copies of a name.  The cross cluster divide hands the same
value back as a tree record's e_cpos, which then claims a hash range it
does not cover.

Read xh_entries[0] instead.  The branch is only reached when every entry
shares one hash, so for a non-empty bucket it holds the same value, and
for an empty one it is the slot that carries the bucket key.

An empty bucket reaches the divide from
ocfs2_check_xattr_bucket_collision(), which reports no collision for
one, through ocfs2_add_new_xattr_bucket() and
ocfs2_extend_xattr_bucket().  It does not take a failed set to get
there: a divide that finds no position is itself what leaves an empty
sentinel bucket behind, and a later extend can pick it as the target.

Link: https://lore.kernel.org/20261024151012.1059683-6-joseph.qi@linux.alibaba.com
Fixes: 80bcaf3469b8 ("ocfs2/xattr: Proper hash collision handle in bucket division")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/xattr.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/xattr.c~ocfs2-do-not-index-before-the-entry-array-when-dividing-an-empty-bucket
+++ a/fs/ocfs2/xattr.c
@@ -5228,7 +5228,15 @@ static int ocfs2_divide_xattr_bucket(str
 	start = ocfs2_xattr_find_divide_pos(xh);
 
 	if (start == count) {
-		xe = &xh->xh_entries[start-1];
+		/*
+		 * start == count means every entry shares one hash, so the
+		 * first of them carries it too.  An empty bucket has no
+		 * entries[start - 1], but its entries[0] still carries the
+		 * bucket key: either the hash ocfs2_xa_remove_entry()
+		 * deliberately leaves behind, or the sentinel a previous
+		 * divide wrote.
+		 */
+		xe = &xh->xh_entries[0];
 
 		/*
 		 * initialized a new empty bucket here.
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


