Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5472425757
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957087; cv=none; b=s1WJQdhqcoZyPhlqvhhdzESUfi6fS5LOpUupQKSSbcJkquTJSTCzCur2FPovloVUAxVHyG9XYZzpNJ7TyfHmJzKYmpDR5JYHep34ccE8wAPOvlG+MlCw9CQNexBrngNIClfCLU08yO1i0r+qZ8emkp2pT44F/a0BWmLjkQ5Rub4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957087; c=relaxed/simple;
	bh=cwQAyFXU7ATyEH5jjrI4m9U+3sf5Fn4O6Ws0tqspdv4=;
	h=Date:To:From:Subject:Message-Id; b=Ateo8z0I+86UFiEOBuL64RHOBM2g4fS3znRfKPdxb7cuHGtvbPwOfeEBh4q5C6BYjOP/FReXr43ihydfsiqJbxRJbz3npgf8sb/JSibazfC5X9oSEh2Yvfg2el9bCldbc3lqCrowkIuBMb/5PRXQ0yl+trvqed+AEi3g1BtPi6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wi3ndRiy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wi3ndRiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2235FC113CC;
	Mon,  6 May 2024 00:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957087;
	bh=cwQAyFXU7ATyEH5jjrI4m9U+3sf5Fn4O6Ws0tqspdv4=;
	h=Date:To:From:Subject:From;
	b=Wi3ndRiytmTPvD4EYVJT8lkeuIY4HL6gSKl5PAHONfJr6drvHVqmdI2RAGmuys+hY
	 p4dat90f6vK2mKHlYS1tXloVnanfvv2D6yCcFqrZacq8g0YW3VfrVA8vKLo6VtvlFt
	 ELHOMqXLNw68Hl+fui4hi6e1XqZhFSElOfCfm1Jo=
Date: Sun, 05 May 2024 17:58:06 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,jane.chu@oracle.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch removed from -mm tree
Message-Id: <20240506005807.2235FC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make page_mapped_in_vma conditional on CONFIG_MEMORY_FAILURE
has been removed from the -mm tree.  Its filename was
     mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: make page_mapped_in_vma conditional on CONFIG_MEMORY_FAILURE
Date: Fri, 12 Apr 2024 20:35:01 +0100

This function is only currently used by the memory-failure code, so we can
omit it if we're not compiling in the memory-failure code.

Link: https://lkml.kernel.org/r/20240412193510.2356957-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Suggested-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_vma_mapped.c~mm-make-page_mapped_in_vma-conditional-on-config_memory_failure
+++ a/mm/page_vma_mapped.c
@@ -314,6 +314,7 @@ next_pte:
 	return false;
 }
 
+#ifdef CONFIG_MEMORY_FAILURE
 /**
  * page_mapped_in_vma - check whether a page is really mapped in a VMA
  * @page: the page to test
@@ -344,3 +345,4 @@ unsigned long page_mapped_in_vma(struct
 out:
 	return pvmw.address;
 }
+#endif
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

