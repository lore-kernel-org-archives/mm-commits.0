Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE22F3A0B31
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 18:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767809444; cv=none; b=B9Wtu+jNIgOk4oq/IkNLocElRz0WC6E5YCDgikueWQSg/XMtwGyH5ATo1umzfmZvSBG4q+Xp961XCD4k5DEH3X5atwWgDGwWQ6Cjiq9GBXgjesVztfzl3jX3QEVBwzPA9CqwfjEjgbu4PPh7mcN8mz2eCkNBzkMXN93Uanb3JVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767809444; c=relaxed/simple;
	bh=1GSTfXMD2GY+7gtMyaXjQ5S9KDaWOy2eMqv7JHv1ORs=;
	h=Date:To:From:Subject:Message-Id; b=CiGTPf7qQlX+sBfvg2GbUaDXyzkf4bseEstH4bJtsx9LTIyaHcmWl9Trv/yc8app065Bx0aD3wqrUQSzhHlCklYzY8qe4MqhI3SZCOWJfe6Xe2X3PyiKRjmyxV+oZxsOuHIvyclhCv4u1eQ5FzsJIJk/vY2idNJTEk2wPnpaW30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S7iOLLoJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S7iOLLoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C31C4CEF1;
	Wed,  7 Jan 2026 18:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767809444;
	bh=1GSTfXMD2GY+7gtMyaXjQ5S9KDaWOy2eMqv7JHv1ORs=;
	h=Date:To:From:Subject:From;
	b=S7iOLLoJyIrm/Yh9SP/U9ZGtMnnQbX2QNF5mbmLv8x5Gn0QVsgNLWdj6HEXRz8VEo
	 jAY6t4oDDgS2gt2W581LhClI2shzjn/N2x1kuXu46fVusi1XfGaPVlbIcXlqgKV9pV
	 xsuK4NhJTuhrfBIlw/0yfMTCEqR+ZzUKUVp7Ylh4=
Date: Wed, 07 Jan 2026 10:10:44 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,rppt@kernel.org,raghavendra.kt@amd.com,peterz@infradead.org,mjguzik@gmail.com,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizhe.67@bytedance.com,Liam.Howlett@oracle.com,konrad.wilk@oracle.com,ioworker0@gmail.com,hpa@zytor.com,david@redhat.com,david@kernel.org,bp@alien8.de,boris.ostrovsky@oracle.com,ankur.a.arora@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-clear_page-introduce-clear_pages.patch added to mm-unstable branch
Message-Id: <20260107181044.91C31C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/clear_page: introduce clear_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     x86-clear_page-introduce-clear_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-clear_page-introduce-clear_pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Ankur Arora <ankur.a.arora@oracle.com>
Subject: x86/clear_page: introduce clear_pages()
Date: Tue, 6 Jan 2026 23:20:06 -0800

Performance when clearing with string instructions (x86-64-stosq and
similar) can vary significantly based on the chunk-size used.

  $ perf bench mem memset -k 4KB -s 4GB -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in arch/x86/lib/memset_64.S)
  # Copying 4GB bytes ...

      13.748208 GB/sec

  $ perf bench mem memset -k 2MB -s 4GB -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in
  # arch/x86/lib/memset_64.S)
  # Copying 4GB bytes ...

      15.067900 GB/sec

  $ perf bench mem memset -k 1GB -s 4GB -f x86-64-stosq
  # Running 'mem/memset' benchmark:
  # function 'x86-64-stosq' (movsq-based memset() in arch/x86/lib/memset_64.S)
  # Copying 4GB bytes ...

      38.104311 GB/sec

(Both on AMD Milan.)

With a change in chunk-size from 4KB to 1GB, we see the performance go
from 13.7 GB/sec to 38.1 GB/sec.  For the chunk-size of 2MB the change
isn't quite as drastic but it is worth adding a clear_page() variant that
can handle contiguous page-extents.

Link: https://lkml.kernel.org/r/20260107072009.1615991-6-ankur.a.arora@oracle.com
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konrad Rzessutek Wilk <konrad.wilk@oracle.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/page_64.h |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/page_64.h~x86-clear_page-introduce-clear_pages
+++ a/arch/x86/include/asm/page_64.h
@@ -52,8 +52,9 @@ void __clear_pages_unrolled(void *page);
 KCFI_REFERENCE(__clear_pages_unrolled);
 
 /**
- * clear_page() - clear a page using a kernel virtual address.
- * @addr: address of kernel page
+ * clear_pages() - clear a page range using a kernel virtual address.
+ * @addr: start address of kernel page range
+ * @npages: number of pages
  *
  * Switch between three implementations of page clearing based on CPU
  * capabilities:
@@ -81,11 +82,11 @@ KCFI_REFERENCE(__clear_pages_unrolled);
  *
  * Does absolutely no exception handling.
  */
-static inline void clear_page(void *addr)
+static inline void clear_pages(void *addr, unsigned int npages)
 {
-	u64 len = PAGE_SIZE;
+	u64 len = npages * PAGE_SIZE;
 	/*
-	 * Clean up KMSAN metadata for the page being cleared. The assembly call
+	 * Clean up KMSAN metadata for the pages being cleared. The assembly call
 	 * below clobbers @addr, so perform unpoisoning before it.
 	 */
 	kmsan_unpoison_memory(addr, len);
@@ -106,6 +107,12 @@ static inline void clear_page(void *addr
 			: "a" (0)
 			: "cc", "memory");
 }
+#define clear_pages clear_pages
+
+static inline void clear_page(void *addr)
+{
+	clear_pages(addr, 1);
+}
 
 void copy_page(void *to, void *from);
 KCFI_REFERENCE(copy_page);
_

Patches currently in -mm which might be from ankur.a.arora@oracle.com are

mm-introduce-clear_pages-and-clear_user_pages.patch
highmem-introduce-clear_user_highpages.patch
x86-mm-simplify-clear_page_.patch
x86-clear_page-introduce-clear_pages.patch
mm-folio_zero_user-clear-pages-sequentially.patch
mm-folio_zero_user-clear-page-ranges.patch
mm-folio_zero_user-cache-neighbouring-pages.patch

