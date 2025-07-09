Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9711DF970
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 02:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752027828; cv=none; b=EQd0Ouo9oVCsBmvgzPiINPwtA7Y/rfjdBmNpsqbX8MtmfMo+689j0Mct4XmN35VinErDhjV6eKmhXf4uxr1fjkKxSSGamNXvUB+uMBa93FoTfrDIspPJgPKa1Hnob3tebiIaaTzLyNNtVcKkiYtftei5sYea5MRMP6jQ76Owbkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752027828; c=relaxed/simple;
	bh=tmHgZAHRTlNHV3IenkzbiH483sbc5U7n3Ix/sPJfwe8=;
	h=Date:To:From:Subject:Message-Id; b=VrIQEk/sMA8zFm9YLGHrmlsgIyehdg+ursmZf7sB5N1vEMpW520qY9fpSiCNcLPqA8qtOI32Eq6sR0J7h6JrVyMLehniQAArvihimpH43WKNaNJuJkcnxH3bC4EWjf3vMW+C4sspr967U/3EGg+bCjr1wxzyryInCMKSzqC1c7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aF65loJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aF65loJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9083BC4CEED;
	Wed,  9 Jul 2025 02:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752027827;
	bh=tmHgZAHRTlNHV3IenkzbiH483sbc5U7n3Ix/sPJfwe8=;
	h=Date:To:From:Subject:From;
	b=aF65loJc6PaUal+HRfE4MWOo+lB8aUUcntNI7IrDaccH5eTsTjQtLkxJKrnAShlbY
	 PqzaLt/6CfuKsw+aYqpVnCjv76w0i0VDlKGMmZ3nwllwVvsKzOrSb84CCLBRBGtjIP
	 vSxO+ChlHMTF9liRq/CxzSSCg+ECGNN6tFsKT9no=
Date: Tue, 08 Jul 2025 19:23:39 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,ravis.opensrc@micron.com,corbet@lwn.net,bijantabatab@micron.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-commit-damos-migrate_dests.patch added to mm-new branch
Message-Id: <20250709022347.9083BC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: commit damos->migrate_dests
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-commit-damos-migrate_dests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-commit-damos-migrate_dests.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Bijan Tabatabai <bijantabatab@micron.com>
Subject: mm/damon/core: commit damos->migrate_dests
Date: Tue, 8 Jul 2025 19:59:37 -0500

When committing new scheme parameters from the sysfs, copy the
migrate_dests struct of the source schemes into the destination schemes.

Link: https://lkml.kernel.org/r/20250709005952.17776-8-bijan311@gmail.com
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-commit-damos-migrate_dests
+++ a/mm/damon/core.c
@@ -943,6 +943,41 @@ static void damos_set_filters_default_re
 		damos_filters_default_reject(&s->ops_filters);
 }
 
+static int damos_commit_dests(struct damos *dst, struct damos *src)
+{
+	struct damos_migrate_dests *dst_dests, *src_dests;
+
+	dst_dests = &dst->migrate_dests;
+	src_dests = &src->migrate_dests;
+
+	if (dst_dests->nr_dests != src_dests->nr_dests) {
+		kfree(dst_dests->node_id_arr);
+		kfree(dst_dests->weight_arr);
+
+		dst_dests->node_id_arr = kmalloc_array(src_dests->nr_dests,
+			sizeof(*dst_dests->node_id_arr), GFP_KERNEL);
+		if (!dst_dests->node_id_arr) {
+			dst_dests->weight_arr = NULL;
+			return -ENOMEM;
+		}
+
+		dst_dests->weight_arr = kmalloc_array(src_dests->nr_dests,
+			sizeof(*dst_dests->weight_arr), GFP_KERNEL);
+		if (!dst_dests->weight_arr) {
+			/* ->node_id_arr will be freed by scheme destruction */
+			return -ENOMEM;
+		}
+	}
+
+	dst_dests->nr_dests = src_dests->nr_dests;
+	for (int i = 0; i < src_dests->nr_dests; i++) {
+		dst_dests->node_id_arr[i] = src_dests->node_id_arr[i];
+		dst_dests->weight_arr[i] = src_dests->weight_arr[i];
+	}
+
+	return 0;
+}
+
 static int damos_commit_filters(struct damos *dst, struct damos *src)
 {
 	int err;
@@ -984,6 +1019,10 @@ static int damos_commit(struct damos *ds
 	dst->wmarks = src->wmarks;
 	dst->target_nid = src->target_nid;
 
+	err = damos_commit_dests(dst, src);
+	if (err)
+		return err;
+
 	err = damos_commit_filters(dst, src);
 	return err;
 }
_

Patches currently in -mm which might be from bijantabatab@micron.com are

mm-damon-core-commit-damos-target_nid.patch
mm-damon-core-commit-damos-migrate_dests.patch
mm-damon-move-migration-helpers-from-paddr-to-ops-common.patch
mm-damon-vaddr-add-vaddr-versions-of-migrate_hotcold.patch
docs-mm-damon-design-document-vaddr-support-for-migrate_hotcold.patch
mm-damon-vaddr-use-damos-migrate_dests-in-migrate_hotcold.patch
mm-damon-move-folio-filtering-from-paddr-to-ops-common.patch
mm-damon-vaddr-apply-filters-in-migrate_hot-cold.patch

