Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BA8153BC5
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714663110; cv=none; b=r0oY39l822bdUQQfVI7UNgNXvv4OEaki8Vg4AsN1ycqKnNqr5A2uGdQ3ldvLKtyUMIHe3cu1VCrreBfCl6l0DesnSoPujX19zwJwkL5511Lsq/x84m35NwTD5cCaOhmeQ0esUIOq14/7B5XOye5E5QN5FSOODBrEzp8bbBzn1jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714663110; c=relaxed/simple;
	bh=b4tqk4hF6J0gika6kmxlg4n/GEkCeJMN3VU8Spdq788=;
	h=Date:To:From:Subject:Message-Id; b=uDSJ7mEXpQZrQUt3PdxgvSjkvIVMzhtSAXl/I0GUTE1in8rz3yfDzyrgWMTqd8mnAgddlBvGKqkjTB3dAZ3pf4MgifJH1slyFgdLR5uPddY3UrLllG19r+5xSj5as8OuwnLWH0jDDwBpN6BAcH5EnGFouYkp5z8zVzxm6+ghS04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TgULrjj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TgULrjj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DFBC32789;
	Thu,  2 May 2024 15:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714663110;
	bh=b4tqk4hF6J0gika6kmxlg4n/GEkCeJMN3VU8Spdq788=;
	h=Date:To:From:Subject:From;
	b=TgULrjj9OMc9xolp5zljOGjZvpsWOXQlnJunCex4sSgAo2LPz8ucgthxbNg5nGo0B
	 fMo4dxzSDGkFdZRo811AatRA1XgHT2GSU12YnxweSDf6+8/1JUS//M2Z4ty7G9piAR
	 291oFLYpse4L7g2jniE4amz1r0Si+hElWkXaa9HM=
Date: Thu, 02 May 2024 08:18:28 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,linux@rasmusvillemoes.dk,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bitops-optimize-fns-for-improved-performance.patch added to mm-nonmm-unstable branch
Message-Id: <20240502151829.C3DFBC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bitops: optimize fns() for improved performance
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bitops-optimize-fns-for-improved-performance.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bitops-optimize-fns-for-improved-performance.patch

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

lib-test_bitops-add-benchmark-test-for-fns.patch
bitops-optimize-fns-for-improved-performance.patch

