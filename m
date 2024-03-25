Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C42129E9F
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 18:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711389615; cv=none; b=Rn9HfuqAskquB5An48rtxeHWCXIgB4B6+HRpiOGiovuuhXKTWVgw0amMf5VePxYN4MgA/Q4fQzPRgMmc3ECPDeKke7TlVvJA8Z9uoVXAZXIVnw7ePQexCABs9YxIhNeBNDJQuVNdbt4y/z3wpHyAwM8jC9Dtna1h6sZq67YHt9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711389615; c=relaxed/simple;
	bh=5eUeR9aSNOPF1X4k8AT5sg302Fg2m5BMkefpCisF17M=;
	h=Date:To:From:Subject:Message-Id; b=SIglLm9QB5BXDqG4BlD7BA8DANaoB+S6rpUaaiOd1VkezdL65yVy+4OTHVqwPV+8NP8u216YJ/oDuL1XHME+CxzcOFlEYBbH/Cyn1Nv7yB4Wh80IOG6WE+mSObyfVfH5Kpdp4MELwqE6iAPjHacqe4U8sT4s8svNB45D/5xffHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cE+2LmJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cE+2LmJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E63C433C7;
	Mon, 25 Mar 2024 18:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711389614;
	bh=5eUeR9aSNOPF1X4k8AT5sg302Fg2m5BMkefpCisF17M=;
	h=Date:To:From:Subject:From;
	b=cE+2LmJmB9TPt7xQiOgLgL9xojxKebjJD+owHuq3n/lDVZ6wroNI9EIc23acmt3gU
	 5NfcEVAPk2rY2BE+JTGzGY47Si/mMJ1NIAYSEdZWou/1jdcjJIYIY3guaqohFD46RR
	 qu9na0Qkax/xPU1FLaxnLh47ON++k9indTW+XB1g=
Date: Mon, 25 Mar 2024 11:00:14 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch added to mm-unstable branch
Message-Id: <20240325180014.D0E63C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-turn-folio_test_hugetlb-into-a-pagetype-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-turn-folio_test_hugetlb-into-a-pagetype-fix
Date: Mon, 25 Mar 2024 15:33:38 +0000

update vmcoreinfo

Link: https://lkml.kernel.org/r/ZgGZUvsdhaT1Va-T@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/vmcore_info.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/vmcore_info.c~mm-turn-folio_test_hugetlb-into-a-pagetype-fix
+++ a/kernel/vmcore_info.c
@@ -205,11 +205,10 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_NUMBER(PG_head_mask);
 #define PAGE_BUDDY_MAPCOUNT_VALUE	(~PG_buddy)
 	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
-#ifdef CONFIG_HUGETLB_PAGE
-	VMCOREINFO_NUMBER(PG_hugetlb);
+#define PAGE_HUGETLB_MAPCOUNT_VALUE	(~PG_hugetlb)
+	VMCOREINFO_NUMBER(PAGE_HUGETLB_MAPCOUNT_VALUE);
 #define PAGE_OFFLINE_MAPCOUNT_VALUE	(~PG_offline)
 	VMCOREINFO_NUMBER(PAGE_OFFLINE_MAPCOUNT_VALUE);
-#endif
 
 #ifdef CONFIG_KALLSYMS
 	VMCOREINFO_SYMBOL(kallsyms_names);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-increase-folio-batch-size.patch
mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch

