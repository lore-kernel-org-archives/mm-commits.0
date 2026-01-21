Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126B9352F83
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967409; cv=none; b=NWtffWFvfD9QXw59EpzT9LfwP7Yv8mmEuC66Gd6NPmDGT80pVUz6tZ8uWKAdbLUPjYlUDF09ppRK+B8Nd+iGGwAIXwzgzfpieZPOvRwUBxbjNX0kvX8iSsvKs/qQfjYcVJ/E1yYJazhvwwMsgy4+Q9fU3rfXPpqZDNvYV+hMfWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967409; c=relaxed/simple;
	bh=vKJqvIEoh2GcmArvElqCzCoVY4zh/dfZJsSGsxNzLPs=;
	h=Date:To:From:Subject:Message-Id; b=SyfpGYProNuoimERSEv2KmtCMWbwYjoUieVQuNXkqT3W5nFGRZ8mJNocxoU+B1RDj/mEVWTzBY+YNBEXtcHxYsq3VndQDxrzoWvZIstZKauMMIjyvw//Ojy5EZPOlJ+CAS4JrqN65kzaw0j2W1BOY1WimIenIRWQD77wqP67DOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yWMUSsTJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yWMUSsTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB0DC116D0;
	Wed, 21 Jan 2026 03:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967408;
	bh=vKJqvIEoh2GcmArvElqCzCoVY4zh/dfZJsSGsxNzLPs=;
	h=Date:To:From:Subject:From;
	b=yWMUSsTJq3zk7Bg5/RYEPHPYahRs3rDjCqMQkfWCMb8soOx9QlkuO0o5prsKeSFiy
	 8rQM2AdgchLfn3afXtuu0izW+6VP1Ihrqa6pN1zbrFcHeotJX5cloOrWeQuoPwwmFQ
	 N8lDAiSy4PUwGs4Cc7DoCp6GeUznz7rn2n5L7YRM=
Date: Tue, 20 Jan 2026 19:50:07 -0800
To: mm-commits@vger.kernel.org,suhui@nfschina.com,martin.petersen@oracle.com,john.g.garry@oracle.com,axboe@kernel.dk,macro@orcam.me.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] linux-log2h-reduce-instruction-count-for-is_power_of_2.patch removed from -mm tree
Message-Id: <20260121035008.6FB0DC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: linux/log2.h: reduce instruction count for is_power_of_2()
has been removed from the -mm tree.  Its filename was
     linux-log2h-reduce-instruction-count-for-is_power_of_2.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


