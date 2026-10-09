Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B883FCB3A
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525411; cv=none; b=QKSUTUa4B0ht+pTfUH0rM8purg//6pdXP9zgz936oira7ODpxcOC8nHSZaUx/21y7ofRBcZNHgXaWT9c2nOrwzb0L0UeIwL5e3s+WTu8QWaCgw/WFDR2LVxq91bG4dRXdZy2DA8dQCBg24Gw2vh7Btybu95piKm217OuiodlxC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525411; c=relaxed/simple;
	bh=0jPpGMHie5U30/GCZppcydleat20FITSwk019A/Nxi4=;
	h=Date:To:From:Subject:Message-Id; b=G6HtVq4bzMAlz8hjohgjaZaSKpwcuhjDvaAFK5wuRlaz0X84t1yFPsGG2SsAU6g6ltF3QxoMVK86Ot52bGRGgPwmGawjzyatLqxCpMLlOcfyRMDIyTT+l2kIJRN/sp2zsJ8UM4KzLuC6hYwYHuTb/+oRbhev8P2dt9Xi1Io3zlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a6oom9Zx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a6oom9Zx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B66D1F00893;
	Fri,  9 Oct 2026 05:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525409;
	bh=b260yzPhJCwFd1mK05DBQ0rh9jw/XxfJ44vq0wS1ODQ=;
	h=Date:To:From:Subject;
	b=a6oom9Zx2z9Zmig/YHTfibAnIkBUsRrd1KSvXU1j+Wa1Pb5ZwjvjcpAyEJUrCKTAp
	 bnrdECQNkhZihFjeVWdonIVzG2trLK3qhMP63pquOvF5xyNDoQgPutlhYgGfVH8LQ0
	 5hmMAy9AU3mE9DC8c3BFC8CncagUK0tMGEiJw67s=
Date: Thu, 08 Oct 2026 22:56:49 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,david@kernel.org,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-ksm-use-the-renamed-ksm-structure-names.patch removed from -mm tree
Message-Id: <20261009055649.9B66D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs/mm: ksm: use the renamed ksm structure names
has been removed from the -mm tree.  Its filename was
     docs-mm-ksm-use-the-renamed-ksm-structure-names.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: docs/mm: ksm: use the renamed ksm structure names
Date: Sat, 5 Sep 2026 10:40:34 +0200

The Reference section of ksm.rst asks mm/ksm.c for mm_slot, stable_node
and rmap_item.  Commit 21fbd59136e0 ("ksm: add the ksm prefix to the names
of the ksm private structures") renamed them to ksm_mm_slot,
ksm_stable_node and ksm_rmap_item.  Since then only ksm_scan is rendered
and the three structures are missing from the generated documentation.

Use the current names.

Link: https://lore.kernel.org/20260905084034.39521-1-kmehltretter@gmail.com
Fixes: 21fbd59136e0 ("ksm: add the ksm prefix to the names of the ksm private structures")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
---

 Documentation/mm/ksm.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/ksm.rst~docs-mm-ksm-use-the-renamed-ksm-structure-names
+++ a/Documentation/mm/ksm.rst
@@ -78,7 +78,7 @@ The frequency of such scans is defined b
 Reference
 ---------
 .. kernel-doc:: mm/ksm.c
-   :functions: mm_slot ksm_scan stable_node rmap_item
+   :functions: ksm_mm_slot ksm_scan ksm_stable_node ksm_rmap_item
 
 --
 Izik Eidus,
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

mm-secretmem-fix-the-enable-parameter-description.patch
mm-damon-core-preserve-the-quota-passed-to-damon_new_scheme.patch
mm-damon-tests-core-kunit-test-preservation-of-quota-state.patch
mm-damon-tests-core-kunit-test-psi-goal-values-with-explicit-samples.patch
ocfs2-cluster-hold-a-reference-on-the-heartbeat-thread.patch
resource-kunit-stop-selecting-get_free_region.patch
kcov-report-spurious-pcs-in-the-interrupt-selftest.patch
squashfs-fix-fragment-index-table-sizing-overflow-on-32-bit.patch
squashfs-make-the-fragment-index-table-bounds-check-overflow-safe.patch

