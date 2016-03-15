From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc-v3.patch removed from -mm tree
Date: Tue, 15 Mar 2016 14:38:54 -0700
Message-ID: <56e880ee.8E4FRIS3uFdeHPES%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbcCOViz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 17:38:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, heiko.carstens@de.ibm.com, iamjoonsoo.kim@lge.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc-v3
has been removed from the -mm tree.  Its filename was
     mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc-v3.patch

This patch was dropped because it was folded into mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc.patch

------------------------------------------------------
From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc-v3

v2 -> v3: tab/whitespace, off->n (Paul Bolle)
	remove "If unsure say no."

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/Kconfig.debug~mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc-v3 mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-debug_pagealloc-ask-users-for-default-setting-of-debug_pagealloc-v3
+++ a/mm/Kconfig.debug
@@ -34,13 +34,11 @@ config DEBUG_PAGEALLOC
 
 config DEBUG_PAGEALLOC_ENABLE_DEFAULT
 	bool "Enable debug page memory allocations by default?"
-        default off
-        depends on DEBUG_PAGEALLOC
-        ---help---
+	default n
+	depends on DEBUG_PAGEALLOC
+	---help---
 	  Enable debug page memory allocations by default? This value
 	  can be overridden by debug_pagealloc=off|on.
 
-	  If unsure say no.
