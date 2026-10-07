Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BD0305677
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334259; cv=none; b=sIe+9xu5KJnw2JYadl2yhhfNYKuIMxqTjn/OWjycGHYv8DIlOTNt6PhDgNbj1OUwWl0AydM+rq+5vy40qIfTafoBRg6tievLddbuPmEI0Nr2cEiyZUK9/llToIbVa+XvXxk133Y+/Fj2pzQA3f7b603jXaPlWLGJ51Z6/fs/710=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334259; c=relaxed/simple;
	bh=TaZf2vVk4+rJ5NeRLu6hp5S8q9TeGu5yHFGQJM86Hag=;
	h=Date:To:From:Subject:Message-Id; b=LJRDv18R8AN7Gqd1dv4+I7amRVpw1BNyzBl14g8CZ2L1HSUtf+FKm9WjLWLtAsotY68z8/sITq9z23pOxi5tonxxkTn1qGwpoPMDBSjMNjZ21H70wtjuUuEezKhxiTuZO4PUXkDdWCl+y2+kvEjnyIsTG6/e1jgABmEykRintMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NNUSBWVR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NNUSBWVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F7B1F0089C;
	Wed,  7 Oct 2026 00:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334258;
	bh=SO3Btt1vwae+2JjzPkApE6r15pvhK4qZ5t4qGImebwk=;
	h=Date:To:From:Subject;
	b=NNUSBWVREzqy9l9xQ5wKmIiY21r3/xOgX99l0UJFOHKbkjAXa1HIn3zjnqxZBcg0V
	 zlES1KmsCFgVxjqqPWXceh9r15vC6eZjicM2Jq4c254R6VQ43yAy6uuc+WvXLntGfD
	 qcXUhx6tsVKTCwBacrq/zw5SUfb6zSAZTjzxDghE=
Date: Tue, 06 Oct 2026 17:50:57 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,rientjes@google.com,mhocko@suse.com,husong@kylinos.cn,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max.patch removed from -mm tree
Message-Id: <20261007005058.34F7B1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/oom_kill, proc: replace magic number 1000 with OOM_SCORE_ADJ_MAX
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/oom_kill, proc: replace magic number 1000 with OOM_SCORE_ADJ_MAX
Date: Tue, 11 Aug 2026 11:36:08 +0800

In oom_badness() and proc_oom_score(), the oom_score_adj normalization
uses a hardcoded 1000, which is the value of OOM_SCORE_ADJ_MAX defined in
include/uapi/linux/oom.h.  Other code in the kernel (e.g.  fs/proc/base.c
oom_adj handling) already uses OOM_SCORE_ADJ_MAX for the same purpose.

Replace the magic number with the macro for consistency and readability. 
No functional change.

Link: https://lore.kernel.org/20260811033609.3992348-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Song Hu <husong@kylinos.cn>
---

 fs/proc/base.c |    3 ++-
 mm/oom_kill.c  |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/proc/base.c~mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max
+++ a/fs/proc/base.c
@@ -594,7 +594,8 @@ static int proc_oom_score(struct seq_fil
 	 * exporting for a long time so userspace might depend on it.
 	 */
 	if (badness != LONG_MIN)
-		points = (1000 + badness * 1000 / (long)totalpages) * 2 / 3;
+		points = (OOM_SCORE_ADJ_MAX +
+			  badness * OOM_SCORE_ADJ_MAX / (long)totalpages) * 2 / 3;
 
 	seq_printf(m, "%lu\n", points);
 
--- a/mm/oom_kill.c~mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max
+++ a/mm/oom_kill.c
@@ -230,7 +230,7 @@ long oom_badness(struct task_struct *p,
 	task_unlock(p);
 
 	/* Normalize to oom_score_adj units */
-	adj *= totalpages / 1000;
+	adj *= totalpages / OOM_SCORE_ADJ_MAX;
 	points += adj;
 
 	return points;
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch
mm-vmalloc-extract-vmap_insert_free_area-helper.patch
mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show.patch
mm-vmalloc-fix-vmalloc_dump_obj-address-alignment-for-last-page-lookups.patch
mm-vmalloc-fix-vmalloc_dump_obj-cross-zone-va-lookup.patch

