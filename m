Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C692331A76
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298504; cv=none; b=fAlHcgNOiOWPhnpF7t/6WEditEHDIiThuXbJ5bKcycrxXnki49oIlfNJZylWUd9QS/TOT1AjQkX1hmjshW3dzKYquwbDZnFfzmdbiX9vd0n9gQ973XMD7WXWOcTtRlkZe0qlHVlrLlvsH/egSq7Sb5jnuy39FzVdunvnlO1a82w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298504; c=relaxed/simple;
	bh=82WmnD8PdZ0XSLnE/1NOhosnQj6G60lITScfzSDgrNg=;
	h=Date:To:From:Subject:Message-Id; b=kBImEZJKFokUIYiQLhbaZqDgB0pQOBicv1Qoy6jiKsivsht14DI1leWvz5huSj9fq+1Gb80uWqsjaMNE9/9AUWu84Gi8vXRew/m1HVkLP5+0qp5YcBkzqli9/efeYhFf3FHBRX7WxyUxY2RmQ0RviAAikfkwmR9lW8iv1N6rEyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I27l8+NR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I27l8+NR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212331F00A3D;
	Wed, 29 Jul 2026 04:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298503;
	bh=M+f8KYH++inuEXeJmlV3N2NOu1swCZKduonHXbitqWE=;
	h=Date:To:From:Subject;
	b=I27l8+NRLMgGqu7DUTybCbqTi8dyUs9Ni04h4Genr+8LZ4XMyAuHyRG/1gao1KSrW
	 HVKjPJiblgcZbKKBjYg00WbPU05Lt9ByaE2NL9R5AvQtfHPvpJw99C2YNYL9otWggC
	 V6DVWCxBP2XF0njcx/RBd1bgW8WuGh7nRYuQupic=
Date: Tue, 28 Jul 2026 21:15:02 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,ritesh.list@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] include-linux-swaph-remove-unused-leftovers.patch removed from -mm tree
Message-Id: <20260729041503.212331F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: include/linux/swap.h: remove unused leftovers
has been removed from the -mm tree.  Its filename was
     include-linux-swaph-remove-unused-leftovers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: include/linux/swap.h: remove unused leftovers
Date: Thu, 11 Jun 2026 08:39:32 +0530

This removed unused leftovers, most of them are forward structure
declarations.  Also removes SWAP_BATCH macro which isn't used any where in
the code.

Found these during manual code review.

Link: https://lore.kernel.org/68591daf0d679e5a0072d63751f187d14613e2b0.1781146877.git.ritesh.list@gmail.com
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    7 -------
 1 file changed, 7 deletions(-)

--- a/include/linux/swap.h~include-linux-swaph-remove-unused-leftovers
+++ a/include/linux/swap.h
@@ -16,10 +16,6 @@
 #include <uapi/linux/mempolicy.h>
 #include <asm/page.h>
 
-struct notifier_block;
-
-struct bio;
-
 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
 #define SWAP_FLAG_PRIO_MASK	0x7fff
 #define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap */
@@ -29,7 +25,6 @@ struct bio;
 #define SWAP_FLAGS_VALID	(SWAP_FLAG_PRIO_MASK | SWAP_FLAG_PREFER | \
 				 SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE | \
 				 SWAP_FLAG_DISCARD_PAGES)
-#define SWAP_BATCH 64
 
 static inline int current_is_kswapd(void)
 {
@@ -175,7 +170,6 @@ static inline void mm_account_reclaimed_
 
 struct address_space;
 struct sysinfo;
-struct writeback_control;
 struct zone;
 
 /*
@@ -442,7 +436,6 @@ extern sector_t swapdev_block(int, pgoff
 extern int __swap_count(swp_entry_t entry);
 extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
-struct backing_dev_info;
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
 sector_t swap_folio_sector(struct folio *folio);
 
_

Patches currently in -mm which might be from ritesh.list@gmail.com are


