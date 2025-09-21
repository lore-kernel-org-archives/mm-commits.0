Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FFB21D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489993; cv=none; b=KwN20xwHCB1yi6ChoMiK5xysHaUY0gYyjqf8L8IIajbF/NhBJoFIDmGibpZEQxlNj/dCUF5/7hI1pt25321rVYdMgoFvPjw4IA34z+YDo097FBvZG9uWO/VMJzm+Htgf3zvvpevOo5vfUrpUr6/1xqfqdplDeBPbY4+E8TFVX6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489993; c=relaxed/simple;
	bh=kgm3h4NbriXsCiHpJmm3PpHajAtA8t4+ZUAhe9kfiP8=;
	h=Date:To:From:Subject:Message-Id; b=mlBN+XV2yqlQRCsa8+fMfPN+9ZYq90PCHt8RzAt08VbPRAowewRlN9Bwalz3fjyrZGNEpIJVZUWY2oDshNvFTq+M6MIfgWGO/+dckml58b++vWwj2AjrONaOgjkgnRi1zNfQ6SerrwtFAx0zenNIwa6OD+4A+L82iiRsmfcubnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rVWdZ5Ir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rVWdZ5Ir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1923AC4CEE7;
	Sun, 21 Sep 2025 21:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489993;
	bh=kgm3h4NbriXsCiHpJmm3PpHajAtA8t4+ZUAhe9kfiP8=;
	h=Date:To:From:Subject:From;
	b=rVWdZ5Iri7dZrcpSGQJTsdVReSpdh1R6KSqhhYfaLTewylf3GH7FBcjqif9tJPXno
	 l5cIhRTMAg6IAS61vvyCM7N11fweNGd0Guxz6vwBNU3G7ofHNSUNXxaPqrrax4qF95
	 H9zPFwSnqjucvy/I2cy499VH5msmwBWVoC+0pyBk=
Date: Sun, 21 Sep 2025 14:26:32 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-redundant-test-in-validate_page_before_insert.patch removed from -mm tree
Message-Id: <20250921212633.1923AC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove redundant test in validate_page_before_insert()
has been removed from the -mm tree.  Its filename was
     mm-remove-redundant-test-in-validate_page_before_insert.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove redundant test in validate_page_before_insert()
Date: Wed, 10 Sep 2025 15:29:18 +0100

The page_has_type() call would have included slab since commit
46df8e73a4a3 and now we don't even get that far because slab pages have a
zero refcount since commit 9aec2fb0fd5e.

Link: https://lkml.kernel.org/r/20250910142923.2465470-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory.c~mm-remove-redundant-test-in-validate_page_before_insert
+++ a/mm/memory.c
@@ -2266,8 +2266,7 @@ static int validate_page_before_insert(s
 			return -EINVAL;
 		return 0;
 	}
-	if (folio_test_anon(folio) || folio_test_slab(folio) ||
-	    page_has_type(page))
+	if (folio_test_anon(folio) || page_has_type(page))
 		return -EINVAL;
 	flush_dcache_folio(folio);
 	return 0;
_

Patches currently in -mm which might be from willy@infradead.org are

ksm-use-a-folio-inside-cmp_and_merge_page.patch

