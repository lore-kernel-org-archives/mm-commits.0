Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9ED93090FD
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675082; cv=none; b=a/PiJtpcfvQT22rJmKs+ELfW7TvlD7MimmAKopNgCGLJAoeXD52qzWyJIV/2PrlPaMJo7I4lv0J83qLggmuI3uhdGNEelGyEbmdZC+NZPf8RvdpaLocN+0KReyJxtROLJqVhK/k4XPx9eS4WdZi58eSlAveJ75VsOtmIg5t3s7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675082; c=relaxed/simple;
	bh=mda7uq/rbN136fiX/fdFNMeWaN/1+u3ccA3GMJ1a+eY=;
	h=Date:To:From:Subject:Message-Id; b=stVKGv4t4j7yFIXThaW6YUSYUDgVv1eJkmE4h3OsSLI9BUTtU2w2NstXYAHtmtllaDF4Z2levkEIEWXSJMWjZQlyVq8Zpdt78b93vTtTYYJ/3j9vP+t7IKowm0Pqi8LG7r7mMM2E1ZazFsWrgrbr/KwpXmbZlXEAPppikbE0w5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m6HCx1Du; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m6HCx1Du"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D74C116B1;
	Thu, 20 Nov 2025 21:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675082;
	bh=mda7uq/rbN136fiX/fdFNMeWaN/1+u3ccA3GMJ1a+eY=;
	h=Date:To:From:Subject:From;
	b=m6HCx1DuPvmCfAKXo9oJJXkyjYwoUM3dhf4uebL8mJqxnzE8wmZJ8Xm5/ScSmmE2N
	 3fCvtCxe5406L3gvj4WQLLZj94GPmiPfijuP5wQdGnzxmLJbxr7OsXTINRqYfnMmfJ
	 aa14XvACZ49PEPDQhGwSMFpJWSPSuXgUcET502Nc=
Date: Thu, 20 Nov 2025 13:44:41 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,david@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-constify-__dump_folio-arguments.patch removed from -mm tree
Message-Id: <20251120214442.67D74C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: constify __dump_folio() arguments
has been removed from the -mm tree.  Its filename was
     mm-constify-__dump_folio-arguments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: constify __dump_folio() arguments
Date: Thu, 6 Nov 2025 20:35:25 +0000

These arguments aren't modified by the function; mark them as const to
help the compiler.

Link: https://lkml.kernel.org/r/20251106203526.2368275-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/debug.c~mm-constify-__dump_folio-arguments
+++ a/mm/debug.c
@@ -67,7 +67,7 @@ static const char *page_type_name(unsign
 	return page_type_names[i];
 }
 
-static void __dump_folio(struct folio *folio, struct page *page,
+static void __dump_folio(const struct folio *folio, const struct page *page,
 		unsigned long pfn, unsigned long idx)
 {
 	struct address_space *mapping = folio_mapping(folio);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-tweak-__vma_enter_locked.patch

