Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2E14A3D3E
	for <mm-commits@vger.kernel.org>; Wed, 16 Sep 2026 21:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594756; cv=none; b=CHNJUmSa+bV0lg31wSyHHTFKsuZ9AusVmJOAB93ZFYanWztjsIvY3cmI9307n2/5QK9XVal2VaWFi7+TmsFqqTtZrh75VoluTg8jA5f3cc5lY6HweiL+4zJ3nsY64sgWQSkz8yQbNvfZj+sNYoyTY3PEbbO6J1slIsu3Aww81ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594756; c=relaxed/simple;
	bh=1a5EPo87KOsx796XxyN9UOULaHYS7jOj+F0l2h28KK4=;
	h=Date:To:From:Subject:Message-Id; b=gLUu8i2dWK92WdYVZKUuPuvRNC/xFfPjP9I9X6EsVU2qgAu4oRAtwTzKlr9MzjAfssG0PkLA6XqFQHTbxQKs0guFo40wscd/BHvTAjoHMmQxKHOP0e3SRLMCnl/A9MEQgLZqykRaQN1JSiaYSxz+/Py1X40X1nwhWJh1+WCprSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=me8OhGtv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="me8OhGtv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC861F00899;
	Wed, 16 Sep 2026 21:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789594743;
	bh=IJUYJ4YwrtB3hg6wgVZK0E/AGh1mo9B5IkgOuSUokc0=;
	h=Date:To:From:Subject;
	b=me8OhGtvuQ1s5V6GWSUrY/r+han5LkNBjxIo+hbb48vEQuLzuVFwBOSnNlzV1A7y2
	 qseZw+uzhtjhNTyKy+CvhZ3fXC+kQ2ZKWh1KTh0HT535wzYp0c/XI0XrbwTvEsQvhx
	 gRSsRFtjdA6txTtA6COlKRHJJyIH3XF5mD9c0718=
Date: Wed, 16 Sep 2026 14:39:02 -0700
To: mm-commits@vger.kernel.org,kernel@pengutronix.de,kees@kernel.org,andy@kernel.org,jre@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-tests-string_helpers-drop-unused-parameters.patch added to mm-nonmm-unstable branch
Message-Id: <20260916213903.1AC861F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/tests: string_helpers: drop unused parameters
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-tests-string_helpers-drop-unused-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-tests-string_helpers-drop-unused-parameters.patch

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

lib-tests-string_helpers-check-null-terminator-too.patch
lib-tests-string_helpers-drop-unused-parameters.patch
lib-tests-string_helpers-introduce-test_string_unescape_one.patch
lib-string_helpers-use-full-destination-buffer-in-string_unescape.patch
lib-string_helpers-fix-counting-of-remaining-bytes-in-string_unescape.patch

