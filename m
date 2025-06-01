Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D416ADD
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756812; cv=none; b=uC030eH4nENXaBF6yAj24zTxihGgDk9+d3GWJaUE4os9TDzQKO6tp1V/f78ykNqJ42g6v0cB3J31GkWB1G2Kf2Ayl5CFaPsuW4ElUySy66Z7MPTtU5OsKiJMMEWxB9v0HCIlTtRpCqWa1IWQ30Q1qBwzrVBxan8cPKbJTtgN0D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756812; c=relaxed/simple;
	bh=JbMJl7wZZqMNLanARalE1ptiuZOZ217xe7FRRr6noKw=;
	h=Date:To:From:Subject:Message-Id; b=qyrPa8nV2A6FCmtQIha7cyoDJMDh1pTBAIYVorhKXl1IPEMYhxLXhz6yY/ZfWIyZnFV6McAZyBn0qwG4Ge4JFpGoh9TAGhxCxHU5nj1PWEcXUGDI15WUibkcmmWfkqnBiomUme7TwYC6ciVT5KiFf8T41mS5GLQLlS36pAOCRvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ZWvv/yn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ZWvv/yn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F53C4CEED;
	Sun,  1 Jun 2025 05:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756812;
	bh=JbMJl7wZZqMNLanARalE1ptiuZOZ217xe7FRRr6noKw=;
	h=Date:To:From:Subject:From;
	b=0ZWvv/yna/k2NG7pSGuTu/i9WCd/5kAOwpVTno5ESPdC4XN/B+xGZWgBSwtXeuMXO
	 YGsXtqGkAnojTVfKLvHRQRptOluIzdvQRMj1O7gZSYfs8MFSjD2BLzqEN8tJmKHcXd
	 PtMnCsd3Pg1I856q+ciO+jIiNKu7aSzdhQHqeud4=
Date: Sat, 31 May 2025 22:46:51 -0700
To: mm-commits@vger.kernel.org,geert@linux-m68k.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] m68k-remove-use-of-page-index.patch removed from -mm tree
Message-Id: <20250601054652.03F53C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: m68k: remove use of page->index
has been removed from the -mm tree.  Its filename was
     m68k-remove-use-of-page-index.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: m68k: remove use of page->index
Date: Fri, 16 May 2025 16:13:29 +0100

Switch to using struct ptdesc to store the markbits which will allow us to
remove index from struct page.

Link: https://lkml.kernel.org/r/20250516151332.3705351-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mm/motorola.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/m68k/mm/motorola.c~m68k-remove-use-of-page-index
+++ a/arch/m68k/mm/motorola.c
@@ -105,7 +105,8 @@ static struct list_head ptable_list[3] =
 
 #define PD_PTABLE(page) ((ptable_desc *)&(virt_to_page((void *)(page))->lru))
 #define PD_PAGE(ptable) (list_entry(ptable, struct page, lru))
-#define PD_MARKBITS(dp) (*(unsigned int *)&PD_PAGE(dp)->index)
+#define PD_PTDESC(ptable) (list_entry(ptable, struct ptdesc, pt_list))
+#define PD_MARKBITS(dp) (*(unsigned int *)&PD_PTDESC(dp)->pt_index)
 
 static const int ptable_shift[3] = {
 	7+2, /* PGD */
_

Patches currently in -mm which might be from willy@infradead.org are


