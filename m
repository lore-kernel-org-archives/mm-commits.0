From: akpm@linux-foundation.org
Subject: + docbook-fix-command-spacing.patch added to -mm tree
Date: Tue, 21 Oct 2008 15:28:00 -0700
Message-ID: <200810212228.m9LMS0YB002580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536AbYJUW2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 18:28:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hun@n-dimensional.de, randy.dunlap@oracle.com


The patch titled
     docbook: fix command spacing
has been added to the -mm tree.  Its filename is
     docbook-fix-command-spacing.patch

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
Subject: docbook: fix command spacing
From: Hans Ulrich Niedermann <hun@n-dimensional.de>

The total width of the command name plus spaces should be
8 characters, but were 7 and 9, respectively. With 8 chars,
all commands are now lining up nicely.

The mandocs, psdocs, xmldocs commands are OK.

Before:
  HOSTCC  scripts/basic/docproc
  DOCPROC Documentation/DocBook/deviceiobook.xml
  HTML   Documentation/DocBook/deviceiobook.html
  DOCPROC Documentation/DocBook/wanbook.xml
  PDF      Documentation/DocBook/wanbook.pdf

After:
  HOSTCC  scripts/basic/docproc
  DOCPROC Documentation/DocBook/deviceiobook.xml
  HTML    Documentation/DocBook/deviceiobook.html
  DOCPROC Documentation/DocBook/wanbook.xml
  PDF     Documentation/DocBook/wanbook.pdf

Signed-off-by: Hans Ulrich Niedermann <hun@n-dimensional.de>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/DocBook/Makefile~docbook-fix-command-spacing Documentation/DocBook/Makefile
--- a/Documentation/DocBook/Makefile~docbook-fix-command-spacing
+++ a/Documentation/DocBook/Makefile
@@ -136,7 +136,7 @@ quiet_cmd_db2ps = PS      $@
 %.ps : %.xml
 	$(call cmd,db2ps)
 
-quiet_cmd_db2pdf = PDF      $@
+quiet_cmd_db2pdf = PDF     $@
       cmd_db2pdf = $(subst TYPE,pdf, $($(PDF_METHOD)template))
 %.pdf : %.xml
 	$(call cmd,db2pdf)
@@ -148,7 +148,7 @@ build_main_index = rm -rf $(main_idx) &&
 		   echo '<h2>Kernel Version: $(KERNELVERSION)</h2>' >> $(main_idx) && \
 		   cat $(HTML) >> $(main_idx)
 
-quiet_cmd_db2html = HTML   $@
+quiet_cmd_db2html = HTML    $@
       cmd_db2html = xmlto xhtml $(XMLTOFLAGS) -o $(patsubst %.html,%,$@) $< && \
 		echo '<a HREF="$(patsubst %.html,%,$(notdir $@))/index.html"> \
         $(patsubst %.html,%,$(notdir $@))</a><p>' > $@
_

Patches currently in -mm which might be from hun@n-dimensional.de are

docbook-fix-command-spacing.patch

