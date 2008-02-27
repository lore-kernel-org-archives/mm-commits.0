From: akpm@linux-foundation.org
Subject: + tags-add-menuconfig-symbols-as-well.patch added to -mm tree
Date: Wed, 27 Feb 2008 14:51:24 -0800
Message-ID: <200802272251.m1RMpOZ5002276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761576AbYB0Wv3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 17:51:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, sam@ravnborg.org


The patch titled
     tags: add menuconfig symbols as well
has been added to the -mm tree.  Its filename is
     tags-add-menuconfig-symbols-as-well.patch

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
Subject: tags: add menuconfig symbols as well
From: Alexey Dobriyan <adobriyan@gmail.com>

Steps to reproduce:

	vi -t NETFILTER

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Makefile~tags-add-menuconfig-symbols-as-well Makefile
--- a/Makefile~tags-add-menuconfig-symbols-as-well
+++ a/Makefile
@@ -1400,7 +1400,7 @@ define xtags
 	    $(all-kconfigs) | xargs $1 -a \
 		--langdef=kconfig \
 		--language-force=kconfig \
-		--regex-kconfig='/^[[:blank:]]*config[[:blank:]]+([[:alnum:]_]+)/\1/'; \
+		--regex-kconfig='/^[[:blank:]]*(menu|)config[[:blank:]]+([[:alnum:]_]+)/\2/'; \
 	    $(all-defconfigs) | xargs -r $1 -a \
 		--langdef=dotconfig \
 		--language-force=dotconfig \
@@ -1408,7 +1408,7 @@ define xtags
 	elif $1 --version 2>&1 | grep -iq emacs; then \
 	    $(all-sources) | xargs $1 -a; \
 	    $(all-kconfigs) | xargs $1 -a \
-		--regex='/^[ \t]*config[ \t]+\([a-zA-Z0-9_]+\)/\1/'; \
+		--regex='/^[ \t]*(menu|)config[ \t]+\([a-zA-Z0-9_]+\)/\2/'; \
 	    $(all-defconfigs) | xargs -r $1 -a \
 		--regex='/^#?[ \t]?\(CONFIG_[a-zA-Z0-9_]+\)/\1/'; \
 	else \
_

Patches currently in -mm which might be from adobriyan@gmail.com are

tags-add-menuconfig-symbols-as-well.patch
modules-warn-about-suspicious-return-values-from-modules-init-hook.patch
