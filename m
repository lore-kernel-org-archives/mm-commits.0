Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C982D1913
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671883; cv=none; b=oql0x4j14WKMfGM5si6yOkGnNLtQYVUqnCtJdTEHZunfKHOcgg+lxNNrsjauBcJZ+AlTiPyZAgqse8rxlD9T/6n4w5vN8giWYmFveKJUMp2xWVdRdlR9NR8mdFmVoxPygQzLrVnW6fZsRrafct39nBFtcs+R8OaruKwo30aENCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671883; c=relaxed/simple;
	bh=ARo9Gr+0lD5HZcTb92Pq1iTE0YREjPcGQcwYyUo91Q0=;
	h=Date:To:From:Subject:Message-Id; b=Kg27ZAxKJqpkvctJb79WjWposTBTQ4Lh2Jdyy1+FN/Kf7M1UboxJ2o3I3bcrupXD9bQDKlJRSb668WERMcIASK58C3SdAJP3SmjMt6ZU0ofnfxbWO9FVXwWF1DFqfqLCyoNAfXDJEYetwAMS3nsVZJrT6kWHi4K0NKsJ+vnD0vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=djdaeMkP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="djdaeMkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12171C4CEF7;
	Sat, 28 Mar 2026 04:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671883;
	bh=ARo9Gr+0lD5HZcTb92Pq1iTE0YREjPcGQcwYyUo91Q0=;
	h=Date:To:From:Subject:From;
	b=djdaeMkPONxWSSsg0/6c7o3tf0/tXrvnG2c4VrZx6z0Cpca2N1aqj2WVR4AxOn3bz
	 nyNwe0OgOvdC+9Skylcyp88/YTjfNl6E/IQaFIX+vgBcS6gdqS/YoRg3cdaDxz9HuD
	 RM03iTLeEIcitCLvHLsA+g+POM+oJYxMKvWlJEeA=
Date: Fri, 27 Mar 2026 21:24:42 -0700
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,pmladek@suse.com,joel.granados@kernel.org,rioo.tsukatsukii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-panic-allocate-taint-string-buffer-dynamically.patch removed from -mm tree
Message-Id: <20260328042443.12171C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/panic: allocate taint string buffer dynamically
has been removed from the -mm tree.  Its filename was
     kernel-panic-allocate-taint-string-buffer-dynamically.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


