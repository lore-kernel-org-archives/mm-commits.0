From: akpm@linux-foundation.org
Subject: + ia64-desc_empty-thinko-typo-fix.patch added to -mm tree
Date: Wed, 04 Apr 2007 16:56:19 -0700
Message-ID: <200704042356.l34NuJZj002518@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35039 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbXDDX4Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 19:56:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maze@google.com, tony.luck@intel.com


The patch titled
     ia64: desc_empty thinko/typo fix
has been added to the -mm tree.  Its filename is
     ia64-desc_empty-thinko-typo-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64: desc_empty thinko/typo fix
From: Maciej Zenczykowski <maze@google.com>

Just a one-byter for an ia64 thinko/typo - already fixed for i386 and x86_64.

Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/processor.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-ia64/processor.h~ia64-desc_empty-thinko-typo-fix include/asm-ia64/processor.h
--- a/include/asm-ia64/processor.h~ia64-desc_empty-thinko-typo-fix
+++ a/include/asm-ia64/processor.h
@@ -210,7 +210,7 @@ struct desc_struct {
 	unsigned int a, b;
 };
 
-#define desc_empty(desc)		(!((desc)->a + (desc)->b))
+#define desc_empty(desc)		(!((desc)->a | (desc)->b))
 #define desc_equal(desc1, desc2)	(((desc1)->a == (desc2)->a) && ((desc1)->b == (desc2)->b))
 
 #define GDT_ENTRY_TLS_ENTRIES	3
_

Patches currently in -mm which might be from maze@google.com are

ia64-desc_empty-thinko-typo-fix.patch
