Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896693EA9B
	for <mm-commits@vger.kernel.org>; Sun, 28 Jul 2024 21:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722201629; cv=none; b=i9tOPhQMJJ0t0ol2Xo4Og6kRi0M4b6eFCjJmzr223oRKJ7fkHONUfP+ZlDyyuvK++k3QD4t9WkAF7VEF5dMI1OdjIbgO20my9C1som0Sbcgu3XnD8vp4Hwi0ArvoSm4rq9AQCqc5zCUFAGW6MymmNt8m9F6/94gYS7bgftpDess=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722201629; c=relaxed/simple;
	bh=tu92v7Y2hNYxy2270JGeFchM4VFosyM3qbwCqpcZol8=;
	h=Date:To:From:Subject:Message-Id; b=RCjSVpKKCwhe6mj7xABBsl7m33FoXYsEfgKCiqv9dqs/vskLyIh99bS45VWZT2a/tFyMSxHzi9Rq1X7ia4Dw3nKID2ieQzRdXGXHKN778Lr6WgqhdOEuD5npMc1omhS4l7GasrJp9L4zDi9jk2vhtPa0a3HYfFy1RXU+0HymCFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DtfehNI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DtfehNI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EAAC116B1;
	Sun, 28 Jul 2024 21:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722201629;
	bh=tu92v7Y2hNYxy2270JGeFchM4VFosyM3qbwCqpcZol8=;
	h=Date:To:From:Subject:From;
	b=DtfehNI42vpMY+VI9ZJ8LKw4TMDexB1jWXnq3hxOSfYqXVi7b3cpq+Y3B4Bd+5/zk
	 d4Ml8Hie5xiS+XsTEfbuD+hn+npkEPEGdR+oogF5gsTgYNMIiCDkkegyDCkZVKXuLl
	 HNYhCJEtxPmpA+uBEtSyymMbP0rnil4hWl4vCsk4=
Date: Sun, 28 Jul 2024 14:20:13 -0700
To: mm-commits@vger.kernel.org,thorsten.blum@toblux.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-checksum-use-array_size-to-improve-assert_setup_correct.patch added to mm-nonmm-unstable branch
Message-Id: <20240728212029.16EAAC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: checksum: use ARRAY_SIZE() to improve assert_setup_correct()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-checksum-use-array_size-to-improve-assert_setup_correct.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-checksum-use-array_size-to-improve-assert_setup_correct.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

lib-checksum-use-array_size-to-improve-assert_setup_correct.patch

