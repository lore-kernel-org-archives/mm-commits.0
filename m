Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DD32E7BDC
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 19:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768247382; cv=none; b=radJLL7mrr1KdoD3Sq1noiqfeRtpcSVcOSQRa9e/eytW1N949fUM5SK83InIAAw5KWF8NbHJsIwE0TSXpdn6e/5VJvWgs9MjQLIEhyGITo/02Ww9B1s2CIMPt2HGCmV6/M5GbJD3oXk5qUmt3HQQKrrpSV+tge/u1YleKwLUovs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768247382; c=relaxed/simple;
	bh=ytJsib9ZZ6Jio4EDxvvHVaRJkJvEK3rh5zJImYJILT0=;
	h=Date:To:From:Subject:Message-Id; b=bwNbNDj6p8ZOCMUWm26VR276MUJuhdwosKbnca1fssaNXNLpOUsE4nGbO8WBn4/heTshdYnAjQXu3nY9YwP77Z9/GXVTj31yj2pbGJaCm8WZIM3Jr+2dY0KVxfUqYG4rqguTPBWR4/4ELWY7euiSwSsl1Jh+QyEcw5123Xmx+Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qOxR/4J4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qOxR/4J4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB19C116D0;
	Mon, 12 Jan 2026 19:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768247381;
	bh=ytJsib9ZZ6Jio4EDxvvHVaRJkJvEK3rh5zJImYJILT0=;
	h=Date:To:From:Subject:From;
	b=qOxR/4J4pVYLB/Qyu4k7SGHHUGtQzDXVYLz4dkiZuepY47xruVnlMshlZf/tAQN+s
	 tJFOPbP44arfARFS/cA+pOheIlQXifmXkgSrpqRY0I8RF5odhzwi/MtEU1/SCBZ4z8
	 /xpJsXTgeosK6nTZyMIdQSJNCQykv1RJ2FQD88ws=
Date: Mon, 12 Jan 2026 11:49:40 -0800
To: mm-commits@vger.kernel.org,suhui@nfschina.com,martin.petersen@oracle.com,john.g.garry@oracle.com,axboe@kernel.dk,macro@orcam.me.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + linux-log2h-reduce-instruction-count-for-is_power_of_2.patch added to mm-nonmm-unstable branch
Message-Id: <20260112194941.5EB19C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: linux/log2.h: reduce instruction count for is_power_of_2()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     linux-log2h-reduce-instruction-count-for-is_power_of_2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/linux-log2h-reduce-instruction-count-for-is_power_of_2.patch

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
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: linux/log2.h: reduce instruction count for is_power_of_2()
Date: Sun, 11 Jan 2026 21:21:57 +0000 (GMT)

Follow an observation that (n ^ (n - 1)) will only ever retain the most
significant bit set in the word operated on if that is the only bit set in
the first place, and use it to determine whether a number is a whole power
of 2, avoiding the need for an explicit check for nonzero.

This reduces the sequence produced to 3 instructions only across Alpha,
MIPS, and RISC-V targets, down from 4, 5, and 4 respectively, removing a
branch in the two latter cases.  And it's 5 instructions on POWER and
x86-64 vs 8 and 9 respectively.  There are no branches now emitted here
for targets that have a suitable conditional set operation, although an
inline expansion will often end with one, depending on what code a call to
this function is used in.

Credit goes to GCC authors for coming up with this optimisation used as
the fallback for (__builtin_popcountl(n) == 1), equivalent to this code,
for targets where the hardware population count operation is considered
expensive.

Link: https://lkml.kernel.org/r/alpine.DEB.2.21.2601111836250.30566@angie.orcam.me.uk
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: John Garry <john.g.garry@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Su Hui <suhui@nfschina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/log2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/log2.h~linux-log2h-reduce-instruction-count-for-is_power_of_2
+++ a/include/linux/log2.h
@@ -44,7 +44,7 @@ int __ilog2_u64(u64 n)
 static __always_inline __attribute__((const))
 bool is_power_of_2(unsigned long n)
 {
-	return (n != 0 && ((n & (n - 1)) == 0));
+	return n - 1 < (n ^ (n - 1));
 }
 
 /**
_

Patches currently in -mm which might be from macro@orcam.me.uk are

linux-log2h-reduce-instruction-count-for-is_power_of_2.patch

