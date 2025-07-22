Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CD127EC78
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 20:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753215457; cv=none; b=DkjC4hH5aIWzxQwqEP+carwnNHMWuWFQjDXt8XZrdYcFMpqiVV+yvHUuKi+bHtVf0kgQ9AA0wNRa6HLCwwNQoggl7inQhjUHiioPmlizgDtpPYS7raG0Uw9iv/K4nWHUekVgvWPuI1KCVvm21QyqEAdXHevJafm1L8EXo8HV6MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753215457; c=relaxed/simple;
	bh=wAlUBYG073XtiYvYY8eLS1KKbJN+OVCR4njykh8VnEQ=;
	h=Date:To:From:Subject:Message-Id; b=sEI3WcqHgJ07XvgaXHQARN6OxKxYPzLfE+pHhICESsz7WNZYLUo77CEcQ2D8Lx3SxaRgrx0oLSgF5t73WGU3+dJnXpztyYopysdhLR1obUok7ErWuNQNIEFX4Voq4yFrBxaa2rw4BgHpVEc8qCSokgh6ok0r8xZTzylvCouhu30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wfQRlyXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wfQRlyXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487F1C4CEEB;
	Tue, 22 Jul 2025 20:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753215454;
	bh=wAlUBYG073XtiYvYY8eLS1KKbJN+OVCR4njykh8VnEQ=;
	h=Date:To:From:Subject:From;
	b=wfQRlyXOPHQ6Ca7IHgnLl3eZnb30vTlE4dPbDjfSal2DfxAd2ueOW8ZNmdYrj9gk2
	 JlYgi/x2cmZl/gfQVJB3BB3S9ykTpqX6h50qzPejw9eSDfobYYJ5AQQsG3eR07DGwm
	 pM3kNcd3FaNhOA+hYMZHrXHS4PsXoWR+PwvNS76I=
Date: Tue, 22 Jul 2025 13:17:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page-flags-remove-folio_start_writeback_keepwrite.patch added to mm-unstable branch
Message-Id: <20250722201734.487F1C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page-flags: remove folio_start_writeback_keepwrite()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page-flags-remove-folio_start_writeback_keepwrite.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page-flags-remove-folio_start_writeback_keepwrite.patch

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
From: Joanne Koong <joannelkoong@gmail.com>
Subject: mm/page-flags: remove folio_start_writeback_keepwrite()
Date: Tue, 22 Jul 2025 11:22:30 -0700

Commit cd57b77197a4 ("ext4: Convert ext4_bio_write_page() to use a folio)
removed set_page_writeback_keepwrite() which was the last/only caller of
folio_start_writeback_keepwrite().

Link: https://lkml.kernel.org/r/20250722182230.2114587-1-joannelkoong@gmail.com
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/page-flags.h~mm-page-flags-remove-folio_start_writeback_keepwrite
+++ a/include/linux/page-flags.h
@@ -837,8 +837,6 @@ void set_page_writeback(struct page *pag
 
 #define folio_start_writeback(folio)			\
 	__folio_start_writeback(folio, false)
-#define folio_start_writeback_keepwrite(folio)	\
-	__folio_start_writeback(folio, true)
 
 static __always_inline bool folio_test_head(const struct folio *folio)
 {
_

Patches currently in -mm which might be from joannelkoong@gmail.com are

mm-page-flags-remove-folio_start_writeback_keepwrite.patch

