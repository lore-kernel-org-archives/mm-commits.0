Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C379C3546EA
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338706; cv=none; b=hEMkD4/pC7AppTswDFNkbJkyAt+vrYw1RaSX0G3iZNMmyFpjHfV94xYlFoHr8SNfgk2n1wMeqpTkGNU9DoHi1MhhEhM7GjHE6kGv8DfkM/ajIoV1HI5IAYzzeEppjqdvrRt+zgnDu+/da+FhB43yCUk3HEiqxLPCz+tz29PweAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338706; c=relaxed/simple;
	bh=/avSlIJMLFp7st+EwH4UwWL41q+jqqiQUkYuB2OiEoI=;
	h=Date:To:From:Subject:Message-Id; b=mzFQcOPei2LYHHS5iRmyzv8YBStKvg/83lNHDjZpkcTkQIsXI2IF+visTdP9a7QbcYZBUssDfj69ar+rN3Ert0Ly8zm4vZUQgGCQ6oyoKAC/oIW3LNT8poNAhAc6znxs1bmYukzikbDuB4nSad50x/xhL5G/D7TT0R0Ke+xN9DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wFsts5gh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wFsts5gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F171F0089B;
	Wed,  7 Oct 2026 02:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338705;
	bh=u0OynU/mJrEqnbcZvfAxNQ4MZl7B7hMp0dCHQ0SfqgQ=;
	h=Date:To:From:Subject;
	b=wFsts5ghwdWZELNDmDGU7FE8hxKO1N71XjSU6oe9BjZsSxAcohBa3WpWc0oc5EyM5
	 H3dToeCowRlaZ3AttAv9hEjkCemWXrNq1oftRlryOvNeuiwXq8ghLKmX307A71IyXL
	 tbszZbJYHkSV/5gD/gOj9KWyMCl+vUDl4Ifrn224=
Date: Tue, 06 Oct 2026 19:05:05 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,joe@perches.com,corbet@lwn.net,colin.i.king@gmail.com,hemanth.selam@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-spellingtxt-keep-british-spelling-for-initalise.patch removed from -mm tree
Message-Id: <20261007020505.84F171F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/spelling.txt: keep British spelling for "initalise"
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-keep-british-spelling-for-initalise.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Assisted-by: Cursor:claude-opus-5
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
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


