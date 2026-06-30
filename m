Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCC838C407
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 04:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782792873; cv=none; b=NV6S+xOO2rbsMeL2h5oVv7IL3MFPyatYW8Tpxhr+On9KWxKgK1QFqkhA6tYo09WzdBP8vRff6eiGE7YnbuTU1Kn+f6NjYlUDtAximroXAGKE0jLb2UMNO1Nh/GjGu4pE6MJU1xYnGM4jR73747P8urZFtmca2clDujyHFyvQWXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782792873; c=relaxed/simple;
	bh=mPSQJ0cpgFrZHjKI9wAF2Q7eDojVn0wqapkm61Ps1/c=;
	h=Date:To:From:Subject:Message-Id; b=iK4BJ2xq714FwPeQugR9pxIU8S58Lw7nzkTC6GD0BrWVJNRsiAe5KtwCdFnWuKpppgin6lG82MGBgaGIWhoLzQO7fUjlEmhrjyuMq5iecjAJpiHjagVUi/YDnMDZdMVhycGywxmefIA8JLB+QCJW9zqfqvxN1bwsQf8hKI8vTHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HX7yR3Ee; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HX7yR3Ee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4921F000E9;
	Tue, 30 Jun 2026 04:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782792872;
	bh=d9xpYYC4/EplMDqSfT6b4phRHm6icGc5BzhTBgFMWPQ=;
	h=Date:To:From:Subject;
	b=HX7yR3EeAhF5jbIi8V26Frt+OEEW6lR/d24WDgYRhTMQjPgiDS9JxVenP5WSUvhML
	 PVpDxyXMdTdMcKp/rclEtKj4IM1tzMsvEd7nC6SKYDIxkXQYHJh+Vk7NrUl8fZSf+X
	 /TSIoDgVqAMe74+L6cdKmttGkanfSHE61OHfBrOM=
Date: Mon, 29 Jun 2026 21:14:31 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,oleg@redhat.com,elver@google.com,brauner@kernel.org,adrianhuang0701@gmail.com,andrea.calabrese@amarulasolutions.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-refactor-shorten-has_pending_signals.patch added to mm-nonmm-unstable branch
Message-Id: <20260630041431.EE4921F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel: refactor: shorten has_pending_signals
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-refactor-shorten-has_pending_signals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-refactor-shorten-has_pending_signals.patch

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
From: Andrea Calabrese <andrea.calabrese@amarulasolutions.com>
Subject: kernel: refactor: shorten has_pending_signals
Date: Wed, 20 May 2026 08:28:50 +0200

In has_pending_signals there was a switch/case used for optimizations. 
However, today's compilers perform loop unrolling efficiently, thus it is
not needed anymore.

Put i inside the for declaration so we do not risk its escape from the
scope.  Moreover, i starts now from 0 and counts up, as it is a more usual
pattern.

Link: https://lore.kernel.org/20260520062849.183621-2-andrea.calabrese@amarulasolutions.com
Signed-off-by: Andrea Calabrese <andrea.calabrese@amarulasolutions.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Adrian Huang <adrianhuang0701@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

--- a/kernel/signal.c~kernel-refactor-shorten-has_pending_signals
+++ a/kernel/signal.c
@@ -130,28 +130,10 @@ static bool sig_ignored(struct task_stru
  */
 static inline bool has_pending_signals(sigset_t *signal, sigset_t *blocked)
 {
-	unsigned long ready;
-	long i;
-
-	switch (_NSIG_WORDS) {
-	default:
-		for (i = _NSIG_WORDS, ready = 0; --i >= 0 ;)
-			ready |= signal->sig[i] &~ blocked->sig[i];
-		break;
-
-	case 4: ready  = signal->sig[3] &~ blocked->sig[3];
-		ready |= signal->sig[2] &~ blocked->sig[2];
-		ready |= signal->sig[1] &~ blocked->sig[1];
-		ready |= signal->sig[0] &~ blocked->sig[0];
-		break;
-
-	case 2: ready  = signal->sig[1] &~ blocked->sig[1];
-		ready |= signal->sig[0] &~ blocked->sig[0];
-		break;
-
-	case 1: ready  = signal->sig[0] &~ blocked->sig[0];
-	}
-	return ready !=	0;
+	unsigned long ready = 0;
+	for (long i = 0; i < _NSIG_WORDS; i++)
+		ready |= signal->sig[i] & ~blocked->sig[i];
+	return ready != 0;
 }
 
 #define PENDING(p,b) has_pending_signals(&(p)->signal, (b))
_

Patches currently in -mm which might be from andrea.calabrese@amarulasolutions.com are

kernel-refactor-shorten-has_pending_signals.patch

