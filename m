Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35C6219EB
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 00:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756254352; cv=none; b=PP+1b+XzN81B6eRU14mYNniqmIMvd6lchXyZYMsBML8VpczQvXlbtU588tD4MBnXCyXUvxC1N/6sSdMx/NJgpU5teD7H6t1ZGyTv/olUy0r+t3h/0NT2wNy9vFFeVt97rdUttsb/c/2NYh8QTeEJmdbF054Q/f1I8y9elk3Pr78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756254352; c=relaxed/simple;
	bh=DbHixXTAyXwMF12O7Nib/8mNDVbplzbFUrh5n84Qo9A=;
	h=Date:To:From:Subject:Message-Id; b=f5/z7jIJQmTDX9WF3iZ87f7ssdMT+J/OCC3nzTxVnlefo09uyCLt112CLO0SLkU/jHe9evNC92e+CjgHWLt5kn8GuLt2L+KUcnr9y2drR6+fYLkNIzIBTW9ETfYNdrMtXE0VKM/0fLN8nWyAh42utkk6Csj9hFUzNchlFM9sRI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0AvSKD5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0AvSKD5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEEFC4CEF1;
	Wed, 27 Aug 2025 00:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756254352;
	bh=DbHixXTAyXwMF12O7Nib/8mNDVbplzbFUrh5n84Qo9A=;
	h=Date:To:From:Subject:From;
	b=0AvSKD5b3EUlODibtirkCPzSQL3OoL75wsv5ojiDbUJRr8wBXbjgkV2Sy3dzoMT06
	 Qo0cEyUTZXaR4ToL79X4B0aeCbyPaPfb7BWY8la0EJi/lt+6ghydhTWP4RZTOZGyp3
	 878x2B1bxhyLUH+wS7RI8tz4OOnS/PWLhE1Qxmg0=
Date: Tue, 26 Aug 2025 17:25:51 -0700
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,409411716@gms.tku.edu.tw,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + btree-simplify-merge-logic-by-using-btree_last-return-value.patch added to mm-nonmm-unstable branch
Message-Id: <20250827002552.2DEEFC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: btree: simplify merge logic by using btree_last() return value
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     btree-simplify-merge-logic-by-using-btree_last-return-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/btree-simplify-merge-logic-by-using-btree_last-return-value.patch

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
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Subject: btree: simplify merge logic by using btree_last() return value
Date: Wed, 27 Aug 2025 00:17:41 +0800

Previously btree_merge() called btree_last() only to test existence, then
performed an extra btree_lookup() to fetch the value.  This patch changes
it to directly use the value returned by btree_last(), avoiding redundant
lookups and simplifying the merge loop.

Link: https://lkml.kernel.org/r/20250826161741.686704-1-409411716@gms.tku.edu.tw
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/btree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/btree.c~btree-simplify-merge-logic-by-using-btree_last-return-value
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

btree-simplify-merge-logic-by-using-btree_last-return-value.patch

