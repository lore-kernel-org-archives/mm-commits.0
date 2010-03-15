From: akpm@linux-foundation.org
Subject: + errh-add-__must_check-to-error-pointer-handlers.patch added to -mm tree
Date: Mon, 15 Mar 2010 14:35:39 -0700
Message-ID: <201003152135.o2FLZdT7023933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932220Ab0COVfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 17:35:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-jani.1.nikula@nokia.com, adobriyan@gmail.com, ext-phil.2.carmody@nokia.com


The patch titled
     err.h: add __must_check to error pointer handlers
has been added to the -mm tree.  Its filename is
     errh-add-__must_check-to-error-pointer-handlers.patch

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
Subject: err.h: add __must_check to error pointer handlers
From: Jani Nikula <ext-jani.1.nikula@nokia.com>

Add __must_check to error pointer handlers to have the compiler warn about
mistakes like:

	if (err)
		ERR_PTR(err);

It found two bugs:

Mar 12 Nikula Jani [PATCH] enclosure: fix error path - actually return ERR_PTR() on error
Mar 12 Nikula Jani [PATCH] sunrpc: fix error path - actually return ERR_PTR() on error

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/err.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/err.h~errh-add-__must_check-to-error-pointer-handlers include/linux/err.h
--- a/include/linux/err.h~errh-add-__must_check-to-error-pointer-handlers
+++ a/include/linux/err.h
@@ -19,22 +19,22 @@
 
 #define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
 
-static inline void *ERR_PTR(long error)
+static inline void * __must_check ERR_PTR(long error)
 {
 	return (void *) error;
 }
 
-static inline long PTR_ERR(const void *ptr)
+static inline long __must_check PTR_ERR(const void *ptr)
 {
 	return (long) ptr;
 }
 
-static inline long IS_ERR(const void *ptr)
+static inline long __must_check IS_ERR(const void *ptr)
 {
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
 
-static inline long IS_ERR_OR_NULL(const void *ptr)
+static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
 {
 	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
 }
@@ -46,7 +46,7 @@ static inline long IS_ERR_OR_NULL(const 
  * Explicitly cast an error-valued pointer to another pointer type in such a
  * way as to make it clear that's what's going on.
  */
-static inline void *ERR_CAST(const void *ptr)
+static inline void * __must_check ERR_CAST(const void *ptr)
 {
 	/* cast away the const */
 	return (void *) ptr;
_

Patches currently in -mm which might be from ext-jani.1.nikula@nokia.com are

errh-add-__must_check-to-error-pointer-handlers.patch

