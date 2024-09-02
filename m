Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B96E13AA45
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248792; cv=none; b=bzhpp4MsPUs/Pu+WLxjk4kguX8CdHRSj0xUciOJj/dSXQbIPImhB5rqGpgRXAR5UZoT2gEDTwYAnDk8tZNXLzMzAria6IbNpsw3GR6ZjohF1lYmH4UDIbMe0CuK3LcChfhSFX9rGP/P8TMX1NKhIukvSweArbfrdQDAxLlC8/ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248792; c=relaxed/simple;
	bh=w5kHZWfjE0pCa/Vgi716dDIZjYo9LlO4EdEA4gMfv7c=;
	h=Date:To:From:Subject:Message-Id; b=e5QDDMo2l928A5sUDAaqxcFJCNIuT2gE3fNKC8vueT9CsGqRG3HCxa2Vqq7JUwKvifEah+MOBWVGqCoKJCJIH3Oo62H4nSfOtp/VSb3TJsgjVfvodZi8guovG9ZPA1Hs4J+3+h8blKJ1zRj7bhweNMsRjKdrUnKS8pQHdZ/gA7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jwJHfs4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jwJHfs4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8124C4CEC7;
	Mon,  2 Sep 2024 03:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248792;
	bh=w5kHZWfjE0pCa/Vgi716dDIZjYo9LlO4EdEA4gMfv7c=;
	h=Date:To:From:Subject:From;
	b=jwJHfs4sfnRamvS5KpXfmBpuVk052Sjg7tlSELZzq5p/UKJKqJ07oLJ5bRH6t/BS+
	 RhZ775/3sS/KZYbt/W4Xksd5qaM6POiMB7LY10ScSRTvlD5mm4B1IohfpvNK0cQlv3
	 ptAyzydd/qGevD/vdT3b78swTL1rJt3PM/QujPa0=
Date: Sun, 01 Sep 2024 20:46:31 -0700
To: mm-commits@vger.kernel.org,thorsten.blum@toblux.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-checksum-use-array_size-to-improve-assert_setup_correct.patch removed from -mm tree
Message-Id: <20240902034631.E8124C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: checksum: use ARRAY_SIZE() to improve assert_setup_correct()
has been removed from the -mm tree.  Its filename was
     lib-checksum-use-array_size-to-improve-assert_setup_correct.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@toblux.com>
Subject: lib: checksum: use ARRAY_SIZE() to improve assert_setup_correct()
Date: Fri, 26 Jul 2024 17:49:46 +0200

Use ARRAY_SIZE() to simplify the assert_setup_correct() function and
improve its readability.

Link: https://lkml.kernel.org/r/20240726154946.230928-1-thorsten.blum@toblux.com
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/checksum_kunit.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/lib/checksum_kunit.c~lib-checksum-use-array_size-to-improve-assert_setup_correct
+++ a/lib/checksum_kunit.c
@@ -468,12 +468,9 @@ static __wsum to_wsum(u32 x)
 
 static void assert_setup_correct(struct kunit *test)
 {
-	CHECK_EQ(sizeof(random_buf) / sizeof(random_buf[0]), MAX_LEN);
-	CHECK_EQ(sizeof(expected_results) / sizeof(expected_results[0]),
-		 MAX_LEN);
-	CHECK_EQ(sizeof(init_sums_no_overflow) /
-			 sizeof(init_sums_no_overflow[0]),
-		 MAX_LEN);
+	CHECK_EQ(ARRAY_SIZE(random_buf), MAX_LEN);
+	CHECK_EQ(ARRAY_SIZE(expected_results), MAX_LEN);
+	CHECK_EQ(ARRAY_SIZE(init_sums_no_overflow), MAX_LEN);
 }
 
 /*
_

Patches currently in -mm which might be from thorsten.blum@toblux.com are

mm-shrinker-use-min-to-improve-shrinker_debugfs_scan_write.patch

