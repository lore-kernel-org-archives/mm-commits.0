From: akpm@linux-foundation.org
Subject: + kbuild-fix-kbuild_extra_symbols.patch added to -mm tree
Date: Tue, 23 Sep 2008 13:08:32 -0700
Message-ID: <200809232008.m8NK8WQA018846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751036AbYIWUIx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Sep 2008 16:08:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pva@gentoo.org, sam@ravnborg.org


The patch titled
     kbuild: fix KBUILD_EXTRA_SYMBOLS
has been added to the -mm tree.  Its filename is
     kbuild-fix-kbuild_extra_symbols.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: fix KBUILD_EXTRA_SYMBOLS
From: Peter Volkov <pva@gentoo.org>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=11567

If you even define KBUILD_EXTRA_SYMBOLS in Makefile it will not be expanded
into command line argument for modpost.

Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.modpost |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/Makefile.modpost~kbuild-fix-kbuild_extra_symbols scripts/Makefile.modpost
--- a/scripts/Makefile.modpost~kbuild-fix-kbuild_extra_symbols
+++ a/scripts/Makefile.modpost
@@ -82,7 +82,7 @@ modpost = scripts/mod/modpost           
  $(if $(CONFIG_MODULE_SRCVERSION_ALL),-a,)       \
  $(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile)   \
  $(if $(KBUILD_EXTMOD),-I $(modulesymfile))      \
- $(if $(KBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(EXTRA_SYMBOLS))) \
+ $(if $(KBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(KBUILD_EXTRA_SYMBOLS))) \
  $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
  $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
  $(if $(CONFIG_MARKERS),-K $(kernelmarkersfile)) \
_

Patches currently in -mm which might be from pva@gentoo.org are

kbuild-fix-kbuild_extra_symbols.patch

