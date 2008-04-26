From: akpm@linux-foundation.org
Subject: - kbuild-silence-documentation-gen-xml-messages-according-to-quiet.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:40:48 -0700
Message-ID: <200804261640.m3QGemPZ031063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758365AbYDZQuW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:50:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, randy.dunlap@oracle.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: silence documentation GEN xml messages according to $(quiet)
has been removed from the -mm tree.  Its filename was
     kbuild-silence-documentation-gen-xml-messages-according-to-quiet.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
remove-duplicated-unlikely-in-is_err.patch

