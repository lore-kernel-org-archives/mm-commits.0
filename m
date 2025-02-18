Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C22C1B424D
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 06:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739860854; cv=none; b=llZmpLLlO5oExyaIcRzV8bddzz4z9fFN3oNajhruEewrO0jed0AWNPb56mBCSl6KnrR87ChJG5T1U+leCDpFR92bBL28crAl0EFAcB2a/hMfOxKr+Qw8FDdlbe++eLskYBIHnGIANFXNaoj+RqR3V3c7EXtVJ8/w76EYA4NgzvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739860854; c=relaxed/simple;
	bh=9iY2CXbFVo5vknWMM4LKjOmE7wHTNUz0RMdJi2SY0Zo=;
	h=Date:To:From:Subject:Message-Id; b=VlfzrW4vMcZj3SXTPfx1Y31+xtLJxmRKy64HuFzUy7fZ65QVK7ieyfW7AY/kfX96peHLa1SVop+jMuPq6N7xboQodDmgMG2vyIcEw03/d0xKJz7zzzywEco7SVEYJDtukdlzZWsCWwWz2djLZ7oA0/+vVvsr8howR78DZAmOoqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nVHBSRYV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nVHBSRYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AE1C4CEE2;
	Tue, 18 Feb 2025 06:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739860853;
	bh=9iY2CXbFVo5vknWMM4LKjOmE7wHTNUz0RMdJi2SY0Zo=;
	h=Date:To:From:Subject:From;
	b=nVHBSRYVs6O/FrHas390PinTS/G1/Kl26FiGNuYhnOubsHZC5QkcLs8tL4qFpLEUh
	 F9js91OEmh3yR8vXe9djHYybx+1CsXHGN9JNgNLctVasI3wC2C7FRgTbwby8J4tBL6
	 Xle57iSXQ3pRHfLvcFn89w8akL9ZjAi/f8hJvK00=
Date: Mon, 17 Feb 2025 22:40:52 -0800
To: mm-commits@vger.kernel.org,zhang.yunkai@zte.com.cn,ye.xingchen@zte.com.cn,xu.xin16@zte.com.cn,wang.yong12@zte.com.cn,tu.qiang35@zte.com.cn,jiang.kun2@zte.com.cn,he.peilin@zte.com.cn,fan.yu9@zte.com.cn,david@redhat.com,bsingharora@gmail.com,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] getdelays-fix-error-format-characters.patch removed from -mm tree
Message-Id: <20250218064053.59AE1C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: getdelays: fix error format characters
has been removed from the -mm tree.  Its filename was
     getdelays-fix-error-format-characters.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wang Yaxin <wang.yaxin@zte.com.cn>
Subject: getdelays: fix error format characters
Date: Sat, 8 Feb 2025 14:44:00 +0800 (CST)

getdelays had a compilation issue because the format string was not
updated when the "delay min" was added.  For example, after adding the
"delay min" in printf, there were 7 strings but only 6 "%s" format
specifiers.  Similarly, after adding the 't->cpu_delay_total', there were
7 variables but only 6 format characters specifiers, causing compilation
issues as follows.  This commit fixes these issues to ensure that
getdelays compiles correctly.

root@xx:~/linux-next/tools/accounting$ make
getdelays.c:199:9: warning: format `%llu' expects argument of type
`long long unsigned int', but argument 8 has type `char *' [-Wformat=]
  199 |  printf("\n\nCPU   %15s%15s%15s%15s%15s%15s\n"
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.....
  216 |         "delay total", "delay average", "delay max", "delay min",
      |                                                      ~~~~~~~~~~~
      |                                                      |
      |                                                      char *
getdelays.c:200:21: note: format string is defined here
  200 |         "      %15llu%15llu%15llu%15llu%15.3fms%13.6fms\n"
      |                ~~~~~^
      |                     |
      |                     long long unsigned int
      |                %15s
getdelays.c:199:9: warning: format `%f' expects argument of type
`double', but argument 12 has type `long long unsigned int' [-Wformat=]
  199 |  printf("\n\nCPU   %15s%15s%15s%15s%15s%15s\n"
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.....
  220 |         (unsigned long long)t->cpu_delay_total,
      |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |         |
      |         long long unsigned int
.....

Link: https://lkml.kernel.org/r/20250208144400544RduNRhwIpT3m2JyRBqskZ@zte.com.cn
Fixes: f65c64f311ee ("delayacct: add delay min to record delay peak")
Reviewed-by: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Kun Jiang <jiang.kun2@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Peilin He <he.peilin@zte.com.cn>
Cc: Qiang Tu <tu.qiang35@zte.com.cn>
Cc: wangyong <wang.yong12@zte.com.cn>
Cc: ye xingchen <ye.xingchen@zte.com.cn>
Cc: Yunkai Zhang <zhang.yunkai@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/getdelays.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/tools/accounting/getdelays.c~getdelays-fix-error-format-characters
+++ a/tools/accounting/getdelays.c
@@ -196,22 +196,22 @@ static int get_family_id(int sd)
 
 static void print_delayacct(struct taskstats *t)
 {
-	printf("\n\nCPU   %15s%15s%15s%15s%15s%15s\n"
-	       "      %15llu%15llu%15llu%15llu%15.3fms%13.6fms\n"
-	       "IO    %15s%15s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms%13.6fms\n"
-	       "SWAP  %15s%15s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms%13.6fms\n"
-	       "RECLAIM  %12s%15s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms%13.6fms\n"
-	       "THRASHING%12s%15s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms%13.6fms\n"
-	       "COMPACT  %12s%15s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms%13.6fms\n"
-	       "WPCOPY   %12s%15s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms%13.6fms\n"
-	       "IRQ   %15s%15s%15s%15s\n"
-	       "      %15llu%15llu%15.3fms%13.6fms\n",
+	printf("\n\nCPU   %15s%15s%15s%15s%15s%15s%15s\n"
+	       "      %15llu%15llu%15llu%15llu%15.3fms%13.6fms%13.6fms\n"
+	       "IO    %15s%15s%15s%15s%15s\n"
+	       "      %15llu%15llu%15.3fms%13.6fms%13.6fms\n"
+	       "SWAP  %15s%15s%15s%15s%15s\n"
+	       "      %15llu%15llu%15.3fms%13.6fms%13.6fms\n"
+	       "RECLAIM  %12s%15s%15s%15s%15s\n"
+	       "      %15llu%15llu%15.3fms%13.6fms%13.6fms\n"
+	       "THRASHING%12s%15s%15s%15s%15s\n"
+	       "      %15llu%15llu%15.3fms%13.6fms%13.6fms\n"
+	       "COMPACT  %12s%15s%15s%15s%15s\n"
+	       "      %15llu%15llu%15.3fms%13.6fms%13.6fms\n"
+	       "WPCOPY   %12s%15s%15s%15s%15s\n"
+	       "      %15llu%15llu%15.3fms%13.6fms%13.6fms\n"
+	       "IRQ   %15s%15s%15s%15s%15s\n"
+	       "      %15llu%15llu%15.3fms%13.6fms%13.6fms\n",
 	       "count", "real total", "virtual total",
 	       "delay total", "delay average", "delay max", "delay min",
 	       (unsigned long long)t->cpu_count,
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are


