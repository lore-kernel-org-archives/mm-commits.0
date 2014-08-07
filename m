From: akpm@linux-foundation.org
Subject: [merged] libata-use-glob_match-from-lib-globc.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:07:43 -0700
Message-ID: <53e3dc8f.9X+/JMnEQd0GO4Tb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:55131 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaHGUHo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:44 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so844548obb.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@horizon.com, mingo@elte.hu, rdunlap@infradead.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: libata: Use glob_match from lib/glob.c
has been removed from the -mm tree.  Its filename was
     libata-use-glob_match-from-lib-globc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "George Spelvin" <linux@horizon.com>
Subject: libata: Use glob_match from lib/glob.c

The function may be useful for other drivers, so export it.  (Suggested by
Tejun Heo.)

Note that I inverted the return value of glob_match; returning true on
match seemed to make more sense.

Signed-off-by: George Spelvin <linux@horizon.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/Kconfig       |    1 
 drivers/ata/libata-core.c |   72 +-----------------------------------
 2 files changed, 4 insertions(+), 69 deletions(-)

diff -puN drivers/ata/Kconfig~libata-use-glob_match-from-lib-globc drivers/ata/Kconfig
--- a/drivers/ata/Kconfig~libata-use-glob_match-from-lib-globc
+++ a/drivers/ata/Kconfig
@@ -16,6 +16,7 @@ menuconfig ATA
 	depends on BLOCK
 	depends on !(M32R || M68K || S390) || BROKEN
 	select SCSI
+	select GLOB
 	---help---
 	  If you want to use an ATA hard disk, ATA tape drive, ATA CD-ROM or
 	  any other ATA device under Linux, say Y and make sure that you know
diff -puN drivers/ata/libata-core.c~libata-use-glob_match-from-lib-globc drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-use-glob_match-from-lib-globc
+++ a/drivers/ata/libata-core.c
@@ -59,6 +59,7 @@
 #include <linux/async.h>
 #include <linux/log2.h>
 #include <linux/slab.h>
+#include <linux/glob.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
@@ -4250,73 +4251,6 @@ static const struct ata_blacklist_entry
 	{ }
 };
 
-/**
- *	glob_match - match a text string against a glob-style pattern
- *	@text: the string to be examined
- *	@pattern: the glob-style pattern to be matched against
- *
- *	Either/both of text and pattern can be empty strings.
- *
- *	Match text against a glob-style pattern, with wildcards and simple sets:
- *
- *		?	matches any single character.
- *		*	matches any run of characters.
- *		[xyz]	matches a single character from the set: x, y, or z.
- *		[a-d]	matches a single character from the range: a, b, c, or d.
- *		[a-d0-9] matches a single character from either range.
- *
- *	The special characters ?, [, -, or *, can be matched using a set, eg. [*]
- *	Behaviour with malformed patterns is undefined, though generally reasonable.
- *
- *	Sample patterns:  "SD1?",  "SD1[0-5]",  "*R0",  "SD*1?[012]*xx"
- *
- *	This function uses one level of recursion per '*' in pattern.
- *	Since it calls _nothing_ else, and has _no_ explicit local variables,
- *	this will not cause stack problems for any reasonable use here.
- *
- *	RETURNS:
- *	0 on match, 1 otherwise.
- */
-static int glob_match (const char *text, const char *pattern)
-{
-	do {
-		/* Match single character or a '?' wildcard */
-		if (*text == *pattern || *pattern == '?') {
-			if (!*pattern++)
-				return 0;  /* End of both strings: match */
-		} else {
-			/* Match single char against a '[' bracketed ']' pattern set */
-			if (!*text || *pattern != '[')
-				break;  /* Not a pattern set */
-			while (*++pattern && *pattern != ']' && *text != *pattern) {
-				if (*pattern == '-' && *(pattern - 1) != '[')
-					if (*text > *(pattern - 1) && *text < *(pattern + 1)) {
-						++pattern;
-						break;
-					}
-			}
-			if (!*pattern || *pattern == ']')
-				return 1;  /* No match */
-			while (*pattern && *pattern++ != ']');
-		}
-	} while (*++text && *pattern);
-
-	/* Match any run of chars against a '*' wildcard */
-	if (*pattern == '*') {
-		if (!*++pattern)
-			return 0;  /* Match: avoid recursion at end of pattern */
-		/* Loop to handle additional pattern chars after the wildcard */
-		while (*text) {
-			if (glob_match(text, pattern) == 0)
-				return 0;  /* Remainder matched */
-			++text;  /* Absorb (match) this char and try again */
-		}
-	}
-	if (!*text && !*pattern)
-		return 0;  /* End of both strings: match */
-	return 1;  /* No match */
-}
