From: akpm@linux-foundation.org
Subject: - xtensa-fix-modpost-warnings.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:58:25 -0700
Message-ID: <200707192058.l6JKwPsf022744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40065 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761584AbXGSU6e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:58:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: czankel@tensilica.com, chris@zankel.net, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     xtensa: fix modpost warnings
has been removed from the -mm tree.  Its filename was
     xtensa-fix-modpost-warnings.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: xtensa: fix modpost warnings
From: Chris Zankel <czankel@tensilica.com>

The Xtensa architecture places literal pools in sections separate from the
instructions.  The corresponsing text sections, therefore, reference the
.literal section, and we have to suppress those warnings.  The naming
convention defines the name for a literal section as .SECTION.literal,
unless .SECTION is .text.  In that case the name is only .literal.  Using
strncmp() instead of strcmp() to compare the from-section with
.SECTION.init.refok in pattern 0 should not cause any regressions for other
architectures.  We also need to suppress warnings for two informational
sections (.xt.lit and .xt.prop) used by the Xtensa architecture.

Signed-off-by: Chris Zankel <chris@zankel.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/modpost.c |   30 ++++++++++++++++++++++++------
 1 files changed, 24 insertions(+), 6 deletions(-)

diff -puN scripts/mod/modpost.c~xtensa-fix-modpost-warnings scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~xtensa-fix-modpost-warnings
+++ a/scripts/mod/modpost.c
@@ -625,12 +625,19 @@ static int strrcmp(const char *s, const 
  *   This pattern is identified by
  *   refsymname = __init_begin, _sinittext, _einittext
  *
+ * Pattern 11:
+ *  Xtensa uses literal sections for constants that are accessed PC-relative.
+ *  Literal sections may savely reference their text sections.
+ *  (Note that the name for the literal section omits any trailing '.text')
+ *  tosec = <section>[.text]
+ *  fromsec = <section>.literal
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
 			    const char *refsymname)
 {
 	int f1 = 1, f2 = 1;
+	int len;
 	const char **s;
 	const char *pat2sym[] = {
 		"driver",
@@ -652,8 +659,10 @@ static int secref_whitelist(const char *
 	};
 
 	/* Check for pattern 0 */
-	if ((strcmp(fromsec, ".text.init.refok") == 0) ||
-	    (strcmp(fromsec, ".data.init.refok") == 0))
+	if ((strncmp(fromsec, ".text.init.refok",
+		     strlen(".text.init.refok")) == 0) ||
+	    (strncmp(fromsec, ".data.init.refok",
+		     strlen(".data.init.refok")) == 0))
 		return 1;
 
 	/* Check for pattern 1 */
@@ -694,6 +703,16 @@ static int secref_whitelist(const char *
 		if (strcmp(refsymname, *s) == 0)
 			return 1;
 
+
+	/* Check for pattern 11 */
+	len = strlen(tosec) - strlen(".text");
+	if (len <= 0 || strcmp(tosec + len, ".text") != 0)
+		len = strlen(tosec);
+	if (strncmp(tosec, fromsec, len) == 0
+	    && (strlen(fromsec) > len)
+	    && (strcmp(fromsec + len, ".literal") == 0))
+		return 1;
+
 	return 0;
 }
 
@@ -821,10 +840,9 @@ static void warn_sec_mismatch(const char
 	if (refsym && strlen(elf->strtab + refsym->st_name))
 		refsymname = elf->strtab + refsym->st_name;
 
-	/* check whitelist - we may ignore it */
-	if (before &&
-	    secref_whitelist(modname, secname, fromsec,
-			     elf->strtab + before->st_name, refsymname))
+	if (secref_whitelist(modname, secname, fromsec,
+			     before ? elf->strtab + before->st_name : "",
+			     refsymname))
 		return;
 
 	if (before && after) {
_

Patches currently in -mm which might be from czankel@tensilica.com are

xtensa-fix-modpost-warnings.patch
