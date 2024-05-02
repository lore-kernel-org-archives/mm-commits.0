Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A397B1586D0
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714663107; cv=none; b=oYLYkWazo6q4lBXsL7ZwykvTGhyKYQ4NSTLDBGv0E9u48g4bc+EXkcLWOt0wK+cxyGcm+EKlVCXIJ8umj4yWwBqs/3GpTnwZ+nvV/a7+djpC5prBQBlg3QFxcZMvCb9sXVv1xumJVh5/qfENC6TmP37HfXYAS6kpLiyUA5V6MbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714663107; c=relaxed/simple;
	bh=944uCDKcxuzmwsqZeSmib6F4b3mFyvyxiOqvcg8JkP8=;
	h=Date:To:From:Subject:Message-Id; b=VZPLcTUpbSV8kqQh4JCo+IMC7GG2A/aqdmT/7KGjfqQCIB9Z6765SGN54a+4zuwIpuKESPNlCCHUi9PrOXS4YddOcmIAcAJRPk2/YCzAW52uajbKgiUQKg4DO0TCh7Le8wPvAC2m1+iLGMPW7CUvPQDBQVWp3gYhg94Ux0grK8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wvdmogWT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wvdmogWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E895C113CC;
	Thu,  2 May 2024 15:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714663107;
	bh=944uCDKcxuzmwsqZeSmib6F4b3mFyvyxiOqvcg8JkP8=;
	h=Date:To:From:Subject:From;
	b=wvdmogWT8rqKFJ69eT3yx43nfKjiPzmppnRHtxWo2TeWlNziw11N4pNx93PvUqVb1
	 I3+hB+LnKPqR5VI5IcYplCPFkM/khOveNXpYzVDDNsEx89H+/98L1xcByiorTEfbAw
	 M8mECDeiVJMjBVRAdpU9sRJl/Z38HsMTdvMW98/U=
Date: Thu, 02 May 2024 08:18:25 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,linux@rasmusvillemoes.dk,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_bitops-add-benchmark-test-for-fns.patch added to mm-nonmm-unstable branch
Message-Id: <20240502151827.0E895C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_bitops: add benchmark test for fns()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test_bitops-add-benchmark-test-for-fns.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_bitops-add-benchmark-test-for-fns.patch

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
Subject: lib/test_bitops: add benchmark test for fns()
Date: Thu, 2 May 2024 17:24:42 +0800

Patch series "bitops: Optimize fns() for improved performance", v5.

This patch series optimizes the fns() function by avoiding repeated calls
to __ffs().  Additionally, tests for fns() have been added in
lib/test_bitops.c.  


This patch (of 2):

Introduce a benchmark test for the fns().  It measures the total time
taken by fns() to process 10,000 test data generated using
get_random_bytes() for each n in the range [0, BITS_PER_LONG).

example:
test_bitops: fns:             7637268 ns

Link: https://lkml.kernel.org/r/20240502092443.6845-1-visitorckw@gmail.com
Link: https://lkml.kernel.org/r/20240502092443.6845-2-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Suggested-by: Yury Norov <yury.norov@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitops.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/lib/test_bitops.c~lib-test_bitops-add-benchmark-test-for-fns
+++ a/lib/test_bitops.c
@@ -50,6 +50,26 @@ static unsigned long order_comb_long[][2
 };
 #endif
 
+static int __init test_fns(void)
+{
+	static unsigned long buf[10000] __initdata;
+	static volatile __used unsigned long tmp __initdata;
+	unsigned int i, n;
+	ktime_t time;
+
+	get_random_bytes(buf, sizeof(buf));
+	time = ktime_get();
+
+	for (n = 0; n < BITS_PER_LONG; n++)
+		for (i = 0; i < 10000; i++)
+			tmp = fns(buf[i], n);
+
+	time = ktime_get() - time;
+	pr_err("fns:  %18llu ns\n", time);
+
+	return 0;
+}
+
 static int __init test_bitops_startup(void)
 {
 	int i, bit_set;
@@ -94,6 +114,8 @@ static int __init test_bitops_startup(vo
 	if (bit_set != BITOPS_LAST)
 		pr_err("ERROR: FOUND SET BIT %d\n", bit_set);
 
+	test_fns();
+
 	pr_info("Completed bitops test\n");
 
 	return 0;
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-test_bitops-add-benchmark-test-for-fns.patch
bitops-optimize-fns-for-improved-performance.patch

