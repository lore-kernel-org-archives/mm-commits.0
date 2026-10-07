Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634602F7F01;
	Wed,  7 Oct 2026 00:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334327; cv=none; b=q+jyEEWt5m+ZZk6YKfuS+Bai7tFP0Sf1MfSmISIGrkFU3nDM0nKnXgL1W0cb2AwsmAvxYgRBHGZsJhQJLRbT14DRYX5AiF1GIV/0IOpWW9JP55he7CKbhGosT3KQNQoFHbWarlPnPgjRrNyp7WqImS+7DH0r4NUdfRLJkJQtMKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334327; c=relaxed/simple;
	bh=LOhu/qpeb2fnALucy46mPwI1UuV80iSA2i5iSb8PM64=;
	h=Date:To:From:Subject:Message-Id; b=PzNxp8h6z8tNqeXcbFEO+vBnM+0ECkkLtpZZDOwZAV2X2SqJ8OiiGm/F9BXhw5dDd9HGMgDD01cjxJHqQHVeTHO8JQKEnY6D8bJQyzW5rNfxeIEyQSrMRrNMscM/Wccy8ZPP/B7V38s3mNSPm8NrCe2leJnYX0aePzP1Wn56H3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LGWOWnYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LGWOWnYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CB41F008A3;
	Wed,  7 Oct 2026 00:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334326;
	bh=FLyM1HRxah/6l4q2JRzLvBXNhnByqSohY/OoyaVralY=;
	h=Date:To:From:Subject;
	b=LGWOWnYDBljWAWs5GStdXuwVLeqjweIoUuLVtfWGV/8XpxBwlsfJZF1ULVJeNNSCa
	 q2FGOEwVfGQi6OQObGz+l4u72adpfk0K40R5XgZ+W+I3xv9yRM7uNqpA0Mvo0xk4wa
	 DMM4jovHUlcf+oKYApVg4eJKqSJjqRXcmlxzllNk=
Date: Tue, 06 Oct 2026 17:52:05 -0700
To: mm-commits@vger.kernel.org,vega@nebusec.ai,stable@vger.kernel.org,liuye@kylinos.cn,enjou1224z@gmail.com,roxy520tt@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_table_check-skip-zero-pages.patch removed from -mm tree
Message-Id: <20261007005206.38CB41F008A3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_table_check: skip zero pages
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-skip-zero-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhiling Zou <roxy520tt@gmail.com>
Subject: mm/page_table_check: skip zero pages
Date: Tue, 21 Jul 2026 23:56:38 +0800

page_table_check_set() accounts pages by whether they are PageAnon().  The
shared zero page is a special page, not an ordinary file-backed page. 
Read faults on private anonymous mappings can install many read-only PTEs
that point at the zero page, but page_table_check currently accounts them
in file_map_count.

That lets an unprivileged process populate enough zero-page mappings to
overflow file_map_count and trip the BUG_ON() in page_table_check_set().

Skip zero pages in page_table_check accounting.  They do not need the
anonymous/file mapping conflict checks that page_table_check performs for
ordinary pages, and this keeps the existing counter size and page_ext
layout unchanged.

Link: https://lore.kernel.org/1f8848512d2e3ded944f8d595c29faee8fdaeab0.1784645969.git.roxy520tt@gmail.com
Fixes: df4e817b7108 ("mm: page table check")
Signed-off-by: Zhiling Zou <roxy520tt@gmail.com>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Cc: Ye Liu <liuye@kylinos.cn>
Cc: <stable@vger.kernel.org>
---

 mm/page_table_check.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_table_check.c~mm-page_table_check-skip-zero-pages
+++ a/mm/page_table_check.c
@@ -67,7 +67,7 @@ static void page_table_check_clear(unsig
 	struct page *page;
 	bool anon;
 
-	if (!pfn_valid(pfn))
+	if (!pfn_valid(pfn) || is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
 		return;
 
 	page = pfn_to_page(pfn);
@@ -102,7 +102,7 @@ static void page_table_check_set(unsigne
 	struct page *page;
 	bool anon;
 
-	if (!pfn_valid(pfn))
+	if (!pfn_valid(pfn) || is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
 		return;
 
 	page = pfn_to_page(pfn);
_

Patches currently in -mm which might be from roxy520tt@gmail.com are


