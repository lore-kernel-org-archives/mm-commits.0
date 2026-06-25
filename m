Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307111EDA32
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 01:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782350714; cv=none; b=kigg6EeLzdvzzUHl9zS1VAWbw/ieXKS/cMxNC55oDWY9XIMQweG0mExYPJ8+w3Tvo/05k/DfblDxjimlsQPZ+HLDzdpO9+Q84X5BPAWAtaL2VVraKF/+ZA4NChxuG/Go0ksg72H28H6EJXVRHPQTCJtItkXKY9KeLE1D1mDI5DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782350714; c=relaxed/simple;
	bh=i1mDjMWNDYoRH8UUxjCRGtdQOw7meu1TsifY+XERaTg=;
	h=Date:To:From:Subject:Message-Id; b=oDHCLymlGHLr9C3rTjKnXmRduzgw5k446EwyxjGD59ADt7Kgyb6YpxwMoFwAbxC3yCUSWUC8MsyyeXTxt0rm0rGh8ePuamFCrZ4NStql7DOrNbHQKq8ji10y5lK9LBL0Gco05PWBEaAQC5mlPkLsfDsYbD5aT8ZpAHoGWfoPSH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CDWhGURM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CDWhGURM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6AC1F000E9;
	Thu, 25 Jun 2026 01:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782350712;
	bh=M3O6XO8HounLo1BPWfGK8ObtgSKDBc6KuevRnAU3HRE=;
	h=Date:To:From:Subject;
	b=CDWhGURM0sZbopCxdJs6CM9iqPjXiM0VRM2wIlBwMceUaIWUlPkNP/RehFH8AaGP5
	 kl4OhW8vxp8Qx4F8eiRwX+/R/3dalA+LfqGRlKfJ9FrOhB5RuYDhSL75gcNknzRLpd
	 GakVzKWZSK2lKXLUtUzrPHgQ1aIR7dFkcD1RpePw=
Date: Wed, 24 Jun 2026 18:25:12 -0700
To: mm-commits@vger.kernel.org,penberg@kernel.org,kees@kernel.org,joern@logfs.org,cl@linux-foundation.org,andy@kernel.org,akinobu.mita@gmail.com,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-string-fix-memchr_inv-for-large-ranges.patch added to mm-nonmm-unstable branch
Message-Id: <20260625012512.CB6AC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/string: fix memchr_inv() for large ranges
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-string-fix-memchr_inv-for-large-ranges.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-string-fix-memchr_inv-for-large-ranges.patch

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
From: Bradley Morgan <include@grrlz.net>
Subject: lib/string: fix memchr_inv() for large ranges
Date: Sun, 21 Jun 2026 12:11:33 +0000

memchr_inv() takes a size_t length but counts 8 byte words in an unsigned
int.  At 32GiB that count wraps, so the scan can quietly miss most of the
range.

Use size_t for the word count.

Link: https://lore.kernel.org/20260621121133.16460-1-include@grrlz.net
Fixes: 798248206b59 ("lib/string.c: introduce memchr_inv()")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Akinbou Mita <akinobu.mita@gmail.com>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Christoph Lameer <cl@linux-foundation.org>
Cc: Joern Engel <joern@logfs.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/string.c~lib-string-fix-memchr_inv-for-large-ranges
+++ a/lib/string.c
@@ -821,7 +821,8 @@ void *memchr_inv(const void *start, int
 {
 	u8 value = c;
 	u64 value64;
-	unsigned int words, prefix;
+	size_t words;
+	unsigned int prefix;
 
 	if (bytes <= 16)
 		return check_bytes8(start, value, bytes);
_

Patches currently in -mm which might be from include@grrlz.net are

lib-string-fix-memchr_inv-for-large-ranges.patch

