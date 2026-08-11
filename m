Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6E72EB5A6
	for <mm-commits@vger.kernel.org>; Tue, 11 Aug 2026 21:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786485015; cv=none; b=oyzsMN2dbGG0SVL+XSXe0VRA2f0QC1r1BLiz7DWe7swpUsI/abQ736Q3jGPe3hyxFqqDMA9BXWX8jIMPSK0rnYjCFskQ7J2bGTtxuP8nIEK1y4JN0/INGzs0XcRpdcSUmS7RTeaHxojfjCQvIJqIm8WiBxDHpiXDrh52iOMPqYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786485015; c=relaxed/simple;
	bh=XGPqMRUCoKMfLdNCGjRLKFZxG4v5Tai9T/VkyPtpReo=;
	h=Date:To:From:Subject:Message-Id; b=cIVPYPQ3a8Hd+b3/nfZ5RZq2sk4pITG+jLL+2IlK2qbDL6gfmyQ5t20HM8eunmLiUf/2nvzlYtDs6YWbXUVJ2/SY5vMEWp1WkN4PPfugDiC3K8UPzPCg2r6ON0DtG0U/23m+5b2MR4cY8Xw6Faq1Bag/o2ntmqx2oQr3IaQWTBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W8dL1sVB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W8dL1sVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B551F000E9;
	Tue, 11 Aug 2026 21:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786485013;
	bh=4A23g99jc0wO+mSKa3yFlf0eGYOgMoqOk2fWNZCxMQQ=;
	h=Date:To:From:Subject;
	b=W8dL1sVBDMai3iDs9HHT+uHjBkURHDcwbdTHSslxEGyDHD5cetY0RADNrrNrkvzyR
	 bnfS0AWZVi7Uc9fBvZTn0a2eKF9IN72DggTEimlUAosOcxL1T4UcXzAWq+RzqaLIxu
	 9PR4bAyCLGs8+uEI2Pof2h43D6jr5p+ON1zFICqw=
Date: Tue, 11 Aug 2026 14:50:13 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,akpm@linux-foundation.org,sh_def@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] kasan-avoid-unnecessary-quarantine-lock-cycling.patch removed from -mm tree
Message-Id: <20260811215013.C7B551F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: avoid unnecessary quarantine lock cycling
has been removed from the -mm tree.  Its filename was
     kasan-avoid-unnecessary-quarantine-lock-cycling.patch

This patch was dropped because it was nacked

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

