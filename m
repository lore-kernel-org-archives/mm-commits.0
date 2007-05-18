From: akpm@linux-foundation.org
Subject: - powerpc64-symbols-start-with.patch removed from -mm tree
Date: Fri, 18 May 2007 00:06:59 -0700
Message-ID: <200705180706.l4I76wYg010233@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42048 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761488AbXERHIk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:08:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     PowerPC64 symbols start with '.'
has been removed from the -mm tree.  Its filename was
     powerpc64-symbols-start-with.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-powerpc.patch
