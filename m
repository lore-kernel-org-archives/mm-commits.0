Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FDB2E11AE
	for <mm-commits@vger.kernel.org>; Fri, 13 Jun 2025 23:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749859165; cv=none; b=L1rloJfkl5wi2Jji6lhtGgbRYLicd+e3FUqw2N07JtqwPdggezoA0ZrlK20JHh3n9GGhSYqvqVoiTJqBJyDLFBuhUrEEp6Z33ZHqGRuLdZZ0IKLs/CY+y7z5eGC2nM5aa0y18cR3CZMz7ndsjLC6CGWYlcPtfo4cc94aRxFCtYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749859165; c=relaxed/simple;
	bh=b6zoZAdfdwBdx3TqJC6mlQvX1wCIb7AUuki4OAVX4/c=;
	h=Date:To:From:Subject:Message-Id; b=OvW3rnHvQ1UNhkdIz2xf58/Vpv9UgIOF7SgXwdA+KzAUKe/Re8LbO+Aypmjra5/5xxeSLB+uo1hNarS7fEi92RbGnZtdhx49qWKYmw5eTajmOIOJESx+KeDC+q76kC/nN8Z37G6rCw0K5HEdbqPIpgVMmddph5kRu00a9Kk3OGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pPgk9cIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pPgk9cIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E6FC4CEE3;
	Fri, 13 Jun 2025 23:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749859165;
	bh=b6zoZAdfdwBdx3TqJC6mlQvX1wCIb7AUuki4OAVX4/c=;
	h=Date:To:From:Subject:From;
	b=pPgk9cISYYZ8xeAaslayBsh4OiKSwbS2Wr0a1ueejnrmRa4nQl6uD3nfTFYlW39S8
	 zpDNwCyN6n62MfGprODld833NuN8waomMFXCAx9mzTMgdhCQnelTOFi6EChhs92uHj
	 gREshzMNuTkO+J5+BhUKaFxt/1Ozc1uOfRrpzCss=
Date: Fri, 13 Jun 2025 16:59:24 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,ptyadav@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-initialize-tail-pages-for-higher-order-folios-properly-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20250613235924.E5E6FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho-initialize-tail-pages-for-higher-order-folios-properly-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kho-initialize-tail-pages-for-higher-order-folios-properly-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-initialize-tail-pages-for-higher-order-folios-properly-v2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Pratyush Yadav <ptyadav@amazon.de>
Subject: kho-initialize-tail-pages-for-higher-order-folios-properly-v2
Date: Fri, 13 Jun 2025 14:59:06 +0200

declare i in the loop instead of at the top

Link: https://lkml.kernel.org/r/20250613125916.39272-1-pratyush@kernel.org
Fixes: fc33e4b44b271 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kexec_handover.c~kho-initialize-tail-pages-for-higher-order-folios-properly-v2
+++ a/kernel/kexec_handover.c
@@ -166,13 +166,13 @@ static int __kho_preserve_order(struct k
 /* almost as free_reserved_page(), just don't free the page */
 static void kho_restore_page(struct page *page, unsigned int order)
 {
-	unsigned int i, nr_pages = (1 << order);
+	unsigned int nr_pages = (1 << order);
 
 	/* Head page gets refcount of 1. */
 	set_page_count(page, 1);
 
 	/* For higher order folios, tail pages get a page count of zero. */
-	for (i = 1; i < nr_pages; i++)
+	for (unsigned int i = 1; i < nr_pages; i++)
 		set_page_count(page + i, 0);
 
 	if (order > 0)
_

Patches currently in -mm which might be from ptyadav@amazon.de are

maintainers-add-linux-mm-list-to-kexec-handover.patch
kho-initialize-tail-pages-for-higher-order-folios-properly.patch
kho-initialize-tail-pages-for-higher-order-folios-properly-v2.patch

