Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4458E8634E
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189237; cv=none; b=as0mxxTaIRt0/g+EYYlxJiaM7ruS8w6m813xDZD5NXSvqQeaOJk+GYjshaW/qYn75qSphG62WYm0Xr7iPGJsO2ixbsP8yyXQ0GXxSyFITcQcUmHEt7UOZCdl/rtUOhhUB9HInp/ZWYYL3Tw3Dafu9IEROKDNdcnjoAcZdsegDzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189237; c=relaxed/simple;
	bh=OKyE7myaQjN8pF57xKfJhz0MVTKyV+gJIy5y4ohK3XA=;
	h=Date:To:From:Subject:Message-Id; b=RxqmHRSjRGC1X/QiQPVBw4QPh184ylRtRnLgN0s1PU4RO4JVvD/bF0/2Pyl1vHiwdOr8G6Gdetw/5WYjbujm5WAyLj89KUkdVCbY/2UHM9cAZna6tVtzcCLydu3cYETEg1HJGAguvCWo4qRGlPZM/5cTa+d0QX8TQ5o9Y5VFQ7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o8qkK+Xo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o8qkK+Xo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F171C4CEEC;
	Mon, 17 Mar 2025 05:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189237;
	bh=OKyE7myaQjN8pF57xKfJhz0MVTKyV+gJIy5y4ohK3XA=;
	h=Date:To:From:Subject:From;
	b=o8qkK+XoZ7Y8AaoJK1pEcOZp+n5RbKlS+MtRxEag0mViDBe+WQqO8TW5q4SwS4pbo
	 1ufN8UQnUxXSCNTQPfaWCMKJdPezwG8vtCQC4EzbTQCfoo5IA1fzofcYP0fVp2jt7l
	 xFUc/2MIH2cQ6Nvym30FckmfL3LBu78lVCI8c9yE=
Date: Sun, 16 Mar 2025 22:27:16 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,mjguzik@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch removed from -mm tree
Message-Id: <20250317052717.0F171C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix
has been removed from the -mm tree.  Its filename was
     signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch

This patch was dropped because it was folded into signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix
Date: Mon Mar  3 02:22:48 PM PST 2025

add unlikely() as well

Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/signal.c~signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix
+++ a/kernel/signal.c
@@ -177,7 +177,7 @@ static bool recalc_sigpending_tsk(struct
 void recalc_sigpending(void)
 {
 	if (!recalc_sigpending_tsk(current) && !freezing(current)) {
-		if (test_thread_flag(TIF_SIGPENDING))
+		if (unlikely(test_thread_flag(TIF_SIGPENDING)))
 			clear_thread_flag(TIF_SIGPENDING);
 	}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset.patch
hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix.patch

