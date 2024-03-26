Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A8020B20
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711476493; cv=none; b=OpiLZSuQ+IZmUAxLzJwnl7yqeKAdlJkOXmvIDuvJFGwitg6uypjTQLlgm2ZsRKYYYsDEDHBDn6LfEUU78Mh2yfMDzqmr82K3nLwiSYFpmvhqRMTOOCQ6Q5jJIcugTuaeZhtPwWVsJKTvLimCNfpEkhe92A9n31271ZPl+eLRFns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711476493; c=relaxed/simple;
	bh=+es8CXGqfeyr+ZyFp3JWx/sJtuFTSLrsfYT1mEcxTJ8=;
	h=Date:To:From:Subject:Message-Id; b=HYEDBh4aQNZUT7oPSydalNGeAxMKBE6m2Wng6Ig/WsNn41/L7jBU5HICLC6OQ5mSFd1coeHy/A3Cp8yNVKcADwUGN2PFCPYiwwJsqVetk8PuakClwvj676dwk8EFzcFezVFZlhKQq/0+P021HgAHWDQ09Biq39JefXMTzq25h/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DHWY9J6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DHWY9J6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B38EC433F1;
	Tue, 26 Mar 2024 18:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711476493;
	bh=+es8CXGqfeyr+ZyFp3JWx/sJtuFTSLrsfYT1mEcxTJ8=;
	h=Date:To:From:Subject:From;
	b=DHWY9J6HImI4dhDuM8IZl714ZmHvoUXKYQYbv1T0K75+BNvDHhMJz4OTJZJZsnC++
	 Wlkgx3k/3Qn+ZmotAEvl3KCLqj49KSMeXsqYZYTFvAjwscNuf2FuRvWRf+dUmEr5I2
	 vriFdtuG+Z50T2pkHJ5N7l2ROfVF0EqXJmkPTvsI=
Date: Tue, 26 Mar 2024 11:08:12 -0700
To: mm-commits@vger.kernel.org,yujie.liu@intel.com,oliver.sang@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-increase-folio-batch-size.patch removed from -mm tree
Message-Id: <20240326180813.4B38EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: increase folio batch size
has been removed from the -mm tree.  Its filename was
     mm-increase-folio-batch-size.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: increase folio batch size
Date: Fri, 15 Mar 2024 14:08:21 +0000

On a 104 thread, 2 socket Skylake system, Intel report a 4.7% performance
reduction with will-it-scale page_fault2.  This was due to reducing the
size of the batch from 32 to 15.  Increasing the folio batch size from 15
to 31 gives a performance increase of 12.5% relative to the original, or
17.2% relative to the reduced performance commit.

The penalty of this commit is an additional 128 bytes of stack usage.  Six
folio_batches are also allocated from percpu memory in cpu_fbatches so
that will be an additional 768 bytes of percpu memory (per CPU).  Tim Chen
originally submitted a patch like this in 2020:
https://lore.kernel.org/linux-mm/d1cc9f12a8ad6c2a52cb600d93b06b064f2bbc57.1593205965.git.tim.c.chen@linux.intel.com/

Link: https://lkml.kernel.org/r/20240315140823.2478146-1-willy@infradead.org
Fixes: 99fbb6bfc16f ("mm: make folios_put() the basis of release_pages()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Yujie Liu <yujie.liu@intel.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202403151058.7048f6a8-oliver.sang@intel.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/pagevec.h~mm-increase-folio-batch-size
+++ a/include/linux/pagevec.h
@@ -11,8 +11,8 @@
 
 #include <linux/types.h>
 
-/* 15 pointers + header align the folio_batch structure to a power of two */
-#define PAGEVEC_SIZE	15
+/* 31 pointers + header align the folio_batch structure to a power of two */
+#define PAGEVEC_SIZE	31
 
 struct folio;
 
_

Patches currently in -mm which might be from willy@infradead.org are

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

