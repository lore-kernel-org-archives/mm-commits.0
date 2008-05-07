From: akpm@linux-foundation.org
Subject: + kbuild-escape-meta-characters-in-regular-expression-in-make-tags.patch added to -mm tree
Date: Wed, 07 May 2008 14:38:46 -0700
Message-ID: <200805072138.m47LckYd017740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762223AbYEGVjP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 17:39:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yamato@redhat.com, adobriyan@gmail.com, sam@ravnborg.org


The patch titled
     kbuild: escape meta characters in regular expression in make TAGS
has been added to the -mm tree.  Its filename is
     kbuild-escape-meta-characters-in-regular-expression-in-make-tags.patch

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
Subject: kbuild: escape meta characters in regular expression in make TAGS
From: Masatake YAMATO <yamato@redhat.com>

Alexey Dobriyan <adobriyan@gmail.com> introduced a change which adds
menuconfig SOMETHING in Kconfig to tags output when you did "make tags".

See http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=80ff26241623875636674a31c0540a78c0fb5433

"make tags" may work fine with his code.  However make TAGS doesn't work well
because etags command requires backslashes to escape meta characters like `(',
`)' and `|'.

Here is a patch.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Makefile~kbuild-escape-meta-characters-in-regular-expression-in-make-tags Makefile
--- a/Makefile~kbuild-escape-meta-characters-in-regular-expression-in-make-tags
+++ a/Makefile
@@ -1436,7 +1436,7 @@ define xtags
 	elif $1 --version 2>&1 | grep -iq emacs; then \
 	    $(all-sources) | xargs $1 -a; \
 	    $(all-kconfigs) | xargs $1 -a \
-		--regex='/^[ \t]*(menu|)config[ \t]+\([a-zA-Z0-9_]+\)/\2/'; \
+		--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'; \
 	    $(all-defconfigs) | xargs -r $1 -a \
 		--regex='/^#?[ \t]?\(CONFIG_[a-zA-Z0-9_]+\)/\1/'; \
 	else \
_

Patches currently in -mm which might be from yamato@redhat.com are

kbuild-escape-meta-characters-in-regular-expression-in-make-tags.patch

