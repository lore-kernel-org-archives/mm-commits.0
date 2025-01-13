Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4F22AF09
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736741573; cv=none; b=Jb6WjGtKHy/50kt1hBJzoP8NEnSn2NUdGZ/u1CguK1/TvzlGWFGsNmtjYvrQHNTQIzLRs6Lb4R6fZyueYylrSxls2WVVvuTzjxiwOe5mJlpIqTs9Xz3VFu4LX+D4keF5CX5+cc3UjEa0FL8DiE78qTx9fB+0lLTz5YrBivsJ0PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736741573; c=relaxed/simple;
	bh=8mloECLTVSWFKbCwWTSDruJ2hN4bxNSFXU4lPZbiTbo=;
	h=Date:To:From:Subject:Message-Id; b=pqDVKAr43iFXf7OEhLPsS7SNatE2PFpCrYlT3kihfqW8dzbRbYo1Vh4DKKMa95k5KbHYwynPZn8UgKg84JRq88VZVP6ChGk4nPlXS2UCYGYeRi0wO3mKmxPtNZQj2dkPlf71edZvmkzFPPLj7S2mJA93UqKKLEONjtMF1DylR/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UmX8KZg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UmX8KZg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38090C4CED6;
	Mon, 13 Jan 2025 04:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736741573;
	bh=8mloECLTVSWFKbCwWTSDruJ2hN4bxNSFXU4lPZbiTbo=;
	h=Date:To:From:Subject:From;
	b=UmX8KZg1m4XNViy8zHLhUkBpqet2HUCbUpezHRa2VJBAobWHRsOqdI5t7y9H7/1g2
	 BMBSMDAIVeP4vZJwnpWcxnElnH0xo+Z3CILSx/ZeCrQUhmsYfi14gbcRoOHAW2kvd9
	 OQJ2RmJAQW9OPbRIJzbfPjLbnrwmJdCIy6cYw3bE=
Date: Sun, 12 Jan 2025 20:12:52 -0800
To: mm-commits@vger.kernel.org,zhang.yunkai@zte.com.cn,ye.xingchen@zte.com.cn,xu.xin16@zte.com.cn,wang.yong12@zte.com.cn,tu.qiang35@zte.com.cn,jiang.kun2@zte.com.cn,he.peilin@zte.com.cn,fan.yu9@zte.com.cn,david@redhat.com,bsingharora@gmail.com,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] delayacct-add-delay-max-to-record-delay-peak-fix.patch removed from -mm tree
Message-Id: <20250113041253.38090C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: delayacct: update docs and fix some spelling errors
has been removed from the -mm tree.  Its filename was
     delayacct-add-delay-max-to-record-delay-peak-fix.patch

This patch was dropped because it was folded into delayacct-add-delay-max-to-record-delay-peak.patch

------------------------------------------------------
From: Yaxin Wang <wang.yaxin@zte.com.cn>
Subject: delayacct: update docs and fix some spelling errors
Date: Fri, 13 Dec 2024 19:27:00 +0800 (CST)

Update delay-accounting.rst to include the 'delay max' in the output of
getdelays, and fix some spelling errors before.

Link: https://lkml.kernel.org/r/20241213192700771XKZ8H30OtHSeziGqRVMs0@zte.com.cn
Signed-off-by: Yaxin Wang <wang.yaxin@zte.com.cn>
Signed-off-by: Jiang Kun <jiang.kun2@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Peilin He <he.peilin@zte.com.cn>
Cc: tuqiang <tu.qiang35@zte.com.cn>
Cc: Wang Yong <wang.yong12@zte.com.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: ye xingchen <ye.xingchen@zte.com.cn>
Cc: Yunkai Zhang <zhang.yunkai@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/delay-accounting.rst |   38 ++++++++--------
 kernel/delayacct.c                            |    2 
 2 files changed, 20 insertions(+), 20 deletions(-)

--- a/Documentation/accounting/delay-accounting.rst~delayacct-add-delay-max-to-record-delay-peak-fix
+++ a/Documentation/accounting/delay-accounting.rst
@@ -100,29 +100,29 @@ Get delays, since system boot, for pid 1
 	# ./getdelays -d -p 10
 	(output similar to next case)
 
-Get sum of delays, since system boot, for all pids with tgid 5::
+Get sum and peak of delays, since system boot, for all pids with tgid 242::
 
-	# ./getdelays -d -t 5
+	bash-4.4# ./getdelays -d -t 242
 	print delayacct stats ON
-	TGID	5
+	TGID    242
 
 
-	CPU             count     real total  virtual total    delay total  delay average
-	                    8        7000000        6872122        3382277          0.423ms
-	IO              count    delay total  delay average
-                   0              0          0.000ms
-	SWAP            count    delay total  delay average
-                       0              0          0.000ms
-	RECLAIM         count    delay total  delay average
-                   0              0          0.000ms
-	THRASHING       count    delay total  delay average
-                       0              0          0.000ms
-	COMPACT         count    delay total  delay average
-                       0              0          0.000ms
-	WPCOPY          count    delay total  delay average
-                       0              0          0.000ms
-	IRQ             count    delay total  delay average
-                       0              0          0.000ms
+	CPU         count     real total  virtual total    delay total  delay average      delay max
+	              239      296000000      307724885        1127792          0.005ms     0.238382ms
+	IO          count    delay total  delay average      delay max
+	                0              0          0.000ms     0.000000ms
+	SWAP        count    delay total  delay average      delay max
+	                0              0          0.000ms     0.000000ms
+	RECLAIM     count    delay total  delay average      delay max
+	                0              0          0.000ms     0.000000ms
+	THRASHING   count    delay total  delay average      delay max
+	                0              0          0.000ms     0.000000ms
+	COMPACT     count    delay total  delay average      delay max
+	                0              0          0.000ms     0.000000ms
+	WPCOPY      count    delay total  delay average      delay max
+	              230       19100476          0.083ms     0.383822ms
+	IRQ         count    delay total  delay average      delay max
+	                0              0          0.000ms     0.000000ms
 
 Get IO accounting for pid 1, it works only with -p::
 
--- a/kernel/delayacct.c~delayacct-add-delay-max-to-record-delay-peak-fix
+++ a/kernel/delayacct.c
@@ -93,7 +93,7 @@ void __delayacct_tsk_init(struct task_st
 
 /*
  * Finish delay accounting for a statistic using its timestamps (@start),
- * accumalator (@total) and @count
+ * accumulator (@total) and @count
  */
 static void delayacct_end(raw_spinlock_t *lock, u64 *start, u64 *total, u32 *count, u64 *max)
 {
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are

delayacct-add-delay-max-to-record-delay-peak.patch
delayacct-add-delay-min-to-record-delay-peak.patch

