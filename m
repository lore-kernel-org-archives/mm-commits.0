From: akpm@linux-foundation.org
Subject: + errh-add-helper-function-to-simplify-pointer-error-checking.patch added to -mm tree
Date: Tue, 29 Sep 2009 12:15:42 -0700
Message-ID: <200909291915.n8TJFgp2002233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752901AbZI2TPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 15:15:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-phil.2.carmody@nokia.com


The patch titled
     err.h: add helper function to simplify pointer error checking
has been added to the -mm tree.  Its filename is
     errh-add-helper-function-to-simplify-pointer-error-checking.patch

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
Subject: err.h: add helper function to simplify pointer error checking
From: Phil Carmody <ext-phil.2.carmody@nokia.com>

There are quite a few instances in the kernel of checks of pointers both
against NULL and against the errno range, handling both cases identically.
This additional helper function would simplify such code.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/err.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN include/linux/err.h~errh-add-helper-function-to-simplify-pointer-error-checking include/linux/err.h
--- a/include/linux/err.h~errh-add-helper-function-to-simplify-pointer-error-checking
+++ a/include/linux/err.h
@@ -34,6 +34,11 @@ static inline long IS_ERR(const void *pt
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
 
+static inline long IS_ERR_OR_NULL(const void *ptr)
+{
+	return (ptr == NULL) || IS_ERR_VALUE((unsigned long)ptr);
+}
+
 /**
  * ERR_CAST - Explicitly cast an error-valued pointer to another pointer type
  * @ptr: The pointer to cast.
_

Patches currently in -mm which might be from ext-phil.2.carmody@nokia.com are

errh-add-helper-function-to-simplify-pointer-error-checking.patch

