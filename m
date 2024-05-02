Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741F815AADA
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714663134; cv=none; b=RZxULxRMpRUbcWAiobLFNjoSQA8YJqNoDZY+5VRZMcFlEQrVfg5c0TIshAR2OTm01PFc8QwTMw7MzsFRrhP/NuOqdyPwqzYHLw/lrI+EgyxrmqUKqTiyuv/8/y/aiJSFE7pjmP4h+jWvZOZ7SlvN0SuF2LL68C5at491E4IX+FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714663134; c=relaxed/simple;
	bh=36e7cixJgQ5FImggtMPOURunsA1sfaqCunhYcTm8lRE=;
	h=Date:To:From:Subject:Message-Id; b=M9dEQ6V6vmGfrWDVcrWCbg51xCM9YZNZmvJX6jU8jdwqfpQyef1mz6w48zYVnZkfa5eTjIDzxE8lZmTe01i3GEF4+9olGpn0HRRhNw0wm9ciuPiPWYAn5jIhFLxtVU78lFNXMpTxmKPActaKteTeVV6b/xJSHmT1LEYLncYZm6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=brPiWO9M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="brPiWO9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94F0C32789;
	Thu,  2 May 2024 15:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714663134;
	bh=36e7cixJgQ5FImggtMPOURunsA1sfaqCunhYcTm8lRE=;
	h=Date:To:From:Subject:From;
	b=brPiWO9Mg0BFm9Wlsud4XNM3oItNUM8OyuN85vWQem9kV3WO8z33Ixnyrlf9IxQAk
	 X/YDClkckaOyJf7l2WUnQRK2+QB81DHTT1PUajMxp4+NCMHy3IhTMycTo/GqJa5t//
	 j5hKT71/lxZsgPqOXmGRFJQU8hnu7k7fD+X1u03o=
Date: Thu, 02 May 2024 08:18:52 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,linux@rasmusvillemoes.dk,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] bitops-optimize-fns-for-improved-performance.patch removed from -mm tree
Message-Id: <20240502151853.C94F0C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bitops: optimize fns() for improved performance
has been removed from the -mm tree.  Its filename was
     bitops-optimize-fns-for-improved-performance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: bitops: optimize fns() for improved performance
Date: Thu, 2 May 2024 17:24:43 +0800

The current fns() repeatedly uses __ffs() to find the index of the least
significant bit and then clears the corresponding bit using __clear_bit().
The method for clearing the least significant bit can be optimized by
using word &= word - 1 instead.

Typically, the execution time of one __ffs() plus one __clear_bit() is
longer than that of a bitwise AND operation and a subtraction.  To improve
performance, the loop for clearing the least significant bit has been
replaced with word &= word - 1, followed by a single __ffs() operation to
obtain the answer.  This change reduces the number of __ffs() iterations
from n to just one, enhancing overall performance.

This modification significantly accelerates the fns() function in the
test_bitops benchmark, improving its speed by approximately 7.6 times. 
Additionally, it enhances the performance of find_nth_bit() in the
find_bit benchmark by approximately 26%.

Before:
test_bitops: fns:            58033164 ns
find_nth_bit:                  4254313 ns,  16525 iterations

After:
test_bitops: fns:             7637268 ns
find_nth_bit:                  3362863 ns,  16501 iterations

Link: https://lkml.kernel.org/r/20240502092443.6845-3-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/include/linux/bitops.h~bitops-optimize-fns-for-improved-performance
+++ a/include/linux/bitops.h
@@ -254,16 +254,10 @@ static inline unsigned long __ffs64(u64
  */
 static inline unsigned long fns(unsigned long word, unsigned int n)
 {
-	unsigned int bit;
+	while (word && n--)
+		word &= word - 1;
 
-	while (word) {
-		bit = __ffs(word);
-		if (n-- == 0)
-			return bit;
-		__clear_bit(bit, &word);
-	}
-
-	return BITS_PER_LONG;
+	return word ? __ffs(word) : BITS_PER_LONG;
 }
 
 /**
_

Patches currently in -mm which might be from visitorckw@gmail.com are


