Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4248E430BB9
	for <mm-commits@vger.kernel.org>; Sun,  1 Mar 2026 21:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772400477; cv=none; b=HO3agJISfY489PXL/uU2qZd8OfCvjxdY7qqHrwIbHpB5w+8zZyJKCvFFoSYu22I08i+BLZFmexF9BqRHXxMxYrv5u0NZvLmouRwkTA47GDD5lSU+IKB8BLwWVG5NdIo+koQGpm/gLR8vBePSq0wrk22Tr/5D7IHdNhuQxe5h420=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772400477; c=relaxed/simple;
	bh=n/gCcx26eXDyieMjhdNrT4X/I0fpRKjsmazDz7sdmgM=;
	h=Date:To:From:Subject:Message-Id; b=fnMxHuBf6sg7AIT4Bv2NdINvfowMiV8cKwJujxtn+6f3UA0Grb2woXITGyTy97HyjeaDzVETGk2pXsUrHS3AZJvYl0FTOftpSLxpXpcVL1jJ25KL4E9iQK3stxnKiShytcpyt7gy5gTu8DupBftNC9QEN8rJYTgzMoN/yhMaHpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XGDtF56/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XGDtF56/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E76C116C6;
	Sun,  1 Mar 2026 21:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772400476;
	bh=n/gCcx26eXDyieMjhdNrT4X/I0fpRKjsmazDz7sdmgM=;
	h=Date:To:From:Subject:From;
	b=XGDtF56/5uerTRu+JO0d9RgXXtUsjQiHHfe9x8qthnXtTZxbSv1kyQ80JsmiSuxrT
	 Ov/vqbe+8WnD35w8j/JT73EsWPRbtyFTeNu8+MWl4qOsTygJ6KTvF7mS6gpNnuJn90
	 igkZPji3LOB9EDySalPbXSo6JMoSFzjfl6obRLNQ=
Date: Sun, 01 Mar 2026 13:27:55 -0800
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-glob-clean-up-bool-abuse-in-pointer-arithmetic.patch added to mm-nonmm-unstable branch
Message-Id: <20260301212756.94E76C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/glob: clean up "bool abuse" in pointer arithmetic
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-glob-clean-up-bool-abuse-in-pointer-arithmetic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-glob-clean-up-bool-abuse-in-pointer-arithmetic.patch

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
From: Josh Law <objecting@objecting.org>
Subject: lib/glob: clean up "bool abuse" in pointer arithmetic
Date: Sun, 1 Mar 2026 20:38:45 +0000

Replace the implicit 'bool' to 'int' conversion with an explicit ternary
operator.  This makes the pointer arithmetic clearer and avoids relying on
boolean memory representation for logic flow.

Link: https://lkml.kernel.org/r/20260301203845.2617217-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/glob.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/glob.c~lib-glob-clean-up-bool-abuse-in-pointer-arithmetic
+++ a/lib/glob.c
@@ -73,7 +73,7 @@ bool __pure glob_match(char const *pat,
 			if (c == '\0')	/* No possible match */
 				return false;
 			bool match = false, inverted = (*pat == '!');
-			char const *class = pat + inverted;
+			char const *class = inverted ? pat + 1 : pat;
 			unsigned char a = *class++;
 
 			/*
_

Patches currently in -mm which might be from objecting@objecting.org are

lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch
lib-glob-add-explicit-include-for-exporth.patch
lib-glob-replace-bitwise-or-with-logical-operation-on-boolean.patch
lib-glob-clean-up-bool-abuse-in-pointer-arithmetic.patch

