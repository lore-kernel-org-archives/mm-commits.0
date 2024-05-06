Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E41F25757
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957098; cv=none; b=MiZcu8eyQJqJJvKb+P4yPz3Kyc+osnUGd5Sexm/FiEcIztHwuNVHzajkJkSf/YQtv07gHlgjju2zuOjfKmyUF9AFD3AWCNb+LYPzib+aSMZCvbU0neOC2cpcUF1KL9+UYTCrRAWXPmlH+1mJoLX75flD0NDNbSsdY48nsyzNeSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957098; c=relaxed/simple;
	bh=YBj0hU/7QuDrhTcpZCUx252ze85qbohb5XVYsGMT0nw=;
	h=Date:To:From:Subject:Message-Id; b=OJvb3HbBPcyN1QlsRtxDeCqlMVuMYMsgcBzAVia8dFTYlqN5OF91kWL1z+SDEbNRqPWxk9G7oMnrQzlSq4uLx/kNCGKXk6S3xqhENRcSxmhUAhUENE6tOwnrvE0c9RTgylw7GzKrEMPG+sLA8xxS6Ss1R7HmQKOpRs7wPfbxY+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B/V/FyNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B/V/FyNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D6EC113CC;
	Mon,  6 May 2024 00:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957098;
	bh=YBj0hU/7QuDrhTcpZCUx252ze85qbohb5XVYsGMT0nw=;
	h=Date:To:From:Subject:From;
	b=B/V/FyNakKTZV2jGWTmVbrhc1iqPcrP74U8w7DWWMfDejbf1yihrW/CHGIIt/3L0f
	 gFH6twsDCoay/BhcqJPTgdnObkhR2ytqFnNYD97yZI/7Luhbz5PvZRytZA55xox1tw
	 O0Kq6OPczTOsRKMgPRwlaBE3B7lD2Z9nJYiQoKMQ=
Date: Sun, 05 May 2024 17:58:18 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,ebiggers@google.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch removed from -mm tree
Message-Id: <20240506005818.77D6EC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: migrate: expand the use of folio in __migrate_device_pages()
has been removed from the -mm tree.  Its filename was
     migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: migrate: expand the use of folio in __migrate_device_pages()
Date: Tue, 23 Apr 2024 23:55:35 +0100

Removes a few calls to compound_head() and a call to page_mapping().

Link: https://lkml.kernel.org/r/20240423225552.4113447-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/migrate_device.c~migrate-expand-the-use-of-folio-in-__migrate_device_pages
+++ a/mm/migrate_device.c
@@ -696,6 +696,7 @@ static void __migrate_device_pages(unsig
 		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
 		struct page *page = migrate_pfn_to_page(src_pfns[i]);
 		struct address_space *mapping;
+		struct folio *folio;
 		int r;
 
 		if (!newpage) {
@@ -730,15 +731,12 @@ static void __migrate_device_pages(unsig
 			continue;
 		}
 
-		mapping = page_mapping(page);
+		folio = page_folio(page);
+		mapping = folio_mapping(folio);
 
 		if (is_device_private_page(newpage) ||
 		    is_device_coherent_page(newpage)) {
 			if (mapping) {
-				struct folio *folio;
-
-				folio = page_folio(page);
-
 				/*
 				 * For now only support anonymous memory migrating to
 				 * device private or coherent memory.
@@ -761,11 +759,10 @@ static void __migrate_device_pages(unsig
 
 		if (migrate && migrate->fault_page == page)
 			r = migrate_folio_extra(mapping, page_folio(newpage),
-						page_folio(page),
-						MIGRATE_SYNC_NO_COPY, 1);
+						folio, MIGRATE_SYNC_NO_COPY, 1);
 		else
 			r = migrate_folio(mapping, page_folio(newpage),
-					page_folio(page), MIGRATE_SYNC_NO_COPY);
+					folio, MIGRATE_SYNC_NO_COPY);
 		if (r != MIGRATEPAGE_SUCCESS)
 			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

