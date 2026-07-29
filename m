Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BBD3932C2
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298486; cv=none; b=VqxTXqSo0rKqW9YFNh5pSDKr7j0ZZao33NPSROLwtFwog3JTQygq3o0mHwKehXKOX7FuDXXw9CTfWo5QEDaqtaYVHL+WcmZpQ7dzenwTlQKEjrV1VFRNymUOpX1kjgNgIa/EMRYOJuQKnqCl3ENxmJW72isxZb+M8gTggFpmTNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298486; c=relaxed/simple;
	bh=vVgAQJkTqG1Pn9fLRbdvcBXkDQGvJfG7caLPuHsi/Gw=;
	h=Date:To:From:Subject:Message-Id; b=Pt+4J1k+tqXrtOmXohLbJDTTg6tMbCGKhPDdhFt8Odm2l4m9SOQ0mZBJR6Z4YsFLGC3jknsl8pfV8Hbr2E3ndRFDx805yN30mfkTr0F8ztm8PDNfmOQLbQyxjJZqiLrKWbDxYPUQ9E0KiPFgypJcJSg1NULHMJSD+8yloGycFdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JuhNHYVC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JuhNHYVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5047F1F000E9;
	Wed, 29 Jul 2026 04:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298485;
	bh=3wduisD3k4kZRTCUK/3m89T4Ay4XNN1QqOWEknVljTQ=;
	h=Date:To:From:Subject;
	b=JuhNHYVCRH+bAYUUeEFq0yR2Az47ohJuzcGV73XvwtY04cnP/35Yx0Ps5aj2ChnLY
	 57W1f0/dKz/9BdPPzZPP/6RHczHSuJVjWTCB29M0mD23Bpshs3g0iHtrx14Htd++oZ
	 A4PIpfIXsLYL6sF14obT4g/vbX+TZfTNReCavVYQ=
Date: Tue, 28 Jul 2026 21:14:44 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,pfalcato@suse.de,nphamcs@gmail.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,jannh@google.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,wangxuewen@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-annotate-data-race-in-cpu_needs_drain.patch removed from -mm tree
Message-Id: <20260729041445.5047F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: annotate data-race in cpu_needs_drain()
has been removed from the -mm tree.  Its filename was
     mm-annotate-data-race-in-cpu_needs_drain.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xuewen Wang <wangxuewen@kylinos.cn>
Subject: mm: annotate data-race in cpu_needs_drain()
Date: Fri, 26 Jun 2026 13:37:00 +0800

KCSAN reports a data-race when cpu_needs_drain() reads another CPU's
per-cpu folio_batch->nr without locking, while the owning CPU writes to it
via folio_batch_add().

Reading a slightly stale value is harmless -- cpu_needs_drain() only
decides whether to schedule a drain, and the next iteration of
__lru_add_drain_all() will re-check.  Use data_race() to annotate the
intentional race.

[akpm@linux-foundation.org: reindent cpu_needs_drain, per David & Lorenzo]
Link: https://lore.kernel.org/20260626053700.2036899-1-wangxuewen@kylinos.cn
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/swap.c~mm-annotate-data-race-in-cpu_needs_drain
+++ a/mm/swap.c
@@ -831,13 +831,13 @@ static bool cpu_needs_drain(unsigned int
 	struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
 
 	/* Check these in order of likelihood that they're not zero */
-	return folio_batch_count(&fbatches->lru_add) ||
-		folio_batch_count(&fbatches->lru_move_tail) ||
-		folio_batch_count(&fbatches->lru_deactivate_file) ||
-		folio_batch_count(&fbatches->lru_deactivate) ||
-		folio_batch_count(&fbatches->lru_lazyfree) ||
-		folio_batch_count(&fbatches->lru_activate) ||
-		need_mlock_drain(cpu) ||
+	return data_race(folio_batch_count(&fbatches->lru_add) ||
+			 folio_batch_count(&fbatches->lru_move_tail) ||
+			 folio_batch_count(&fbatches->lru_deactivate_file) ||
+			 folio_batch_count(&fbatches->lru_deactivate) ||
+			 folio_batch_count(&fbatches->lru_lazyfree) ||
+			 folio_batch_count(&fbatches->lru_activate) ||
+			 need_mlock_drain(cpu)) ||
 		has_bh_in_lru(cpu, NULL);
 }
 
_

Patches currently in -mm which might be from wangxuewen@kylinos.cn are

mm-damon-remove-trailing-semicolons-after-function-definitions.patch

