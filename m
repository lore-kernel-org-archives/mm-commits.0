From: akpm@osdl.org
Subject: + respect-srctree-objtree-in-documentation-docbook-makefile.patch added to -mm tree
Date: Wed, 27 Dec 2006 13:14:41 -0800
Message-ID: <200612272114.kBRLEfIf020363@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35266 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932689AbWL0VOo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 16:14:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, rdunlap@xenotime.net


The patch titled
     respect srctree/objtree in Documentation/DocBook/Makefile
has been added to the -mm tree.  Its filename is
     respect-srctree-objtree-in-documentation-docbook-makefile.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: respect srctree/objtree in Documentation/DocBook/Makefile
From: "Mike Frysinger" <vapier.adi@gmail.com>

The KERNELDOC and DOCPROC variables are relative to the
$(srctree)/$(objtree) and expect to be run only from there ...  attached
patch adds proper srctree/objtree prefixes to both variables.

Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/DocBook/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/DocBook/Makefile~respect-srctree-objtree-in-documentation-docbook-makefile Documentation/DocBook/Makefile
--- a/Documentation/DocBook/Makefile~respect-srctree-objtree-in-documentation-docbook-makefile
+++ a/Documentation/DocBook/Makefile
@@ -53,8 +53,8 @@ installmandocs: mandocs
 
 ###
 #External programs used
-KERNELDOC = scripts/kernel-doc
-DOCPROC   = scripts/basic/docproc
+KERNELDOC = $(srctree)/scripts/kernel-doc
+DOCPROC   = $(objtree)/scripts/basic/docproc
 
 XMLTOFLAGS = -m $(srctree)/Documentation/DocBook/stylesheet.xsl
 #XMLTOFLAGS += --skip-validation
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

search-a-little-harder-for-mkimage.patch
scrub-non-__glibc__-checks-in-linux-socketh-and-linux-stath.patch
respect-srctree-objtree-in-documentation-docbook-makefile.patch

