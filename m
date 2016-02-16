From: akpm@linux-foundation.org
Subject: [merged] vsprintf-kptr_restrict-is-okay-in-irq-when-2.patch
 removed from -mm tree
Date: Tue, 16 Feb 2016 10:49:00 -0800
Message-ID: <56c36f1c.Pm8kzuFzgH4FT1d9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbcBPStA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Feb 2016 13:49:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Jason@zx2c4.com, keescook@chromium.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: vsprintf: kptr_restrict is okay in IRQ when 2
has been removed from the -mm tree.  Its filename was
     vsprintf-kptr_restrict-is-okay-in-irq-when-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: vsprintf: kptr_restrict is okay in IRQ when 2

The kptr_restrict flag, when set to 1, only prints the kernel address when
the user has CAP_SYSLOG.  When it is set to 2, the kernel address is
always printed as zero.  When set to 1, this needs to check whether or not
we're in IRQ.  However, when set to 2, this check is unneccessary, and
produces confusing results in dmesg.  Thus, only make sure we're not in
IRQ when mode 1 is used, but not mode 2.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-kptr_restrict-is-okay-in-irq-when-2 lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-kptr_restrict-is-okay-in-irq-when-2
+++ a/lib/vsprintf.c
@@ -1590,22 +1590,23 @@ char *pointer(const char *fmt, char *buf
 			return buf;
 		}
 	case 'K':
-		/*
-		 * %pK cannot be used in IRQ context because its test
-		 * for CAP_SYSLOG would be meaningless.
-		 */
-		if (kptr_restrict && (in_irq() || in_serving_softirq() ||
-				      in_nmi())) {
-			if (spec.field_width == -1)
-				spec.field_width = default_width;
-			return string(buf, end, "pK-error", spec);
-		}
-
 		switch (kptr_restrict) {
 		case 0:
 			/* Always print %pK values */
 			break;
 		case 1: {
+			const struct cred *cred;
+
+			/*
+			 * kptr_restrict==1 cannot be used in IRQ context
+			 * because its test for CAP_SYSLOG would be meaningless.
+			 */
+			if (in_irq() || in_serving_softirq() || in_nmi()) {
+				if (spec.field_width == -1)
+					spec.field_width = default_width;
+				return string(buf, end, "pK-error", spec);
+			}
+
 			/*
 			 * Only print the real pointer value if the current
 			 * process has CAP_SYSLOG and is running with the
@@ -1615,8 +1616,7 @@ char *pointer(const char *fmt, char *buf
 			 * leak pointer values if a binary opens a file using
 			 * %pK and then elevates privileges before reading it.
 			 */
-			const struct cred *cred = current_cred();
