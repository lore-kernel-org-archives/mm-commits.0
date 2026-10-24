Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792863573;
	b=QZMIOFjgeo/7vqEMpyd7micZij+u839ag1sA0CetAwt1oBUrJ8TMAAmprk3vIGpHi+ff
	 wPvNkGW1grhF+dQZjpZZf9XPUA2O9pDpGn8pyEWExEYsTHttl6ONt1YFNwbzGiB3bMQuB
	 bEeVGcucRso3Uqa3bQ1XaG2QTMZANB4pCfOArF83LCXxRL56Er3wGZqJuAqtmoTllqqtq
	 vGx/ns6XigmnV3+wN3+c68x2mnTK9eWsCsdHXcTpO7Zz9mrPRTZOuwwmOB+u+SpZi0wwe
	 hC9VUH6Pd7GLePOVvzmzh/m5ehU5PsFALWTPH7yeaev1yj3RRa3hLOxfmSjdCyI1+Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792863573;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ltZxm43WLsltiKzcI4YwjrkjSh75kf1koSoq85AHEn4=;
	b=kpg8StySXrM5mYr2h9ovBnzxeXDBJNUJiA0j0mkiHgADIck4LmqkgZTLzSk5eScr4DIV
	 2MkuGrK1wM077t1Op6i/e1Fb6Eo41GBSM97+8MKIP657ZCjDlUlqcxYat7hbs+aRCRrTV
	 SlwXFckjO//UVY8yoXnQtEjLojfkUmtz0J3K6oB7owvA2nv2YjYzG0z2B8TRNpHNUPATz
	 Pq8+zAayWCJdEbp0SQjMsvVCjZDOfzE9nx+IhmlOK043dwUvym3/aKecDyKdgnSmtasWr
	 JwxOUwmbPZrs3fGYdwnoKCJd03EM104ZjqkKzsoewyapc6icrwLeLr2g8ZQ2xrTjchw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hiAXQTiZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A65D606A321;
	Sat, 24 Oct 2026 17:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hiAXQTiZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32B31F01825;
	Sat, 24 Oct 2026 17:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792863572;
	bh=ltZxm43WLsltiKzcI4YwjrkjSh75kf1koSoq85AHEn4=;
	h=Date:To:From:Subject;
	b=hiAXQTiZDrjIK0bw7cqxMFkCumoV0BX1vaIE7djCN5o0Uo0kX08wD3SysiygvEzF/
	 ICqsQ4qArHQGn48x1J/sZQ3ZkZnKeuTQfBLy7G0HVnI6GXNWyOW5wZRXzu/hQL58B8
	 tkNy36Mh1AH++Jnb/kmJf0/KyZKxrrpkyDsC9FE4=
Date: Sat, 24 Oct 2026 10:39:32 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,
	jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-do-not-index-before-the-entry-array-when-dividing-an-empty-bucket.patch added to mm-nonmm-unstable branch
Message-Id: <20261024173932.C32B31F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: do not index before the entry array when dividing an empty bucket
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-do-not-index-before-the-entry-array-when-dividing-an-empty-bucket.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-do-not-index-before-the-entry-array-when-dividing-an-empty-bucket.patch

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

ocfs2-read-the-xattr-entry-hash-before-defragmenting-the-bucket.patch
ocfs2-find-the-xattr-entry-again-after-defragmenting-a-bucket.patch
ocfs2-find-the-xattr-entry-again-after-converting-a-block-to-a-bucket.patch
ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-bucket.patch
ocfs2-do-not-index-before-the-entry-array-when-dividing-an-empty-bucket.patch
ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-block.patch

