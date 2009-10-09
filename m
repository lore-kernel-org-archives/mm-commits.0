From: akpm@linux-foundation.org
Subject: [merged] page-types-introduce-kpageflags_flags.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:05:14 -0700
Message-ID: <200910092205.n99M5E9N021014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934667AbZJIWFz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:05:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     page-types: introduce kpageflags_flags()
has been removed from the -mm tree.  Its filename was
     page-types-introduce-kpageflags_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-types: introduce kpageflags_flags()
From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/vm/page-types.c~page-types-introduce-kpageflags_flags Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~page-types-introduce-kpageflags_flags
+++ a/Documentation/vm/page-types.c
@@ -436,6 +436,16 @@ static uint64_t well_known_flags(uint64_
 	return flags;
 }
 
+static uint64_t kpageflags_flags(uint64_t flags)
+{
+	flags = expand_overloaded_flags(flags);
+
+	if (!opt_raw)
+		flags = well_known_flags(flags);
+
+	return flags;
+}
+
 /*
  * page frame walker
  */
@@ -470,10 +480,7 @@ static int hash_slot(uint64_t flags)
 static void add_page(unsigned long voffset,
 		     unsigned long offset, uint64_t flags)
 {
-	flags = expand_overloaded_flags(flags);
