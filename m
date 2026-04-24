Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8083EE1D7
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 18:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777054408; cv=none; b=WkJjCJ6Rjiqo1NyXJYN7gDFHvBT02XFOP+09ymCrWtjSpo+VxuicVcDIgEH6vTtOzsxk2EvuV0/Tqeksp2J7xnZKau1p9e/PXerS+i2ivzV8TAkQgp7OkwRIif+w3ZWfasuPrjKJxxua8cbAm2zKA2KD+KK3PEZX3aTYzd6dNJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777054408; c=relaxed/simple;
	bh=EKiZuUDSSNLMD61RA4yzIcl+7qblhPv7XW6Sn0311UE=;
	h=Date:To:From:Subject:Message-Id; b=l9q6qswiFzYW12UlDR+0k2roSuxDbJ4d/qbky1WBy4ca6VVoLgW0OY7PHuwgKTzQFTChEN4R+AQn3zBV3NxA+8A6S4bKn+CdjP+EMq5zz2O48h8bciYCsmd3NRi1KvFnNL6+ieMz24Mg5icW7rgu82zFsQdKwbz1jUqvX/tHGSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vvH8xPWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vvH8xPWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8757FC19425;
	Fri, 24 Apr 2026 18:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777054408;
	bh=EKiZuUDSSNLMD61RA4yzIcl+7qblhPv7XW6Sn0311UE=;
	h=Date:To:From:Subject:From;
	b=vvH8xPWcs5sJ5FqXvJQwxmbzWW5c1NvG0dz/i/sBXKftle5nVsfqvqfKBfotrwvZz
	 TO6erC5RmKCZosfbyFNQymtxOioANoN1i4JkWA6BRi5CpbCo1waHWyxxMl2qX/4ZeR
	 hNqqQ2n5/wva9nf5M+z2m82ZXep+rCNoekVLD3y8=
Date: Fri, 24 Apr 2026 11:13:27 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,david@davidgow.net,shuvampandey1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + seq_buf-export-seq_buf_putmem_hex-and-add-kunit-tests.patch added to mm-nonmm-unstable branch
Message-Id: <20260424181328.8757FC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: seq_buf: export seq_buf_putmem_hex() and add KUnit tests
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     seq_buf-export-seq_buf_putmem_hex-and-add-kunit-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/seq_buf-export-seq_buf_putmem_hex-and-add-kunit-tests.patch

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
From: Shuvam Pandey <shuvampandey1@gmail.com>
Subject: seq_buf: export seq_buf_putmem_hex() and add KUnit tests
Date: Thu, 9 Apr 2026 02:08:51 +0545

The seq_buf KUnit suite does not exercise seq_buf_putmem_hex().

Add one test for the len > 8 chunking path and one overflow test where a
later chunk no longer fits in the buffer.

Export seq_buf_putmem_hex() as well so SEQ_BUF_KUNIT_TEST=m links cleanly.
Without the export, modpost reports seq_buf_putmem_hex as undefined when
seq_buf_kunit is built as a module.

Link: https://lore.kernel.org/20260408202351.21829-1-shuvampandey1@gmail.com
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: David Gow <david@davidgow.net>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/seq_buf.c             |    1 +
 lib/tests/seq_buf_kunit.c |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

--- a/lib/seq_buf.c~seq_buf-export-seq_buf_putmem_hex-and-add-kunit-tests
+++ a/lib/seq_buf.c
@@ -298,6 +298,7 @@ int seq_buf_putmem_hex(struct seq_buf *s
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(seq_buf_putmem_hex);
 
 /**
  * seq_buf_path - copy a path into the sequence buffer
--- a/lib/tests/seq_buf_kunit.c~seq_buf-export-seq_buf_putmem_hex-and-add-kunit-tests
+++ a/lib/tests/seq_buf_kunit.c
@@ -184,6 +184,38 @@ static void seq_buf_get_buf_commit_test(
 	KUNIT_EXPECT_TRUE(test, seq_buf_has_overflowed(&s));
 }
 
+static void seq_buf_putmem_hex_test(struct kunit *test)
+{
+	DECLARE_SEQ_BUF(s, 24);
+	const u8 data[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
+#ifdef __BIG_ENDIAN
+	const char *expected = "0001020304050607 0809 ";
+#else
+	const char *expected = "0706050403020100 0908 ";
+#endif
+
+	KUNIT_EXPECT_EQ(test, seq_buf_putmem_hex(&s, data, sizeof(data)), 0);
+	KUNIT_EXPECT_FALSE(test, seq_buf_has_overflowed(&s));
+	KUNIT_EXPECT_EQ(test, seq_buf_used(&s), strlen(expected));
+	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), expected);
+}
+
+static void seq_buf_putmem_hex_overflow_test(struct kunit *test)
+{
+	DECLARE_SEQ_BUF(s, 20);
+	const u8 data[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
+#ifdef __BIG_ENDIAN
+	const char *expected = "0001020304050607 ";
+#else
+	const char *expected = "0706050403020100 ";
+#endif
+
+	KUNIT_EXPECT_EQ(test, seq_buf_putmem_hex(&s, data, sizeof(data)), -1);
+	KUNIT_EXPECT_TRUE(test, seq_buf_has_overflowed(&s));
+	KUNIT_EXPECT_EQ(test, seq_buf_used(&s), 20);
+	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), expected);
+}
+
 static struct kunit_case seq_buf_test_cases[] = {
 	KUNIT_CASE(seq_buf_init_test),
 	KUNIT_CASE(seq_buf_declare_test),
@@ -194,6 +226,8 @@ static struct kunit_case seq_buf_test_ca
 	KUNIT_CASE(seq_buf_printf_test),
 	KUNIT_CASE(seq_buf_printf_overflow_test),
 	KUNIT_CASE(seq_buf_get_buf_commit_test),
+	KUNIT_CASE(seq_buf_putmem_hex_test),
+	KUNIT_CASE(seq_buf_putmem_hex_overflow_test),
 	{}
 };
 
_

Patches currently in -mm which might be from shuvampandey1@gmail.com are

seq_buf-export-seq_buf_putmem_hex-and-add-kunit-tests.patch
lib-tests-extend-cmdline-kunit-with-next_arg-tests.patch

