From: akpm@linux-foundation.org
Subject: + fix-the-warning-when-running-make-tags.patch added to -mm tree
Date: Thu, 28 Jun 2007 15:24:14 -0700
Message-ID: <200706282224.l5SMOEKo002892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54913 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035AbXF1WY3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 18:24:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, sam@ravnborg.org


The patch titled
     Fix the warning when running make tags
has been added to the -mm tree.  Its filename is
     fix-the-warning-when-running-make-tags.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix the warning when running make tags
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

make tags was giving the below warning.

ctags: Warning: arch/x86_64/kernel/head.S:124: null expansion of name
pattern "\1"

Fix the same by making sure we taken only ENTRY pattern found at the
begining of the line.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN Makefile~fix-the-warning-when-running-make-tags Makefile
--- a/Makefile~fix-the-warning-when-running-make-tags
+++ a/Makefile
@@ -1316,7 +1316,7 @@ define xtags
 		-I __initdata,__exitdata,__acquires,__releases \
 		-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL \
 		--extra=+f --c-kinds=+px \
-		--regex-asm='/ENTRY\(([^)]*)\).*/\1/'; \
+		--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'; \
 	    $(all-kconfigs) | xargs $1 -a \
 		--langdef=kconfig \
 		--language-force=kconfig \
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

fix-the-warning-when-running-make-tags.patch
