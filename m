Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEC31EB3D;
	Sat, 15 Jun 2024 17:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473428; cv=none; b=jKugGkj8o0pNomIxBld19dOI/IrCUMlvViit8Uz8dxju//vZNJCSwWEA5hOKVfgWtcYwQvM0JmmiN0aXeM6ljzulMo5ADWdWMVgW57fRT7DA5AFBeE+LdYK5RAH2QM/XxXNCuRqXKZlCgWfqoIhtrHzbsRar5L5XO70UNJ7hKgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473428; c=relaxed/simple;
	bh=ULSvVxtGaCm1DI5+QeSX39fRYQTep27pYtir+PsfNGA=;
	h=Date:To:From:Subject:Message-Id; b=ntdY6dEPEbKs+iegJGZo3tHtikQMYzdtaXdElvDR1ZNBOsCXAcSCBw8Pyj1c30Zd0sRGNr/TGjfebVAQZh/p/nJyWFcoquKMTApL+2PzUexXRXhHxGdrGQQFXJLv4Lukir3tYG367Mp+FiUMBrZnOPNG2XxC98p1B13AuGfrxcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bOaz76Es; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bOaz76Es"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CA7C116B1;
	Sat, 15 Jun 2024 17:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473428;
	bh=ULSvVxtGaCm1DI5+QeSX39fRYQTep27pYtir+PsfNGA=;
	h=Date:To:From:Subject:From;
	b=bOaz76EsMQY+Bo3wXwhvsN/QxKXwhEUnKCHllY3D66TvE8ykB8v2iu597ziAw57Ba
	 K5uGeBMsJeiSXZiSz/FA1nKYpE0aXGlhiJQN3gRGCkJWKjGOEcnem8TbWHD4aLV/ss
	 E0eKFio0qRXF8XBfZI4vbh6HGT+DRb++QhRbAnJo=
Date: Sat, 15 Jun 2024 10:43:47 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pasha.tatashin@soleen.com,dan.j.williams@intel.com,apopple@nvidia.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_table_check-fix-crash-on-zone_device.patch removed from -mm tree
Message-Id: <20240615174348.41CA7C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_table_check: fix crash on ZONE_DEVICE
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-fix-crash-on-zone_device.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: df4e817b7108 ("mm: page table check")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
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

mm-drop-leftover-comment-references-to-pxx_huge.patch

