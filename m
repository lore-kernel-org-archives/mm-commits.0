Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C350E275B15
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 19:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517610; cv=none; b=dESA3odow/dnmoJKgpMpof6zhFrbsIyI+5Qaje2jCg0+WEitdZ3rvBoBNyU43y7L9W8ILyyZmVhhYR2P1314x9T1YxqbPZI6rasL6i6xdlwOGVRNdz8N18dvvcfFGKlZbiPflE/lRhHm58vfvswKn/cxeY5p0dnrJhMIcno7n/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517610; c=relaxed/simple;
	bh=Pn+TyXxl15IQjqWL7K0+ghvJgAHgVoDtopx8qss0cGM=;
	h=Date:To:From:Subject:Message-Id; b=iowRMDnFeBZk2YR8GyfgTJVb/yPxHkc8/Rwq+3uBb2AaSeeCxwURpyA2R2NQVQixy5Gmf8pYRLIlZ/z4QqEhNv418doVqdTS6FwCwjVGv8F0rMGSEawXVJxWYJYSXzLauMwgCge1brmUhCkJxlhV2Vjj8rcOk4DfrdgWt8d9Las=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i/xr51O8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i/xr51O8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4512CC19421;
	Tue, 23 Dec 2025 19:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517610;
	bh=Pn+TyXxl15IQjqWL7K0+ghvJgAHgVoDtopx8qss0cGM=;
	h=Date:To:From:Subject:From;
	b=i/xr51O8uoLK9EY4d5aDYGGhIKhiLo3vwkHfGSsIYIbUMfejMUnBppXECdQD7gSq7
	 5C8CXcrxnGlGNO0YWhJVvqm+AZtJautYXVOWomiND8v3TeNnA4YO85msrf5aTGyYU6
	 DekQlWTDx5z4+PF+vgLtLf4pp363BqASAaKVA4xI=
Date: Tue, 23 Dec 2025 11:20:09 -0800
To: mm-commits@vger.kernel.org,andreyknvl@gmail.com,maciej.wieczor-retman@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-unpoison-vms-addresses-with-a-common-tag-v4.patch removed from -mm tree
Message-Id: <20251223192010.4512CC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan-unpoison-vms-addresses-with-a-common-tag-v4
has been removed from the -mm tree.  Its filename was
     kasan-unpoison-vms-addresses-with-a-common-tag-v4.patch

This patch was dropped because it was folded into kasan-unpoison-vms-addresses-with-a-common-tag.patch

------------------------------------------------------
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Subject: kasan-unpoison-vms-addresses-with-a-common-tag-v4
Date: Fri, 05 Dec 2025 14:59:26 +0000

remove unneeded pr_warn()

Link: https://lkml.kernel.org/r/919897daaaa3c982a27762a2ee038769ad033991.1764945396.git.m.wieczorretman@pm.me
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/kasan/common.c~kasan-unpoison-vms-addresses-with-a-common-tag-v4
+++ a/mm/kasan/common.c
@@ -591,10 +591,8 @@ void __kasan_unpoison_vmap_areas(struct
 	 * would be unpoisoned with the KASAN_TAG_KERNEL which would disable
 	 * KASAN checks down the line.
 	 */
-	if (WARN_ON_ONCE(flags & KASAN_VMALLOC_KEEP_TAG)) {
-		pr_warn("KASAN_VMALLOC_KEEP_TAG flag shouldn't be already set!\n");
+	if (WARN_ON_ONCE(flags & KASAN_VMALLOC_KEEP_TAG))
 		return;
-	}
 
 	size = vms[0]->size;
 	addr = vms[0]->addr;
_

Patches currently in -mm which might be from maciej.wieczor-retman@intel.com are

kasan-refactor-pcpu-kasan-vmalloc-unpoison.patch
kasan-unpoison-vms-addresses-with-a-common-tag.patch

