Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29991F91F6
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 04:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789446983; cv=none; b=lrRWh516hMqiojgl4n67Cavz7o+MEbDvpKBXZSW6lieGJ/XDDM79TpicxZOCrY8ETX5RqfM2XxmjpGuGiML00s92zld49flEcRcQcT9iD8nLqBDzULwwSsqSentTv13H05N9xMNypNtsqScD5CdP2kXoJeWMsO0gwYfyOcvudfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789446983; c=relaxed/simple;
	bh=OyJEpmqO+CMEmqHZuFU+xNxFB3vPG1s8BaFjzM/ZxGc=;
	h=Date:To:From:Subject:Message-Id; b=b3wkFUwcIa9McsgZfjo+kxeNcOimFviv6s2bg+jijfIsc68YSh0oVaNlezVoSJopaaeE7CVYs0jwPCKPEZ2mH3KODUXPmsZlo12kTKbDXuETDNUqvgVQTb+PUe+0eonsFKANbkyTlnv/iMrwN/Efo6yMrMSKlivVC/HUQQnSakQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yovjATQG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yovjATQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE151F000FF;
	Tue, 15 Sep 2026 04:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789446981;
	bh=/u9geokdfn9KZ7+2qCz6DCwAXUIN2Wk+34PAHDp+g3A=;
	h=Date:To:From:Subject;
	b=yovjATQGi8Qqyc7PMYhUE9C2y8+rsg1mGR61En2KxqakC4ffwqSASx8Rwj4+w722m
	 Z/tena0ymhU3dt+NeQLSVr5wKmpv/efpXGrNjma3SFEtQ1Um6zav/R2wt27w9CNOM5
	 UImQefoQ/Aa8aGb1ztEXTabBNNAWxiXqTJ/uzLEs=
Date: Mon, 14 Sep 2026 21:36:20 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch added to mm-new branch
Message-Id: <20260915043621.5EE151F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: group xa_init with vbq field initializations
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/vmalloc: group xa_init with vbq field initializations
Date: Mon, 14 Sep 2026 11:34:00 +0800

Move xa_init() next to the other vbq field initializations instead of
after the unrelated vfree_deferred setup.

Link: https://lore.kernel.org/20260914-vmalloc_study-v1-1-526f68559706@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-group-xa_init-with-vbq-field-initializations
+++ a/mm/vmalloc.c
@@ -5591,10 +5591,11 @@ void __init vmalloc_init(void)
 		vbq = &per_cpu(vmap_block_queue, i);
 		spin_lock_init(&vbq->lock);
 		INIT_LIST_HEAD(&vbq->free);
+		xa_init(&vbq->vmap_blocks);
+
 		p = &per_cpu(vfree_deferred, i);
 		init_llist_head(&p->list);
 		INIT_WORK(&p->wq, delayed_vfree_work);
-		xa_init(&vbq->vmap_blocks);
 	}
 
 	/*
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-fix-vmap_purge_lock-livelock-under-memory-pressure.patch
tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored.patch
tools-mm-page_owner_sort-add-module-name-sort-cull-filter-support.patch
tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text.patch
mm-oom_kill-remove-unreachable-__gfp_thisnode-check-in-constrained_alloc.patch
mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max.patch
mm-page_table_check-add-explicit-pmd_none-check-in-pte_clear_range.patch
mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show.patch
mm-vmalloc-group-xa_init-with-vbq-field-initializations.patch
mm-vmalloc-extract-vmap_insert_free_area-helper.patch

