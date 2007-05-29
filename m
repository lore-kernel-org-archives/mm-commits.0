From: akpm@linux-foundation.org
Subject: - powerpc-suppress-modpost-warnings-for-references-from-the-toc.patch removed from -mm tree
Date: Tue, 29 May 2007 11:54:08 -0700
Message-ID: <200705291854.l4TIs7Vq008503@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760775AbXE2Syp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:54:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, paulus@samba.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: suppress modpost warnings for references from the .toc
has been removed from the -mm tree.  Its filename was
     powerpc-suppress-modpost-warnings-for-references-from-the-toc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-kbuild.patch
move-three-functions-that-are-only-needed-for.patch
introduce-config_virt_to_bus.patch
