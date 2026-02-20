Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0693309EFB
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 21:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771623281; cv=none; b=RKSTgVZssJSQXdFQS3UPV/hZSf92JAitTjYgrbr34v1+I4zMpahhvOrP7V2V5PtN5EKZtNI4NRfFpegKWhfq1I/61Nbch8NUuWUnVFW6/yfqstiPGN5es2Z7d1gOGFBR8aLVbU3ZTOZZFp+U1nGvxYMi4cbH5Kh60Q3HDy3+Lzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771623281; c=relaxed/simple;
	bh=DQ9g8eCLJMfnugcrcntC1BcPRR4fiah6Ti+YpoaRGGU=;
	h=Date:To:From:Subject:Message-Id; b=AcMXCPtysCgWzrQ9yB/2ytsU0l6s+lme/q0Zape0wW57RmiLGkppO4Nb8hygHX0ukAJY2jTVTd1AX1/bNfLe88bi4Ir5w/mKMFYSbj4GCYTZk9+yTmVW84fBzEFk+JwqCZGdFat89qkXt+jCPlLvzlHxwOKeu0QGow6YZYjZRvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LzbHgQTO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LzbHgQTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A318DC116C6;
	Fri, 20 Feb 2026 21:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771623281;
	bh=DQ9g8eCLJMfnugcrcntC1BcPRR4fiah6Ti+YpoaRGGU=;
	h=Date:To:From:Subject:From;
	b=LzbHgQTOAopiEHdM5pLmHNdgynULCxlBzYHSeXcWxOcZeN8/N3bk5p0NM3p84fZ5x
	 IRPyFQ8vsXPk/iogrrbCH0OBatysMsF2dNWV/48u0z81PptHAOLrQ3hM8xJ8eqEzhq
	 WO+ARC9i1BpNf+PhcAabOScY84b+2OKauja5AH9Q=
Date: Fri, 20 Feb 2026 13:34:40 -0800
To: mm-commits@vger.kernel.org,kees@kernel.org,djwong@kernel.org,andriy.shevchenko@intel.com,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-fix-memparse-to-handle-overflow.patch added to mm-nonmm-unstable branch
Message-Id: <20260220213441.A318DC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: fix memparse() to handle overflow
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-fix-memparse-to-handle-overflow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-fix-memparse-to-handle-overflow.patch

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
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: lib: fix memparse() to handle overflow
Date: Thu, 12 Feb 2026 19:44:10 +0300

Since '_parse_integer_limit()' (and so 'simple_strtoull()') is now capable
to handle overflow, adjust 'memparse()' to handle overflow (denoted by
ULLONG_MAX) returned from 'simple_strtoull()'.  Also use
'check_shl_overflow()' to catch an overflow possibly caused by processing
size suffix and denote it with ULLONG_MAX as well.

Link: https://lkml.kernel.org/r/20260212164413.889625-3-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cmdline.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/lib/cmdline.c~lib-fix-memparse-to-handle-overflow
+++ a/lib/cmdline.c
@@ -150,39 +150,46 @@ EXPORT_SYMBOL(get_options);
 unsigned long long memparse(const char *ptr, char **retptr)
 {
 	char *endptr;	/* local pointer to end of parsed string */
-
 	unsigned long long ret = simple_strtoull(ptr, &endptr, 0);
+	unsigned int shl = 0;
 
+	/* Consume valid suffix even in case of overflow. */
 	switch (*endptr) {
 	case 'E':
 	case 'e':
-		ret <<= 10;
+		shl += 10;
 		fallthrough;
 	case 'P':
 	case 'p':
-		ret <<= 10;
+		shl += 10;
 		fallthrough;
 	case 'T':
 	case 't':
-		ret <<= 10;
+		shl += 10;
 		fallthrough;
 	case 'G':
 	case 'g':
-		ret <<= 10;
+		shl += 10;
 		fallthrough;
 	case 'M':
 	case 'm':
-		ret <<= 10;
+		shl += 10;
 		fallthrough;
 	case 'K':
 	case 'k':
-		ret <<= 10;
-		endptr++;
+		shl += 10;
 		fallthrough;
 	default:
 		break;
 	}
 
+	if (shl && likely(ptr != endptr)) {
+		/* Have valid suffix with preceding number. */
+		if (unlikely(check_shl_overflow(ret, shl, &ret)))
+			ret = ULLONG_MAX;
+		endptr++;
+	}
+
 	if (retptr)
 		*retptr = endptr;
 
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

lib-fix-_parse_integer_limit-to-handle-overflow.patch
lib-fix-memparse-to-handle-overflow.patch
lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch
lib-cmdline_kunit-add-test-case-for-memparse.patch
lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch

