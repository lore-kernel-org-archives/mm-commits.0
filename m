Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C281A76AD
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 21:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723583442; cv=none; b=lWPJGirPGGTRI/raPPjo4AeHPgS8EyMP4rwdF+bkAc/33jRN3sYs6gBHK/6OaRg0TJ4yOj9XVwml10hYnbi5SJlbuYn7FyEyVKIDW9ZWUB1JtVF+hVd9Um94MOAJWAQXENsRapl+pZ3qJuqV8FJSL8vdOphqVP0gj23eTwBUHTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723583442; c=relaxed/simple;
	bh=7YbgqdrpcqXdZRoeLGmHtpuyAcgZZIl3GhC1tEGzA5E=;
	h=Date:To:From:Subject:Message-Id; b=WYLEg1ho+HU2t6q9R0szg1Bo8qGS7lF50+mYbjIqpSOP7rYoKMSnWoLtwApg3yTNnfdN7GQ9cUP5JYmIQHC/uPfmCGIPfF5oRxrSYLlesTMMERhs2LrT13UTkwkUXQ772GU8TAuS3OOIQMouAihnraP8EFyYbgWHfyI0rjuKb4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rE9eXIjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rE9eXIjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC9CC32782;
	Tue, 13 Aug 2024 21:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723583440;
	bh=7YbgqdrpcqXdZRoeLGmHtpuyAcgZZIl3GhC1tEGzA5E=;
	h=Date:To:From:Subject:From;
	b=rE9eXIjtlxj8a4q0gaIfY6SZ0fXRqmO/Xl7CzCh1CQ82uVP4wynDtiakcJwEjtf5K
	 yuLYt8AEnuohwoFnnI+YR9SThfGsP/gTRnYCE5d7dSdenxEYewpxvVLjzLbfSdv37P
	 Wfy/Z+yCB5b6MoR3/6Mcuw9gNWSZOSrg5yn2A5TQ=
Date: Tue, 13 Aug 2024 14:10:39 -0700
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-bcd-optimize-_bin2bcd-for-improved-performance.patch added to mm-nonmm-unstable branch
Message-Id: <20240813211040.4DC9CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/bcd: optimize _bin2bcd() for improved performance
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-bcd-optimize-_bin2bcd-for-improved-performance.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-bcd-optimize-_bin2bcd-for-improved-performance.patch

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
Subject: lib/bcd: optimize _bin2bcd() for improved performance
Date: Tue, 13 Aug 2024 01:02:29 +0800

The original _bin2bcd() function used / 10 and % 10 operations for
conversion.  Although GCC optimizes these operations and does not generate
division or modulus instructions, the new implementation reduces the
number of mov instructions in the generated code for both x86-64 and ARM
architectures.

This optimization calculates the tens digit using (val * 103) >> 10, which
is accurate for values of 'val' in the range [0, 178].  Given that the
valid input range is [0, 99], this method ensures correctness while
simplifying the generated code.

Link: https://lkml.kernel.org/r/20240812170229.229380-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bcd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/bcd.c~lib-bcd-optimize-_bin2bcd-for-improved-performance
+++ a/lib/bcd.c
@@ -10,6 +10,8 @@ EXPORT_SYMBOL(_bcd2bin);
 
 unsigned char _bin2bcd(unsigned val)
 {
-	return ((val / 10) << 4) + val % 10;
+	const unsigned int t = (val * 103) >> 10;
+
+	return (t << 4) | (val - t * 10);
 }
 EXPORT_SYMBOL(_bin2bcd);
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-bcd-optimize-_bin2bcd-for-improved-performance.patch

