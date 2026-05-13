Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F112038B7CD
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 03:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778644769; cv=none; b=PgHN6KvMxfD0hyvkbb/RXbSnuczSzQGouubddGMtr1DnjFyOdHj4I/cEuSHxCxou0tyCRVIj6SmJg5ZAO+RGH5rHEV6D5GccyA+10Q1a5dqK1UGyUrvF6+s6YOcPWnbfa96XWRiucPwly7PTGwZZMMzMSQfc3d1DVhNPY6BaYQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778644769; c=relaxed/simple;
	bh=ArhiZiIZCVFA7V4dvLKilLj0tDnBce5pi22VkdfXgm8=;
	h=Date:To:From:Subject:Message-Id; b=gGNtJlGPN1Q8T2dWjg4yTYx9IUBWUXdBjm3066m67hZ5/4tplJ9Q8fWeW3BQt3ZnE6xOe+AW9yC3jwx+abLJxypb0F1lmiM5FK7lRpLY2FlAuxzua49a9simj3TheKh2TwyjCYheLdWNNDBKrhjLEYPpZJ+zziyEw202pzFrBqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1OI4gRIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1OI4gRIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DEBC2BCC7;
	Wed, 13 May 2026 03:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778644768;
	bh=ArhiZiIZCVFA7V4dvLKilLj0tDnBce5pi22VkdfXgm8=;
	h=Date:To:From:Subject:From;
	b=1OI4gRIgrRb+mRxCJukvtmTDYo4nRShiNr0LbEYrqsxm57NqvEysUsG8Eiw6ZP0Je
	 D3Ihd11zhvHxwyMcrMoYG1D4x0iZEssyPzq+4FiQV9TDWCu40fv5rSxDR/1oJXnuAj
	 0YtUcnnAs5EPa4eJmVc06dnGgX9WfUg80MVhM2/U=
Date: Tue, 12 May 2026 20:59:28 -0700
To: mm-commits@vger.kernel.org,pjw@kernel.org,palmer@dabbelt.com,nathan@kernel.org,kees@kernel.org,djwong@kernel.org,ardb@kernel.org,aou@eecs.berkeley.edu,andriy.shevchenko@intel.com,alex@ghiti.fr,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-fix-memparse-to-handle-overflow.patch removed from -mm tree
Message-Id: <20260513035928.A4DEBC2BCC7@smtp.kernel.org>
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
Date: Fri, 3 Apr 2026 13:33:34 +0300

Since '_parse_integer_limit()' (and so 'simple_strtoull()') is now capable
to handle overflow, adjust 'memparse()' to handle overflow (denoted by
ULLONG_MAX) returned from 'simple_strtoull()'.  Also use
'check_shl_overflow()' to catch an overflow possibly caused by processing
size suffix and denote it with ULLONG_MAX as well.

Link: https://lore.kernel.org/20260403103338.1122415-3-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <pjw@kernel.org>
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
riscv-export-symbols-needed-for-riscv32-efi-stub.patch

