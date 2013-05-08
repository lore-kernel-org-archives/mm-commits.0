From: akpm@linux-foundation.org
Subject: + errh-is_err-can-accept-__user-pointers.patch added to -mm tree
Date: Wed, 08 May 2013 15:16:32 -0700
Message-ID: <20130508221632.738AD31C15D@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:64257 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab3EHWQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 18:16:33 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so232098ves.2
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 15:16:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, sparse@chrisli.org


The patch titled
     Subject: err.h: IS_ERR() can accept __user pointers
has been added to the -mm tree.  Its filename is
     errh-is_err-can-accept-__user-pointers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: err.h: IS_ERR() can accept __user pointers

Sparse generates a false positive when you pass a __user or __iomem
pointer to the IS_ERR() functions.

drivers/rtc/rtc-ds1286.c:344:36: sparse: incorrect type in argument 1 (different address spaces)
drivers/rtc/rtc-ds1286.c:344:36:    expected void const *ptr
drivers/rtc/rtc-ds1286.c:344:36:    got unsigned int [noderef] [usertype] <asn:2>*rtcregs

We can silence these by adding a __force here and upgrading to the
latest git release of Sparse.

This change has no effect when using current Sparse releases.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Christopher Li <sparse@chrisli.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/err.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/err.h~errh-is_err-can-accept-__user-pointers include/linux/err.h
--- a/include/linux/err.h~errh-is_err-can-accept-__user-pointers
+++ a/include/linux/err.h
@@ -24,17 +24,17 @@ static inline void * __must_check ERR_PT
 	return (void *) error;
 }
 
-static inline long __must_check PTR_ERR(const void *ptr)
+static inline long __must_check PTR_ERR(__force const void *ptr)
 {
 	return (long) ptr;
 }
 
-static inline long __must_check IS_ERR(const void *ptr)
+static inline long __must_check IS_ERR(__force const void *ptr)
 {
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
 
-static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
+static inline long __must_check IS_ERR_OR_NULL(__force const void *ptr)
 {
 	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
 }
@@ -46,13 +46,13 @@ static inline long __must_check IS_ERR_O
  * Explicitly cast an error-valued pointer to another pointer type in such a
  * way as to make it clear that's what's going on.
  */
-static inline void * __must_check ERR_CAST(const void *ptr)
+static inline void * __must_check ERR_CAST(__force const void *ptr)
 {
 	/* cast away the const */
 	return (void *) ptr;
 }
 
-static inline int __must_check PTR_RET(const void *ptr)
+static inline int __must_check PTR_RET(__force const void *ptr)
 {
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
configfs-use-capped-length-for-store_attribute.patch
errh-is_err-can-accept-__user-pointers.patch
mwave-fix-info-leak-in-mwave_ioctl.patch

