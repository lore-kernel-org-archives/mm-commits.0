Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721AB26BD8E
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 03:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739246292; cv=none; b=IwQz6gyWD4PTo9hDf/ynjCoRACH8rG8aKwS6Ousy9TgqqAyTNSfC3ODS7WDjle1cfPaE8BCLCmxonyB/6ttdAP0ghRoWA643v5qThOwRo8mbWYF9G7ZrrrSNeyEelqHOdKn2Dnv4JhlG5UONjKo4F0mFnKjppllWqyEGVpJxfho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739246292; c=relaxed/simple;
	bh=eFDGt6G1H9S5oUF1vUj5x/GPvLo++C/csPkU1F8xLMw=;
	h=Date:To:From:Subject:Message-Id; b=VzIiZZYD45e0686hiGEozyWaIj4Na6106y8yrssPYISv+enKgstmquiQ1ab3r0aVjgCLjDaOv12y5ZPwJjusY/5Bs+gAS8eHfzm47Mjd2/ivqAx24WNV1log2Wmf65ZWMcp6h0GVSAiyHBK0MZWqD1I1JUp8Ap6vXsckYgfDTgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D5Kjrxhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D5Kjrxhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6966C4CEDD;
	Tue, 11 Feb 2025 03:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739246291;
	bh=eFDGt6G1H9S5oUF1vUj5x/GPvLo++C/csPkU1F8xLMw=;
	h=Date:To:From:Subject:From;
	b=D5Kjrxhz8lHh/WKr/w4QVDyrImE2iIyyH0dEFbu7jj7KOdT4v7M6i0lVFiP95TmkG
	 FjCsIRW29tNCNnmf+NrcTxcEZqCPNMUedV7xS5S+hixciOAilYtu2t+TZXrCeni0GR
	 BYAZcQ1ct93/rkYr+Qn1LR6NiHZWBOf82Zu+dWvo=
Date: Mon, 10 Feb 2025 19:58:11 -0800
To: mm-commits@vger.kernel.org,zhang.yunkai@zte.com.cn,ye.xingchen@zte.com.cn,xu.xin16@zte.com.cn,wang.yong12@zte.com.cn,tu.qiang35@zte.com.cn,jiang.kun2@zte.com.cn,he.peilin@zte.com.cn,fan.yu9@zte.com.cn,david@redhat.com,bsingharora@gmail.com,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + =utf-8bw1bbveniigxpbnv4ig5lehrdigdldgrlbgf5czogzml4igvycm9yigzvcm1hdcbjagfyywn0zxjz=.patch added to mm-hotfixes-unstable branch
Message-Id: <20250211035811.B6966C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: getdelays: fix error format characters
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     =utf-8bw1bbveniigxpbnv4ig5lehrdigdldgrlbgf5czogzml4igvycm9yigzvcm1hdcbjagfyywn0zxjz=.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/=utf-8bw1bbveniigxpbnv4ig5lehrdigdldgrlbgf5czogzml4igvycm9yigzvcm1hdcbjagfyywn0zxjz=.patch

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

--- a/tools/accounting/getdelays.c~=utf-8bw1bbveniigxpbnv4ig5lehrdigdldgrlbgf5czogzml4igvycm9yigzvcm1hdcbjagfyywn0zxjz=
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

=utf-8bw1bbveniigxpbnv4ig5lehrdigdldgrlbgf5czogzml4igvycm9yigzvcm1hdcbjagfyywn0zxjz=.patch

