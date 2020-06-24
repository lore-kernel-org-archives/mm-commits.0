From: akpm@linux-foundation.org
Subject: + make-asm-generic-cacheflushh-more-standalone.patch added
 to -mm tree
Date: Wed, 24 Jun 2020 15:12:11 -0700
Message-ID: <20200624221211.VvV96%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728798AbgFXWMO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 18:12:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, heiko.carstens@de.ibm.com, hch@lst.de, gor@linux.ibm.com, borntraeger@de.ibm.com, arnd@arndb.de, sfr@canb.auug.org.au


The patch titled
     Subject: make asm-generic/cacheflush.h more standalone
has been added to the -mm tree.  Its filename is
     make-asm-generic-cacheflushh-more-standalone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/make-asm-generic-cacheflushh-more-standalone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/make-asm-generic-cacheflushh-more-standalone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: make asm-generic/cacheflush.h more standalone

Some s390 builds get these warnings:

include/asm-generic/cacheflush.h:16:42: warning: 'struct mm_struct' declared inside parameter list will not be visible outside of this definition or declaration
include/asm-generic/cacheflush.h:22:46: warning: 'struct mm_struct' declared inside parameter list will not be visible outside of this definition or declaration
include/asm-generic/cacheflush.h:28:45: warning: 'struct vm_area_struct' declared inside parameter list will not be visible outside of this definition or declaration
include/asm-generic/cacheflush.h:36:44: warning: 'struct vm_area_struct' declared inside parameter list will not be visible outside of this definition or declaration
include/asm-generic/cacheflush.h:44:45: warning: 'struct page' declared inside parameter list will not be visible outside of this definition or declaration
include/asm-generic/cacheflush.h:52:50: warning: 'struct address_space' declared inside parameter list will not be visible outside of this definition or declaration
include/asm-generic/cacheflush.h:58:52: warning: 'struct address_space' declared inside parameter list will not be visible outside of this definition or declaration
include/asm-generic/cacheflush.h:75:17: warning: 'struct page' declared inside parameter list will not be visible outside of this definition or declaration
include/asm-generic/cacheflush.h:74:45: warning: 'struct vm_area_struct' declared inside parameter list will not be visible outside of this definition or declaration
include/asm-generic/cacheflush.h:82:16: warning: 'struct page' declared inside parameter list will not be visible outside of this definition or declaration
include/asm-generic/cacheflush.h:81:50: warning: 'struct vm_area_struct' declared inside parameter list will not be visible outside of this definition or declaration

Forward declare the named structs to get rid of these.

Link: http://lkml.kernel.org/r/20200623135714.4dae4b8a@canb.auug.org.au
Fixes: e0cf615d725c ("asm-generic: don't include <linux/mm.h> in cacheflush.h")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/cacheflush.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/asm-generic/cacheflush.h~make-asm-generic-cacheflushh-more-standalone
+++ a/include/asm-generic/cacheflush.h
@@ -2,6 +2,11 @@
 #ifndef _ASM_GENERIC_CACHEFLUSH_H
 #define _ASM_GENERIC_CACHEFLUSH_H
 
+struct mm_struct;
+struct vm_area_struct;
+struct page;
+struct address_space;
+
 /*
  * The cache doesn't need to be flushed when TLB entries change when
  * the cache is mapped to physical memory, not virtual memory
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

make-asm-generic-cacheflushh-more-standalone.patch
