From: akpm@linux-foundation.org
Subject: [merged] errh-add-helper-function-to-simplify-pointer-error-checking.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:56:08 -0800
Message-ID: <200912152156.nBFLu8R1015549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933791AbZLOV4j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:56:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-phil.2.carmody@nokia.com, mm-commits@vger.kernel.org


The patch titled
     err.h: add helper function to simplify pointer error checking
has been removed from the -mm tree.  Its filename was
     errh-add-helper-function-to-simplify-pointer-error-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: err.h: add helper function to simplify pointer error checking
From: Phil Carmody <ext-phil.2.carmody@nokia.com>

There are quite a few instances in the kernel of checks of pointers both
against NULL and against the errno range, handling both cases identically.
This additional helper function would simplify such code.

[akpm@linux-foundation.org: build fix]
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
+	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
+}
+
 /**
  * ERR_CAST - Explicitly cast an error-valued pointer to another pointer type
  * @ptr: The pointer to cast.
_

Patches currently in -mm which might be from ext-phil.2.carmody@nokia.com are

origin.patch

