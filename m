Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE0728DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489828; cv=none; b=EM6CTiB4zKnCqA2X0ZzW/SblL2/cafc1cezmPi/FAT3Yo7eCYubsd6scI53BNaZNy+QMrXkL1fQwBQ7eozZ00Ck6v6GEFVpfAFWA4Li2jbwH5TWEXvivltCthyI1DBXrY8Cl0ZayLTTgW8LJ2mQMwO3HAivSZH+W+QJOa/Qebjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489828; c=relaxed/simple;
	bh=eBQrdk7An6ClHkx+5GkQYTOSKwrgq3y3CqV034WnHfI=;
	h=Date:To:From:Subject:Message-Id; b=u6k2dawrAp/XhAkk+/j3iINnD2xCS7vxFMAylOKoRer5J35uPFsoR8YPU4YLB+hSfKWiarfUpZuTw5VSlhcN+vD2RMJn85A5M2UZ6VIqTV1gO5EzbhuijZ47GTXq1TI4H4lHRslUz6PIuqTOmI9qg2eugH0Nfu1dXlr27K3+LOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AmAaCNTT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AmAaCNTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74758C4CEE7;
	Sun, 21 Sep 2025 21:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489828;
	bh=eBQrdk7An6ClHkx+5GkQYTOSKwrgq3y3CqV034WnHfI=;
	h=Date:To:From:Subject:From;
	b=AmAaCNTT7Vgnvpp2bcd0rJo3O0eIot+GXTucZz8I/xHaj4wg6tDdZWAtMh4gP6STf
	 WuSwt20WdccH6tle2KszQcpt2Tdd0Fj8ueQtUilUbo7etkNZoJ/+xPwbDtejKiIAfE
	 VnXGR2dsEAOB8p4e50GoBklRr94XiLt1uAvKfbzs=
Date: Sun, 21 Sep 2025 14:23:47 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-drop-nth_page-usage-within-folio-when-recording-subpages.patch removed from -mm tree
Message-Id: <20250921212348.74758C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: drop nth_page() usage within folio when recording subpages
has been removed from the -mm tree.  Its filename was
     mm-gup-drop-nth_page-usage-within-folio-when-recording-subpages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: drop nth_page() usage within folio when recording subpages
Date: Mon, 1 Sep 2025 17:03:39 +0200

nth_page() is no longer required when iterating over pages within a single
folio, so let's just drop it when recording subpages.

Link: https://lkml.kernel.org/r/20250901150359.867252-19-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-gup-drop-nth_page-usage-within-folio-when-recording-subpages
+++ a/mm/gup.c
@@ -488,12 +488,11 @@ static int record_subpages(struct page *
 			   unsigned long addr, unsigned long end,
 			   struct page **pages)
 {
-	struct page *start_page;
 	int nr;
 
-	start_page = nth_page(page, (addr & (sz - 1)) >> PAGE_SHIFT);
+	page += (addr & (sz - 1)) >> PAGE_SHIFT;
 	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
-		pages[nr] = nth_page(start_page, nr);
+		pages[nr] = page++;
 
 	return nr;
 }
@@ -1512,7 +1511,7 @@ next_page:
 			}
 
 			for (j = 0; j < page_increm; j++) {
-				subpage = nth_page(page, j);
+				subpage = page + j;
 				pages[i + j] = subpage;
 				flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
 				flush_dcache_page(subpage);
_

Patches currently in -mm which might be from david@redhat.com are


