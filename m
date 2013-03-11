From: akpm@linux-foundation.org
Subject: + decompressors-fix-typo-powerpc.patch added to -mm tree
Date: Mon, 11 Mar 2013 16:36:46 -0700
Message-ID: <20130311233646.747C15A431F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:47919 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab3CKXgr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 19:36:47 -0400
Received: by mail-qa0-f73.google.com with SMTP id g10so245392qah.4
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 16:36:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pebolle@tiscali.nl, benh@kernel.crashing.org, florian@openwrt.org, lasse.collin@tukaani.org


The patch titled
     Subject: decompressors: fix typo "POWERPC"
has been added to the -mm tree.  Its filename is
     decompressors-fix-typo-powerpc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Bolle <pebolle@tiscali.nl>
Subject: decompressors: fix typo "POWERPC"

Commit 5dc49c75a2 ("decompressors: make the default XZ_DEC_* config match
the selected architecture") added

	default y if POWERPC

to lib/xz/Kconfig.  But there is no Kconfig symbol POWERPC.  The most
general Kconfig symbol for the powerpc architecture is PPC.  So let's use
that.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Lasse Collin <lasse.collin@tukaani.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xz/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/xz/Kconfig~decompressors-fix-typo-powerpc lib/xz/Kconfig
--- a/lib/xz/Kconfig~decompressors-fix-typo-powerpc
+++ a/lib/xz/Kconfig
@@ -15,7 +15,7 @@ config XZ_DEC_X86
 
 config XZ_DEC_POWERPC
 	bool "PowerPC BCJ filter decoder"
-	default y if POWERPC
+	default y if PPC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_IA64
_

Patches currently in -mm which might be from pebolle@tiscali.nl are

origin.patch
linux-next.patch
decompressors-fix-typo-powerpc.patch

