From: akpm@linux-foundation.org
Subject: + powerpc64-symbols-start-with.patch added to -mm tree
Date: Thu, 10 May 2007 23:51:44 -0700
Message-ID: <200705110651.l4B6pigo009132@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbXEKGvv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 02:51:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au


The patch titled
     PowerPC64 symbols start with '.'
has been added to the -mm tree.  Its filename is
     powerpc64-symbols-start-with.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PowerPC64 symbols start with '.'
From: Stephen Rothwell <sfr@canb.auug.org.au>

which we want to skip during modpost processing.  We need this to make some
of the whitelisting work.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/modpost.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff -puN scripts/mod/modpost.c~powerpc64-symbols-start-with scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~powerpc64-symbols-start-with
+++ a/scripts/mod/modpost.c
@@ -164,7 +164,13 @@ static inline unsigned int tdb_hash(cons
 static struct symbol *alloc_symbol(const char *name, unsigned int weak,
 				   struct symbol *next)
 {
-	struct symbol *s = NOFAIL(malloc(sizeof(*s) + strlen(name) + 1));
+	struct symbol *s;
+
+	/* For our purposes, .foo matches foo.  PPC64 needs this. */
+	if (name[0] == '.')
+		name++;
+
+	s = NOFAIL(malloc(sizeof(*s) + strlen(name) + 1));
 
 	memset(s, 0, sizeof(*s));
 	strcpy(s->name, name);
@@ -180,6 +186,10 @@ static struct symbol *new_symbol(const c
 	unsigned int hash;
 	struct symbol *new;
 
+	/* For our purposes, .foo matches foo.  PPC64 needs this. */
+	if (name[0] == '.')
+		name++;
+
 	hash = tdb_hash(name) % SYMBOL_HASH_SIZE;
 	new = symbolhash[hash] = alloc_symbol(name, 0, symbolhash[hash]);
 	new->module = module;
@@ -684,6 +694,12 @@ static int secref_whitelist(const char *
 		NULL
 	};
 
+	/* For our purposes, .foo matches foo.  PPC64 needs this. */
+	if (atsym[0] == '.')
+		atsym++;
+	if (refsymname[0] == '.')
+		refsymname++;
+
 	/* Check for pattern 1 */
 	if (strcmp(tosec, ".init.data") != 0)
 		f1 = 0;
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
consolidate-asm-pollh.patch
powerpc64-symbols-start-with.patch
