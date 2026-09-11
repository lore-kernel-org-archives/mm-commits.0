Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BD717A586
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 00:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789086030; cv=none; b=X+LPGO+T1WenMRcX9jii1rxrTf80WMOnQznmzL/gYkDnsmFSqOeAdx5jL3HlKdFVkYgm2B0AFxYthnc4noWl3iOXVhREZ8yMdrJYsZs0SXFJPtK99962pksO+bOleLwnYjAcxhkSO1fB9Ox9HdM1MBx5FmBjB5Hd5AOUJ5rQulE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789086030; c=relaxed/simple;
	bh=Vix4fk2MzACyOJXiFenR2i+dgj3zj/w3Up2L9Ugxrp8=;
	h=Date:To:From:Subject:Message-Id; b=utg747UAWvaPRhKTi6fCryBaBuRk1qS2wRr4zaEOg7Z4+aihCo3eXBR+PFq2cSjrvFylZZ2kATlOAy4SHBmlaqEV5lcmO/5nwfZvS0OT24ArA040zniRYv2B3B5EaThq22Oj34xzrpFWa1M22PIZ+h0JEs2t9571EqhB9RT7uTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UBxC9gJr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UBxC9gJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8951F000FF;
	Fri, 11 Sep 2026 00:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789086029;
	bh=Ltdolm77MWmwDuucjv6u6L4/vrgwwQ+WCHTJaZhrh4k=;
	h=Date:To:From:Subject;
	b=UBxC9gJrATpoFz9/nvEcnzKDuKGZnyyuv1okU4CQIWLz4olpaJns8RaXG4UDvEt88
	 ZZAgN7bVa/UaRC9xKS/iLuwcdGuSi7knSyhSHgO2kWu1w156afS8912umXw92fhE4c
	 WSg3CGRTddC4wWkYSWaavnDXpmjsbDWogUlamhxI=
Date: Thu, 10 Sep 2026 17:20:28 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,joe@perches.com,corbet@lwn.net,colin.i.king@gmail.com,hemanth.selam@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-spellingtxt-keep-british-spelling-for-initalise.patch added to mm-nonmm-unstable branch
Message-Id: <20260911002029.1B8951F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/spelling.txt: keep British spelling for "initalise"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-spellingtxt-keep-british-spelling-for-initalise.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-spellingtxt-keep-british-spelling-for-initalise.patch

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
From: Hemanth Selam <hemanth.selam@gmail.com>
Subject: scripts/spelling.txt: keep British spelling for "initalise"
Date: Mon, 7 Sep 2026 14:43:24 +0530

These are the only two entries in the file that map a British spelling to
an American one:

  initalised||initialized
  initalise||initialize

doc-guide/checkpatch.rst asks that British and American spellings be left
alone, so correcting the missing "i" should not also change the variety of
English.  Following checkpatch here silently rewrites "initalised" to
"initialized" in files that otherwise use British forms; arch/arm64 alone
has 58 uses of "initialised" against 132 of "initialized", so both are
clearly in use.

Map them to the British forms instead, so the misspelling is still caught
while the spelling variety is left to the author.

Link: https://lore.kernel.org/20260907091324.32211-1-hemanth.selam@gmail.com
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
Suggested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Assisted-by: Cursor:claude-opus-5
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/spelling.txt~scripts-spellingtxt-keep-british-spelling-for-initalise
+++ a/scripts/spelling.txt
@@ -872,8 +872,8 @@ infromation||information
 ingore||ignore
 inheritence||inheritance
 inital||initial
-initalised||initialized
-initalise||initialize
+initalised||initialised
+initalise||initialise
 initalized||initialized
 initalize||initialize
 initation||initiation
_

Patches currently in -mm which might be from hemanth.selam@gmail.com are

selftests-mm-remove-the-local-pkey_unrestricted-fallback.patch
scripts-spellingtxt-keep-british-spelling-for-initalise.patch

