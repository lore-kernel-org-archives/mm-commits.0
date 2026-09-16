Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034F24A4852
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 21:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594775; cv=none; b=J4HQkxzpW0vgB2uoeFXEor/jJ4tWHT/F18m7J0DOR2PBbktG757s2EGgobdt3mbm/546Wd2ZyTdSnQapMqvJNSVTt0GqgOgrQynJDuI3LFgl+JxKV/K0C4uqAnvc75RFykVgWpsFRFPkC/hX3eXTQtFNhlDrWTvB2JP0/uFlkNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594775; c=relaxed/simple;
	bh=Ly9mb81Bwb2CjCIxTESHDLeX1BaKn66U+r7jQSS7Z8c=;
	h=Date:To:From:Subject:Message-Id; b=XLinK5t1ABAWzrgNd34k4oZVPNTb70i6un3nYZY3+HbMQ63VdQACpJ531sdKrt76QEGJDEzspbL1aLpS1U+5Ov6g1O9F0zX0qbMfsump4kiKJyRbVSyF5OotzGp+Xh+SBnK3om3S3HOSjaslLmXDucYad7D+8rt36FlW3UF/tyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bmIdr9lf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bmIdr9lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DB91F00898;
	Wed, 16 Sep 2026 21:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789594747;
	bh=Iy3Od66AjcQN0zf7ihtrX73tyOJl+4I4qMt3Kwr9oP4=;
	h=Date:To:From:Subject;
	b=bmIdr9lfxeVsunYU6Cj7h9Z3Uk319Bg/xTcjaGAxwuPrlaBtsGDbsdnTwMs5lilsO
	 PD7Ubny7W5vYQyMvrdYNhrzXqtSL8SPuVbF0aWo28DLE7NjcYhkmIpYmmxK1kPAsKs
	 5xua66bBL+oHIF8GLNyDi0jNX4LL6iLedvKEx1/Y=
Date: Wed, 16 Sep 2026 14:39:06 -0700
To: mm-commits@vger.kernel.org,kernel@pengutronix.de,kees@kernel.org,andy@kernel.org,jre@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-string_helpers-use-full-destination-buffer-in-string_unescape.patch added to mm-nonmm-unstable branch
Message-Id: <20260916213907.27DB91F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/string_helpers: use full destination buffer in string_unescape()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-string_helpers-use-full-destination-buffer-in-string_unescape.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-string_helpers-use-full-destination-buffer-in-string_unescape.patch

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

lib-tests-string_helpers-check-null-terminator-too.patch
lib-tests-string_helpers-drop-unused-parameters.patch
lib-tests-string_helpers-introduce-test_string_unescape_one.patch
lib-string_helpers-use-full-destination-buffer-in-string_unescape.patch
lib-string_helpers-fix-counting-of-remaining-bytes-in-string_unescape.patch

