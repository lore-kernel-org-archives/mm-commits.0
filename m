Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C912DF6E6
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 18:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784140716; cv=none; b=nu3KE+WgS2JSsKBkqlzK/KnpwS2lurl7nlMvOFKb4EcS1/w9DBKCgPRlghELrmERb191Azaoz9aQdBVTKoZJf7UeQmzy0DhtEy26/nIjgoxrS46PuXQOYf8aP+lY5ukOuR81SeIY70gqJraog9mYxHjVlO1YJ/mZxKl5Vg1mYhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784140716; c=relaxed/simple;
	bh=DDwZnzvKr2R3ReUHE+pn1NKWBqP04kT9oWmj3lM+e68=;
	h=Date:To:From:Subject:Message-Id; b=mdjEmoUCP1Y38v9SDwVevkmfMlBxvzCi4eXvJkwyJxmPWdlFk/DtFflYvF2K4SMn+wiswKlQSVOBSRWwrcsXUrGXfiZadv5w5YwW0WGAdjUQz8szxqiW0GacaA7CIFkmJS2dHrvowyIZL1QLGCi1wYvQ6rQ1Io7n0zog+0AR9A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VF2yaPI1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VF2yaPI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E22C1F00A3F;
	Wed, 15 Jul 2026 18:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784140701;
	bh=yxlnX8pID82CJGqxQlB9eCeMffS/nRzm4e8b4l+gtHQ=;
	h=Date:To:From:Subject;
	b=VF2yaPI1rZWZz5hZ04t7sBHByToC8aPy3CRgdzm/Ose+cUDREDrXkRtXviA+qRIFv
	 4bA8pq+tP9p2E1IsMOrRjsx0VB0WmDs/60o60qTqUFdhNs/5RlwQP0Q1AmjWd2k2n+
	 +4+BO8kVpiNaF2vXIekCmCjZCqyjCPBW+lg5TWuw=
Date: Wed, 15 Jul 2026 11:38:20 -0700
To: mm-commits@vger.kernel.org,jiangwenxiaomi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection.patch added to mm-unstable branch
Message-Id: <20260715183821.4E22C1F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: extract vm_shift() to consolidate mapping shift selection
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Subject: mm/vmalloc: extract vm_shift() to consolidate mapping shift selection
Date: Wed, 15 Jul 2026 20:08:11 +0800

Extract the vmalloc mapping shift selection from
__vmalloc_node_range_noprof() into vm_shift(), preparing for reuse by the
vmap batching path.

No functional change.

Link: https://lore.kernel.org/20260715120813.3609949-6-jiangwen6@xiaomi.com
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection
+++ a/mm/vmalloc.c
@@ -3578,6 +3578,14 @@ void vunmap(const void *addr)
 }
 EXPORT_SYMBOL(vunmap);
 
+static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
+{
+	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
+		return PMD_SHIFT;
+
+	return arch_vmap_pte_supported_shift(size);
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -4089,11 +4097,7 @@ void *__vmalloc_node_range_noprof(unsign
 		 * supporting them.
 		 */
 
-		if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
-			shift = PMD_SHIFT;
-		else
-			shift = arch_vmap_pte_supported_shift(size);
-
+		shift = vm_shift(prot, size);
 		align = max(original_align, 1UL << shift);
 	}
 
_

Patches currently in -mm which might be from jiangwenxiaomi@gmail.com are

mm-vmalloc-extract-vmap_set_ptes-to-consolidate-pte-mapping-logic.patch
mm-vmalloc-extract-vm_shift-to-consolidate-mapping-shift-selection.patch

