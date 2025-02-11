Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF8C8488
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 04:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739246711; cv=none; b=hlYvr+zrBZhXlnCMSwmJDDQG8tifvAsrXElIZLcEGICUX+Ob1TJ6G29tDeR7xe3hhtgjaTyfBDN/gGqE9M+5TNR5FN8aRTAbuzVbY5DCRMccUg1MlWcgAY8EvZSjAUZWY6rBDc0vo4jRsBUACaBSm1kwPwLhDIJPvcvtwGufmy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739246711; c=relaxed/simple;
	bh=9X/2DXNdRNNMHvacFHjz70X7cq6H73+S5yM/d5nt2Tg=;
	h=Date:To:From:Subject:Message-Id; b=mT04Bj9ejOv8NL7/F+QYxLt8Lc2gaw1AFyW06rtdv/J9f+Zd/bqWzbubMVJowsqrPkwms1AgPKQUAJLsKbPVuHZCFk1b93Nul0Sg6+tutxZrkDk269M5PUFADqCKoBCRPb9zRnuugXuAaFQCJm8HO4ukIW5EHmjwDbZWeg8+L+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Eb1t96/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Eb1t96/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F96EC4CEDD;
	Tue, 11 Feb 2025 04:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739246709;
	bh=9X/2DXNdRNNMHvacFHjz70X7cq6H73+S5yM/d5nt2Tg=;
	h=Date:To:From:Subject:From;
	b=Eb1t96/eJ80fkOG8J8REXuAFwokh8s2xNSUlY/4Y1eaWbSNAPnnCWD5zcDmdA9O+F
	 SFewUQgUdpqdGbPnPQ5BFbn+lv//AKagGgmkrLuwgSsBDAja+ZIw7RPCLdJ5zM5Aiv
	 dM3iiksumrq2aQx4GY41LOyrdauD5fOR8r55nstY=
Date: Mon, 10 Feb 2025 20:05:08 -0800
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,jiang.kun2@zte.com.cn,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-modify-taskstats-version.patch added to mm-hotfixes-unstable branch
Message-Id: <20250211040509.8F96EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: taskstats: modify taskstats version
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     taskstats-modify-taskstats-version.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/taskstats-modify-taskstats-version.patch

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
Subject: taskstats: modify taskstats version
Date: Sat, 8 Feb 2025 14:49:01 +0800 (CST)

After adding "delay max" and "delay min" to the taskstats structure, the
taskstats version needs to be updated.

Link: https://lkml.kernel.org/r/20250208144901218Q5ptVpqsQkb2MOEmW4Ujn@zte.com.cn
Fixes: f65c64f311ee ("delayacct: add delay min to record delay peak")
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Kun Jiang <jiang.kun2@zte.com.cn>
Reviewed-by: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/taskstats.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/taskstats.h~taskstats-modify-taskstats-version
+++ a/include/uapi/linux/taskstats.h
@@ -34,7 +34,7 @@
  */
 
 
-#define TASKSTATS_VERSION	14
+#define TASKSTATS_VERSION	15
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are

getdelays-fix-error-format-characters.patch
taskstats-modify-taskstats-version.patch

