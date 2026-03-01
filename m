Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AD4175A6A
	for <mm-commits@vger.kernel.org>; Sun,  1 Mar 2026 19:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772392812; cv=none; b=dFCYPc0obvZSOne6fAMAzGVE2XprzVsJeoh3Il37aFE5uFnjTUg2yKYkoVTEGKqVrpxk6X5oXh+t9kaRJj0kXekyN+FWXttteta3DYP6aAAN5h76CEolVGy3AJ0YGiF6YSAKGv+5c3Opf2a5OvXWIlgwY8FQ3cacbcaGotVRG3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772392812; c=relaxed/simple;
	bh=1haLKSBu15uSC4vfDrIHI8HEOwalT9mKriBrV1dCNF4=;
	h=Date:To:From:Subject:Message-Id; b=Z89sokgce2R+6koRG8CbvQcywAqccxJSF6ZeFfvJJHvXBCHvAMCF+i0NcZ8iI+A4wtx1nHxAplu/LPtfxM+K97TZ3B/H05JCmoNlE27g9qAejBUSPaQaOe7EBGZC2hA8mr3YMSeGDi9w4hdV3VeYIo4/b6s/3nvjY5ILm3I7hIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0scYn8s1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0scYn8s1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA874C116C6;
	Sun,  1 Mar 2026 19:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772392812;
	bh=1haLKSBu15uSC4vfDrIHI8HEOwalT9mKriBrV1dCNF4=;
	h=Date:To:From:Subject:From;
	b=0scYn8s1UdAvfQRjxwuv1qBUSFxemQdAR3IwxiiB5ywQXdStWD2ALo3YJuG47jrBx
	 p403PjqWTqiltteh4NHzvqMDXWBtpw2FCoT7vHEfu5AarKGN+wfYvwdV35VOUPC/Au
	 ACfu62QPsd+d5RtvAkKs3aR9+FSBMcXOl5NX8Wz4=
Date: Sun, 01 Mar 2026 11:20:11 -0800
To: mm-commits@vger.kernel.org,objecting@objecting.org,hlcj1234567@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch added to mm-nonmm-unstable branch
Message-Id: <20260301192011.EA874C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: glob: fix grammar and replace non-inclusive terminology
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch

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
From: Josh Law <hlcj1234567@gmail.com>
Subject: lib: glob: fix grammar and replace non-inclusive terminology
Date: Sun, 1 Mar 2026 15:45:53 +0000

Fix a missing article ('a') in the comment describing the glob
implementation, and replace 'blacklists' with 'denylists' to align with
the kernel's inclusive terminology guidelines.

Link: https://lkml.kernel.org/r/20260301154553.2592681-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/glob.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/glob.c~lib-glob-fix-grammar-and-replace-non-inclusive-terminology
+++ a/lib/glob.c
@@ -21,7 +21,7 @@ MODULE_LICENSE("Dual MIT/GPL");
  * Pattern metacharacters are ?, *, [ and \.
  * (And, inside character classes, !, - and ].)
  *
- * This is small and simple implementation intended for device blacklists
+ * This is a small and simple implementation intended for device denylists
  * where a string is matched against a number of patterns.  Thus, it
  * does not preprocess the patterns.  It is non-recursive, and run-time
  * is at most quadratic: strlen(@str)*strlen(@pat).
_

Patches currently in -mm which might be from hlcj1234567@gmail.com are

lib-glob-add-missing-spdx-license-identifier.patch
lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch

