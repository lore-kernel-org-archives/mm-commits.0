Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0259D3659EB
	for <mm-commits@vger.kernel.org>; Mon, 10 Aug 2026 22:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786402163; cv=none; b=QB3Qb0Q1wZde/qPCNaYU+5j1sk5BSy32tX2qPg9BeUFisknZSrxQ0ozJCTcXfP16C3FmWthimGi2Crcx27wQcDGi51fFJOa2S9QLgLuYE5evkINoAmHmxRzp7xT4Qf5F+IaViJDvoXbRo73jERbHoUv90O+6NFyqNMl4MtWFVO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786402163; c=relaxed/simple;
	bh=ldQTvqINBmr3C0ylQuCZbQmfY5/4GINmsKMNDZQCALU=;
	h=Date:To:From:Subject:Message-Id; b=EGZdwoVn3tKPVkAWi2ZXJJr4qDFfrKoYlqKhOLbyaaO9Pc8hXh6sQaLUui7FBMRt+O4JF2FlTkmlyRgxnVW15gvAX3cYBTn5ZpXrUwcM7f9HKfxEWKfTXganBtHoWeUzCGTctGp0DeDzA73LFc56HOt2G8jH8c8zXaAUOri3UZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EvyWsyTV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EvyWsyTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F0E1F000E9;
	Mon, 10 Aug 2026 22:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786402161;
	bh=m9fEeEU2xWeX8jozTacgDNcs2FZzPtg5GZpjXrWH5uA=;
	h=Date:To:From:Subject;
	b=EvyWsyTVKx5lJn68dUbYWGk6LGFVHirkYuqHVjc5hxCwFv7sJQwKpWrC8bGC/6Frv
	 jfnmUBRFm3NehA8yAMvYIQ9a5iDikfD8ARohpwV5VcOC1bfS4Jh6+rTk/34F8zUJPU
	 sVGK4Rqm5ctJyCFLWAQq58fJMMvQcDIp37vgbvH4=
Date: Mon, 10 Aug 2026 15:49:21 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,akpm@linux-foundation.org,sh_def@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-avoid-unnecessary-quarantine-lock-cycling.patch added to mm-new branch
Message-Id: <20260810224921.B3F0E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: avoid unnecessary quarantine lock cycling
has been added to the -mm mm-new branch.  Its filename is
     kasan-avoid-unnecessary-quarantine-lock-cycling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-avoid-unnecessary-quarantine-lock-cycling.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Hui Su <sh_def@163.com>
Subject: kasan: avoid unnecessary quarantine lock cycling
Date: Sun, 9 Aug 2026 03:12:31 +0800

kasan_quarantine_remove_cache() drops quarantine_lock and restores
interrupts after scanning each non-empty quarantine batch so that
cond_resched() can schedule during a long scan.

When no reschedule is pending, the unlock/IRQ restore and subsequent IRQ
save/relock cycle is unnecessary.

Check need_resched() before cycling quarantine_lock to avoid this overhead
when rescheduling is not needed.

Link: https://lore.kernel.org/20260808191230.3345930-2-sh_def@163.com
Signed-off-by: Hui Su <sh_def@163.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/kasan/quarantine.c~kasan-avoid-unnecessary-quarantine-lock-cycling
+++ a/mm/kasan/quarantine.c
@@ -373,10 +373,12 @@ void kasan_quarantine_remove_cache(struc
 		if (qlist_empty(&global_quarantine[i]))
 			continue;
 		qlist_move_cache(&global_quarantine[i], &to_free, cache);
-		/* Scanning whole quarantine can take a while. */
-		raw_spin_unlock_irqrestore(&quarantine_lock, flags);
-		cond_resched();
-		raw_spin_lock_irqsave(&quarantine_lock, flags);
+		if (need_resched()) {
+			/* Scanning whole quarantine can take a while. */
+			raw_spin_unlock_irqrestore(&quarantine_lock, flags);
+			cond_resched();
+			raw_spin_lock_irqsave(&quarantine_lock, flags);
+		}
 	}
 	raw_spin_unlock_irqrestore(&quarantine_lock, flags);
 
_

Patches currently in -mm which might be from sh_def@163.com are

kasan-fix-cache-shrink-race-with-cpu-hotplug.patch
kasan-avoid-unnecessary-quarantine-lock-cycling.patch

