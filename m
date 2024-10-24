Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22D83C47B
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 03:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729740586; cv=none; b=XBFNzDDiLWxzyqDqPhzS4DWiVikoTrOETsiYOWhfoxI94Dy/5foSSuEJ+s+ypLrbRBbMWB1bi3WgzVmAzpnxAsk0xXoQTv7gxSDKygaTECp8By8iLIioDUi2+DAK1e0b4BUEmePEHpPEe1VL+lRsxTg58/9EgsUGFR6L0JkRMPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729740586; c=relaxed/simple;
	bh=Iyd1WApJ2V+yTrcEk8BGemuMiu7cZg1ExbvuEb7Q5TI=;
	h=Date:To:From:Subject:Message-Id; b=aITbXYkbZG0bYq38zXLcefXThHjY6szBEQ9RuEabWnA4dOU1Pl1RH3Vg/lCUZlMX0qeNq2RZ4ZNCe+W610sBwoucxrYci5A7lOgcmxE2IL2OJONPhOZYQEom+cSZwvu2LWTz+v59n1XO+exX/CUsdlwLbMP3VAfXnUGaa5mx73g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mr7kAZIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mr7kAZIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9061AC4CEC7;
	Thu, 24 Oct 2024 03:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729740586;
	bh=Iyd1WApJ2V+yTrcEk8BGemuMiu7cZg1ExbvuEb7Q5TI=;
	h=Date:To:From:Subject:From;
	b=Mr7kAZIKOmzB66GPyXiIP1gOgbp2NaLoQ/YA/5ekyLkIEWEgXWOx1bA554qK8xJ6N
	 X6JB7GwS7LBUe1ZvLUHfNsAb6Zx6+cCQY+em9aMnmEKxa6WpWGXjTsfyAHRmyHd0Gl
	 NctdU0NqPx7brZK4wko1DX8Wsr4rt1pyxs7hj8jk=
Date: Wed, 23 Oct 2024 20:29:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,alexs@kernel.org,cuigaosheng1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-convert-cmp_and_merge_page-to-use-a-folio-fix.patch added to mm-unstable branch
Message-Id: <20241024032946.9061AC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: add missing IS_ERR_OR_NULL check for stable_tree_search()
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-convert-cmp_and_merge_page-to-use-a-folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-convert-cmp_and_merge_page-to-use-a-folio-fix.patch

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
From: Gaosheng Cui <cuigaosheng1@huawei.com>
Subject: mm/ksm: add missing IS_ERR_OR_NULL check for stable_tree_search()
Date: Thu, 24 Oct 2024 11:23:00 +0800

The stable_tree_search() maybe return -EBUSY if the stable node's page is
being migrated or nullptr, we need to check kfolio with IS_ERR_OR_NULL()
before dereference it.

To mitigate this, add IS_ERR_OR_NULL check for stable_tree_search().

Link: https://lkml.kernel.org/r/20241024032300.2501949-1-cuigaosheng1@huawei.com
Fixes: ("ksm: convert cmp_and_merge_page() to use a folio")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/ksm.c~ksm-convert-cmp_and_merge_page-to-use-a-folio-fix
+++ a/mm/ksm.c
@@ -1787,7 +1787,7 @@ static __always_inline struct folio *cha
  * with identical content to the page that we are scanning right now.
  *
  * This function returns the stable tree node of identical content if found,
- * NULL otherwise.
+ * -EBUSY if the stable node's page is being migrated, NULL otherwise.
  */
 static struct folio *stable_tree_search(struct page *page)
 {
@@ -2261,7 +2261,8 @@ static void cmp_and_merge_page(struct pa
 
 	/* Start by searching for the folio in the stable tree */
 	kfolio = stable_tree_search(page);
-	if (&kfolio->page == page && rmap_item->head == stable_node) {
+	if (!IS_ERR_OR_NULL(kfolio) && &kfolio->page == page &&
+	    rmap_item->head == stable_node) {
 		folio_put(kfolio);
 		return;
 	}
_

Patches currently in -mm which might be from cuigaosheng1@huawei.com are

ksm-convert-cmp_and_merge_page-to-use-a-folio-fix.patch

