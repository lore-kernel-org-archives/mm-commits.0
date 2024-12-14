Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF100B672
	for <mm-commits@vger.kernel.org>; Sat, 14 Dec 2024 00:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734136795; cv=none; b=QEJ6Z3siZLg95QwY7kSicgeIm6WGakE/v0kReSlhJai/kC1ZozxLvbOulJjms+RTRAgb6LR7lNh9wySGufGCMl7+/ekUNd3mgFXc192E4UXxNgiejfDUtBH10Rh/2R5dVtobGi5Gok4gys3jQ4SPXd/x0UWYhs6dv6+isNZt19g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734136795; c=relaxed/simple;
	bh=awGYVYUjx80kgfU/Dq591u43ooPYD/zEUDswabgVa3M=;
	h=Date:To:From:Subject:Message-Id; b=mGo/rezAvXFM946WE+gIaZOZwTPHyIN7y7gZD/SoLUkut110yDpHbP2S7OUnxc6s4dVgufemC0qSuwEnX1uipgeIE4Ap+aMZpJGbbJ4fw6GJ4r3BhMObpPoTPHqnGcpYgRABWOiw2lxyKetDl+lri5HogtMLeCFGdgo//Sx5MYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ta/jgL0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ta/jgL0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CB3C4CED0;
	Sat, 14 Dec 2024 00:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734136795;
	bh=awGYVYUjx80kgfU/Dq591u43ooPYD/zEUDswabgVa3M=;
	h=Date:To:From:Subject:From;
	b=Ta/jgL0pAbRKIlgSVt0xGTB0AiJbF26sxXL3J9wkhr9BhZvPr+mH/w5D72vYGFRUi
	 e+nwGA9zqLGDT8e5ZI/A8Y537ziigpjK1WUCoGE7XlIuq4egmKDsTBld2WHldXJQaE
	 XjCY/sW8k4LvIu4mu82vFY8PqeK7JSB2bVGKt22M=
Date: Fri, 13 Dec 2024 16:39:54 -0800
To: mm-commits@vger.kernel.org,zhang.yunkai@zte.com.cn,ye.xingchen@zte.com.cn,xu.xin16@zte.com.cn,wang.yong12@zte.com.cn,wang.yaxin@zte.com.cn,tu.qiang35@zte.com.cn,he.peilin@zte.com.cn,fan.yu9@zte.com.cn,david@redhat.com,bsingharora@gmail.com,jiang.kun2@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + delayacct-update-docs-and-fix-some-spelling-errors.patch added to mm-hotfixes-unstable branch
Message-Id: <20241214003955.47CB3C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: delayacct: update docs and fix some spelling errors
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     delayacct-update-docs-and-fix-some-spelling-errors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/delayacct-update-docs-and-fix-some-spelling-errors.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: <jiang.kun2@zte.com.cn>
Subject: delayacct: update docs and fix some spelling errors
Date: Fri, 13 Dec 2024 19:27:00 +0800 (CST)


Update delay-accounting.rst to include the 'delay max' in the output
of getdelays, and fix some spelling errors before.

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

--- a/Documentation/accounting/delay-accounting.rst~delayacct-update-docs-and-fix-some-spelling-errors
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
 
--- a/kernel/delayacct.c~delayacct-update-docs-and-fix-some-spelling-errors
+++ a/kernel/delayacct.c
@@ -93,7 +93,7 @@ void __delayacct_tsk_init(struct task_st
 
 /*
  * Finish delay accounting for a statistic using its timestamps (@start),
- * accumalator (@total) and @count
+ * accumulator (@total) and @count
  */
 static void delayacct_end(raw_spinlock_t *lock, u64 *start, u64 *total, u32 *count)
 {
_

Patches currently in -mm which might be from jiang.kun2@zte.com.cn are

delayacct-update-docs-and-fix-some-spelling-errors.patch

