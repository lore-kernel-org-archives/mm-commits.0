Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8419825757
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957092; cv=none; b=hD5PZEEbjRKRE0BIQAfu/H0WB7Hp/bnKoNK3p1wfD3A95cuOJ8dw8aiJn4HzjNGU1Z4hp+D3drEsi+oyp8Nb8w1UPb59sw3ur/4YRHTfhYuBHr/qEkMWpjf1mwI7YtZirRSbviUgx8J4OT1ytnIt9UO81qQgyoOPb93wEOyjQ5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957092; c=relaxed/simple;
	bh=yfD2gFfhHlalSdPoDzgwZpQ0/7xtG8zvr5YmCXZ83t4=;
	h=Date:To:From:Subject:Message-Id; b=aG3u0O87jXxS/zIwSgcsB25hPzZ0unqKAajd1KyvnJg46W+6AtcttFoNvXey5Ew0VhXDMJbq+DE+E2PBfYggIUHfp6IHy5v/NWVnuSk0UbFW+q7K0VLbbLoAr/vPohgqfMCcjh5FVu9DxA5WULnObgV+LV46/Ltu+ysIWVNinos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LPtuZhY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LPtuZhY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5055DC116B1;
	Mon,  6 May 2024 00:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957092;
	bh=yfD2gFfhHlalSdPoDzgwZpQ0/7xtG8zvr5YmCXZ83t4=;
	h=Date:To:From:Subject:From;
	b=LPtuZhY0Zpkq0v8gl6Frka5lsk9Aye635vwgxNMPlQKLnics8ZU19k5hZvxzf+Cfk
	 OJDu1FNIba6hq/ZgzpN2nboXNZEW4kPOkFAKDR00KhDGlLU3euFBszprvh0gJ9zTSn
	 AbLYT0ZqXo3ELxnxltERNgZIDGyH1lozGR+0W/3Y=
Date: Sun, 05 May 2024 17:58:11 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,jane.chu@oracle.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch removed from -mm tree
Message-Id: <20240506005812.5055DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: add some folio conversions to unpoison_memory
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/memory-failure: add some folio conversions to unpoison_memory
Date: Fri, 12 Apr 2024 20:35:06 +0100

Some of these folio APIs didn't exist when the unpoison_memory()
conversion was done originally.

Link: https://lkml.kernel.org/r/20240412193510.2356957-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-add-some-folio-conversions-to-unpoison_memory
+++ a/mm/memory-failure.c
@@ -2556,8 +2556,8 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}
 
-	if (folio_test_slab(folio) || PageTable(&folio->page) ||
-	    folio_test_reserved(folio) || PageOffline(&folio->page))
+	if (folio_test_slab(folio) || folio_test_pgtable(folio) ||
+	    folio_test_reserved(folio) || folio_test_offline(folio))
 		goto unlock_mutex;
 
 	/*
@@ -2578,7 +2578,7 @@ int unpoison_memory(unsigned long pfn)
 
 	ghp = get_hwpoison_page(p, MF_UNPOISON);
 	if (!ghp) {
-		if (PageHuge(p)) {
+		if (folio_test_hugetlb(folio)) {
 			huge = true;
 			count = folio_free_raw_hwp(folio, false);
 			if (count == 0)
@@ -2594,7 +2594,7 @@ int unpoison_memory(unsigned long pfn)
 					 pfn, &unpoison_rs);
 		}
 	} else {
-		if (PageHuge(p)) {
+		if (folio_test_hugetlb(folio)) {
 			huge = true;
 			count = folio_free_raw_hwp(folio, false);
 			if (count == 0) {
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

