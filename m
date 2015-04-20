From: akpm@linux-foundation.org
Subject: [merged] binfmt_misc-simplify-entry_status.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:17:26 -0700
Message-ID: <553550c6.6n87v6RNH6z+DHOo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40142 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbbDTTLF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_misc.c: simplify entry_status()
has been removed from the -mm tree.  Its filename was
     binfmt_misc-simplify-entry_status.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: fs/binfmt_misc.c: simplify entry_status()

sprintf() reliably returns the number of characters printed, so we don't
need to ask strlen() where we are.  Also replace calling sprintf("%02x")
in a loop with the much simpler bin2hex().

[akpm@linux-foundation.org: it's odd to include kernel.h after everything else]
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff -puN fs/binfmt_misc.c~binfmt_misc-simplify-entry_status fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~binfmt_misc-simplify-entry_status
+++ a/fs/binfmt_misc.c
@@ -9,6 +9,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
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

origin.patch

