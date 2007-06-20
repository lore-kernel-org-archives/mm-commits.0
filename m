From: akpm@linux-foundation.org
Subject: - remove-usage-of-memmem-from-scripts-kallsymsc.patch removed from -mm tree
Date: Wed, 20 Jun 2007 10:01:18 -0700
Message-ID: <200706201701.l5KH1I2h010075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39633 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753509AbXFTRCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Jun 2007 13:02:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmarques@grupopie.com, sam@ravnborg.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     remove usage of memmem from scripts/kallsyms.c
has been removed from the -mm tree.  Its filename was
     remove-usage-of-memmem-from-scripts-kallsymsc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: remove usage of memmem from scripts/kallsyms.c
From: Paulo Marques <pmarques@grupopie.com>

The only in-kernel user of "memmem" is scripts/kallsyms.c and it only uses it
to find tokens that are 2 bytes in size.  It is trivial to replace it with a
simple function that finds 2-byte tokens.

This should help users from systems that don't have the memmem GNU extension
available.

Signed-off-by: Paulo Marques <pmarques@grupopie.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kallsyms.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff -puN scripts/kallsyms.c~remove-usage-of-memmem-from-scripts-kallsymsc scripts/kallsyms.c
--- a/scripts/kallsyms.c~remove-usage-of-memmem-from-scripts-kallsymsc
+++ a/scripts/kallsyms.c
@@ -378,6 +378,17 @@ static void build_initial_tok_table(void
 	table_cnt = pos;
 }
 
+static void *find_token(unsigned char *str, int len, unsigned char *token)
+{
+	int i;
+
+	for (i = 0; i < len - 1; i++) {
+		if (str[i] == token[0] && str[i+1] == token[1])
+			return &str[i];
+	}
+	return NULL;
+}
+
 /* replace a given token in all the valid symbols. Use the sampled symbols
  * to update the counts */
 static void compress_symbols(unsigned char *str, int idx)
@@ -391,7 +402,7 @@ static void compress_symbols(unsigned ch
 		p1 = table[i].sym;
 
 		/* find the token on the symbol */
-		p2 = memmem(p1, len, str, 2);
+		p2 = find_token(p1, len, str);
 		if (!p2) continue;
 
 		/* decrease the counts for this symbol's tokens */
@@ -410,7 +421,7 @@ static void compress_symbols(unsigned ch
 			if (size < 2) break;
 
 			/* find the token on the symbol */
-			p2 = memmem(p1, size, str, 2);
+			p2 = find_token(p1, size, str);
 
 		} while (p2);
 
_

Patches currently in -mm which might be from pmarques@grupopie.com are

remove-usage-of-memmem-from-scripts-kallsymsc.patch
