Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA7B8468
	for <mm-commits@vger.kernel.org>; Sun,  7 Jul 2024 02:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720318299; cv=none; b=pJpUHldmDc1CFYM4TLPcSBUeNNvbC3/nmrbkCb4ZtpDfYyMA/a9cARf4pJiNsyGkJ3xnOLwjmzZ6pBJDyhcUeciukxCQ2zvEkAZnkFQxvQuOu4WMTi94Zvs8ATmeLBTQjt7m4SKn+iPaAiyP35E3olywEvyRa0KWYCoZAuKghzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720318299; c=relaxed/simple;
	bh=/DFiBSEUHTKGKnRG+yMKrcyfLze1ELW2kSNprf2lKl4=;
	h=Date:To:From:Subject:Message-Id; b=d3WJ9jtH4A5t4Y07Bq9Zwvm19dDFGjOF95Le5Iu1VYvmuAs/gr5qNyWgDdxNJ8CcW/cBr/ONmSQnn6ARUaaCzR7kcYQ+BPUlQ+7sU/XYTiukIgXu8/Abv4pb/gGgbbNcrPh9sm8ELTzu5hlL/FYDXJH9STijyRuH5XnoAuW4tYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J/HiZguM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J/HiZguM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2322EC2BD10;
	Sun,  7 Jul 2024 02:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720318299;
	bh=/DFiBSEUHTKGKnRG+yMKrcyfLze1ELW2kSNprf2lKl4=;
	h=Date:To:From:Subject:From;
	b=J/HiZguMdQf/oLzVYdoigzbmD7Mkayd8K3u+qdLbZmeAYQc4N6rNbW9VuFbbYAmHX
	 2rWGB85R2+hgrLwbV15DrmvrAxn7beMcFM8Eu+HN4wXngLFpaj6Eky+dcjhZQlGv9s
	 z/Ze1Z1dSjAlpdHZF56GMoI8BozcJombYJgwPU9g=
Date: Sat, 06 Jul 2024 19:11:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,nphamcs@gmail.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-simplify-folio_migrate_mapping.patch added to mm-unstable branch
Message-Id: <20240707021139.2322EC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: simplify folio_migrate_mapping()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-simplify-folio_migrate_mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-simplify-folio_migrate_mapping.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm: simplify folio_migrate_mapping()
Date: Sat, 6 Jul 2024 14:29:00 -0700 (PDT)

Now that folio_undo_large_rmappable() is an inline function checking
order and large_rmappable for itself (and __folio_undo_large_rmappable()
is now declared even when CONFIG_TRANASPARENT_HUGEPAGE is off) there is
no need for folio_migrate_mapping() to check large and large_rmappable
first (in the mapping case when it has had to freeze anyway).

Link: https://lkml.kernel.org/r/68feee73-050e-8e98-7a3a-abf78738d92c@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/migrate.c~mm-simplify-folio_migrate_mapping
+++ a/mm/migrate.c
@@ -438,8 +438,7 @@ static int __folio_migrate_mapping(struc
 	}
 
 	/* Take off deferred split queue while frozen and memcg set */
-	if (folio_test_large(folio) && folio_test_large_rmappable(folio))
-		folio_undo_large_rmappable(folio);
+	folio_undo_large_rmappable(folio);
 
 	/*
 	 * Now we know that no one else is looking at the folio:
_

Patches currently in -mm which might be from hughd@google.com are

mm-simplify-folio_migrate_mapping.patch

