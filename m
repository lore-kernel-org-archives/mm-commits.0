From: akpm@linux-foundation.org
Subject: + modpost-white-list-pattern-adjustment.patch added to -mm tree
Date: Tue, 12 Jun 2007 13:23:46 -0700
Message-ID: <200706122023.l5CKNkcf020537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43066 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756223AbXFLUXz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 16:23:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, sam@ravnborg.org


The patch titled
     modpost white list pattern adjustment
has been added to the -mm tree.  Its filename is
     modpost-white-list-pattern-adjustment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: modpost white list pattern adjustment
From: "Jan Beulich" <jbeulich@novell.com>

gcc puts data into .data.rel or .data.rel.* on some architectures (e.g.
ia64) or under certain conditions, so whatever is legal relative to
.data should also be legal for those other sections. Fixes a few
modpost warnings on ia64.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/modpost.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN scripts/mod/modpost.c~modpost-white-list-pattern-adjustment scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~modpost-white-list-pattern-adjustment
+++ a/scripts/mod/modpost.c
@@ -608,7 +608,7 @@ static int strrcmp(const char *s, const 
  *   warn here.
  *   the pattern is identified by:
  *   tosec   = .init.text | .exit.text | .init.data
- *   fromsec = .data
+ *   fromsec = .data | .data.rel | .data.rel.*
  *   atsym = *driver, *_template, *_sht, *_ops, *_probe, *probe_one, *_console, *_timer
  *
  * Pattern 3:
@@ -671,7 +671,9 @@ static int secref_whitelist(const char *
 	    (strcmp(tosec, ".exit.text") != 0) &&
 	    (strcmp(tosec, ".init.data") != 0))
 		f2 = 0;
-	if (strcmp(fromsec, ".data") != 0)
+	if (strcmp(fromsec, ".data") != 0 &&
+	    strcmp(fromsec, ".data.rel") != 0 &&
+	    strncmp(fromsec, ".data.rel.", strlen(".data.rel.")) != 0)
 		f2 = 0;
 
 	for (s = pat2sym; *s; s++)
_

Patches currently in -mm which might be from jbeulich@novell.com are

remove-pci_dac_dma_-apis.patch
more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
i386-minor-nx-handling-adjustment.patch
mm-fix-improper-init-type-section-references.patch
page-table-handling-cleanup.patch
modpost-white-list-pattern-adjustment.patch
adjust-nosmp-handling.patch
kill-vmalloc_earlyreserve.patch
x86-fix-change_page_attr-tlb-and-cache-flushing.patch
x86-smp-alt-once-option-is-only-useful-with-hotplug_cpu.patch
x86-64-remove-unused-variable-maxcpus.patch
