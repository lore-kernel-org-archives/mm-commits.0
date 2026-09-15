Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72EB339872
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 04:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789446981; cv=none; b=IbkvAB3X18bnvaNwh558zetaKCZDUiI8pygrOmjklglyQdXULHWIxaVEREE9xguZ4ybHGMRK/b3BdJUMpOxTzbDMNcD0kYtdS2WJAfmGDTCNmG6sCQZ5rh5KsMPZP3b5iqj5kZPersEL8Rvd3m2EfQfoUeuonreqnK/zlecS3WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789446981; c=relaxed/simple;
	bh=sXGMiLcTdaV17UxDS2Jg/YJ8mKpvR20j2yXMSeG6jFs=;
	h=Date:To:From:Subject:Message-Id; b=LekOAPbXLl+WmGG65bLWAyWgTZxAUMUTLjplG9l6Uw8uVq5CplRz5B0C97ZF4mk4TgWA3BwhWaW6fLzzx0WUeNyJsE03FrRJ47tMq28eSlHqSRYkFKgAIuX8J418HhYOWUqkUmifUdgpYp17EaabL5gBFHgeihy/s4o/mavtmFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=smoCWsSy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="smoCWsSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CA51F000FF;
	Tue, 15 Sep 2026 04:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789446979;
	bh=c+julmaGDcuBiXSNDIR6PYSQv/a1NVO1tO3rGh/SH9w=;
	h=Date:To:From:Subject;
	b=smoCWsSyJ8Aw4uGmP1N1XzHQx/xodLW9J2ri2QGd9Fd0rW28P4KUY9/iPM94AX1p9
	 ehAS6MwK5zNAKagF46FLZ2Oc0T9n9T2PvhP5o3fEC5sr7WguFLeEKctsa8+azW9NoI
	 pjKN30v+NN9e1QGIGO61RPJONdehavevpPH62IQ8=
Date: Mon, 14 Sep 2026 21:36:18 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show.patch added to mm-new branch
Message-Id: <20260915043619.69CA51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: extract show_busy_info from vmalloc_info_show
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show.patch

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
Subject: mm/vmalloc: extract show_busy_info from vmalloc_info_show
Date: Mon, 14 Sep 2026 11:34:02 +0800

Patch series "mm/vmalloc: minor cleanups".

Small cleanup series for mm/vmalloc.c, no functional changes:

- Group xa_init() with the other vmap_block_queue field initializations
  in vmalloc_init(), instead of after the unrelated vfree_deferred setup.

- Extract vmap_insert_free_area() helper to deduplicate the allocate-
  and-insert pattern that appeared both inside the loop body and after
  the loop in vmap_init_free_space().

- Extract show_busy_info() from vmalloc_info_show(), mirroring the
  existing show_purge_info() pattern, so the top-level show function
  only orchestrates the two data sources.


This patch (of 3):

Extract the busy vmap area iteration into show_busy_info, mirroring the
existing show_purge_info pattern.

Link: https://lore.kernel.org/20260914-vmalloc_study-v1-0-526f68559706@linux.dev
Link: https://lore.kernel.org/20260914-vmalloc_study-v1-3-526f68559706@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---

 mm/vmalloc.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-extract-show_busy_info-from-vmalloc_info_show
+++ a/mm/vmalloc.c
@@ -5345,12 +5345,12 @@ static void show_purge_info(struct seq_f
 	}
 }
 
-static int vmalloc_info_show(struct seq_file *m, void *p)
+static void show_busy_info(struct seq_file *m)
 {
 	struct vmap_node *vn;
 	struct vmap_area *va;
 	struct vm_struct *v;
-	unsigned int *counters;
+	unsigned int *counters = NULL;
 
 	if (IS_ENABLED(CONFIG_NUMA))
 		counters = kmalloc_array(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
@@ -5415,12 +5415,18 @@ static int vmalloc_info_show(struct seq_
 		spin_unlock(&vn->busy.lock);
 	}
 
+	if (IS_ENABLED(CONFIG_NUMA))
+		kfree(counters);
+}
+
+static int vmalloc_info_show(struct seq_file *m, void *p)
+{
+	show_busy_info(m);
+
 	/*
 	 * As a final step, dump "unpurged" areas.
 	 */
 	show_purge_info(m);
-	if (IS_ENABLED(CONFIG_NUMA))
-		kfree(counters);
 	return 0;
 }
 
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

