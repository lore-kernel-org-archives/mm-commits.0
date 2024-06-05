Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E673B1AB;
	Wed,  5 Jun 2024 22:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717625049; cv=none; b=QIC+26P9zd5+lZZCaakB0D1rQIYL2MAEmDBvHSeEnyzoRjcZbFEaWLenRfaFdn8pT6dtT8YujPz9K4ObFjOU0KCyQENEE08UiUqkuHfkA7Ze/+V23HBLpzTPWaoE9uAxYGnB4NRfYc101qB5Jvx92fKwlZIWk1MEBbIZSJj/mKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717625049; c=relaxed/simple;
	bh=RZioaYMJPvPZnCV3Q6RXiVh/YaDF6STFZSTPUk9xEZE=;
	h=Date:To:From:Subject:Message-Id; b=MvRS2ZlDY6l+hs//l7zCB85wXXehy1/XbC866v0uvi1FcVToZdFL64b4wRA5SGgSGJMjgKoX7cMcqxCTMsVlQIx2UUYoGfF0mkHeUGjxhXYiPKD7Q5eFCEyiiujmnhOp1kXH7DvYjDf1FRsSDBjcPpg2UMKWGkMHAMEgRhLhxfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gdB+LAMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gdB+LAMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9192FC2BD11;
	Wed,  5 Jun 2024 22:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717625048;
	bh=RZioaYMJPvPZnCV3Q6RXiVh/YaDF6STFZSTPUk9xEZE=;
	h=Date:To:From:Subject:From;
	b=gdB+LAMFeEc7OqgAnLfrE+GCYfGH0eR6JSQXPTI9DCPUIHrcHwieucIONtO34Pdst
	 bGpnJS1AF1+bRJDyYNuUeLqGegCTwtKt/x/Iy5TIJTdYebklDZqN0O/RVc+rjL8Sb8
	 kYw878CQi/S9hv0MQgYmzF/h22+1YsSkvJzsQg1Y=
Date: Wed, 05 Jun 2024 15:04:07 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pasha.tatashin@soleen.com,dan.j.williams@intel.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-fix-crash-on-zone_device.patch added to mm-hotfixes-unstable branch
Message-Id: <20240605220408.9192FC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_table_check: fix crash on ZONE_DEVICE
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_table_check-fix-crash-on-zone_device.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-fix-crash-on-zone_device.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/page_table_check: fix crash on ZONE_DEVICE
Date: Wed, 5 Jun 2024 17:21:46 -0400

Not all pages may apply to pgtable check.  One example is ZONE_DEVICE
pages: they map PFNs directly, and they don't allocate page_ext at all
even if there's struct page around.  One may reference
devm_memremap_pages().

When both ZONE_DEVICE and page-table-check enabled, then try to map some
dax memories, one can trigger kernel bug constantly now when the kernel
was trying to inject some pfn maps on the dax device:

 kernel BUG at mm/page_table_check.c:55!

While it's pretty legal to use set_pxx_at() for ZONE_DEVICE pages for page
fault resolutions, skip all the checks if page_ext doesn't even exist in
pgtable checker, which applies to ZONE_DEVICE but maybe more.

Link: https://lkml.kernel.org/r/20240605212146.994486-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/page_table_check.c~mm-page_table_check-fix-crash-on-zone_device
+++ a/mm/page_table_check.c
@@ -73,6 +73,9 @@ static void page_table_check_clear(unsig
 	page = pfn_to_page(pfn);
 	page_ext = page_ext_get(page);
 
+	if (!page_ext)
+		return;
+
 	BUG_ON(PageSlab(page));
 	anon = PageAnon(page);
 
@@ -110,6 +113,9 @@ static void page_table_check_set(unsigne
 	page = pfn_to_page(pfn);
 	page_ext = page_ext_get(page);
 
+	if (!page_ext)
+		return;
+
 	BUG_ON(PageSlab(page));
 	anon = PageAnon(page);
 
@@ -140,7 +146,10 @@ void __page_table_check_zero(struct page
 	BUG_ON(PageSlab(page));
 
 	page_ext = page_ext_get(page);
-	BUG_ON(!page_ext);
+
+	if (!page_ext)
+		return;
+
 	for (i = 0; i < (1ul << order); i++) {
 		struct page_table_check *ptc = get_page_table_check(page_ext);
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-page_table_check-fix-crash-on-zone_device.patch
mm-debug_vm_pgtable-drop-random_orvalue-trick.patch
mm-drop-leftover-comment-references-to-pxx_huge.patch

