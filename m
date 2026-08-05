Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF5A3BED66
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896663; cv=none; b=bzMt+V2ItvCqw758ppFsJcwHIntb5pD9ar2eKKCEafYsXwSMANf9+dTbuwOdmFT+Jdpfo73aH6IkNfUNFG4CuYm5qF5vGB9jQQSC9/FrLpskE9TDR1mevZFpWWZ5faEl7va83RgOjQh8nHOFxwZkvgnBx0v8lSTeUBCP9isthjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896663; c=relaxed/simple;
	bh=aFT2udShS1s8la7X6mH6Q5RGvMOuLDQuBOvGab5fofs=;
	h=Date:To:From:Subject:Message-Id; b=WOYH6FUUq9yT+z0wYSRbLUTfKo/o9ZHmdWeC8TRN5tFzIZeh3qxyR/IatHPrCo5ULMp4d5X2oc/soZFwNC+7VUz4CjiHY/5oMCrU2YD8ITjeErWq4pWBSa2Aev86hDxDkkzvirKwV33yONvb+JM7MynExcammKUaxWOOBrMDSn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wtfZkHuS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wtfZkHuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925F81F00A3A;
	Wed,  5 Aug 2026 02:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896661;
	bh=dCSkYXPzBmUBaeaqGjnghOSt+F7RNpU6iMNAn+Wzqls=;
	h=Date:To:From:Subject;
	b=wtfZkHuSnPMp3WTsyJTFKxA20sJK2StlJY6CyLvjBve69X6hCBqevaA0fQ/ezAzc4
	 pkM+RkY8y/IyKYhq04B/Tfu4iE5KtSoyLnWk5Z2ZgJX5ig7TeIl1PzRaMXBtVUnU0Q
	 EZFMH06voDXJ97J1/MR9qc3MvKvhV41i7ClanCbg=
Date: Tue, 04 Aug 2026 19:24:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hpa@zytor.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,brendan.jackman@linux.dev,bp@alien8.de,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-remove-bootmem_infoh-include.patch removed from -mm tree
Message-Id: <20260805022421.925F81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: remove bootmem_info.h include
has been removed from the -mm tree.  Its filename was
     mm-sparse-remove-bootmem_infoh-include.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: remove bootmem_info.h include
Date: Thu, 16 Jul 2026 16:51:08 +0200

No longer required, so let's remove it.

Link: https://lore.kernel.org/20260716-bootmem_info_part2-v2-9-4afc76c73d61@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/sparse.c~mm-sparse-remove-bootmem_infoh-include
+++ a/mm/sparse.c
@@ -13,7 +13,6 @@
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
-#include <linux/bootmem_info.h>
 #include <linux/vmstat.h>
 #include "internal.h"
 #include <asm/dma.h>
_

Patches currently in -mm which might be from david@kernel.org are

mm-standardize-printing-for-pgtable-entries.patch
mm-gup-fix-always-draining-lru-caches-in-collect_longterm_unpinnable_folios.patch

