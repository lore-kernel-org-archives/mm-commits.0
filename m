Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5061D35BDCF
	for <mm-commits@vger.kernel.org>; Sun, 22 Feb 2026 19:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771788355; cv=none; b=XJor6pMe27f+hr75mQAk3Z9wtrQQ6SLkMCVs4hK4wigr8I52n0OpVz912gwfgExBmHWl3OVEuWZZM15vzPRGigsPdMQMFENLHHI/lir0Jtb8E5xI91rMAMJJnX1R8s9AgxKIVqsKQ7Eo3YvFYSqzHVKfoiY8JEhlS4Dz6qzejX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771788355; c=relaxed/simple;
	bh=i2FJdfhi9MhMdwfCcgakQkZc7p5T9ZTzwmk2ZUPUz7M=;
	h=Date:To:From:Subject:Message-Id; b=CcPClV7F+pCQXkMXrFigO+UhtENy9ZZ0tVDsKeHxyJs28t0IgdOfxaZ0CbjtL4Mc4sN1PU2kp2PUrvKTvNE/5VNzeaDUfdRYnQDS0CF4DurnrObGdiJ2yvuZxxnHXMXr1LJmzcfQGfHmoIbpVfJVzx5otWXh3pnVSot/A0TyAgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RiS7bytp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RiS7bytp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106C8C116D0;
	Sun, 22 Feb 2026 19:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771788355;
	bh=i2FJdfhi9MhMdwfCcgakQkZc7p5T9ZTzwmk2ZUPUz7M=;
	h=Date:To:From:Subject:From;
	b=RiS7bytp6qXdXwBIsFJUfQ/XTTkonyLGy9QAnOpaZom4EDrgHHp2cWabf9za1cbmw
	 g08RqfDrM30Ylhpi13nQxoa+EA2I/1vL8y51NZRinmDLmXv3o+KE2udhbHXG/fLmSg
	 TbbnzBSRuWYOxwsPYtGdVGmvD7ej111HKwRYayR0=
Date: Sun, 22 Feb 2026 11:25:54 -0800
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,pmladek@suse.com,joel.granados@kernel.org,rioo.tsukatsukii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-panic-allocate-taint-string-buffer-dynamically.patch added to mm-nonmm-unstable branch
Message-Id: <20260222192555.106C8C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/panic: allocate taint string buffer dynamically
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-panic-allocate-taint-string-buffer-dynamically.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-panic-allocate-taint-string-buffer-dynamically.patch

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
From: Rio <rioo.tsukatsukii@gmail.com>
Subject: kernel/panic: allocate taint string buffer dynamically
Date: Sun, 22 Feb 2026 19:38:04 +0530

The buffer used to hold the taint string is statically allocated, which
requires updating whenever a new taint flag is added.

Instead, allocate the exact required length at boot once the allocator is
available in an init function.  The allocation sums the string lengths in
taint_flags[], along with space for separators and formatting. 
print_tainted() is switched to use this dynamically allocated buffer.

If allocation fails, print_tainted() warns about the failure and continues
to use the original static buffer as a fallback.

Link: https://lkml.kernel.org/r/20260222140804.22225-1-rioo.tsukatsukii@gmail.com
Signed-off-by: Rio <rioo.tsukatsukii@gmail.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   51 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 5 deletions(-)

--- a/kernel/panic.c~kernel-panic-allocate-taint-string-buffer-dynamically
+++ a/kernel/panic.c
@@ -802,7 +802,7 @@ EXPORT_SYMBOL(panic);
  * small shell script that prints the TAINT_FLAGS_COUNT bits of
  * /proc/sys/kernel/tainted.
  *
- * Also, update TAINT_BUF_MAX below.
+ * Also, update INIT_TAINT_BUF_MAX below.
  */
 const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
 	TAINT_FLAG(PROPRIETARY_MODULE,		'P', 'G'),
@@ -856,17 +856,58 @@ static void print_tainted_seq(struct seq
 	}
 }
 
-/* 350 can accommodate all taint flags in verbose mode, with some headroom */
-#define TAINT_BUF_MAX 350
+/* The initial buffer can accommodate all taint flags in verbose
+ * mode, with some headroom. Once the allocator is available, the
+ * exact size is allocated dynamically; the initial buffer remains
+ * as a fallback if allocation fails.
+ *
+ * The verbose taint string currently requires up to 327 characters.
+ */
+#define INIT_TAINT_BUF_MAX 350
+
+static char init_taint_buf[INIT_TAINT_BUF_MAX];
+static char *taint_buf = init_taint_buf;
+static size_t taint_buf_size = INIT_TAINT_BUF_MAX;
+
+static __init int alloc_taint_buf(void)
+{
+	int i;
+	char *buf;
+	size_t size = 0;
+
+	size += sizeof("Tainted: ") - 1;
+	for (i = 0; i < TAINT_FLAGS_COUNT; i++) {
+		size += 2; /* For ", " */
+		size += 4; /* For "[%c]=" */
+		size += strlen(taint_flags[i].desc);
+	}
+
+	size += 1; /* For NULL terminator */
+
+	buf = kmalloc(size, GFP_KERNEL);
+
+	if (!buf) {
+		/* Allocation may fail; this warning explains possibly
+		 * truncated taint strings
+		 */
+		pr_warn_once("taint string buffer allocation failed, using fallback buffer\n");
+		return 0;
+	}
+
+	taint_buf = buf;
+	taint_buf_size = size;
+
+	return 0;
+}
+postcore_initcall(alloc_taint_buf);
 
 static const char *_print_tainted(bool verbose)
 {
-	static char buf[TAINT_BUF_MAX];
 	struct seq_buf s;
 
 	BUILD_BUG_ON(ARRAY_SIZE(taint_flags) != TAINT_FLAGS_COUNT);
 
-	seq_buf_init(&s, buf, sizeof(buf));
+	seq_buf_init(&s, taint_buf, taint_buf_size);
 
 	print_tainted_seq(&s, verbose);
 
_

Patches currently in -mm which might be from rioo.tsukatsukii@gmail.com are

kernel-panic-increase-buffer-size-for-verbose-taint-logging.patch
kernel-panic-allocate-taint-string-buffer-dynamically.patch

