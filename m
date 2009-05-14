From: akpm@linux-foundation.org
Subject: + mm-check-the-argument-of-kunmap-on-architectures-without-highmem.patch added to -mm tree
Date: Thu, 14 May 2009 09:44:51 -0700
Message-ID: <200905141644.n4EGipmE031306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387AbZENQpu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 May 2009 12:45:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthew@wil.cx, dwmw2@infradead.org, willy@linux.intel.com


The patch titled
     mm: check the argument of kunmap on architectures without highmem
has been added to the -mm tree.  Its filename is
     mm-check-the-argument-of-kunmap-on-architectures-without-highmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
scsi-ncr53c8xx-div-reaches-1.patch
mm-check-the-argument-of-kunmap-on-architectures-without-highmem.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
make-sure-nobodys-leaking-resources.patch

