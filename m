Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCED468D
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UzrgTTZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F9BC433C7;
	Mon, 11 Dec 2023 00:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256113;
	bh=5X50RuiZSqRL7O1oWjV6gvyGLd3hZfKo/uUYJJM6XJY=;
	h=Date:To:From:Subject:From;
	b=UzrgTTZKQHl4dPtZ4a15ClEhEY4qNpM1gm0VHERD6QyY5QCrlApCyOZ9ED7JANy0c
	 8uWbHHq1FvkDTr0xFLCw+VoGnVyn35qKLPUjbLfoDHUUVPmCZDq1oQ3wqi5kLrHuvB
	 PBczkXvmc6bwTAD+7uHpDsvah2S0BFBZTFaZm5hU=
Date: Sun, 10 Dec 2023 16:55:13 -0800
To: mm-commits@vger.kernel.org,ira.weiny@intel.com,fabio.maria.de.francesco@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_poison-replace-kmap_atomic-with-kmap_local_page.patch removed from -mm tree
Message-Id: <20231211005513.B8F9BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_poison: replace kmap_atomic() with kmap_local_page()
has been removed from the -mm tree.  Its filename was
     mm-page_poison-replace-kmap_atomic-with-kmap_local_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Fabio M. De Francesco" <fabio.maria.de.francesco@linux.intel.com>
Subject: mm/page_poison: replace kmap_atomic() with kmap_local_page()
Date: Mon, 20 Nov 2023 15:28:23 +0100

kmap_atomic() has been deprecated in favor of kmap_local_page().

Therefore, replace kmap_atomic() with kmap_local_page().

kmap_atomic() is implemented like a kmap_local_page() which also disables
page-faults and preemption (the latter only in !PREEMPT_RT kernels).  The
kernel virtual addresses returned by these two API are only valid in the
context of the callers (i.e., they cannot be handed to other threads).

With kmap_local_page() the mappings are per thread and CPU local like in
kmap_atomic(); however, they can handle page-faults and can be called from
any context (including interrupts).  The tasks that call kmap_local_page()
can be preempted and, when they are scheduled to run again, the kernel
virtual addresses are restored and are still valid.

The code blocks between the mappings and un-mappings do not rely on the
above-mentioned side effects of kmap_atomic(), so that mere replacements
of the old API with the new one is all that they require (i.e., there is
no need to explicitly call pagefault_disable() and/or preempt_disable()).

Link: https://lkml.kernel.org/r/20231120142836.7219-1-fabio.maria.de.francesco@linux.intel.com
Signed-off-by: Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_poison.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_poison.c~mm-page_poison-replace-kmap_atomic-with-kmap_local_page
+++ a/mm/page_poison.c
@@ -21,13 +21,13 @@ early_param("page_poison", early_page_po
 
 static void poison_page(struct page *page)
 {
-	void *addr = kmap_atomic(page);
+	void *addr = kmap_local_page(page);
 
 	/* KASAN still think the page is in-use, so skip it. */
 	kasan_disable_current();
 	memset(kasan_reset_tag(addr), PAGE_POISON, PAGE_SIZE);
 	kasan_enable_current();
-	kunmap_atomic(addr);
+	kunmap_local(addr);
 }
 
 void __kernel_poison_pages(struct page *page, int n)
@@ -77,7 +77,7 @@ static void unpoison_page(struct page *p
 {
 	void *addr;
 
-	addr = kmap_atomic(page);
+	addr = kmap_local_page(page);
 	kasan_disable_current();
 	/*
 	 * Page poisoning when enabled poisons each and every page
@@ -86,7 +86,7 @@ static void unpoison_page(struct page *p
 	 */
 	check_poison_mem(page, kasan_reset_tag(addr), PAGE_SIZE);
 	kasan_enable_current();
-	kunmap_atomic(addr);
+	kunmap_local(addr);
 }
 
 void __kernel_unpoison_pages(struct page *page, int n)
_

Patches currently in -mm which might be from fabio.maria.de.francesco@linux.intel.com are


