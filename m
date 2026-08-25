Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5E8372B3D
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622927; cv=none; b=b+sr720RHUtU4yJDpT+Izn7lw0lFkMwB/d/3Uuk1BHkfh3in6HykHIQMQGXur+0KvUZXadGteiBs/3VIDu5Rd0D+LY/gIMRinSt0A0K2/urlsIIEftR3j+ZT9VCG0+3fimXdrvgtfJwzELwfCJuGZQtCovqiqe5ctWwOMLvzZkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622927; c=relaxed/simple;
	bh=pZoXIOXv/A7sXLX9adGYbhzNzEfUAILAdA6snuoQ06U=;
	h=Date:To:From:Subject:Message-Id; b=FNr9ks59t1D6nmJW9KhPatxF926wMg645oU5bXku2h85IqUKZMGWKx5ROYHN9X6n28wA0S+RS8BxWulqkCw4GQEAAUetTxidQcrHJiEETFEYc9cEzqrM5nPy8lkDVyYYwWnPFU+DiPR9edHQikA6QOWcRwDmay2k1Fly0VD9jJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t+0Qicbb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t+0Qicbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11421F00A3D;
	Tue, 25 Aug 2026 01:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622920;
	bh=TmdxQuZZ0zGnawJjJipt8fP0Z/QRGdPPof3o4kNDsmg=;
	h=Date:To:From:Subject;
	b=t+0QicbbAgjt2ZNeadFC9Kd65xis6eo0UN/RF2ROwYeKC1AC0OFbACuoSde5eERQf
	 8wTvPZZnGHogWUbLgFDzAjIpPxIXwM5NjCXN1bfCIHmwCtJ8tLADqydR4/4FQfUVaA
	 jqc2vGAcXmyHuvoUF4FiXv3OmmgDqq7AjDFOAJl0=
Date: Mon, 24 Aug 2026 18:55:19 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,sashiko-bot@kernel.org,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,sh_def@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-fix-quarantine_size-accounting-during-cache-removal.patch removed from -mm tree
Message-Id: <20260825015519.F11421F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: fix quarantine_size accounting during cache removal
has been removed from the -mm tree.  Its filename was
     kasan-fix-quarantine_size-accounting-during-cache-removal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-migrate_device-avoid-out-of-bounds-writes-for-compound-folios.patch

