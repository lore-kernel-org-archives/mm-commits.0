Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BBA1684AE
	for <mm-commits@vger.kernel.org>; Wed,  9 Oct 2024 21:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728509696; cv=none; b=JJLBRk2T5ud2AeHR3qDs4XQApZz1dBrXELTQm2jjykzlO4nDfbzEKL4VLdR6a/WFuz5IR4rxKvgZ9UbfFNFnvb7JAEC9eGy16VKhJiCbZFbZkSQEAK/vx22ihqb5giJq4tD/ACMAWlWb7fANHETToajcIQmaNaHRHJtp30e1x2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728509696; c=relaxed/simple;
	bh=oDSfANP5f3JeoIP0L5dABahokG6l8mt3P+BxuwV8KL8=;
	h=Date:To:From:Subject:Message-Id; b=d6vT0wm7zwDIgXYz8YuZtvnvrUtoTB6BfH2Tr2nzfA9bCQQUtHBJqA/OJwobkW4DNEr5DzZX8mYEKT1wH8QX+nbDxpLzBi8XNUrkaJ5uQiNxw/ZQpG5auPkq17rD+2DIeWA2ebdRs819eLya37Xwslqo3MVNwExzJSHeTs6f64U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I1UC5E0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I1UC5E0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1719CC4CECC;
	Wed,  9 Oct 2024 21:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728509696;
	bh=oDSfANP5f3JeoIP0L5dABahokG6l8mt3P+BxuwV8KL8=;
	h=Date:To:From:Subject:From;
	b=I1UC5E0BWmLAZQgN6M/LiBSjqx05ggiKUIDlyZLRPJT0I8WfIPyVcfBrCShprrqiD
	 RarLnTbebad0WQ948WNIhgJI10mb0N0Lw11RiynCrdPm7tRw9HNhKLLf1O/w2jirkf
	 6hRfM+8QNig9qRDiM8vT03UwVgrtDG4VbFigPU1w=
Date: Wed, 09 Oct 2024 14:34:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bootmem-stop-using-page-index-fix.patch added to mm-unstable branch
Message-Id: <20241009213456.1719CC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bootmem-stop-using-page-index-fix
has been added to the -mm mm-unstable branch.  Its filename is
     bootmem-stop-using-page-index-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bootmem-stop-using-page-index-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bootmem-stop-using-page-index-fix
Date: Wed Oct  9 02:16:16 PM PDT 2024

fix arch/x86/mm/init_64.c build with !CONFIG_HAVE_BOOTMEM_INFO_NODE

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410090311.eaqcL7IZ-lkp@intel.com/
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
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

mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas-fix.patch
lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls-fix.patch
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
bootmem-stop-using-page-index-fix.patch

