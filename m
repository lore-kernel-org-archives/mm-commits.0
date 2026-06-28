Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869B528690
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 02:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782612974; cv=none; b=Bb62W+itQBmljzFcDDeO1dFEGNFNG2Ha+x2u4SjzGIRs0DEyMS+Y8sUM+sR483W6Nwy0dOqBzE10lGeZdpvNsnUaP6h5PZAeeZyV0J71FB6dmVWuuuNYbqLB4kEOs1cUFuwg60WedC5Xh/GzPo+5AjwqEumaiE/lpfoBrHchLOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782612974; c=relaxed/simple;
	bh=SXzZN9AfodYiKbJH7r6A+16MA6bWqz3kXVH7RQNAAig=;
	h=Date:To:From:Subject:Message-Id; b=RsJQ/QjMUea+zFIVu/c5VOlZ0oWwKRC2Vxz7stX/Af/klyWLLTam0Mh7DYwhgYxDoGScTeSMD9gA9UTsAtu3ACqV42Udh68iWuosp5e3zVl6FPj1QB5FcKCeoWg/k4XRqCGOm0JDOspu5bRkWWPmW/XfXk8neqkvMsmDBSB9kEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RlOYWfAZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RlOYWfAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E321F000E9;
	Sun, 28 Jun 2026 02:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782612973;
	bh=JoTBaBo41kau2hCJkPoXRtV7n+KHpKq8PV+6/7RMraU=;
	h=Date:To:From:Subject;
	b=RlOYWfAZkkQ3u2aKGDhbjR01lV3HVMR1o/ieNkFfMmFs9qs2Ll/zA+CvgE/MqA1x7
	 9eIHLxUvmzsIETljvblYHgIjykHbFgsHbpCKTtcr3LhCvqlNLBsRSfCxCQP1AUZMXo
	 BQFCbnjOI6VdjIq0G9Fao76e75EZbDYYCyJIFeKM=
Date: Sat, 27 Jun 2026 19:16:12 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,pfalcato@suse.de,nphamcs@gmail.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,jannh@google.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,wangxuewen@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-annotate-data-race-in-cpu_needs_drain.patch added to mm-new branch
Message-Id: <20260628021612.F3E321F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: annotate data-race in cpu_needs_drain()
has been added to the -mm mm-new branch.  Its filename is
     mm-annotate-data-race-in-cpu_needs_drain.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-annotate-data-race-in-cpu_needs_drain.patch

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

Link: https://lore.kernel.org/20260626053700.2036899-1-wangxuewen@kylinos.cn
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swap.c~mm-annotate-data-race-in-cpu_needs_drain
+++ a/mm/swap.c
@@ -831,13 +831,13 @@ static bool cpu_needs_drain(unsigned int
 	struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
 
 	/* Check these in order of likelihood that they're not zero */
-	return folio_batch_count(&fbatches->lru_add) ||
+	return data_race(folio_batch_count(&fbatches->lru_add) ||
 		folio_batch_count(&fbatches->lru_move_tail) ||
 		folio_batch_count(&fbatches->lru_deactivate_file) ||
 		folio_batch_count(&fbatches->lru_deactivate) ||
 		folio_batch_count(&fbatches->lru_lazyfree) ||
 		folio_batch_count(&fbatches->lru_activate) ||
-		need_mlock_drain(cpu) ||
+		need_mlock_drain(cpu)) ||
 		has_bh_in_lru(cpu, NULL);
 }
 
_

Patches currently in -mm which might be from wangxuewen@kylinos.cn are

mm-annotate-data-race-in-cpu_needs_drain.patch

