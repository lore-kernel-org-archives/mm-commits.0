From: akpm@linux-foundation.org
Subject: + resource-remove-deprecated-__check_region-and-friends.patch
 added to -mm tree
Date: Wed, 11 Mar 2015 16:35:33 -0700
Message-ID: <5500d145.M1Sl+so1ZfX3RRc3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbbCKXfd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 19:35:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsitnicki@gmail.com, bhelgaas@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource.c: remove deprecated __check_region() and friends
has been added to the -mm tree.  Its filename is
     resource-remove-deprecated-__check_region-and-friends.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/resource-remove-deprecated-__check_region-and-friends.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/resource-remove-deprecated-__check_region-and-friends.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jakub Sitnicki <jsitnicki@gmail.com>
Subject: kernel/resource.c: remove deprecated __check_region() and friends

All users of __check_region(), check_region(), and check_mem_region() are
gone.  We got rid of the last user in v4.0-rc1.  Remove them.

bloat-o-meter on x86_64 shows:

add/remove: 0/3 grow/shrink: 0/0 up/down: 0/-102 (-102)
function                                     old     new   delta
__kstrtab___check_region                      15       -     -15
__ksymtab___check_region                      16       -     -16
__check_region                                71       -     -71

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    8 --------
 kernel/resource.c      |   32 --------------------------------
 2 files changed, 40 deletions(-)

diff -puN include/linux/ioport.h~resource-remove-deprecated-__check_region-and-friends include/linux/ioport.h
--- a/include/linux/ioport.h~resource-remove-deprecated-__check_region-and-friends
+++ a/include/linux/ioport.h
@@ -196,10 +196,8 @@ extern struct resource * __request_regio
 
 /* Compatibility cruft */
 #define release_region(start,n)	__release_region(&ioport_resource, (start), (n))
-#define check_mem_region(start,n)	__check_region(&iomem_resource, (start), (n))
 #define release_mem_region(start,n)	__release_region(&iomem_resource, (start), (n))
 
-extern int __check_region(struct resource *, resource_size_t, resource_size_t);
 extern void __release_region(struct resource *, resource_size_t,
 				resource_size_t);
 #ifdef CONFIG_MEMORY_HOTREMOVE
@@ -207,12 +205,6 @@ extern int release_mem_region_adjustable
 				resource_size_t);
 #endif
 
-static inline int __deprecated check_region(resource_size_t s,
-						resource_size_t n)
-{
-	return __check_region(&ioport_resource, s, n);
-}
-
 /* Wrappers for managed devices */
 struct device;
 
diff -puN kernel/resource.c~resource-remove-deprecated-__check_region-and-friends kernel/resource.c
--- a/kernel/resource.c~resource-remove-deprecated-__check_region-and-friends
+++ a/kernel/resource.c
@@ -1034,8 +1034,6 @@ resource_size_t resource_alignment(struc
  *
  * request_region creates a new busy region.
  *
- * check_region returns non-zero if the area is already busy.
- *
  * release_region releases a matching busy region.
  */
 
@@ -1098,36 +1096,6 @@ struct resource * __request_region(struc
 EXPORT_SYMBOL(__request_region);
 
 /**
- * __check_region - check if a resource region is busy or free
- * @parent: parent resource descriptor
- * @start: resource start address
- * @n: resource region size
- *
- * Returns 0 if the region is free at the moment it is checked,
- * returns %-EBUSY if the region is busy.
- *
- * NOTE:
- * This function is deprecated because its use is racy.
- * Even if it returns 0, a subsequent call to request_region()
- * may fail because another driver etc. just allocated the region.
- * Do NOT use it.  It will be removed from the kernel.
- */
-int __check_region(struct resource *parent, resource_size_t start,
-			resource_size_t n)
-{
-	struct resource * res;
-
-	res = __request_region(parent, start, n, "check-region", 0);
-	if (!res)
-		return -EBUSY;
-
-	release_resource(res);
-	free_resource(res);
-	return 0;
-}
-EXPORT_SYMBOL(__check_region);
