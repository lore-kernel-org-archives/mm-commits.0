Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C592034EEF3
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338406; cv=none; b=arMgRig7WuorqqeUzxYVpOfwZg6DZpEalGKiUCQs1JhDBa4t+R0/ohHVSF/wXmr3ysR1DZSgbFvV7HhXvM1Ya+uUamXLYancWY01CCUppnidUNho4xA8TtcG03G/L2L1IrzI3F1kIEkumrgadVNUquH1qIP+zb2dwtgsPgkIxr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338406; c=relaxed/simple;
	bh=jgZTuMVnJPItlPdCZUCVuK5EuWX/VwPmqBrJoCGGckc=;
	h=Date:To:From:Subject:Message-Id; b=LQnXYwlPtBlLEz2L+cwxHa/lK5vco8vFLvbpYkxZY8d34vBoAsHyOgBs8DvVFggG36j+gEYXgvYV+dqNfkyIsZhaXkRV/3v5BSZvaoD/uMxfPFg6eY6Bt+eyqN/h6zCtbQGl8E67m5HO99q8vkwGmsxwMn00vKrM98V2TTMQ2Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zsh2zl+B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zsh2zl+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB021F008A2;
	Wed,  7 Oct 2026 02:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338405;
	bh=pL1BN9IZvRZiCWuI6fv5x/tHg+i++saMMBTl72RruT4=;
	h=Date:To:From:Subject;
	b=zsh2zl+B2YigRIs67bD5usYH5TRS1+os9dTjVrVOgoOWHsK892UWvC9FFhAcOivX9
	 9napYhbsipubYkMypIjDQolfONgHSa5cKRPPowO9hXutedychtQhabiHPQee4AoZ/Z
	 SSnDLhjTo8A93AOGp2WghWcQ44lDi6dBCCCIW46U=
Date: Tue, 06 Oct 2026 19:00:05 -0700
To: mm-commits@vger.kernel.org,kernel@pengutronix.de,kees@kernel.org,andy@kernel.org,jre@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-tests-string_helpers-drop-unused-parameters.patch removed from -mm tree
Message-Id: <20261007020005.6EB021F008A2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/tests: string_helpers: drop unused parameters
has been removed from the -mm tree.  Its filename was
     lib-tests-string_helpers-drop-unused-parameters.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jonas Rebmann <jre@pengutronix.de>
Subject: lib/tests: string_helpers: drop unused parameters
Date: Wed, 16 Sep 2026 19:38:07 +0200

Drop the unused parameters from test_string_check_buf() to improve
readability.

Link: https://lore.kernel.org/20260916-string_unescape-v1-2-7f8bd986fa33@pengutronix.de
Signed-off-by: Jonas Rebmann <jre@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
---

 lib/tests/string_helpers_kunit.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/lib/tests/string_helpers_kunit.c~lib-tests-string_helpers-drop-unused-parameters
+++ a/lib/tests/string_helpers_kunit.c
@@ -18,7 +18,6 @@
 
 static void test_string_check_buf(struct kunit *test,
 				  const char *name, unsigned int flags,
-				  char *in, size_t p,
 				  char *out_real, size_t q_real,
 				  char *out_test, size_t q_test)
 {
@@ -101,8 +100,7 @@ static void test_string_unescape(struct
 		q_real = string_unescape(in, out_real, q_real, flags);
 	}
 
-	test_string_check_buf(test, name, flags, in, p - 1, out_real, q_real,
-			      out_test, q_test);
+	test_string_check_buf(test, name, flags, out_real, q_real, out_test, q_test);
 	KUNIT_EXPECT_EQ_MSG(test, out_real[q_real], '\0', "name:%s", name);
 }
 
@@ -457,8 +455,7 @@ static void test_string_escape(struct ku
 
 	q_real = string_escape_mem(in, p, out_real, out_size, flags, esc);
 
-	test_string_check_buf(test, name, flags, in, p, out_real, q_real, out_test,
-			      q_test);
+	test_string_check_buf(test, name, flags, out_real, q_real, out_test, q_test);
 
 	test_string_escape_overflow(test, in, p, flags, esc, q_test, name);
 }
_

Patches currently in -mm which might be from jre@pengutronix.de are

lib-tests-string_helpers-introduce-test_string_unescape_one.patch
lib-string_helpers-use-full-destination-buffer-in-string_unescape.patch
lib-string_helpers-fix-counting-of-remaining-bytes-in-string_unescape.patch

