Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2B1494A14
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 21:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594775; cv=none; b=UtKGpOlzUwi4hVKcR4m08HYZCV+aSZxQVed6DPtUoSLtSp1mBIVcenlZIVoQForXb1Hk4zUfP3noclBWMsITTks0HwWT8Z9mTmtRrUdU48zgFrg6BfF/pYBwfW/RRiQuo3FXIJSO8c6HOmA1kXcL5XX64XiJ8cqUB7ZSrLCu3UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594775; c=relaxed/simple;
	bh=wXyb4TKqPzGtTNnKaZO2co/B5rVheiL91Rd5Ts4SO58=;
	h=Date:To:From:Subject:Message-Id; b=joCsxnbaqvuoilokWalePk/73pRo3zIQ8MOrVmXB9StoLYBPrOz0BRXK1tBtrVyv8fvH9B+je1IJbdwprjFPHj0ayf9M/ZYiH02J2NwYepPmx5dovxctjC9MH6qsmebq5nCLJHc2vLEPzLIs+JDzNcJAj3RsVNZt1FnBN/QMSko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=POhCuDE/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="POhCuDE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC591F0089D;
	Wed, 16 Sep 2026 21:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789594749;
	bh=MxiWA3SMEKlViwtOogINp9krZzG19nDzPXoPTRVjmis=;
	h=Date:To:From:Subject;
	b=POhCuDE/s4FG39V0lkJldSNmQGFeGuiuePK/fJKG4xOKa9yxEh1XhHO8l/M2+CEv7
	 d2w26XUQS2Z2BiVW4Fkt7/B9uAZVaTn7pHn5izTV496VIc84FygJmxMPGpbfKAe8eH
	 JltQpeZmiMYjdLHFtNO0eMsOH9BbsKl3o8Z2S0PE=
Date: Wed, 16 Sep 2026 14:39:09 -0700
To: mm-commits@vger.kernel.org,kernel@pengutronix.de,kees@kernel.org,andy@kernel.org,jre@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-string_helpers-fix-counting-of-remaining-bytes-in-string_unescape.patch added to mm-nonmm-unstable branch
Message-Id: <20260916213909.9FC591F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/string_helpers: fix counting of remaining bytes in string_unescape()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-string_helpers-fix-counting-of-remaining-bytes-in-string_unescape.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-string_helpers-fix-counting-of-remaining-bytes-in-string_unescape.patch

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
From: Jonas Rebmann <jre@pengutronix.de>
Subject: lib/string_helpers: fix counting of remaining bytes in string_unescape()
Date: Wed, 16 Sep 2026 19:38:10 +0200

All of the available sequences expand to exactly one byte, the size check
in the loop condition is sufficient for the case of an escaped character
too.

Otherwise, an escape sequence that should be unescaped to the last
character before terminating with null in the destination buffer will be
output as backslash instead of the escaped character.

The only exception is when encountering a backslash that turns out to not
start a valid escape sequence and both the backslash and the character
following are handled in one iteration.  Move the check there.

Add a kunit regression-test that unescapes a character to right in front
of the null terminator of the destination buffer.

Link: https://lore.kernel.org/20260916-string_unescape-v1-5-7f8bd986fa33@pengutronix.de
Fixes: 16c7fa05829e ("lib/string_helpers: introduce generic string_unescape")
Signed-off-by: Jonas Rebmann <jre@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
---

 lib/string_helpers.c             |    5 +++--
 lib/tests/string_helpers_kunit.c |    2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/lib/string_helpers.c~lib-string_helpers-fix-counting-of-remaining-bytes-in-string_unescape
+++ a/lib/string_helpers.c
@@ -329,7 +329,7 @@ int string_unescape(char *src, char *dst
 		size = SIZE_MAX;
 
 	while (*src && --size) {
-		if (src[0] == '\\' && src[1] != '\0' && size > 1) {
+		if (src[0] == '\\' && src[1] != '\0') {
 			src++;
 
 			if (flags & UNESCAPE_SPACE &&
@@ -349,7 +349,8 @@ int string_unescape(char *src, char *dst
 				continue;
 
 			*out++ = '\\';
-			size--;
+			if (!--size)
+				break;
 		}
 		*out++ = *src++;
 	}
--- a/lib/tests/string_helpers_kunit.c~lib-string_helpers-fix-counting-of-remaining-bytes-in-string_unescape
+++ a/lib/tests/string_helpers_kunit.c
@@ -626,6 +626,8 @@ static void test_unescape(struct kunit *
 
 	test_string_unescape_one(test, "short buffer", UNESCAPE_HEX, "\\x41\\x41B", 4, "AAB", 3);
 	test_string_unescape_one(test, "unrecognized escape at end", UNESCAPE_HEX, "B\\qX", 4, "B\\q", 3);
+
+	test_string_unescape_one(test, "end of buffer", UNESCAPE_HEX, "B\\x41", 3, "BA", 2);
 }
 
 static void test_escape(struct kunit *test)
_

Patches currently in -mm which might be from jre@pengutronix.de are

lib-tests-string_helpers-check-null-terminator-too.patch
lib-tests-string_helpers-drop-unused-parameters.patch
lib-tests-string_helpers-introduce-test_string_unescape_one.patch
lib-string_helpers-use-full-destination-buffer-in-string_unescape.patch
lib-string_helpers-fix-counting-of-remaining-bytes-in-string_unescape.patch

