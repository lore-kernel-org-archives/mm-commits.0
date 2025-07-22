Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E27317A30A
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 00:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753145622; cv=none; b=G9CUnrHq+c3bNYug2oBF70wku0UpT7gvC3WfpclUVkVjUk230eGjzb2caZ/GXtXAUv/xY3Y55G6h4GCgQdC7L7JzGMNQm4Fv+M+nIel8CSpedkMTfvR07xPh0xfVZOHPKkoyPyeaWu1Nr4Hv5nyCdLrBs0Mfu3hRImPrm3LR6II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753145622; c=relaxed/simple;
	bh=iGqcYC2Bi0xF5hJfeI/mhmKCqtr1bsfAotxmCaRpL7Q=;
	h=Date:To:From:Subject:Message-Id; b=q77wopgZMTl4yRzNW41uWCQSjq2bb8FqsnAVzJ1yk3qLx1svPRxhgXwW+TDXmYqpsTdiw437gNORbg4FNttlAgR6G730CAKYlsmfIrm7ZtmKDhBvuwLZkwob3CMg3O5PQxPwzvDLtTucACPELmA2MJ5aL77HEfyRqtv8Xo3DIQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d8Dte3hp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d8Dte3hp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69B1C4CEED;
	Tue, 22 Jul 2025 00:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753145621;
	bh=iGqcYC2Bi0xF5hJfeI/mhmKCqtr1bsfAotxmCaRpL7Q=;
	h=Date:To:From:Subject:From;
	b=d8Dte3hphiYnUCBqEn5necv0V+pDfPkTHyq4VWQHMtRVIVY8pu6QI8LbINO3WtVmM
	 367u/cTUCwkbjvaCRlyI37Ab3+OgLW5afbe5kAZsGVqSKNWuNy5hDigqtQspn9eDk7
	 xuwJBBREFaypdF55vV6u61XVmhooi+Ybydv9d3G8=
Date: Mon, 21 Jul 2025 17:53:41 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,krzk@kernel.org,fan.yu9@zte.com.cn,bsingharora@gmail.com,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + =utf-8bw1bbveniigxpbnv4ig5lehrdie1bsu5uqulorvjtoibhzgqgbwfpbnrhaw5lcnmgzm9yigrlbgf5dg9w=.patch added to mm-nonmm-unstable branch
Message-Id: <20250722005341.D69B1C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add maintainers for delaytop
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     =utf-8bw1bbveniigxpbnv4ig5lehrdie1bsu5uqulorvjtoibhzgqgbwfpbnrhaw5lcnmgzm9yigrlbgf5dg9w=.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/=utf-8bw1bbveniigxpbnv4ig5lehrdie1bsu5uqulorvjtoibhzgqgbwfpbnrhaw5lcnmgzm9yigrlbgf5dg9w=.patch

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
From: Wang Yaxin <wang.yaxin@zte.com.cn>
Subject: MAINTAINERS: add maintainers for delaytop
Date: Mon, 21 Jul 2025 09:40:49 +0800 (CST)

The delaytop tool supports showing system delays and task-level delays,
effectively identifying the top-n tasks with high latency in the system,
which is highly beneficial for improving system performance.  Wang Yaxin
and her colleague Fan Yu focus on locating system delay issues.  To
promote the thriving development of delaytop, we hope to serve as
maintainers to continuously improve it, aiming to provide a more effective
solution for system latency issues in the future.

Link: https://lkml.kernel.org/r/20250721094049958ImB8XG_imntcPqpQn1KfG@zte.com.cn
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Fan Yu <fan.yu9@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/MAINTAINERS~=utf-8bw1bbveniigxpbnv4ig5lehrdie1bsu5uqulorvjtoibhzgqgbwfpbnrhaw5lcnmgzm9yigrlbgf5dg9w=
+++ a/MAINTAINERS
@@ -19468,6 +19468,16 @@ S:	Maintained
 F:	include/linux/delayacct.h
 F:	kernel/delayacct.c
 
+TASK DELAY MONITORING TOOLS
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Wang Yaxin <wang.yaxin@zte.com.cn>
+M:	Fan Yu <fan.yu9@zte.com.cn>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	Documentation/accounting/delay-accounting.rst
+F:	tools/accounting/delaytop.c
+F:	tools/accounting/getdelays.c
+
 PERFORMANCE EVENTS SUBSYSTEM
 M:	Peter Zijlstra <peterz@infradead.org>
 M:	Ingo Molnar <mingo@redhat.com>
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are

=utf-8bw1bbveniigxpbnv4ig5lehrdie1bsu5uqulorvjtoibhzgqgbwfpbnrhaw5lcnmgzm9yigrlbgf5dg9w=.patch

