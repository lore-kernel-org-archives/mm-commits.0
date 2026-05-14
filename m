Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7331AFC0A
	for <mm-commits@vger.kernel.org>; Thu, 14 May 2026 00:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778717320; cv=none; b=G9ODd3+iG+pk9mly/MHmm3pyojEFymW2HLfPrjDxOw6XD5lbX6x2AHo5OcJzgofvv13u7ndCv4ngVp/4cu6CMOitm31OWEMt5UOkU+33kb4Gp3hd/cmZzlOpYfYZEDAuCcvg85Rs+XayM79IA3b9of+cXLxVlYonJeiW8hO246g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778717320; c=relaxed/simple;
	bh=74x9G/Q7CAnjDQpuMA6KKVkvdoFCxXB2kj6LUPPBlqA=;
	h=Date:To:From:Subject:Message-Id; b=ZBPV9X/jsud74Xg2w9lQNLKYBRzc7IyZmFKrC67M9UsbaHQqq4NEoC8LJd+WuN06PpDv5/fhOC5oy+ypP3MRpsoFOvyGJK6t1S9IH5y1+lwBw+UOxlmGP7TZYk/jJ34sSsZnktcnxgPbdLQgOS9FnwtnfM2EYJSKbvso8fsGA10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gE2AZJAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gE2AZJAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EBAC19425;
	Thu, 14 May 2026 00:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778717320;
	bh=74x9G/Q7CAnjDQpuMA6KKVkvdoFCxXB2kj6LUPPBlqA=;
	h=Date:To:From:Subject:From;
	b=gE2AZJAxzOGqgMWTkfwo9IQwEKOjpYmwyseeicKYGRaBfQnU5Otesg7SYznXRBf9z
	 fcf8BVV2J1V1d0P++C6qdlagSltJ32F94XK73R0Eli4B0cBlMt0Zw65/MBalbUdrOF
	 Ep/WZ5pSq5HCUeTecQeRHuJ+0CReRq89tLsgQqoY=
Date: Wed, 13 May 2026 17:08:39 -0700
To: mm-commits@vger.kernel.org,thecharlesjenkins@gmail.com,palmer@dabbelt.com,lkp@intel.com,ardb@kernel.org,aou@eecs.berkeley.edu,andriy.shevchenko@intel.com,alex@ghiti.fr,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-fix-memparse-to-handle-overflow.patch added to mm-nonmm-unstable branch
Message-Id: <20260514000839.E1EBAC19425@smtp.kernel.org>
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
Date: Wed, 13 May 2026 16:44:01 +0300

Since '_parse_integer_limit()' (and so 'simple_strtoull()') is now capable
to handle overflow, adjust 'memparse()' to handle overflow (denoted by
ULLONG_MAX) returned from 'simple_strtoull()'.  Also use
'check_shl_overflow()' to catch an overflow possibly caused by processing
size suffix and denote it with ULLONG_MAX as well.

Link: https://lore.kernel.org/20260513134407.884033-3-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Charlie Jenkins <thecharlesjenkins@gmail.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
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

lib-free-pagelist-on-error-in-iov_iter_extract_pages.patch
lib-fix-_parse_integer_limit-to-handle-overflow.patch
lib-fix-memparse-to-handle-overflow.patch
lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch
lib-cmdline_kunit-add-test-case-for-memparse.patch
lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch
riscv-add-platform-specific-double-word-shifts-for-riscv32.patch
lib-kunit-add-tests-for-__ashldi3-__ashrdi3-and-__lshrdi3.patch
riscv-fix-building-compressed-efi-image.patch

