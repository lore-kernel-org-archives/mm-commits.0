From: akpm@linux-foundation.org
Subject: - move-kernel-doc-comment-for-might_sleep-directly-before-its-defining-block.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:53:03 -0700
Message-ID: <200808130853.m7D8r3ig008287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510AbYHMJDP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 05:03:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Uwe.Kleine-Koenig@digi.com, mingo@elte.hu, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     move kernel-doc comment for might_sleep directly before its defini=
ng block
has been removed from the -mm tree.  Its filename was
     move-kernel-doc-comment-for-might_sleep-directly-before-its-defini=
ng-block.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: move kernel-doc comment for might_sleep directly before its de=
fining block
=46rom: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>

Signed-off-by: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/kernel.h~move-kernel-doc-comment-for-might_slee=
p-directly-before-its-defining-block include/linux/kernel.h
--- a/include/linux/kernel.h~move-kernel-doc-comment-for-might_sleep-di=
rectly-before-its-defining-block
+++ a/include/linux/kernel.h
@@ -108,6 +108,13 @@ struct completion;
 struct pt_regs;
 struct user;
=20
+#ifdef CONFIG_PREEMPT_VOLUNTARY
+extern int _cond_resched(void);
+# define might_resched() _cond_resched()
+#else
+# define might_resched() do { } while (0)
+#endif
+
 /**
  * might_sleep - annotation for functions that can sleep
  *
@@ -118,13 +125,6 @@ struct user;
  * be bitten later when the calling function happens to sleep when it =
is not
  * supposed to.
  */
-#ifdef CONFIG_PREEMPT_VOLUNTARY
-extern int _cond_resched(void);
-# define might_resched() _cond_resched()
-#else
-# define might_resched() do { } while (0)
-#endif
