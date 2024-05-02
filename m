Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F2C15AADA
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714663132; cv=none; b=hQWNfHjlF+4jigAyA8cmz2iQkRh7ngY86D777bRAXgdR5KG9k0S3WUBO4gjvGVoEuHMsDQOWfXb2js8maJUrMXNGpeTUgfiyFk2SmV3XOUX3QOGamncmKb5w2hdpbAElmtx3b9c3oz9uOzzH78yJIjqe1Ts18dwd0DtDp/lWFaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714663132; c=relaxed/simple;
	bh=Tab7lw2R94kdzyknTBS87CH6YJusaLr97ee7WPFp2Iw=;
	h=Date:To:From:Subject:Message-Id; b=FzHSPxlohNj4hLB7QPyjGsBkhjAaPcRBLFJ8llZGPb+jmUKJO+ZCzxktFDVJ/pZHGacj4Cu+kiNuWCvyrYGXzbYvB7W2QKS5m+/kS8HkiXgN32T2Sj9brqqM0TuJN3i+GIxfyonvhGVPUx1L0J1/Pt1kz8p/c6M5l69J4SQCdYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n7hRTixO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n7hRTixO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACB8C113CC;
	Thu,  2 May 2024 15:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714663131;
	bh=Tab7lw2R94kdzyknTBS87CH6YJusaLr97ee7WPFp2Iw=;
	h=Date:To:From:Subject:From;
	b=n7hRTixOy1/rXi1EeG9CDy1F8Z+1fZrQsFGfDVwwJSXCU//SQyoaFMQX2THeh+Ttb
	 ZXh0Vo8tQQmqhS8LQVg5VoZ3xoDRYwbjaVSWnfFioouv3Fik6BeqtulW0BU6JpQ6ZT
	 MITZY662+QDPklsmP17mDxFYjRE58HiH6z6ZrT28=
Date: Thu, 02 May 2024 08:18:50 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,linux@rasmusvillemoes.dk,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-test_bitops-add-benchmark-test-for-fns.patch removed from -mm tree
Message-Id: <20240502151851.AACB8C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_bitops: add benchmark test for fns()
has been removed from the -mm tree.  Its filename was
     lib-test_bitops-add-benchmark-test-for-fns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

bitops-optimize-fns-for-improved-performance.patch

