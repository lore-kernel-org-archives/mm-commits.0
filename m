From: akpm@linux-foundation.org
Subject: + binfmt_misc-simplify-entry_status.patch added to -mm tree
Date: Thu, 26 Feb 2015 15:18:00 -0800
Message-ID: <54efa9a8.Vfqs8x+C+EA2vvsv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbbBZXSB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Feb 2015 18:18:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_misc.c: simplify entry_status()
has been added to the -mm tree.  Its filename is
     binfmt_misc-simplify-entry_status.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/binfmt_misc-simplify-entry_status.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_misc-simplify-entry_status.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: fs/binfmt_misc.c: simplify entry_status()

sprintf() reliably returns the number of characters printed, so we don't
need to ask strlen() where we are.  Also replace calling sprintf("%02x")
in a loop with the much simpler bin2hex().

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff -puN fs/binfmt_misc.c~binfmt_misc-simplify-entry_status fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~binfmt_misc-simplify-entry_status
+++ a/fs/binfmt_misc.c
@@ -24,6 +24,7 @@
 #include <linux/syscalls.h>
 #include <linux/fs.h>
 #include <linux/uaccess.h>
+#include <linux/kernel.h>
 
 #ifdef DEBUG
 # define USE_DEBUG 1
@@ -521,9 +522,8 @@ static int parse_command(const char __us
 
 static void entry_status(Node *e, char *page)
 {
-	char *dp;
-	char *status = "disabled";
-	const char *flags = "flags: ";
+	char *dp = page;
+	const char *status = "disabled";
 
 	if (test_bit(Enabled, &e->flags))
 		status = "enabled";
@@ -533,12 +533,10 @@ static void entry_status(Node *e, char *
 		return;
 	}
 
-	sprintf(page, "%s\ninterpreter %s\n", status, e->interpreter);
-	dp = page + strlen(page);
+	dp += sprintf(dp, "%s\ninterpreter %s\n", status, e->interpreter);
 
 	/* print the special flags */
-	sprintf(dp, "%s", flags);
-	dp += strlen(flags);
+	dp += sprintf(dp, "flags: ");
 	if (e->flags & MISC_FMT_PRESERVE_ARGV0)
 		*dp++ = 'P';
 	if (e->flags & MISC_FMT_OPEN_BINARY)
@@ -550,21 +548,11 @@ static void entry_status(Node *e, char *
 	if (!test_bit(Magic, &e->flags)) {
 		sprintf(dp, "extension .%s\n", e->magic);
 	} else {
-		int i;
-
-		sprintf(dp, "offset %i\nmagic ", e->offset);
-		dp = page + strlen(page);
-		for (i = 0; i < e->size; i++) {
-			sprintf(dp, "%02x", 0xff & (int) (e->magic[i]));
-			dp += 2;
-		}
+		dp += sprintf(dp, "offset %i\nmagic ", e->offset);
+		dp = bin2hex(dp, e->magic, e->size);
 		if (e->mask) {
-			sprintf(dp, "\nmask ");
-			dp += 6;
-			for (i = 0; i < e->size; i++) {
-				sprintf(dp, "%02x", 0xff & (int) (e->mask[i]));
-				dp += 2;
-			}
+			dp += sprintf(dp, "\nmask ");
+			dp = bin2hex(dp, e->mask, e->size);
 		}
 		*dp++ = '\n';
 		*dp = '\0';
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-vsprintfc-eliminate-some-branches.patch
lib-vsprintfc-reduce-stack-use-in-number.patch
lib-vsprintfc-eliminate-duplicate-hex-string-array.patch
lib-vsprintfc-another-small-hack.patch
linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch
lib-find__bit-reimplementation.patch
lib-find__bit-reimplementation-fix.patch
lib-move-find_last_bit-to-lib-find_next_bitc.patch
lib-rename-lib-find_next_bitc-to-lib-find_bitc.patch
binfmt_misc-simplify-entry_status.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch
lib-lz4-pull-out-constant-tables.patch
linux-next.patch

