From: akpm@linux-foundation.org
Subject: + mm-page_allocc-use-__paginginit-instead-of-__init.patch added
 to -mm tree
Date: Wed, 24 Jul 2013 13:48:08 -0700
Message-ID: <51f03d88.mJYlGQ4SdUbLsUVB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3GXUsI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 16:48:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gang.chen@asianux.com

Subject: + mm-page_allocc-use-__paginginit-instead-of-__init.patch added to -mm tree
To: gang.chen@asianux.com
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 13:48:08 -0700


The patch titled
     Subject: mm/page_alloc.c: use '__paginginit' instead of '__init'
has been added to the -mm tree.  Its filename is
     mm-page_allocc-use-__paginginit-instead-of-__init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-use-__paginginit-instead-of-__init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-use-__paginginit-instead-of-__init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: mm/page_alloc.c: use '__paginginit' instead of '__init'

set_pageblock_order() may be called when memory hotplug, so need use
'__paginginit' instead of '__init'.

The related warning:

  The function __meminit .free_area_init_node() references
  a function __init .set_pageblock_order().
  If .set_pageblock_order is only used by .free_area_init_node then
  annotate .set_pageblock_order with a matching annotation.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-use-__paginginit-instead-of-__init mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-use-__paginginit-instead-of-__init
+++ a/mm/page_alloc.c
@@ -4586,7 +4586,7 @@ static inline void setup_usemap(struct p
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
-void __init set_pageblock_order(void)
+void __paginginit set_pageblock_order(void)
 {
 	unsigned int order;
 
@@ -4614,7 +4614,7 @@ void __init set_pageblock_order(void)
  * include/linux/pageblock-flags.h for the values of pageblock_order based on
  * the kernel config
  */
-void __init set_pageblock_order(void)
+void __paginginit set_pageblock_order(void)
 {
 }
 
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch
mm-page_allocc-use-__paginginit-instead-of-__init.patch
kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd.patch
linux-next.patch

