Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF652E62AE
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 22:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743718789; cv=none; b=e1bSpgA55TR33yyA7cXbpIU9JASkQGkq92wFexaivr9gr67j5pCaeNBYbodxfZVE7lYLrfaGygAhI+KhcSt7r7cfCvrbefH3tX/JoMoivmJaGqlS1V8qaGhDHhw5IvtfqMZP/JXxulee1VOIz/8HmqUGI39TJDnVYRf2TwaNRG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743718789; c=relaxed/simple;
	bh=zQRQhsWQMI8fpQmdy2GoAqzSx1UrsSVaFNbUzVeh+m4=;
	h=Date:To:From:Subject:Message-Id; b=WEhcvxDfbz0dIN8Ep/sgETeWAeDibIHiF5eZthUngAf3vT2Z3D862jSTRXnaZcWPTWEJghAhisiiJv09Xg7shFiVBQlLETy2CPhbVK+cVlYxVj9vy35Jp39s3qMVuvDJJ5Nb2lfghKEqEelmeiYdh+4RhhCRYfZDgU3GC12jmzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x3pLexzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x3pLexzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3CFC4CEE3;
	Thu,  3 Apr 2025 22:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743718788;
	bh=zQRQhsWQMI8fpQmdy2GoAqzSx1UrsSVaFNbUzVeh+m4=;
	h=Date:To:From:Subject:From;
	b=x3pLexzJJx+PiqZsXEpmdAAJzsEhrPqFiy0Kb8Hf5UbhUU8z6K0n4cyScsUANeBx1
	 CirDK0EQ/F6vqQaqVr9YM7+MmWWJDn+mPgwZ0b5YIXlq4///gGNnP32G7LGE7HDVqi
	 cTNChw7RmyWjpymZV9m1cby+BA237HZjIHljl/hE=
Date: Thu, 03 Apr 2025 15:19:47 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,anshuman.khandual@arm.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-simplify-free_page_is_bad-by-removing-free_page_is_bad_report.patch added to mm-new branch
Message-Id: <20250403221948.8D3CFC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: simplify free_page_is_bad by removing free_page_is_bad_report
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-simplify-free_page_is_bad-by-removing-free_page_is_bad_report.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-simplify-free_page_is_bad-by-removing-free_page_is_bad_report.patch

This patch will later appear in the mm-new branch at
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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/page_alloc: simplify free_page_is_bad by removing free_page_is_bad_report
Date: Fri, 28 Mar 2025 09:20:31 +0800

Refactor free_page_is_bad() to call bad_page() directly, removing the
intermediate free_page_is_bad_report(). This reduces unnecessary
indirection, improving code clarity and maintainability without changing
functionality.

Link: https://lkml.kernel.org/r/20250328012031.1204993-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-simplify-free_page_is_bad-by-removing-free_page_is_bad_report
+++ a/mm/page_alloc.c
@@ -933,19 +933,13 @@ static const char *page_bad_reason(struc
 	return bad_reason;
 }
 
-static void free_page_is_bad_report(struct page *page)
-{
-	bad_page(page,
-		 page_bad_reason(page, PAGE_FLAGS_CHECK_AT_FREE));
-}
-
 static inline bool free_page_is_bad(struct page *page)
 {
 	if (likely(page_expected_state(page, PAGE_FLAGS_CHECK_AT_FREE)))
 		return false;
 
 	/* Something has gone sideways, find it */
-	free_page_is_bad_report(page);
+	bad_page(page, page_bad_reason(page, PAGE_FLAGS_CHECK_AT_FREE));
 	return true;
 }
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-show_mem-optimize-si_meminfo_node-by-reducing-redundant-code.patch
mm-page_alloc-simplify-free_page_is_bad-by-removing-free_page_is_bad_report.patch

