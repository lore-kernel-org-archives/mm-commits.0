From: akpm@osdl.org
Subject: + make-mkcompile_h-use-lang=c-and-lc_all=c-for-cc-v.patch added to -mm tree
Date: Tue, 26 Dec 2006 23:30:23 -0800
Message-ID: <200612270730.kBR7UNvw004417@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36437 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932944AbWL0Hac (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 02:30:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: situert@yahoo.com, sam@ravnborg.org


The patch titled
     Make mkcompile_h use LANG=C and LC_ALL=C for $CC -v
has been added to the -mm tree.  Its filename is
     make-mkcompile_h-use-lang=c-and-lc_all=c-for-cc-v.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

make-mkcompile_h-use-lang=c-and-lc_all=c-for-cc-v.patch

