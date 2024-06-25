Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00A3145344
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293199; cv=none; b=BzgwLmpYykfNT+n+hojAE0r74uXYLmdnMG3KbtjY1F/2nviDvqKLX43gYx5MTfiWaM2cceGDA1E/vkpyFkuUjDY0mLCbW0GbQ1EP4p7ZmsXNCdJJguQzptRebH9/y38QxTmpi8ZrPb2I1DjdCGEEJlG5P9IMaj1zQrfghO7Y+Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293199; c=relaxed/simple;
	bh=5wkE+/Qjuqgd9RP4KsAUhvZIOgUqOHbvzchuIAcknT0=;
	h=Date:To:From:Subject:Message-Id; b=MCwOkIi/L9wDkyCqBPWh2fYN9Szs8T+cbssGPxERMuPgJdxAlrOE1wzALmKINqv3Q61tQ9kzThCd70ujsOCMzpbwcwtMRrFq21f8mn0snRLD6qfEtHriMUa0QulNJTeKoQ3UPmpIyhK5W8uVKSsJ7vU/q8z5JW/FofgbKga8GGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nYkEqaaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nYkEqaaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC84DC32782;
	Tue, 25 Jun 2024 05:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293198;
	bh=5wkE+/Qjuqgd9RP4KsAUhvZIOgUqOHbvzchuIAcknT0=;
	h=Date:To:From:Subject:From;
	b=nYkEqaaYMddUsZsBNR5hX3fLOWfnlk3LaZws3lO2tuZj2uC353DMpiZDsDBwnxXoo
	 cNOpKAXtSFex6ZeDNvLF9Ie65VNoZES0D8eguf4evkrY6CAIOLjB++lu7zg7fBHrzg
	 liEcNEN6zgYyIr44NWfl5tSZNCv20sWIm26jky+E=
Date: Mon, 24 Jun 2024 22:26:38 -0700
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,jani.nikula@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-panic-convert-print_tainted-to-use-struct-seq_buf-internally.patch removed from -mm tree
Message-Id: <20240625052638.AC84DC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/panic: convert print_tainted() to use struct seq_buf internally
has been removed from the -mm tree.  Its filename was
     kernel-panic-convert-print_tainted-to-use-struct-seq_buf-internally.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jani Nikula <jani.nikula@intel.com>
Subject: kernel/panic: convert print_tainted() to use struct seq_buf internally
Date: Fri, 31 May 2024 12:04:55 +0300

Convert print_tainted() to use struct seq_buf internally in order to be
more aware of the buffer constraints as well as make it easier to extend
in follow-up work.

Link: https://lkml.kernel.org/r/cb6006fa7c0f82a6b6885e8eea2920fcdc4fc9d0.1717146197.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

--- a/kernel/panic.c~kernel-panic-convert-print_tainted-to-use-struct-seq_buf-internally
+++ a/kernel/panic.c
@@ -35,6 +35,7 @@
 #include <linux/debugfs.h>
 #include <linux/sysfs.h>
 #include <linux/context_tracking.h>
+#include <linux/seq_buf.h>
 #include <trace/events/error_report.h>
 #include <asm/sections.h>
 
@@ -496,6 +497,25 @@ const struct taint_flag taint_flags[TAIN
 	[ TAINT_TEST ]			= { 'N', ' ', true },
 };
 
+static void print_tainted_seq(struct seq_buf *s)
+{
+	int i;
+
+	if (!tainted_mask) {
+		seq_buf_puts(s, "Not tainted");
+		return;
+	}
+
+	seq_buf_printf(s, "Tainted: ");
+	for (i = 0; i < TAINT_FLAGS_COUNT; i++) {
+		const struct taint_flag *t = &taint_flags[i];
+		bool is_set = test_bit(i, &tainted_mask);
+		char c = is_set ? t->c_true : t->c_false;
+
+		seq_buf_putc(s, c);
+	}
+}
+
 /**
  * print_tainted - return a string to represent the kernel taint state.
  *
@@ -507,25 +527,15 @@ const struct taint_flag taint_flags[TAIN
 const char *print_tainted(void)
 {
 	static char buf[TAINT_FLAGS_COUNT + sizeof("Tainted: ")];
-	char *s;
-	int i;
+	struct seq_buf s;
 
 	BUILD_BUG_ON(ARRAY_SIZE(taint_flags) != TAINT_FLAGS_COUNT);
 
-	if (!tainted_mask) {
-		snprintf(buf, sizeof(buf), "Not tainted");
-		return buf;
-	}
+	seq_buf_init(&s, buf, sizeof(buf));
 
-	s = buf + sprintf(buf, "Tainted: ");
-	for (i = 0; i < TAINT_FLAGS_COUNT; i++) {
-		const struct taint_flag *t = &taint_flags[i];
-		*s++ = test_bit(i, &tainted_mask) ?
-			t->c_true : t->c_false;
-	}
-	*s = 0;
+	print_tainted_seq(&s);
 
-	return buf;
+	return seq_buf_str(&s);
 }
 
 int test_taint(unsigned flag)
_

Patches currently in -mm which might be from jani.nikula@intel.com are


