From: akpm@linux-foundation.org
Subject: + tags-link-from-config_x-to-config-x-as-well.patch added to -mm tree
Date: Tue, 04 Nov 2008 16:38:11 -0800
Message-ID: <200811050038.mA50cBAr026405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593AbYKEAiN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2008 19:38:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     tags: link from CONFIG_x to 'config x' as well
has been added to the -mm tree.  Its filename is
     tags-link-from-config_x-to-config-x-as-well.patch

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
Subject: tags: link from CONFIG_x to 'config x' as well
From: Alexey Dobriyan <adobriyan@gmail.com>

Inability to jump from CONFIG_ symbol in source to symbol definition in
Kconfig is very, very annoying. You'll jump to useless entry in autoconf.h,
if it exists at all.

No more.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN Makefile~tags-link-from-config_x-to-config-x-as-well Makefile
--- a/Makefile~tags-link-from-config_x-to-config-x-as-well
+++ a/Makefile
@@ -1483,6 +1483,10 @@ define xtags
 		--langdef=kconfig \
 		--language-force=kconfig \
 		--regex-kconfig='/^[[:blank:]]*(menu|)config[[:blank:]]+([[:alnum:]_]+)/\2/'; \
+	    $(all-kconfigs) | xargs $1 -a \
+		--langdef=kconfig \
+		--language-force=kconfig \
+		--regex-kconfig='/^[[:blank:]]*(menu|)config[[:blank:]]+([[:alnum:]_]+)/CONFIG_\2/'; \
 	    $(all-defconfigs) | xargs -r $1 -a \
 		--langdef=dotconfig \
 		--language-force=dotconfig \
@@ -1491,6 +1495,8 @@ define xtags
 	    $(all-sources) | xargs $1 -a; \
 	    $(all-kconfigs) | xargs $1 -a \
 		--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'; \
+	    $(all-kconfigs) | xargs $1 -a \
+		--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/CONFIG_\3/'; \
 	    $(all-defconfigs) | xargs -r $1 -a \
 		--regex='/^#?[ \t]?\(CONFIG_[a-zA-Z0-9_]+\)/\1/'; \
 	else \
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
tags-skip-in-filenames.patch
kconfig-add-module_name-shortcut.patch
tags-link-from-config_x-to-config-x-as-well.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
remove-remaining-unwinder-code.patch
profile-likely-unlikely-macros.patch

