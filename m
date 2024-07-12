Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCD612EBF5
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824899; cv=none; b=T4qT7GdgVw3VzAY19WYqtSysqOQrnitqkq+qSzt6ksPivD+vx/TiJ18ydDX9b6Y/Wu5q/ey8I9lkJgOtfuoYrGWB/HmXwqDZ4eKRlTNJIXxil0BrY4zqq9Ov/7H4xwqT8fmL7U+xuRI0CxtAkI48Xix6CEKWey246wim1bNCN84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824899; c=relaxed/simple;
	bh=rdlQsBAT01KgdfiYDA/XVVZT7aQLScPpX0sMXmqAKrw=;
	h=Date:To:From:Subject:Message-Id; b=mYHj9lOrCoRj9+nGLT5N2kAY/0hiICXYcMJLZueC5OXpqFc9mzbtOoIo9ge8jCRjbP5UCSMbwuIf5XbzlP1JTD2wp1l0DdZ3esFcJOOiBRfypNjP2Yo8j/JhWwCkpJUXhIaRb/FH4giYnMupvBx03dqUO4iRT5CkAVgiInQ9SuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ryTwcvIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ryTwcvIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25E3C32782;
	Fri, 12 Jul 2024 22:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824898;
	bh=rdlQsBAT01KgdfiYDA/XVVZT7aQLScPpX0sMXmqAKrw=;
	h=Date:To:From:Subject:From;
	b=ryTwcvIhHwaamOsixMBHBaesI/yP9etsqMavbPymQMUNuLQVqwGh90bL4EO/D7OnR
	 JB85J54VTk4OF1/2egAyfBVQJ57NknkknOXh3WYF5hQm03FWCQProXV20VxWchPFeg
	 AlmowDaCqbwk4RGPurTOUQ/X8wEfFOm6+dpXyqcE=
Date: Fri, 12 Jul 2024 15:54:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,nphamcs@gmail.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-simplify-folio_migrate_mapping.patch removed from -mm tree
Message-Id: <20240712225458.C25E3C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: simplify folio_migrate_mapping()
has been removed from the -mm tree.  Its filename was
     mm-simplify-folio_migrate_mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


