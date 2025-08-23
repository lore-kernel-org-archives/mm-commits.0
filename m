Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9F3224F6
	for <mm-commits@vger.kernel.org>; Sat, 23 Aug 2025 00:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755908965; cv=none; b=n/38Ed3cu+VdzhXksZe1ZWFuoFnjEphveHVqydrTmfegoYjTHs99Le3SlCFaJWOMRUxNV4a8oTvBBbCQHPExr5BZ14o8HtFxiyvckKFd2mCVWooZUtsuPSy1hV7CNIqQlAEoRZlx1sIKqqLSPT+lFbWxRApqg5s0NIielSLXnGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755908965; c=relaxed/simple;
	bh=8IzoUbGXgcwmpeGkbk4jv7+eWGXirAcTBEQJbnKKx3w=;
	h=Date:To:From:Subject:Message-Id; b=E3+0F8EjlX9wfThWM58lZr4iIO8iwHdd5Zu41jkGKupmJfEPNMtCqe8NXqME3sq6JVvF+dJ5ShtEzjRRmpaBS8dI9hhEn3Draky/1gLumy2rOd2OePN4L7RuLViyfN0CO1w/i7NSU88FEqdw7S6nAMQy7Wy/OKCOUBpx5kVZN94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F7Ox+d0z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F7Ox+d0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8144BC4CEED;
	Sat, 23 Aug 2025 00:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755908964;
	bh=8IzoUbGXgcwmpeGkbk4jv7+eWGXirAcTBEQJbnKKx3w=;
	h=Date:To:From:Subject:From;
	b=F7Ox+d0zPle/ZpJ3XGS7J/NT+G498loD+/fBU+JwXCFDvm6lFuckLAZTgOjCn2iD1
	 JWR2n8kgJNx3o0zJtjWEkyxNaHCAfP07xwu7RhjP3jcemBLNnsyhO9AeoYZIZk8Vwb
	 DvglREpLzxhWI1e8F8ZMBkBiSrlAlVhyBv6bCbCc=
Date: Fri, 22 Aug 2025 17:29:23 -0700
To: mm-commits@vger.kernel.org,409411716@gms.tku.edu.tw,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + btree-fix-merge-logic-to-use-btree_last-return-value.patch added to mm-nonmm-unstable branch
Message-Id: <20250823002924.8144BC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: btree: fix merge logic to use btree_last() return value
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     btree-fix-merge-logic-to-use-btree_last-return-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/btree-fix-merge-logic-to-use-btree_last-return-value.patch

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
From: "Guan-Chun.Wu" <409411716@gms.tku.edu.tw>
Subject: btree: fix merge logic to use btree_last() return value
Date: Fri, 22 Aug 2025 16:58:51 +0800

Previously btree_merge() called btree_last() only to test existence, then
performed an extra btree_lookup() to fetch the value.  This patch changes
it to directly use the value returned by btree_last(), avoiding redundant
lookups and simplifying the merge loop.

Link: https://lkml.kernel.org/r/20250822085851.566303-1-409411716@gms.tku.edu.tw
Signed-off-by: Guan-Chun.Wu <409411716@gms.tku.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/btree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/btree.c~btree-fix-merge-logic-to-use-btree_last-return-value
+++ a/lib/btree.c
@@ -653,9 +653,9 @@ int btree_merge(struct btree_head *targe
 	 * walks to remove a single object from the victim.
 	 */
 	for (;;) {
-		if (!btree_last(victim, geo, key))
+		val = btree_last(victim, geo, key);
+		if (!val)
 			break;
-		val = btree_lookup(victim, geo, key);
 		err = btree_insert(target, geo, key, val, gfp);
 		if (err)
 			return err;
_

Patches currently in -mm which might be from 409411716@gms.tku.edu.tw are

btree-fix-merge-logic-to-use-btree_last-return-value.patch

