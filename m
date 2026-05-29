Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D06F371CE0
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028745; cv=none; b=nIHWZkCFyATRz7QhgAOhtKT6icdPdRdPInoIS7pvi4FfLjOdIygebC3JQvJzIyfRyHHLCW/SKpuBSn7rhZ8hceabBjHnjqLGDZOcUyxCzGzMCx5ogMWxS0ZZV198tevbjARFxSFPP6ngJKNm1R4tmrUlXUA99pcXKAK3zL7m184=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028745; c=relaxed/simple;
	bh=Al7wVSP+e/YJtltEuXO0VifJCabA4PNyeyuAcmJSTGM=;
	h=Date:To:From:Subject:Message-Id; b=gSvPKAM+Q5ApVzXQM1jg5Vrmo91xoQhvzDfwQPVL4PHw7NBxb7Peo3ndQocxRHThdT4+oaIJo6d1QhzpTz/18+tHJartK7qBcif0pbZCHev/Jh/GhhNntJG1L66fAOMedEb9STjpKxKShK2BdkNCNJNhFJntBEHDuT0vv8boRaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ywUF5v8O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ywUF5v8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8891F00893;
	Fri, 29 May 2026 04:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028743;
	bh=+aKxB6Bvic4Hv8zqg/EvdvmFboIb56ZfyNp4IJueYe8=;
	h=Date:To:From:Subject;
	b=ywUF5v8OPRt8+fToqnuz3+L562TW2X2+oarO3jvoWtqMpEVDPv3WuL8rk+Aen8g99
	 qpdJRdHqF0sGMOIcFaw/21Ek38Ys0jHzscmcn7YtKeL5/ac4WHMigdsMr7CGVrOZYN
	 KjKy+GU6YUC88CuxYmTIe7V44t790WrS2MDcBnOc=
Date: Thu, 28 May 2026 21:25:43 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,david@davidgow.net,shuvampandey1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] seq_buf-export-seq_buf_putmem_hex-and-add-kunit-tests.patch removed from -mm tree
Message-Id: <20260529042543.9D8891F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: seq_buf: export seq_buf_putmem_hex() and add KUnit tests
has been removed from the -mm tree.  Its filename was
     seq_buf-export-seq_buf_putmem_hex-and-add-kunit-tests.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


