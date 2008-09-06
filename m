From: akpm@linux-foundation.org
Subject: + include-linux-ioporth-add-missing-macro-argument-for-devm_release_-family.patch added to -mm tree
Date: Fri, 05 Sep 2008 18:53:02 -0700
Message-ID: <200809060153.m861r2UR030471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183AbYIFBxk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2008 21:53:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Hiroshi.DOYU@nokia.com, tony@atomide.com


The patch titled
     include/linux/ioport.h: add missing macro argument for devm_release_* family
has been added to the -mm tree.  Its filename is
     include-linux-ioporth-add-missing-macro-argument-for-devm_release_-family.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/ioport.h: add missing macro argument for devm_release_* family
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>

(akpm: these have no callers at this time)

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/ioport.h~include-linux-ioporth-add-missing-macro-argument-for-devm_release_-family include/linux/ioport.h
--- a/include/linux/ioport.h~include-linux-ioporth-add-missing-macro-argument-for-devm_release_-family
+++ a/include/linux/ioport.h
@@ -159,9 +159,9 @@ extern struct resource * __devm_request_
 				struct resource *parent, resource_size_t start,
 				resource_size_t n, const char *name);
 
-#define devm_release_region(start,n) \
+#define devm_release_region(dev,start,n) \
 	__devm_release_region(dev, &ioport_resource, (start), (n))
-#define devm_release_mem_region(start,n) \
+#define devm_release_mem_region(dev,start,n) \
 	__devm_release_region(dev, &iomem_resource, (start), (n))
 
 extern void __devm_release_region(struct device *dev, struct resource *parent,
_

Patches currently in -mm which might be from Hiroshi.DOYU@nokia.com are

include-linux-ioporth-add-missing-macro-argument-for-devm_release_-family.patch

