Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793597400;
	b=pRlGwc6VeG41hP1quR1e4OkJLnTesS5ObBIq0anHcoCiDQ6Gymg/GilQzdSG1i+LLXbM
	 ceIZJVNWXapHcywx1KZG/bM1tPVyOfGLHUeOyui6aGQNbJ2Dk5gOieSziyiUBu5/nMPpA
	 18rKTNtsSbSjFcUHq1Np46e5Icim4RbEJMLwVHYWHuubaayVjdwd33Ndq3PnDQROYI13I
	 gixyYv8reWXs1FTMR+zud16xd+ho2+H1TUGPhezSWqcLAXUfGKN57jlCyQgyJGNYwM1pj
	 d6LRcKnB0Mml8J0zzPrypJK4qKxf3fdAcGAgkEFHkhFERkoFMB6y7thiElkOkXY3N3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793597400;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=wEAqmDddHxdK7UYEmVNP2yyq0r1MkAxmwFiCsB9nPuM=;
	b=W6y6XE2ZTh5JSGfSgbawCsxVYGgfGtTvY5JYdjGlOYueE3KNIlcKuxZbYOZm86YDPrPE
	 0kY15l7xJCsohNCpQyTpOme+Dn6BdCejnjOYxKrldNEJdZsuYiv+ycRV7xK/LTg1RSQQQ
	 +derR+PE4BorikGqO+97ZsscOgdtxiq1kMOmGOtLmSp84EossYzLdmKsNK73Yf9X8Xv5B
	 h13esJfSiih8jOgtW7+vvXKAGrbN6xyvudPCFjs+3x6j+M61kHMCZQtUfxe4BC1JS0g49
	 d+yk2HLVIhhfKMK1MjfIV2IEPaqtWlPtJQXlECS3ElSC5mNxnz0ykgCMIZp34gLp3ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="P3Ma2ik/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB48606A324
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 05:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=P3Ma2ik/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177631F00A02;
	Mon,  2 Nov 2026 05:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793597399;
	bh=wEAqmDddHxdK7UYEmVNP2yyq0r1MkAxmwFiCsB9nPuM=;
	h=Date:To:From:Subject;
	b=P3Ma2ik/vnVe1IXVHIapsNximiJ5is35SNMRaGHIJy06JXsJ6zsDMHxIurbXmRl9/
	 jbFcLLcOEbaC9noCZiFFGKksBLYPvzzJ2KmUKyHZfjUXYt4p4tcKVrfle1PFjipGQS
	 vmyQoqkuyzpGhReviO5nr1hpgyY7H5djedOUzHfw=
Date: Sun, 01 Nov 2026 21:29:58 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,linux@rasmusvillemoes.dk,
	arjan@linux.intel.com,teczm@foxmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + async-use-ktime_us_delta-for-debug-timings.patch added to mm-nonmm-unstable branch
Message-Id: <20261102052959.177631F00A02@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: async: Use ktime_us_delta() for debug timings
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     async-use-ktime_us_delta-for-debug-timings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/async-use-ktime_us_delta-for-debug-timings.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: zhoumin <teczm@foxmail.com>
Subject: async: Use ktime_us_delta() for debug timings
Date: Tue, 27 Oct 2026 20:01:12 +0800

Replace microseconds_since() with ktime_us_delta() for accurate
microsecond timings.

Link: https://lore.kernel.org/tencent_58D610F93574D60C9AE734253AF69A528506@qq.com
Fixes: 22a9d645677f ("async: Asynchronous function calls to speed up kernel boot")
Signed-off-by: zhoumin <teczm@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---

 kernel/async.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/kernel/async.c~async-use-ktime_us_delta-for-debug-timings
+++ a/kernel/async.c
@@ -80,12 +80,6 @@ static DECLARE_WAIT_QUEUE_HEAD(async_don
 
 static atomic_t entry_count;
 
-static long long microseconds_since(ktime_t start)
-{
-	ktime_t now = ktime_get();
-	return ktime_to_ns(ktime_sub(now, start)) >> 10;
-}
-
 static async_cookie_t lowest_in_progress(struct async_domain *domain)
 {
 	struct async_entry *first = NULL;
@@ -130,7 +124,7 @@ static void async_run_entry_fn(struct wo
 
 	pr_debug("initcall %lli_%pS returned after %lld usecs\n",
 		 (long long)entry->cookie, entry->func,
-		 microseconds_since(calltime));
+		 ktime_us_delta(ktime_get(), calltime));
 
 	/* 2) remove self from the pending queues */
 	spin_lock_irqsave(&async_lock, flags);
@@ -317,7 +311,7 @@ void async_synchronize_cookie_domain(asy
 	wait_event(async_done, lowest_in_progress(domain) >= cookie);
 
 	pr_debug("async_continuing @ %i after %lli usec\n", task_pid_nr(current),
-		 microseconds_since(starttime));
+		 ktime_us_delta(ktime_get(), starttime));
 }
 EXPORT_SYMBOL_GPL(async_synchronize_cookie_domain);
 
_

Patches currently in -mm which might be from teczm@foxmail.com are

async-use-ktime_us_delta-for-debug-timings.patch

