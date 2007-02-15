From: akpm@linux-foundation.org
Subject: - make-mkcompile_h-use-lang=c-and-lc_all=c-for-cc-v.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:46:55 -0800
Message-ID: <200702150846.l1F8ktFs024938@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39853 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965332AbXBOIq7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:46:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: situert@yahoo.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Make mkcompile_h use LANG=C and LC_ALL=C for $CC -v
has been removed from the -mm tree.  Its filename was
     make-mkcompile_h-use-lang=c-and-lc_all=c-for-cc-v.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make mkcompile_h use LANG=C and LC_ALL=C for $CC -v
From: s s <situert@yahoo.com>

Fix a minor bug in mkcompile_h.  As one can see, the current locale is used
while getting the version of gcc.  This produces problems when a locale
other than C or en_US is used.  As an example, my /proc/version contains
Turkish characters in iso-8859-9 encoding.

This patch fixes this issue by making sure that the C locale is used to get
gcc's version.

Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mkcompile_h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/mkcompile_h~make-mkcompile_h-use-lang=c-and-lc_all=c-for-cc-v scripts/mkcompile_h
--- a/scripts/mkcompile_h~make-mkcompile_h-use-lang=c-and-lc_all=c-for-cc-v
+++ a/scripts/mkcompile_h
@@ -58,7 +58,7 @@ UTS_TRUNCATE="sed -e s/\(.\{1,$UTS_LEN\}
     echo \#define LINUX_COMPILE_DOMAIN
   fi
 
-  echo \#define LINUX_COMPILER \"`$CC -v 2>&1 | tail -n 1`\"
+  echo \#define LINUX_COMPILER \"`LC_ALL=C LANG=C $CC -v 2>&1 | tail -n 1`\"
 ) > .tmpcompile
 
 # Only replace the real compile.h if the new one is different,
_

Patches currently in -mm which might be from situert@yahoo.com are

origin.patch
