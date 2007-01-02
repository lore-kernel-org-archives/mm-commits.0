From: akpm@osdl.org
Subject: - respect-srctree-objtree-in-documentation-docbook-makefile.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:24:53 -0800
Message-ID: <200701020724.l027Orub012989@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37370 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838AbXABHYz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:24:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     respect srctree/objtree in Documentation/DocBook/Makefile
has been removed from the -mm tree.  Its filename was
     respect-srctree-objtree-in-documentation-docbook-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: respect srctree/objtree in Documentation/DocBook/Makefile
From: "Mike Frysinger" <vapier.adi@gmail.com>

The KERNELDOC and DOCPROC variables are relative to the
$(srctree)/$(objtree) and expect to be run only from there ...  attached
patch adds proper srctree/objtree prefixes to both variables.

Acked-by: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/DocBook/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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

fix-typo-in-i2c-smbus-documentation.patch
search-a-little-harder-for-mkimage.patch
scrub-non-__glibc__-checks-in-linux-socketh-and-linux-stath.patch
