From: akpm@linux-foundation.org
Subject: - fix-the-warning-when-running-make-tags.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:09:16 -0700
Message-ID: <200707172309.l6HN9Gt6012359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38813 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935928AbXGQXPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Fix the warning when running make tags
has been removed from the -mm tree.  Its filename was
     fix-the-warning-when-running-make-tags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-kbuild.patch
