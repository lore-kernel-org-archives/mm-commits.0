Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7185218929
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731018915; cv=none; b=s6gc7No6Mop2hHGxhsX1xXuC14SKxQJdCv9V/vp9H5Fwt7jLnQMqhFp2dGpMOITA7Hl0ociNiKZI8Fubf55nPWl8giSqKnKu5yD3Pm5xofZcAqWoNJPaQNUPJ2OUp45153VouDt6eCGtl2Wi3u589+I/4yTLW1odcc+C3q29+/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731018915; c=relaxed/simple;
	bh=bw8rVCEGeTkWnFRC0x0ej2fHjpopep0GLcyVRiFFG20=;
	h=Date:To:From:Subject:Message-Id; b=i4H2Hx27/ugzvOW70+fM+o2W/UtXy097BsJrpIP/ElviE8acWPmiLF9a0cj1Hq52PHQwtExJr/BFnOIX/pbmF/geyDO0UvAi43lgkN1ZFT4rMFUhfaTt31XDYjZ2m81bWuGedhKWAdta/8djh0n+BtzZw3UkGDpZKb8ypDoK4Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ny051cx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ny051cx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2FCC4CECC;
	Thu,  7 Nov 2024 22:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731018915;
	bh=bw8rVCEGeTkWnFRC0x0ej2fHjpopep0GLcyVRiFFG20=;
	h=Date:To:From:Subject:From;
	b=Ny051cx9kLBJoU91v8DEN6Cvrvsy7s4tmt1Xj9n+8vm+qX2ZP4s8KTRFypJi9AGTc
	 w5CgXrdydd6taFjiz7tBgb2XO9ISlbTYuY/5MI5Ydbce1lhrc2VyrGlT+M5VxrukBc
	 dHUvBngy5v8+0J0bBgo/3w5qyNVtL0f7kRK33a58=
Date: Thu, 07 Nov 2024 14:35:14 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,lkp@intel.com,arnd@arndb.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] bootmem-stop-using-page-index-fix.patch removed from -mm tree
Message-Id: <20241107223515.2C2FCC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bootmem-stop-using-page-index-fix
has been removed from the -mm tree.  Its filename was
     bootmem-stop-using-page-index-fix.patch

This patch was dropped because it was folded into bootmem-stop-using-page-index.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bootmem-stop-using-page-index-fix
Date: Wed Oct  9 02:16:16 PM PDT 2024

fix arch/x86/mm/init_64.c build with !CONFIG_HAVE_BOOTMEM_INFO_NODE

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410090311.eaqcL7IZ-lkp@intel.com/
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/arch/x86/mm/init_64.c~bootmem-stop-using-page-index-fix
+++ a/arch/x86/mm/init_64.c
@@ -985,21 +985,32 @@ int arch_add_memory(int nid, u64 start,
 	return add_pages(nid, start_pfn, nr_pages, params);
 }
 
+static void free_reserved_pages(struct page *page, unsigned long nr_pages)
+{
+	while (nr_pages--)
+		free_reserved_page(page++);
+}
+
 static void __meminit free_pagetable(struct page *page, int order)
 {
 	/* bootmem page has reserved flag */
 	if (PageReserved(page)) {
-		enum bootmem_type type = bootmem_type(page);
 		unsigned long nr_pages = 1 << order;
+#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
+		enum bootmem_type type = bootmem_type(page);
 
 		if (type == SECTION_INFO || type == MIX_SECTION_INFO) {
 			while (nr_pages--)
 				put_page_bootmem(page++);
-		} else
-			while (nr_pages--)
-				free_reserved_page(page++);
-	} else
+		} else {
+			free_reserved_pages(page, nr_pages);
+		}
+#else
+		free_reserved_pages(page, nr_pages);
+#endif
+	} else {
 		free_pages((unsigned long)page_address(page), order);
+	}
 }
 
 static void __meminit free_hugepage_table(struct page *page,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

bootmem-stop-using-page-index.patch
vma-detect-infinite-loop-in-vma-tree-fix.patch
maple_tree-add-a-test-checking-storing-null-fix.patch

