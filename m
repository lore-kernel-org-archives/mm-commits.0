From: akpm@linux-foundation.org
Subject: + kbuild-fix-_modinst_post-to-pick-up-cross-depmod-instead-of-host-depmod.patch added to -mm tree
Date: Mon, 01 Jun 2009 14:45:13 -0700
Message-ID: <200906012145.n51LjD3c003081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058AbZFAVpV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 17:45:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: robert.berger@reliableembeddedsystems.com, sam@ravnborg.org


The patch titled
     kbuild: fix _modinst_post to pick up Cross $DEPMOD instead of host depmod
has been added to the -mm tree.  Its filename is
     kbuild-fix-_modinst_post-to-pick-up-cross-depmod-instead-of-host-depmod.patch

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
Subject: kbuild: fix _modinst_post to pick up Cross $DEPMOD instead of host depmod
From: Robert Berger <robert.berger@reliableembeddedsystems.com>

Signed-off-by: Robert Berger <robert.berger@reliableembeddedsystems.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Makefile~kbuild-fix-_modinst_post-to-pick-up-cross-depmod-instead-of-host-depmod Makefile
--- a/Makefile~kbuild-fix-_modinst_post-to-pick-up-cross-depmod-instead-of-host-depmod
+++ a/Makefile
@@ -1170,7 +1170,7 @@ _modinst_:
 PHONY += _modinst_post
 _modinst_post: _modinst_
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_modinst
-	$(call cmd,depmod)
+	$(call cmd,$(DEPMOD))
 
 else # CONFIG_MODULES
 
_

Patches currently in -mm which might be from robert.berger@reliableembeddedsystems.com are

kbuild-fix-_modinst_post-to-pick-up-cross-depmod-instead-of-host-depmod.patch

