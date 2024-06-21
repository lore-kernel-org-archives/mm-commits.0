Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4935516630B;
	Fri, 21 Jun 2024 17:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718989960; cv=none; b=BLebLxnFZDPeYNkbyrpDy15EyYVj1anxjjs6RsM/PkB5cTt+Ud3palpnPCLbLnOjB5lxcNVRTCZ+PJV+LULO6x24JDJ/h8EcVUJfALWvWrZnBkWCtYSYyLLOpUYRNCBffaot4drV709Lt7viUOcnx512XI293pOlCkJK/yKUMQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718989960; c=relaxed/simple;
	bh=30cTgoRowG8PLheLB99SN9nk0CO3G+hEj/VcPgOPTLU=;
	h=Date:To:From:Subject:Message-Id; b=Tv24wQjhcu4iQwXfwtXJqcOApQslj+kgwQ5F+BRioCEEuQmQ7rOuE+bcQxFSxg5gs7JymYhJ51dXTy34TbgJ5KY8Osa1WYGGKiHhgBfBKNwEpaMwHTNU04esThE/322EWmLKA3/kbgi+8A7jKPbfJUtuIneOf89njmyqVLFM+54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C0Rdqcdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C0Rdqcdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1722DC2BBFC;
	Fri, 21 Jun 2024 17:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718989960;
	bh=30cTgoRowG8PLheLB99SN9nk0CO3G+hEj/VcPgOPTLU=;
	h=Date:To:From:Subject:From;
	b=C0RdqcdxBolvII2kYmI29krBjhBrGexkOgBLAs6XQdtQnLV7MO7hpQyS5btwcuUNX
	 r/N94Q3+aEWOk8K/SwpYXTdeVz8ZaJ0fU0zyVH5mlXytnsEP9o2wf+0lrc5t1ESaRj
	 jdrmFg5flQ/WJCINTo0/XZvkaRyftZnG6ANn3FEg=
Date: Fri, 21 Jun 2024 10:12:39 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,stable@vger.kernel.org,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-avoid-overflows-in-dirty-throttling-logic.patch added to mm-unstable branch
Message-Id: <20240621171240.1722DC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: avoid overflows in dirty throttling logic
has been added to the -mm mm-unstable branch.  Its filename is
     mm-avoid-overflows-in-dirty-throttling-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-avoid-overflows-in-dirty-throttling-logic.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: avoid overflows in dirty throttling logic
Date: Fri, 21 Jun 2024 16:42:38 +0200

The dirty throttling logic is interspersed with assumptions that dirty
limits in PAGE_SIZE units fit into 32-bit (so that various multiplications
fit into 64-bits).  If limits end up being larger, we will hit overflows,
possible divisions by 0 etc.  Fix these problems by never allowing so
large dirty limits as they have dubious practical value anyway.  For
dirty_bytes / dirty_background_bytes interfaces we can just refuse to set
so large limits.  For dirty_ratio / dirty_background_ratio it isn't so
simple as the dirty limit is computed from the amount of available memory
which can change due to memory hotplug etc.  So when converting dirty
limits from ratios to numbers of pages, we just don't allow the result to
exceed UINT_MAX.

Link: https://lkml.kernel.org/r/20240621144246.11148-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Zach O'Keefe <zokeefe@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

--- a/mm/page-writeback.c~mm-avoid-overflows-in-dirty-throttling-logic
+++ a/mm/page-writeback.c
@@ -417,13 +417,20 @@ static void domain_dirty_limits(struct d
 	else
 		bg_thresh = (bg_ratio * available_memory) / PAGE_SIZE;
 
-	if (bg_thresh >= thresh)
-		bg_thresh = thresh / 2;
 	tsk = current;
 	if (rt_task(tsk)) {
 		bg_thresh += bg_thresh / 4 + global_wb_domain.dirty_limit / 32;
 		thresh += thresh / 4 + global_wb_domain.dirty_limit / 32;
 	}
+	/*
+	 * Dirty throttling logic assumes the limits in page units fit into
+	 * 32-bits. This gives 16TB dirty limits max which is hopefully enough.
+	 */
+	if (thresh > UINT_MAX)
+		thresh = UINT_MAX;
+	/* This makes sure bg_thresh is within 32-bits as well */
+	if (bg_thresh >= thresh)
+		bg_thresh = thresh / 2;
 	dtc->thresh = thresh;
 	dtc->bg_thresh = bg_thresh;
 
@@ -473,7 +480,11 @@ static unsigned long node_dirty_limit(st
 	if (rt_task(tsk))
 		dirty += dirty / 4;
 
-	return dirty;
+	/*
+	 * Dirty throttling logic assumes the limits in page units fit into
+	 * 32-bits. This gives 16TB dirty limits max which is hopefully enough.
+	 */
+	return min_t(unsigned long, dirty, UINT_MAX);
 }
 
 /**
@@ -510,10 +521,17 @@ static int dirty_background_bytes_handle
 		void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret;
+	unsigned long old_bytes = dirty_background_bytes;
 
 	ret = proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
-	if (ret == 0 && write)
+	if (ret == 0 && write) {
+		if (DIV_ROUND_UP(dirty_background_bytes, PAGE_SIZE) >
+								UINT_MAX) {
+			dirty_background_bytes = old_bytes;
+			return -ERANGE;
+		}
 		dirty_background_ratio = 0;
+	}
 	return ret;
 }
 
@@ -539,6 +557,10 @@ static int dirty_bytes_handler(struct ct
 
 	ret = proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 	if (ret == 0 && write && vm_dirty_bytes != old_bytes) {
+		if (DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE) > UINT_MAX) {
+			vm_dirty_bytes = old_bytes;
+			return -ERANGE;
+		}
 		writeback_set_ratelimit();
 		vm_dirty_ratio = 0;
 	}
_

Patches currently in -mm which might be from jack@suse.cz are

ocfs2-fix-dio-failure-due-to-insufficient-transaction-credits.patch
revert-mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again.patch
mm-avoid-overflows-in-dirty-throttling-logic.patch

