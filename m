From: akpm@linux-foundation.org
Subject: + printk-only-look-for-prefix-levels-in-kernel-messages.patch added to -mm tree
Date: Wed, 06 Jun 2012 14:47:13 -0700
Message-ID: <20120606214713.DB723A0274@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:38845 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756307Ab2FFVrQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2012 17:47:16 -0400
Received: by lagr15 with SMTP id r15so424671lag.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Jun 2012 14:47:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, kay@vrfy.org


The patch titled
     Subject: printk: only look for prefix levels in kernel messages
has been added to the -mm tree.  Its filename is
     printk-only-look-for-prefix-levels-in-kernel-messages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: only look for prefix levels in kernel messages

vprintk_emit() prefix parsing should only be done for internal kernel
messages.  This allows existing behavior to be kept in all cases.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff -puN kernel/printk.c~printk-only-look-for-prefix-levels-in-kernel-messages kernel/printk.c
--- a/kernel/printk.c~printk-only-look-for-prefix-levels-in-kernel-messages
+++ a/kernel/printk.c
@@ -1269,7 +1269,6 @@ asmlinkage int vprintk_emit(int facility
 	static char cont_buf[LOG_LINE_MAX];
 	static size_t cont_len;
 	static int cont_level;
-	int kern_level;
 	static struct task_struct *cont_task;
 	static char textbuf[LOG_LINE_MAX];
 	char *text = textbuf;
@@ -1331,21 +1330,24 @@ asmlinkage int vprintk_emit(int facility
 		newline = true;
 	}
 
-	/* strip syslog prefix and extract log level or control flags */
-	kern_level = printk_get_level(text);
-	if (kern_level) {
-		const char *end_of_header = printk_skip_level(text);
-		switch (kern_level) {
-		case '0' ... '7':
-			if (level == -1)
-				level = kern_level - '0';
-		case 'd':	/* KERN_DEFAULT */
-			prefix = true;
-		case 'c':	/* KERN_CONT */
-			break;
+	/* strip kernel syslog prefix and extract log level or control flags */
+	if (facility == 0) {
+		int kern_level = printk_get_level(text);
+
+		if (kern_level) {
+			const char *end_of_header = printk_skip_level(text);
+			switch (kern_level) {
+			case '0' ... '7':
+				if (level == -1)
+					level = kern_level - '0';
+			case 'd':	/* KERN_DEFAULT */
+				prefix = true;
+			case 'c':	/* KERN_CONT */
+				break;
+			}
+			text_len -= end_of_header - text;
+			text = (char *)end_of_header;
 		}
-		text_len -=  end_of_header - text;
-		text = (char *)end_of_header;
 	}
 
 	if (level == -1)
_
Subject: Subject: printk: only look for prefix levels in kernel messages

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-whitespace-fixes.patch
printk-add-generic-functions-to-find-kern_level-headers.patch
printk-add-kern_levelsh-to-make-kern_level-available-for-asm-use.patch
arch-remove-direct-definitions-of-kern_level-uses.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
sound-use-printk_get_level-and-printk_skip_level.patch
staging-wlags49_h2-remove-direct-declarations-of-kern_level-prefixes.patch
printk-convert-the-format-for-kern_level-to-a-2-byte-pattern.patch
printk-only-look-for-prefix-levels-in-kernel-messages.patch
printk-remove-the-now-unnecessary-c-annotation-for-kern_cont.patch

