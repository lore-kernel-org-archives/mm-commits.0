From: akpm@linux-foundation.org
Subject: [merged] drivers-char-mmtimerc-eliminate-useless-code.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:04:40 -0400
Message-ID: <201003150705.o2F75DYt017074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759722Ab0COHF2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:05:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, sivanich@sgi.com, stefanr@s5r6.in-berlin.de, mm-commits@vger.kernel.org


The patch titled
     drivers/char/mmtimer.c: eliminate useless code
has been removed from the -mm tree.  Its filename was
     drivers-char-mmtimerc-eliminate-useless-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/mmtimer.c: eliminate useless code
From: Julia Lawall <julia@diku.dk>

The variable x is initialized twice to the same (side effect-free)
expression.  Drop one initialization.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@forall@
idexpression *x;
identifier f!=ERR_PTR;
@@

x = f(...)
... when != x
(
x = f(...,<+...x...+>,...)
|
* x = f(...)
)
// </smpl>

Stefan observed:

  The next x = rb_entry(mn->next, struct mmtimer, list); is preceded by a
  test whether mn->next is NULL.

  Unless that test is redundant too, your patch fixes a potential NULL
  pointer dereference, introduced by commit cbacdd95 "SGI Altix mmtimer:
  allow larger number of timers per node" in 2.6.26.

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mmtimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mmtimer.c~drivers-char-mmtimerc-eliminate-useless-code drivers/char/mmtimer.c
--- a/drivers/char/mmtimer.c~drivers-char-mmtimerc-eliminate-useless-code
+++ a/drivers/char/mmtimer.c
@@ -546,7 +546,7 @@ static void mmtimer_tasklet(unsigned lon
 {
 	int nodeid = data;
 	struct mmtimer_node *mn = &timers[nodeid];
-	struct mmtimer *x = rb_entry(mn->next, struct mmtimer, list);
+	struct mmtimer *x;
 	struct k_itimer *t;
 	unsigned long flags;
 
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch
drivers-edac-introduce-missing-kfree.patch

