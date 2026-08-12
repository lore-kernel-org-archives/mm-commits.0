Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8717336923B
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 01:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786498159; cv=none; b=eIXTEw0/gH7e/bYgpHHzA5h+pEBUNqQrk9dSijA09i4jbnZCIbjTl2h06NQcY454iMTe7zQUgx1HmZGDyR9nxKK/rQzSR+DtGyWrDD7QBjKbP0FTNwwXnobIrCeEQnovG0YLJY7B6kwcrQE1AaJ4PlsHG7aydlzfiTTak5Rm4Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786498159; c=relaxed/simple;
	bh=wpDVffH+9mMwwnE0ji4H0k3wm104uKh9yD3HbpWqzKc=;
	h=Date:To:From:Subject:Message-Id; b=DuUDte2EifylMewGBbqvhN4ay+MhYljqqwcgVbo0K18MhQyeAheR4Uxtd0AUJ4+CrjEf00VTuh8FsN9WWVQ9XS9OSE1PABmJ3pF1iDuDVBYJkrqVi5y46kyaurHczjCdXhwfRRc6lGBBkIr6Oe0mlzMo6KA02dZmkzNoez2jpzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bz8a6E7f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bz8a6E7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A01D1F000E9;
	Wed, 12 Aug 2026 01:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786498158;
	bh=qzR0xf/7wumikAY5KLxQsCM39zf+ZawK9lxCSty2giQ=;
	h=Date:To:From:Subject;
	b=bz8a6E7fSl2pEGLXqyG9/sOfLkniQ7G0EoYn1HsAHF62x3P3Z2sqrdER610Qz4js+
	 l0DeRccoJsRVqPoz31VUksfSEnn1VcEhJoaVvDsYtF+K8Q1xRJuh+FhCXpx/ngXMa6
	 BBRaLGsp0XiwCH4jvrc0AeyE0Gh5vVOqZP+8RhHo=
Date: Tue, 11 Aug 2026 18:29:17 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,sashiko-bot@kernel.org,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,sh_def@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-quarantine_size-accounting-during-cache-removal.patch added to mm-new branch
Message-Id: <20260812012918.1A01D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: fix quarantine_size accounting during cache removal
has been added to the -mm mm-new branch.  Its filename is
     kasan-fix-quarantine_size-accounting-during-cache-removal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-fix-quarantine_size-accounting-during-cache-removal.patch

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
Subject: kasan: fix quarantine_size accounting during cache removal
Date: Tue, 11 Aug 2026 15:33:32 +0800

quarantine_size tracks the total number of bytes stored in
global_quarantine[].  It is incremented when per-CPU quarantine objects
are moved into the global quarantine and decremented when a global batch
is evicted by kasan_quarantine_reduce().

kasan_quarantine_remove_cache() also removes objects from the global
quarantine.  qlist_move_cache() rebuilds the source batch and updates its
.bytes field, but quarantine_size is not adjusted accordingly.

As a result, quarantine_size remains over-counted by the size of the
removed objects.  The stale accounting accumulates across cache removals. 
Once the inflated value exceeds quarantine_max_size,
kasan_quarantine_reduce() can evict a batch even though the actual number
of bytes in global_quarantine[] is still below quarantine_max_size,
shortening the quarantine window.

Fix the accounting by recording each batch's size before
qlist_move_cache() and subtracting the number of bytes actually removed
from quarantine_size while holding quarantine_lock.

A KUnit reproducer used during testing observed the over-count grow by
4698864 bytes after one kasan_quarantine_remove_cache() call with the fix
reverted.  With this change applied, the over-count did not grow.

Link: https://lore.kernel.org/20260811073332.1351893-1-sh_def@163.com
Fixes: 64abdcb24351 ("kasan: eliminate long stalls during quarantine reduction")
Signed-off-by: Hui Su <sh_def@163.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260808031459.3032812-1-sh_def%40163.com
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/kasan/quarantine.c~kasan-fix-quarantine_size-accounting-during-cache-removal
+++ a/mm/kasan/quarantine.c
@@ -370,9 +370,14 @@ void kasan_quarantine_remove_cache(struc
 
 	raw_spin_lock_irqsave(&quarantine_lock, flags);
 	for (i = 0; i < QUARANTINE_BATCHES; i++) {
+		size_t old_bytes;
+
 		if (qlist_empty(&global_quarantine[i]))
 			continue;
+		old_bytes = global_quarantine[i].bytes;
 		qlist_move_cache(&global_quarantine[i], &to_free, cache);
+		WRITE_ONCE(quarantine_size, quarantine_size -
+			   (old_bytes - global_quarantine[i].bytes));
 		/* Scanning whole quarantine can take a while. */
 		raw_spin_unlock_irqrestore(&quarantine_lock, flags);
 		cond_resched();
_

Patches currently in -mm which might be from sh_def@163.com are

kasan-fix-cache-shrink-race-with-cpu-hotplug.patch
kasan-fix-quarantine_size-accounting-during-cache-removal.patch

