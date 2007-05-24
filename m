From: akpm@linux-foundation.org
Subject: + powerpc-suppress-modpost-warnings-for-references-from-the-toc.patch added to -mm tree
Date: Thu, 24 May 2007 15:22:00 -0700
Message-ID: <200705242222.l4OMM038004759@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbXEXWWj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 18:22:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, paulus@samba.org, sam@ravnborg.org


The patch titled
     powerpc: suppress modpost warnings for references from the .toc
has been added to the -mm tree.  Its filename is
     powerpc-suppress-modpost-warnings-for-references-from-the-toc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: suppress modpost warnings for references from the .toc
From: Stephen Rothwell <sfr@canb.auug.org.au>

We should do better here by effetively "dereferencing" references to the
.toc (or the .got2) section, but that is much harder.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/modpost.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN scripts/mod/modpost.c~powerpc-suppress-modpost-warnings-for-references-from-the-toc scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~powerpc-suppress-modpost-warnings-for-references-from-the-toc
+++ a/scripts/mod/modpost.c
@@ -865,9 +865,12 @@ static void warn_sec_mismatch(const char
 		return;
 
 	/* fromsec whitelist - without a valid 'before'
-	 * powerpc has a GOT table in .got2 section */
+	 * powerpc has a GOT table in .got2 section
+	 * and also a .toc section */
 	if (strcmp(fromsec, ".got2") == 0)
 		return;
+	if (strcmp(fromsec, ".toc") == 0)
+		return;
 
 	if (before && after) {
 		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
powerpc-suppress-modpost-warnings-for-references-from-the-toc.patch
move-three-functions-that-are-only-needed-for.patch
introduce-config_virt_to_bus.patch
