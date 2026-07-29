Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A69C2EA
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298383; cv=none; b=cjmXE1IyX5P47qyhFXayCj9Iol2m+irIcm7IDzF8/dpPBfPH50/dmOZc8jbVDpv7EL6wK6e9nsTWG/P+/zZI78uw3VpDaVeBvReMFXUGxt6ynVMFiG0Ct4MHt3Ez/Hd5wlFRtf/GgJAl3VnoYjpON4iHgvs7Adpz6LcFbg8T9a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298383; c=relaxed/simple;
	bh=xWP947lV1I7bwJCZz8o2+elUCH78dbquKoCQaFtRKJw=;
	h=Date:To:From:Subject:Message-Id; b=KpbamAmRTOEzGxHh1bcmHvB24HKW/eM8+TRFgITpX8/pJx6PbRKxQkPdv4AV8H7rqA5YZVTeCAt1hfhz0PDEnqTrFAXH+7+51Dy34KR/rwfUvEDMA+BjxmTbueN1f5TigZp8mVkQYiMAmT1KTAdWgSRGy/tbglBzqD8Uc1KJ3k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iQwkdMg1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iQwkdMg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD711F000E9;
	Wed, 29 Jul 2026 04:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298382;
	bh=BR8a/nUj8tBoU4bXRXEVTy0jyVkvI/LDuQP8FeDVllM=;
	h=Date:To:From:Subject;
	b=iQwkdMg1xf/J3ee9aAqS1bWdZzGh0Iuu3EMww6mMuo5t4IvpNprtUMMa42K0ZukC5
	 2Opc5xkt0uVi5sZ3+S126U4Yswi1TH6cpXTj1AZ1O2udRwdFAnhmxqZ//mj5OUbXbm
	 Ik/YLyhMO43eE4jp6Zz1g2QJcgugX1/RRZVw5sjo=
Date: Tue, 28 Jul 2026 21:13:01 -0700
To: mm-commits@vger.kernel.org,harry@kernel.org,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-remove-stray-text-from-obj_stock_pcp-comment.patch removed from -mm tree
Message-Id: <20260729041302.3FD711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: remove stray text from obj_stock_pcp comment
has been removed from the -mm tree.  Its filename was
     mm-memcg-remove-stray-text-from-obj_stock_pcp-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: mm: memcg: remove stray text from obj_stock_pcp comment
Date: Tue, 23 Jun 2026 16:26:14 +0800

A patch filename was accidentally inserted into the comment describing
the nr_bytes field of struct obj_stock_pcp. Remove it.

No functional change.

Link: https://lore.kernel.org/20260623082614.81621-1-guopeng.zhang@linux.dev
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-remove-stray-text-from-obj_stock_pcp-comment
+++ a/mm/memcontrol.c
@@ -2039,7 +2039,7 @@ struct obj_stock_pcp {
 	/*
 	 * On rare archs with 256KiB base page size (hexagon and powerpc 44x)
 	 * keep nr_bytes to unsigned int as uint16_t cannot represent the full
-e patches/memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch	 * sub-page remainder. Such archs are not cacheline optimization target.
+	 * sub-page remainder. Such archs are not cacheline optimization targets.
 	 */
 	unsigned int nr_bytes[NR_OBJ_STOCK];
 #else
_

Patches currently in -mm which might be from zhangguopeng@kylinos.cn are

mm-memcontrol-update-state_local-when-flushing-nmi-stats.patch
mm-memcg-v1-account-vmpressure-event-allocations.patch
mm-memcg-v1-fix-wrong-linux-mm-list-address-in-deprecation-warnings.patch
mm-memcontrol-drop-unused-cpu-argument-from-flush_nmi_stats.patch
mm-memcontrol-factor-out-memcg-kmem-uncharge-sequence.patch
mm-memcg-v1-make-mem_cgroup_oom_notify_cb-return-void.patch
mm-memcg-stop-reclaim-when-a-limit-update-is-superseded.patch

