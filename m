Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A359349CFD
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338409; cv=none; b=bBfurCwBV20ecS9EMwTs1oN3LpW5cCtCjNTZDBPy4gdHc1Ov90GGDdzPfR4rpULIz/SlDReVVL0aSH0X6mD0QoR4LKh8tWVOm4YM0/MjbEuHTuzCfZv9XZ/Y3iUNZIlAI+ziVDlYo5GcBao6/GyLEjHcB1YW7aJHBbUZxnzlNxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338409; c=relaxed/simple;
	bh=NytArXElIKDEPutLEC4h78Vx89pIbFQxPeb1+YUCV1k=;
	h=Date:To:From:Subject:Message-Id; b=tinqPPgEpb66vVrcKDZj+3AAFeY+cPuZRLLY+O9En+8TOEtW5HFiz+DjuXUiyCV4VwUFSpzzGj/CWvg9kE05tv4R7XouFrSdMRlti5eU0YKBcDIv64HXIwzGnQYeMzAD+oYHMR+jfVBAAFjUhdrpNOfjGpXPssMxwfdEQppyZ5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gJdFDRAS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gJdFDRAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931781F008A0;
	Wed,  7 Oct 2026 02:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338407;
	bh=V11DbnUxycAgarZ8DfgHgXzUXcLyRmAfQKa38uUq2Gc=;
	h=Date:To:From:Subject;
	b=gJdFDRASOgOb7xQEsWay5WpixNK48LSWmuas8tgyCFQjAWzkh+kGVnEVB/zJRL5D/
	 ++8WwzBofOhNjfRTAHeIGENHGF/d7v3GZx96KROoFOHwAwT/cS6kGuL03cnZFqjIMK
	 +T9vKywKCknWbW0oTjM05stBSQ6Dw8ThYNUzF2X4=
Date: Tue, 06 Oct 2026 19:00:07 -0700
To: mm-commits@vger.kernel.org,kernel@pengutronix.de,kees@kernel.org,andy@kernel.org,jre@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-string_helpers-use-full-destination-buffer-in-string_unescape.patch removed from -mm tree
Message-Id: <20261007020007.931781F008A0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/string_helpers: use full destination buffer in string_unescape()
has been removed from the -mm tree.  Its filename was
     lib-string_helpers-use-full-destination-buffer-in-string_unescape.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jonas Rebmann <jre@pengutronix.de>
Subject: lib/string_helpers: use full destination buffer in string_unescape()
Date: Wed, 16 Sep 2026 19:38:09 +0200

Although all of the available sequences expand to exactly one byte, the
current implementation decrements the remaining bytes in the destination
buffer twice, effectively shortening it by one byte per each unescaped
character.

The extra decrement is only needed in the one case where a single loop
iteration produces two output bytes: when the sequence turns out not to be
a valid escape sequence, the previously skipped backslash has to be
emitted before the character is copied verbatim.

Add a kunit regression-test that unescapes into a barely long enough 3
buffer.

Link: https://lore.kernel.org/20260916-string_unescape-v1-4-7f8bd986fa33@pengutronix.de
Fixes: 16c7fa05829e ("lib/string_helpers: introduce generic string_unescape")
Signed-off-by: Jonas Rebmann <jre@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
---

 lib/string_helpers.c             |    2 +-
 lib/tests/string_helpers_kunit.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/lib/string_helpers.c~lib-string_helpers-use-full-destination-buffer-in-string_unescape
+++ a/lib/string_helpers.c
@@ -331,7 +331,6 @@ int string_unescape(char *src, char *dst
 	while (*src && --size) {
 		if (src[0] == '\\' && src[1] != '\0' && size > 1) {
 			src++;
-			size--;
 
 			if (flags & UNESCAPE_SPACE &&
 					unescape_space(&src, &out))
@@ -350,6 +349,7 @@ int string_unescape(char *src, char *dst
 				continue;
 
 			*out++ = '\\';
+			size--;
 		}
 		*out++ = *src++;
 	}
--- a/lib/tests/string_helpers_kunit.c~lib-string_helpers-use-full-destination-buffer-in-string_unescape
+++ a/lib/tests/string_helpers_kunit.c
@@ -623,6 +623,9 @@ static void test_unescape(struct kunit *
 	test_string_unescape_one(test, "escape at end", UNESCAPE_HEX, "a\\qX", 3, "a\\", 2);
 	test_string_unescape_one(test, "backslash before escape", UNESCAPE_HEX, "\\\\x41B", 12, "\\\\x41B", 6);
 	test_string_unescape_one(test, "backslash escape", UNESCAPE_HEX | UNESCAPE_SPECIAL, "\\\\x41B", 16, "\\x41B", 5);
+
+	test_string_unescape_one(test, "short buffer", UNESCAPE_HEX, "\\x41\\x41B", 4, "AAB", 3);
+	test_string_unescape_one(test, "unrecognized escape at end", UNESCAPE_HEX, "B\\qX", 4, "B\\q", 3);
 }
 
 static void test_escape(struct kunit *test)
_

Patches currently in -mm which might be from jre@pengutronix.de are

lib-string_helpers-fix-counting-of-remaining-bytes-in-string_unescape.patch

