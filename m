From: akpm@linux-foundation.org
Subject: + printk-add-generic-functions-to-find-kern_level-headers.patch added to -mm tree
Date: Wed, 06 Jun 2012 14:45:09 -0700
Message-ID: <20120606214510.5F08BA02AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53788 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab2FFVpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2012 17:45:12 -0400
Received: by vcbfl13 with SMTP id fl13so761727vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Jun 2012 14:45:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, kay.sievers@vrfy.org


The patch titled
     Subject: printk: add generic functions to find KERN_<LEVEL> headers
has been added to the -mm tree.  Its filename is
     printk-add-generic-functions-to-find-kern_level-headers.patch

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
Subject: printk: add generic functions to find KERN_<LEVEL> headers

The current form of a KERN_<LEVEL> is "<.>".

Add printk_get_level and printk_skip_level functions to handle these
formats.

These functions centralize tests of KERN_<LEVEL> so a future modification
can change the KERN_<LEVEL> style and shorten the number of bytes consumed
by these headers.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |   26 ++++++++++++++++++++++++++
 kernel/printk.c        |   13 ++++++++-----
 2 files changed, 34 insertions(+), 5 deletions(-)

diff -puN include/linux/printk.h~printk-add-generic-functions-to-find-kern_level-headers include/linux/printk.h
--- a/include/linux/printk.h~printk-add-generic-functions-to-find-kern_level-headers
+++ a/include/linux/printk.h
@@ -24,6 +24,32 @@ extern const char linux_proc_banner[];
  */
 #define KERN_CONT	"<c>"
 
+static inline int printk_get_level(const char *buffer)
+{
+	if (buffer[0] == '<' && buffer[1] && buffer[2] == '>') {
+		switch (buffer[1]) {
+		case '0' ... '7':
+		case 'd':	/* KERN_DEFAULT */
+		case 'c':	/* KERN_CONT */
+			return buffer[1];
+		}
+	}
+	return 0;
+}
+
+static inline const char *printk_skip_level(const char *buffer)
+{
+	if (printk_get_level(buffer)) {
+		switch (buffer[1]) {
+		case '0' ... '7':
+		case 'd':	/* KERN_DEFAULT */
+		case 'c':	/* KERN_CONT */
+			return buffer + 3;
+		}
+	}
+	return buffer;
+}
+
 extern int console_printk[];
 
 #define console_loglevel (console_printk[0])
diff -puN kernel/printk.c~printk-add-generic-functions-to-find-kern_level-headers kernel/printk.c
--- a/kernel/printk.c~printk-add-generic-functions-to-find-kern_level-headers
+++ a/kernel/printk.c
@@ -1269,6 +1269,7 @@ asmlinkage int vprintk_emit(int facility
 	static char cont_buf[LOG_LINE_MAX];
 	static size_t cont_len;
 	static int cont_level;
+	int kern_level;
 	static struct task_struct *cont_task;
 	static char textbuf[LOG_LINE_MAX];
 	char *text = textbuf;
@@ -1331,17 +1332,19 @@ asmlinkage int vprintk_emit(int facility
 	}
 
 	/* strip syslog prefix and extract log level or control flags */
-	if (text[0] == '<' && text[1] && text[2] == '>') {
-		switch (text[1]) {
+	kern_level = printk_get_level(text);
+	if (kern_level) {
+		const char *end_of_header = printk_skip_level(text);
+		switch (kern_level) {
 		case '0' ... '7':
 			if (level == -1)
-				level = text[1] - '0';
+				level = kern_level - '0';
 		case 'd':	/* KERN_DEFAULT */
 			prefix = true;
 		case 'c':	/* KERN_CONT */
-			text += 3;
-			text_len -= 3;
 		}
+		text_len -=  end_of_header - text;
+		text = end_of_header;
 	}
 
 	if (level == -1)
_
Subject: Subject: printk: add generic functions to find KERN_<LEVEL> headers

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-whitespace-fixes.patch
printk-add-generic-functions-to-find-kern_level-headers.patch
printk-add-kern_levelsh-to-make-kern_level-available-for-asm-use.patch
arch-remove-direct-definitions-of-kern_level-uses.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch
sound-use-printk_get_level-and-printk_skip_level.patch
staging-wlags49_h2-remove-direct-declarations-of-kern_level-prefixes.patch
printk-convert-the-format-for-kern_level-to-a-2-byte-pattern.patch
printk-only-look-for-prefix-levels-in-kernel-messages.patch
printk-remove-the-now-unnecessary-c-annotation-for-kern_cont.patch

