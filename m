From: akpm@linux-foundation.org
Subject: + drivers-char-mmtimerc-eliminate-useless-code.patch added to -mm tree
Date: Fri, 22 Jan 2010 17:00:18 -0800
Message-ID: <201001230100.o0N10IRU007463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565Ab0AWBAg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jan 2010 20:00:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, sivanich@sgi.com, stefanr@s5r6.in-berlin.de


The patch titled
     drivers/char/mmtimer.c: eliminate useless code
has been added to the -mm tree.  Its filename is
     drivers-char-mmtimerc-eliminate-useless-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
drivers-scsi-sesc-eliminate-double-free.patch
kernel-credc-use-kmem_cache_free.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-gpu-drm-nouveau-nouveau_grctxc-correct-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
net-ipv4-correct-the-size-argument-to-kzalloc.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-staging-tm6000-tm6000-videoc-correct-null-test.patch
drivers-edac-introduce-missing-kfree.patch
drivers-char-mmtimerc-eliminate-useless-code.patch

