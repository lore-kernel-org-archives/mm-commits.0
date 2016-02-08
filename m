From: akpm@linux-foundation.org
Subject: + vsprintf-kptr_restrict-is-okay-in-irq-when-2.patch added to -mm tree
Date: Mon, 08 Feb 2016 15:45:40 -0800
Message-ID: <56b928a4.GDbvNA5FyC2WJ5U0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbcBHXpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 18:45:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Jason@zx2c4.com, keescook@chromium.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: vsprintf: kptr_restrict is okay in IRQ when 2
has been added to the -mm tree.  Its filename is
     vsprintf-kptr_restrict-is-okay-in-irq-when-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vsprintf-kptr_restrict-is-okay-in-irq-when-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vsprintf-kptr_restrict-is-okay-in-irq-when-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: vsprintf: kptr_restrict is okay in IRQ when 2

The kptr_restrict flag, when set to 1, only prints the kernel address when
the user has CAP_SYSLOG.  When it is set to 2, the kernel address is
always printed as zero.  When set to 1, this needs to check whether or not
we're in IRQ.  However, when set to 2, this check is unneccessary, and
produces confusing results in dmesg.  Thus, only make sure we're not in
IRQ when mode 1 is used, but not mode 2.

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
@@ -1663,22 +1663,23 @@ char *pointer(const char *fmt, char *buf
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
+			 * kptr_restrict==1 cannot be used in IRQ context because
+			 * its test for CAP_SYSLOG would be meaningless.
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
@@ -1688,8 +1689,7 @@ char *pointer(const char *fmt, char *buf
 			 * leak pointer values if a binary opens a file using
 			 * %pK and then elevates privileges before reading it.
 			 */
-			const struct cred *cred = current_cred();
