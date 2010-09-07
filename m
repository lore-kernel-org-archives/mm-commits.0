From: akpm@linux-foundation.org
Subject: + modules-no-need-to-align-modinfo-strings.patch added to -mm tree
Date: Tue, 07 Sep 2010 13:09:50 -0700
Message-ID: <201009072009.o87K9o2U003159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758137Ab0IGUKX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 16:10:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, jbeulich@novell.com, rusty@rustcorp.com.au


The patch titled
     modules: no need to align .modinfo strings
has been added to the -mm tree.  Its filename is
     modules-no-need-to-align-modinfo-strings.patch

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
Subject: modules: no need to align .modinfo strings
From: "Jan Beulich" <JBeulich@novell.com>

gcc aligns strings as a performance consideration for those cases where
strings are being used a lot.

Their use is not performance critical, and hence it seems better to save
some space.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/moduleparam.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/moduleparam.h~modules-no-need-to-align-modinfo-strings include/linux/moduleparam.h
--- a/include/linux/moduleparam.h~modules-no-need-to-align-modinfo-strings
+++ a/include/linux/moduleparam.h
@@ -21,8 +21,8 @@
 #define __module_cat(a,b) ___module_cat(a,b)
 #define __MODULE_INFO(tag, name, info)					  \
 static const char __module_cat(name,__LINE__)[]				  \
-  __used								  \
-  __attribute__((section(".modinfo"),unused)) = __stringify(tag) "=" info
+  __used __attribute__((section(".modinfo"), unused, aligned(1)))	  \
+  = __stringify(tag) "=" info
 #else  /* !MODULE */
 #define __MODULE_INFO(tag, name, info)
 #endif
_

Patches currently in -mm which might be from JBeulich@novell.com are

linux-next.patch
modules-no-need-to-align-modinfo-strings.patch

