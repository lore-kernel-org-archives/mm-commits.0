Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F8532B106
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816298; cv=none; b=lgWVX+fLanMms2ZgKfTUnfMZWXWKnyAtbBcOa0bw8gF0YnTm178rtsFjFTBFLw2UwcFlhOi3ek9hIbug4SUb6bEf0iq+3jgkmT9GwaOeUm/pfj3jD8T67L4c3DTMRS3FI750kyDT7O28UulUurtla8MceCQxChSaNB5Dxv5MKkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816298; c=relaxed/simple;
	bh=gqDWqMZqLGiytAuzzQXquLqGJatR26rfxt5+7lCewOA=;
	h=Date:To:From:Subject:Message-Id; b=KQeHJRAtDVMWoGIOFfA0FAwdyorq2LtriOgC8z3fkY3ZMMPxBDCJc7Khomcjymeuq7/DoWW5nyGr8vohMEHhx1xHwRtWIW9ZzCABaKcnx67Ph9lMEXdSZUpN2DtgOVvbdVSsjRSroBgBw1xV0OAHF5RreFgOU9RXY4eInAae6cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cmmnEcST; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cmmnEcST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5541F00A3A;
	Tue,  4 Aug 2026 04:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816296;
	bh=D8weIQJbVkFGOHcUZuKZ//+stATYUDri0aEItTrlYjY=;
	h=Date:To:From:Subject;
	b=cmmnEcSTIqBTOohyAzaS2s8E87JYaAjO6pr0KUk2P98m/02RnpBYkJRRTR0hLwxaF
	 9xr0Kw8QeJf7HOB4f4wV/ItFul1tRHN4lSEeFeRQZyr66cvT/KkeElC6zWv22Dpu0M
	 287IL+xmvGnxIO746JiZ2M+jxj2hQZOiDrDJ8Tnk=
Date: Mon, 03 Aug 2026 21:04:56 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,oleg@redhat.com,elver@google.com,brauner@kernel.org,adrianhuang0701@gmail.com,andrea.calabrese@amarulasolutions.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-refactor-shorten-has_pending_signals.patch removed from -mm tree
Message-Id: <20260804040456.BA5541F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel: refactor: shorten has_pending_signals
has been removed from the -mm tree.  Its filename was
     kernel-refactor-shorten-has_pending_signals.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


