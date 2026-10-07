Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FAE34678E
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338410; cv=none; b=IFO4w7fNDXMLrfzkks04a+Ur51y6LBlsalHb93v/VBVOxEDIt58tDTnZg4dp+iznuOpVGXK/gcCMMqepGe5zF2YO3BvyFsqGcW22ji+zU8NhXa2MObR2P1Bt8g5NvV6mzDcoJWd2WjEXcvDv1wauQtAWM9SOz7XlCtrExGNz67I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338410; c=relaxed/simple;
	bh=SQSRGE5uD9aC8frViBJ8Xn2/1PkXdQ2bH16lAaFOQTs=;
	h=Date:To:From:Subject:Message-Id; b=pXeTfd3ozF9VIoOnGhABjJ+1HKfJ3c6JTRKXjXKZbwvFGbUno2/iXb+WdGFaOitJKcUMLqF16F0NTjS/Ktuk4zPs3g0MN1Tey0gFZUKCTsHAcp51NX6rN9Vz7+h7X1pvzXRTAf2C8nfv2m4vYg/W6pnRJnFL8MGEM4UVw8I3YG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T0d1NRCa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T0d1NRCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45F01F0089E;
	Wed,  7 Oct 2026 02:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338408;
	bh=b6U/wv0kt3N4IvgovZnqso8X1OcwOR1IPCHs5VROunI=;
	h=Date:To:From:Subject;
	b=T0d1NRCa3dyJtX5tnH/5DVUBTRiRwBwSSUYbt6NGCP7xaCVh2LKvf9fDD+8Q2SV3W
	 uIy7kawscDeE+pEqopesPjwoflOY/dVzNhJTtNR8o5OUzDE5sh9IkWMYumh4cHD7mZ
	 hdcnch2iyYAhkDdBbGx3oV1Q5FaDOXOlaPeja2fk=
Date: Tue, 06 Oct 2026 19:00:08 -0700
To: mm-commits@vger.kernel.org,kernel@pengutronix.de,kees@kernel.org,andy@kernel.org,jre@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-string_helpers-fix-counting-of-remaining-bytes-in-string_unescape.patch removed from -mm tree
Message-Id: <20261007020008.A45F01F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/string_helpers: fix counting of remaining bytes in string_unescape()
has been removed from the -mm tree.  Its filename was
     lib-string_helpers-fix-counting-of-remaining-bytes-in-string_unescape.patch

This patch was dropped because an updated version will be issued

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


