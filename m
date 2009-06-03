From: akpm@linux-foundation.org
Subject: [failures] kbuild-fix-_modinst_post-to-pick-up-cross-depmod-instead-of-host-depmod.patch removed from -mm tree
Date: Wed, 03 Jun 2009 10:32:51 -0700
Message-ID: <200906031732.n53HWpac014009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756188AbZFCRdp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 13:33:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robert.berger@reliableembeddedsystems.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: fix _modinst_post to pick up Cross $DEPMOD instead of host depmod
has been removed from the -mm tree.  Its filename was
     kbuild-fix-_modinst_post-to-pick-up-cross-depmod-instead-of-host-depmod.patch

This patch was dropped because it had testing failures

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

