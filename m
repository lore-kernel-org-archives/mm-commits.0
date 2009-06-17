From: akpm@linux-foundation.org
Subject: [merged] mm-check-the-argument-of-kunmap-on-architectures-without-highmem.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:35:31 -0700
Message-ID: <200906171835.n5HIZVuK001575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757516AbZFQSrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:47:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, dwmw2@infradead.org, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     mm: check the argument of kunmap on architectures without highmem
has been removed from the -mm tree.  Its filename was
     mm-check-the-argument-of-kunmap-on-architectures-without-highmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: check the argument of kunmap on architectures without highmem
From: Matthew Wilcox <matthew@wil.cx>

If you're using a non-highmem architecture, passing an argument with the
wrong type to kunmap() doesn't give you a warning because the ifdef
doesn't check the type.

Using a static inline function solves the problem nicely.

Reported-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/highmem.h~mm-check-the-argument-of-kunmap-on-architectures-without-highmem include/linux/highmem.h
--- a/include/linux/highmem.h~mm-check-the-argument-of-kunmap-on-architectures-without-highmem
+++ a/include/linux/highmem.h
@@ -55,7 +55,9 @@ static inline void *kmap(struct page *pa
 	return page_address(page);
 }
 
-#define kunmap(page) do { (void) (page); } while (0)
+static inline void kunmap(struct page *page)
+{
+}
 
 static inline void *kmap_atomic(struct page *page, enum km_type idx)
 {
_

Patches currently in -mm which might be from matthew@wil.cx are

origin.patch
linux-next.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
make-sure-nobodys-leaking-resources.patch

