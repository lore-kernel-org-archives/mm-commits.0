From: akpm@linux-foundation.org
Subject: + docs-note-about-select-in-kconfig-languagetxt.patch added to -mm tree
Date: Tue, 07 Aug 2007 16:18:53 -0700
Message-ID: <200708072318.l77NIrpx010068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59401 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753358AbXHGXTn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 19:19:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkao2@o2.pl, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     docs: note about select in kconfig-language.txt
has been added to the -mm tree.  Its filename is
     docs-note-about-select-in-kconfig-languagetxt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: docs: note about select in kconfig-language.txt
From: Jarek Poplawski <jarkao2@o2.pl>

A warning note from Sam Ravnborg about kconfig's select evilness,
dependencies and the future (slightly corrected).

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kbuild/kconfig-language.txt |    9 +++++++++
 1 files changed, 9 insertions(+)

diff -puN Documentation/kbuild/kconfig-language.txt~docs-note-about-select-in-kconfig-languagetxt Documentation/kbuild/kconfig-language.txt
--- a/Documentation/kbuild/kconfig-language.txt~docs-note-about-select-in-kconfig-languagetxt
+++ a/Documentation/kbuild/kconfig-language.txt
@@ -98,6 +98,15 @@ applicable everywhere (see syntax).
   times, the limit is set to the largest selection.
   Reverse dependencies can only be used with boolean or tristate
   symbols.
+  Note:
+	select is evil.... select will by brute force set a symbol
+	equal to 'y' without visiting the dependencies. So abusing
+	select you are able to select a symbol FOO even if FOO depends
+	on BAR that is not set. In general use select only for
+	non-visible symbols (no promts anywhere) and for symbols with
+	no dependencies. That will limit the usefulness but on the
+	other hand avoid the illegal configurations all over. kconfig
+	should one day warn about such things.
 
 - numerical ranges: "range" <symbol> <symbol> ["if" <expr>]
   This allows to limit the range of possible input values for int
_

Patches currently in -mm which might be from jarkao2@o2.pl are

docs-note-about-select-in-kconfig-languagetxt.patch
