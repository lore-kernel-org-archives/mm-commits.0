From: akpm@linux-foundation.org
Subject: - printk-fix-comment-for-printk-ratelimiting.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:15:03 -0700
Message-ID: <200807301915.m6UJF3OW010958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502AbYG3TPi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:15:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Uwe.Kleine-Koenig@digi.com, hidave.darkstar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     printk: fix comment for printk ratelimiting
has been removed from the -mm tree.  Its filename was
     printk-fix-comment-for-printk-ratelimiting.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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
linux-next.patch
genirq-better-warning-on-irqchip-set_type-failure.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
