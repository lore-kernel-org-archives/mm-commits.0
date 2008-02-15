From: akpm@linux-foundation.org
Subject: + make-lkdtm-depend-on-block.patch added to -mm tree
Date: Fri, 15 Feb 2008 00:38:23 -0800
Message-ID: <200802150838.m1F8cNG3028394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52459 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761358AbYBOIjb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 03:39:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: csnook@redhat.com


The patch titled
     make LKDTM depend on BLOCK
has been added to the -mm tree.  Its filename is
     make-lkdtm-depend-on-block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make LKDTM depend on BLOCK
From: Chris Snook <csnook@redhat.com>

Make LKDTM depend on BLOCK to prevent build failures with certain configs.

Signed-off-by: Chris Snook <csnook@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/Kconfig.debug~make-lkdtm-depend-on-block lib/Kconfig.debug
--- a/lib/Kconfig.debug~make-lkdtm-depend-on-block
+++ a/lib/Kconfig.debug
@@ -524,6 +524,7 @@ config LKDTM
 	tristate "Linux Kernel Dump Test Tool Module"
 	depends on DEBUG_KERNEL
 	depends on KPROBES
+	depends on BLOCK
 	default n
 	help
 	This module enables testing of the different dumping mechanisms by
_

Patches currently in -mm which might be from csnook@redhat.com are

make-lkdtm-depend-on-block.patch
