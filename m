From: akpm@linux-foundation.org
Subject: + kbuild-silence-documentation-gen-xml-messages-according-to-quiet.patch added to -mm tree
Date: Tue, 25 Mar 2008 15:40:31 -0700
Message-ID: <200803252240.m2PMeVPu017250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753682AbYCYWkp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 18:40:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, randy.dunlap@oracle.com, sam@ravnborg.org


The patch titled
     kbuild: silence documentation GEN xml messages according to $(quiet)
has been added to the -mm tree.  Its filename is
     kbuild-silence-documentation-gen-xml-messages-according-to-quiet.patch

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
Subject: kbuild: silence documentation GEN xml messages according to $(quiet)
From: Mike Frysinger <vapier@gentoo.org>

Add rules for gen_xml and its quiet & silent variants.  This causes "make -s"
to be silent for gen_xml.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/Makefile |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN Documentation/DocBook/Makefile~kbuild-silence-documentation-gen-xml-messages-according-to-quiet Documentation/DocBook/Makefile
--- a/Documentation/DocBook/Makefile~kbuild-silence-documentation-gen-xml-messages-according-to-quiet
+++ a/Documentation/DocBook/Makefile
@@ -186,8 +186,11 @@ quiet_cmd_fig2png = FIG2PNG $@
 
 ###
 # Rule to convert a .c file to inline XML documentation
+       gen_xml = :
+ quiet_gen_xml = echo '  GEN     $@'
+silent_gen_xml = :
 %.xml: %.c
-	@echo '  GEN     $@'
+	@$($(quiet)gen_xml)
 	@(                            \
 	   echo "<programlisting>";   \
 	   expand --tabs=8 < $< |     \
_

Patches currently in -mm which might be from vapier@gentoo.org are

mtd-maps-document-mtd_physmap-module-name-in-kconfig.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
remove-duplicated-unlikely-in-is_err.patch
kbuild-silence-documentation-gen-xml-messages-according-to-quiet.patch

