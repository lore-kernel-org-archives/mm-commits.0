From: akpm@linux-foundation.org
Subject: - drivers-net-hamradio-6packc-move-a-dereference-below-a-null-test.patch removed from -mm tree
Date: Mon, 12 Jan 2009 11:58:34 -0800
Message-ID: <200901121958.n0CJwYO9027752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbZALUJn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 15:09:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     drivers/net/hamradio/6pack.c: move a dereference below a NULL test
has been removed from the -mm tree.  Its filename was
     drivers-net-hamradio-6packc-move-a-dereference-below-a-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/hamradio/6pack.c: move a dereference below a NULL test
From: Julia Lawall <julia@diku.dk>

In each case, if the NULL test is necessary, then the dereference should be
moved below the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/hamradio/6pack.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/hamradio/6pack.c~drivers-net-hamradio-6packc-move-a-dereference-below-a-null-test drivers/net/hamradio/6pack.c
--- a/drivers/net/hamradio/6pack.c~drivers-net-hamradio-6packc-move-a-dereference-below-a-null-test
+++ a/drivers/net/hamradio/6pack.c
@@ -717,11 +717,12 @@ static int sixpack_ioctl(struct tty_stru
 	unsigned int cmd, unsigned long arg)
 {
 	struct sixpack *sp = sp_get(tty);
-	struct net_device *dev = sp->dev;
+	struct net_device *dev;
 	unsigned int tmp, err;
 
 	if (!sp)
 		return -ENXIO;
+	dev = sp->dev;
 
 	switch(cmd) {
 	case SIOCGIFNAME:
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch

