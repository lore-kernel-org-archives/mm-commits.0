Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A37637EFF8
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 19:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779217299; cv=none; b=sE8cQNFBSzkiRz+4GtmNGaPp6L5bKas5lNvNkYysZC1FI6QnpgXQbgqSauIqgFp746QEhwbW0fa53Q756ofTJR1+D1m2/9PXkzn1qW6NN7Dl+MRQQOlIlv28Dzw5k45r2rRrvNzyFisHd/eTGJSlilgQO4Oao6Sy+eMiEfbiSJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779217299; c=relaxed/simple;
	bh=xTLAyaWoludJkTpDUE/90fQwajn3W1GbShZJ64A7zPw=;
	h=Date:To:From:Subject:Message-Id; b=u11VGyhNv6u/aCCWkwGNSOVBn019QbR6S34mzXSwpH7PMAFpefhDVoR6O79GinVrEijH+Z7yRmtr5unA6983+HHBcDAHs4g0Z8sDKDl/yT0FFsbX2prc0kRnLoCKlQTqoFkWZPDjWPrlHriO2ig0jUmBl2YYTgCtcYJRV55x0FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eEU0TqtC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eEU0TqtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184ED1F000E9;
	Tue, 19 May 2026 19:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779217298;
	bh=aV1QmgcHj6gzsVD41m48HGyK6UInVLbnZBJW6/Itftw=;
	h=Date:To:From:Subject;
	b=eEU0TqtCIPWHG1WM0XXWfdhZSHALBzFc+uiWzoLYqcTNU4JWA63iiY/DxUn4l9Lq/
	 idyYHkdhdlziZNRlwDoZlXC3R9aDeODyHuPF0LMpqtLEQgsL4rObBLMRnyBH16Iq6W
	 kwHWZh5FoCIQsj8Bbgk9gwoJXsra+cjt2DdTfSOs=
Date: Tue, 19 May 2026 12:01:37 -0700
To: mm-commits@vger.kernel.org,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-fix-memparse-to-handle-overflow.patch removed from -mm tree
Message-Id: <20260519190138.184ED1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: fix memparse() to handle overflow
has been removed from the -mm tree.  Its filename was
     lib-fix-memparse-to-handle-overflow.patch

This patch was dropped because an updated version will be issued

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
lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch
lib-cmdline_kunit-add-test-case-for-memparse.patch
lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch
riscv-add-platform-specific-double-word-shifts-for-riscv32.patch
lib-kunit-add-tests-for-__ashldi3-__ashrdi3-and-__lshrdi3.patch
riscv-fix-building-compressed-efi-image.patch

