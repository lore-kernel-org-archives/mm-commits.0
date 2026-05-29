Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC8936F8E1
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027608; cv=none; b=rVI41msjcY7GNIxPcg2pa0Hm9YWXcQe7ogdt+GwebnKWimE41yRD60pvpr6SDW6vzlwcI3uXMLE6yKwq9aGRB1Rcnn4Ozq+72XY3Pu/QsB/9pIvg7lRJ05FaaA23PD+lOjP65YiLyr04ilNQkKXf/EbkWu/uvXRdGyXZZhdKjew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027608; c=relaxed/simple;
	bh=rorHwdXbk/Kk51/xyt/T01GqQ3R5tD0HONhs9cZ3Cjg=;
	h=Date:To:From:Subject:Message-Id; b=VbvZERjV1bBR26eu0WM6SYlOotbTU9jhmM4i3BBCGPAr69tsC3spylB1wXRLBlpvWCTtt+pVw8iekmIC06IwP7mnBtablgjZq0tGJTgHLL9VQCoYRIys+ZYUj6Ca9MG+pYrB0/CDYb9RsomyNSmMp5fs4YujvzwPsCmUUo1BcBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rtU0qzd4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rtU0qzd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A671F00898;
	Fri, 29 May 2026 04:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027607;
	bh=Iuk0LoZTA1FNvdOMNodQTR2dUo27f3I0kmodjH3v/tM=;
	h=Date:To:From:Subject;
	b=rtU0qzd4Nng9FJ64FVvNO0cupP33JkpbpT4gCq7eGt97PGAsFk5jaP+eHeDiA+HkF
	 I2ZZO1ehh3gOKjPZ3Eah6a9FM6Q1nn093ws9AXEmPKyZG+1N3YO68cnlTU/2hrlsGY
	 FmhHDEmkvjKBKbfjYIpzvLE6Ws5KMPDucWXW/f7M=
Date: Thu, 28 May 2026 21:06:46 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch removed from -mm tree
Message-Id: <20260529040646.E7A671F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/maintainer-profile: add AI review usage guideline
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/maintainer-profile: add AI review usage guideline
Date: Sun, 12 Apr 2026 14:19:31 -0700

DAMON is opted-in for DAMON patches scanning [1] and email delivery [2]. 
Clarify how that could be used on DAMON maintainer profile.

Link: https://lore.kernel.org/20260412211932.89038-1-sj@kernel.org
Link: https://github.com/sashiko-dev/sashiko/commit/ad9f4a98f958 [1]
Link: https://github.com/sashiko-dev/sashiko/commit/b554c7b6e733 [2]
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |   21 ++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -100,3 +100,24 @@ There is also a public Google `calendar
 <https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t>`_
 that has the events.  Anyone can subscribe to it.  DAMON maintainer will also
 provide periodic reminders to the mailing list (damon@lists.linux.dev).
+
+AI Review
+---------
+
+For patches that are publicly posted to DAMON mailing list
+(damon@lists.linux.dev), AI reviews of the patches will be available at
+sashiko.dev.  The reviews could also be sent as mails to the author of the
+patch.
+
+Patch authors are encouraged to check the AI reviews and share their opinions.
+The sharing could be done as a reply to the mail thread.  Consider reducing the
+recipients list for such sharing, since some people are not really interested
+in AI reviews.  As a rule of thumb, drop stable@vger.kernel.org and individuals
+except DAMON maintainer.
+
+`hkml` also provides a `feature
+<https://github.com/sjp38/hackermail/blob/master/USAGE.md#forwarding-sashikodev-statuscomments-to-mailing-list>`_
+for such sharing.  Please feel free to use the feature.
+
+It is only an optional recommendation.  DAMON maintainer could also ask any
+question about the AI reviews, though.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-ops-common-call-folio_test_lru-after-folio_get.patch
mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
mm-damon-core-introduce-struct-damon_probe.patch
mm-damon-core-embed-damon_probe-objects-in-damon_ctx.patch
mm-damon-core-introduce-damon_filter.patch
mm-damon-core-commit-probes.patch
mm-damon-core-introduce-damon_region-probe_hits.patch
mm-damon-core-introduce-damon_ops-apply_probes.patch
mm-damon-core-do-data-attributes-monitoring.patch
mm-damon-paddr-support-data-attributes-monitoring.patch
mm-damon-sysfs-implement-probes-dir.patch
mm-damon-sysfs-implement-probe-dir.patch
mm-damon-sysfs-implement-filters-directory.patch
mm-damon-sysfs-implement-filter-dir.patch
mm-damon-sysfs-implement-filter-dir-files.patch
mm-damon-sysfs-setup-probes-on-damon-core-api-parameters.patch
mm-damon-sysfs-schemes-implement-tried_regions-r-probes.patch
mm-damon-sysfs-schemes-implement-probe-dir.patch
mm-damon-sysfs-schemes-implement-probe-hits-file.patch
mm-damon-trace-probe_hits.patch
selftests-damon-sysfssh-test-probes-dir.patch
docs-mm-damon-design-document-data-attributes-monitoring.patch
docs-admin-guide-mm-damon-usage-document-data-attributes-monitoring.patch
mm-damon-core-introduce-damon_filter_type_memcg.patch
mm-damon-paddr-support-damon_filter_type_memcg.patch
mm-damon-sysfs-add-filters-f-path-file.patch
mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common.patch
mm-damon-sysfs-setup-damon_filter-memcg_id-from-path.patch
docs-mm-damon-design-update-for-memcg-damon-filter.patch
docs-admin-guide-mm-damon-usage-update-for-memcg-damon-filter.patch
mm-damon-core-safely-handle-no-region-case-in-damon_set_regions.patch
mm-damon-core-do-not-use-region-out-of-a-loop-in-damon_set_regions.patch
samples-damon-mtier-replace-damon_add_region-with-damon_set_regions.patch
mm-damon-tests-vaddr-kunit-replace-damon_add_region-with-damon_set_regions.patch
mm-damon-core-hide-damon_add_region.patch
mm-damon-core-hide-damon_insert_region.patch
mm-damon-core-hide-damon_destroy_region.patch
mm-damon-core-add-kdamond_call-debug_sanity-check.patch
mm-damon-core-remove-damon_verify_nr_regions.patch
mm-damon-tests-core-kunit-add-damon_set_regions-test-cases.patch
selftests-damon-sysfspy-stop-kdamonds-before-failing.patch
selftests-damon-sysfssh-test-monitoring-intervals-goal-dir.patch
selftests-damon-sysfssh-test-addr_unit-file-existence.patch
selftests-damon-sysfssh-test-pause-file-existence.patch
mm-damon-core-trace-esz-at-first-setup.patch

