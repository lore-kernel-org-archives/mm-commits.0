Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7A82F2E
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 03:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746935797; cv=none; b=AVMeupZeT7gioi33KW1IYNjU75DLuEYEovs3giMeAm+ZXAWL1bndJM+S5UlbrwmxXgHl9AgTs17UtsK3IrzN5W0RSdIDp117JaHGms/VXMl2HuTQo9pI+R4Z1ceVw/lklHdG0/iBh2sOeVI0NVYRhrO123TBuZPsYyZNtTfpe/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746935797; c=relaxed/simple;
	bh=r1KekSG98iLNjhmyKR6zmbwKg9qbY5U/qvKBGJq2924=;
	h=Date:To:From:Subject:Message-Id; b=BZaAlHo+zquzmhsU34HLB2pgpbyqX3YBqUnDTilpN/AAfPa9CZRciF026kduJUSwq1TrUt4K/8cGQraOoWRE8eVopAWsypR874jkirocpV73RdEGOvfD3Ws/Glo8zTbPZtdE04IEs8YEFIgMbbrMzAyumDSFVShbKRUQ7bavQdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AJawg/Ha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AJawg/Ha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB25C4CEE4;
	Sun, 11 May 2025 03:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746935797;
	bh=r1KekSG98iLNjhmyKR6zmbwKg9qbY5U/qvKBGJq2924=;
	h=Date:To:From:Subject:From;
	b=AJawg/Haw8ZrwIP2xMu9PuvGOsGl/Vgx3p2XF3ZtWGWsebwQJW9984XfN6zoPo/gp
	 DEUOpTIhD3l1iCJuY2JnQK8XEefsuOexeiNbPGLrhKdZq3kDHVF7ZYnPRlL02eRb1F
	 NjRfyQLESgVkT5LgMI5aM1KYRzKhBeZcm1TI3m30=
Date: Sat, 10 May 2025 20:56:36 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] samples-damon-implement-a-damon-module-for-memory-tiering-fix.patch removed from -mm tree
Message-Id: <20250511035637.2AB25C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon: trigger build even if only mtier is enabled
has been removed from the -mm tree.  Its filename was
     samples-damon-implement-a-damon-module-for-memory-tiering-fix.patch

This patch was dropped because it was folded into samples-damon-implement-a-damon-module-for-memory-tiering.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon: trigger build even if only mtier is enabled
Date: Sat, 26 Apr 2025 11:40:54 -0700

mtier can be built only if one or more of other DAMON sample modules are
build-enabled.  This is because commit 66001f0476f4 ("samples/damon:
implement a DAMON module for memory tiering") on mm-unstable tree is not
connecting it on samples/Makefile.  Fix it by adding the connection on
samples/Makefile.

Link: https://lkml.kernel.org/r/20250426184054.11437-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/samples/Makefile~samples-damon-implement-a-damon-module-for-memory-tiering-fix
+++ a/samples/Makefile
@@ -42,4 +42,5 @@ obj-$(CONFIG_SAMPLE_FPROBE)		+= fprobe/
 obj-$(CONFIG_SAMPLES_RUST)		+= rust/
 obj-$(CONFIG_SAMPLE_DAMON_WSSE)		+= damon/
 obj-$(CONFIG_SAMPLE_DAMON_PRCL)		+= damon/
+obj-$(CONFIG_SAMPLE_DAMON_MTIER)	+= damon/
 obj-$(CONFIG_SAMPLE_HUNG_TASK)		+= hung_task/
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-define-and-use-madvise_behavior-struct-for-madvise_do_behavior.patch
mm-madvise-batch-tlb-flushes-for-madv_free.patch
mm-memory-split-non-tlb-flushing-part-from-zap_page_range_single.patch
mm-madvise-batch-tlb-flushes-for-madv_dontneed.patch
mm-damon-core-introduce-damos-quota-goal-metrics-for-memory-node-utilization.patch
mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch
mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch
docs-mm-damon-design-document-node_mem_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-nid-file.patch
docs-abi-damon-document-nid-file.patch
samples-damon-implement-a-damon-module-for-memory-tiering.patch

