Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445C325740
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467337; cv=none; b=feUMgs0JYrnFkk7jCqkx/5tovATkjV3Wzfc3L24yD/1XrnxPKJ4NHLRkV0FBUSQqKOdDcv1M9qXcomn0KW5TtN9iDnT0VBAamArZVpGVtpxNa862ghxI/pwPUw9xdxTc/eTs6wFseDDDDUmerfuJnqRfcxbQ1cVxtPeoiWPGzuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467337; c=relaxed/simple;
	bh=/G0K9pvvAIn0owS27rrgFPZ2pUMnpqBtEzr/dsy2t70=;
	h=Date:To:From:Subject:Message-Id; b=nxogDywah0hYeQVBscTNEFpaSxXMmOMCv10fBoNBpQbzYDsHUtHGCgiQsTWlfrFls7q6uLrtO5DcPoYeGss7r6EwewWyW67GtsgkaO8LlKNYqNXG33l2Hh5JyFHC7hxMru07+ExKIqBct2Vu9CqhStOJdOFLq1VRRLWFrqgwAgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=stZUqpsE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="stZUqpsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D09C32781;
	Sat, 11 May 2024 22:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467337;
	bh=/G0K9pvvAIn0owS27rrgFPZ2pUMnpqBtEzr/dsy2t70=;
	h=Date:To:From:Subject:From;
	b=stZUqpsEoEVWwhno8iKpH40Slx/qwX7oSWqageqEoFM7Ohn5OtGuPXDgsoPDaVbC/
	 JyoVex79FRnt0JDKQUgZ3NI7TiJygm78KfyIqRJyoSyGobvf8NKx9o8OyucRBF7Cxx
	 tDkfttXqA+VdS1LDl25vCFLyouYcVPITnpbUvcRk=
Date: Sat, 11 May 2024 15:42:16 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch removed from -mm tree
Message-Id: <20240511224217.18D09C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/maintainer-profile: allow posting patches based on damon/next tree
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/maintainer-profile: allow posting patches based on damon/next tree
Date: Fri, 3 May 2024 11:03:18 -0700

The document mentions any patches for review should based on mm-unstable
instead of damon/next.  It should be the recommended process, but
sometimes patches based on damon/next could be posted for some reasons. 
Actually, the DAMON-based tiered memory management patchset[1] was written
on top of 'young page' DAMOS filter patchset, which was in damon/next tree
as of the writing.

Allow such case and just ask such things to be clearly specified.

[1] https://lore.kernel.org/20240405060858.2818-1-honggyu.kim@sk.com

Link: https://lkml.kernel.org/r/20240503180318.72798-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -20,9 +20,10 @@ management subsystem maintainer.  After
 be queued in mm-stable [3]_ , and finally pull-requested to the mainline by the
 memory management subsystem maintainer.
 
-Note again the patches for review should be made against the mm-unstable
-tree [1]_ whenever possible.  damon/next is only for preview of others' works
-in progress.
+Note again the patches for mm-unstable tree [1]_ are queued by the memory
+management subsystem maintainer.  If the patches requires some patches in
+damon/next tree [2]_ which not yet merged in mm-unstable, please make sure the
+requirement is clearly specified.
 
 Submit checklist addendum
 -------------------------
_

Patches currently in -mm which might be from sj@kernel.org are


