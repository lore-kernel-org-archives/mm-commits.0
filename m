Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52842248B9
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 17:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775235763; cv=none; b=ICf7oYKcCKsS2exZ/29xlqPpXwql3ixSvv5nLyWVhwuHn0UmUYh9DHYvPs8nMkNRXBfXe+EO3WW5/6b683Xnt+mxhLKF8uwwlIp1wxyu6/H8fQz1cWUaM++SqgNCOH5FFeHjXVqRh342NJdVhE5s3mBPvJJ7wqXiwjFV6jREBGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775235763; c=relaxed/simple;
	bh=F/ZK7SrF9O+k/+ZCfT3myw4wWS3DlMuh/88N8Sb0DqE=;
	h=Date:To:From:Subject:Message-Id; b=hfcL1sgS/AYWD7HtYUQ7o3S9OmZ1yI0mFDYEuBAVI+qWOhAvx1mclJfp0GiFbcOz+Y52uv9QX+I7DNwNjPXJEtq23KI2vXjKWvyhvOfzPVNQHUqnlWN6Oe5KdMsB6wgQNHImsfGG9wVrOeYYdIs87qRs1H0QWER2tvWFWsYTsnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=av5Cx1eA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="av5Cx1eA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8F6C4CEF7;
	Fri,  3 Apr 2026 17:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775235763;
	bh=F/ZK7SrF9O+k/+ZCfT3myw4wWS3DlMuh/88N8Sb0DqE=;
	h=Date:To:From:Subject:From;
	b=av5Cx1eAKEudWqaTo7KeRdNoTJ0ceKrgApxSjKTlixBrXlt3H7dsum4sh9w2rRNxH
	 cqNlJ4T8BhyQmuAU2FCLKNlIuUoXzuCzUlkl2vKB9nqGC10WJGbAV3VFV8ylWpzKz8
	 lNkGE4bUHVGCIbZq/sCulj3cUSy4eGbqjXLIaWts=
Date: Fri, 03 Apr 2026 10:02:42 -0700
To: mm-commits@vger.kernel.org,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-fix-memparse-to-handle-overflow.patch removed from -mm tree
Message-Id: <20260403170243.7F8F6C4CEF7@smtp.kernel.org>
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

lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch
lib-cmdline_kunit-add-test-case-for-memparse.patch
lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch

