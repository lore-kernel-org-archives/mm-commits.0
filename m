Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504471C32
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 00:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753145629; cv=none; b=YT1CBxzhtVgsJoDvIOO9X+FDxKtC+PS03TSt+JR8ln7Rb71gFBNTf5hQtpyOfXMYNrVgQCHd3Tezf9OU3CvAIJPdZcrOdx3D9DBplNFbO+QiqaACAYF53tkxMb0FPC5n/3UJE0CIflTjkEp1T2W3tGoLCyiWcjpiiSXfI5VllRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753145629; c=relaxed/simple;
	bh=xrMEor6W0AsELlS1zWfrJCBKWiRDbsWK2fZFuJBgZPI=;
	h=Date:To:From:Subject:Message-Id; b=FjcEqPc4Mfm3GEdYRZ4aC0/zS5v9vbqDIf9eJDl32bRhec5KLhLXniVB8kUjMzS41Ppa4yBkcV5oHwffcFFwMG82AhfA4nM2I5epsYR4pctaS3jii/Ll1b9EFgGkpK2xZ8qI6KdOdBP3jjlNWr1thxeBk5ieMqFvk7ZZ2kD06CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kD+S1ypb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kD+S1ypb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCABEC4CEED;
	Tue, 22 Jul 2025 00:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753145628;
	bh=xrMEor6W0AsELlS1zWfrJCBKWiRDbsWK2fZFuJBgZPI=;
	h=Date:To:From:Subject:From;
	b=kD+S1ypb25Gq11vhttycaFkjI3hF2rEigLHxK1o0y8MPR6w3fHnCXscLEAXRevAge
	 rFpCsT/TjHQQxwjNdnrR54FX9LewLI2oonJw3acIjhbntuZgrFwppVcGKmNKPbg5QG
	 mLPEcG6+62XBaiwyxagTda/bzcB8+kb96En+iOqI=
Date: Mon, 21 Jul 2025 17:53:48 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,krzk@kernel.org,fan.yu9@zte.com.cn,bsingharora@gmail.com,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-maintainers-for-delaytop.patch added to mm-nonmm-unstable branch
Message-Id: <20250722005348.BCABEC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add maintainers for delaytop
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-add-maintainers-for-delaytop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-maintainers-for-delaytop.patch

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

--- a/MAINTAINERS~maintainers-add-maintainers-for-delaytop
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

maintainers-add-maintainers-for-delaytop.patch

