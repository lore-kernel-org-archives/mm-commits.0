From: akpm@linux-foundation.org
Subject: + printk-fix-comment-for-printk-ratelimiting.patch added to -mm tree
Date: Tue, 29 Jul 2008 00:53:44 -0700
Message-ID: <200807290753.m6T7riEA021888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753370AbYG2HyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 03:54:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Uwe.Kleine-Koenig@digi.com, hidave.darkstar@gmail.com


The patch titled
     printk: fix comment for printk ratelimiting
has been added to the -mm tree.  Its filename is
     printk-fix-comment-for-printk-ratelimiting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: printk: fix comment for printk ratelimiting
=46rom: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>

The comment assumed the burst to be one and the ratelimit used to be na=
med
printk_ratelimit_jiffies.

Signed-off-by: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/printk.c~printk-fix-comment-for-printk-ratelimiting ke=
rnel/printk.c
--- a/kernel/printk.c~printk-fix-comment-for-printk-ratelimiting
+++ a/kernel/printk.c
@@ -1309,14 +1309,14 @@ void tty_write_message(struct tty_struct
=20
 #if defined CONFIG_PRINTK
=20
-DEFINE_RATELIMIT_STATE(printk_ratelimit_state, 5 * HZ, 10);
 /*
  * printk rate limiting, lifted from the networking subsystem.
  *
- * This enforces a rate limit: not more than one kernel message
- * every printk_ratelimit_jiffies to make a denial-of-service
- * attack impossible.
+ * This enforces a rate limit: not more than 10 kernel messages
+ * every 5s to make a denial-of-service attack impossible.
  */
+DEFINE_RATELIMIT_STATE(printk_ratelimit_state, 5 * HZ, 10);
+
 int printk_ratelimit(void)
 {
 	return __ratelimit(&printk_ratelimit_state);
_

Patches currently in -mm which might be from Uwe.Kleine-Koenig@digi.com=
 are

origin.patch
printk-fix-comment-for-printk-ratelimiting.patch
linux-next.patch
genirq-better-warning-on-irqchip-set_type-failure.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
