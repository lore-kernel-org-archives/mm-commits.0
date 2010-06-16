From: akpm@linux-foundation.org
Subject: + docbook-need-xmldoclinks-for-all-doc-types.patch added to -mm tree
Date: Wed, 16 Jun 2010 16:05:11 -0700
Message-ID: <201006162305.o5GN5BQV000719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755881Ab0FPXFc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jun 2010 19:05:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@decadent.org.uk, apw@canonical.com, randy.dunlap@oracle.com


The patch titled
     docbook: need xmldoclinks for all doc types
has been added to the -mm tree.  Its filename is
     docbook-need-xmldoclinks-for-all-doc-types.patch

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
Subject: docbook: need xmldoclinks for all doc types
From: Ben Hutchings <ben@decadent.org.uk>

$ rm -rf build
$ mkdir build
$ cp .config build
$ make O=build htmldocs
...
xmlto: linux-2.6/build/Documentation/DocBook/media.xml
does not validate (status 3)
xmlto: Fix document syntax or use --skip-validation option
linux-2.6/build/Documentation/DocBook/media.xml:4:
warning: failed to load external entity
"linux-2.6/build/Documentation/DocBook/media-entities.tmpl"

We need the xmldoclinks built for any document types built from the
XML sources.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Acked-by: Andy Whitcroft <apw@canonical.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/DocBook/Makefile~docbook-need-xmldoclinks-for-all-doc-types Documentation/DocBook/Makefile
--- a/Documentation/DocBook/Makefile~docbook-need-xmldoclinks-for-all-doc-types
+++ a/Documentation/DocBook/Makefile
@@ -35,7 +35,7 @@ PS_METHOD	= $(prefer-db2x)
 PHONY += xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs cleandocs xmldoclinks
 
 BOOKS := $(addprefix $(obj)/,$(DOCBOOKS))
-xmldocs: $(BOOKS) xmldoclinks
+xmldocs: $(BOOKS)
 sgmldocs: xmldocs
 
 PS := $(patsubst %.xml, %.ps, $(BOOKS))
@@ -95,7 +95,7 @@ define rule_docproc
         ) > $(dir $@).$(notdir $@).cmd
 endef
 
-%.xml: %.tmpl FORCE
+%.xml: %.tmpl xmldoclinks FORCE
 	$(call if_changed_rule,docproc)
 
 ###
_

Patches currently in -mm which might be from ben@decadent.org.uk are

docbook-need-xmldoclinks-for-all-doc-types.patch

