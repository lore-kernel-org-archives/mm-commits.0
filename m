From: akpm@linux-foundation.org
Subject: [merged] drivers-net-cxgb3-suppress-a-gcc-44-warning.patch removed from -mm tree
Date: Mon, 04 May 2009 13:14:03 -0700
Message-ID: <200905042014.n44KE3K4022946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753734AbZEDUQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 16:16:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@mail.by, davem@davemloft.net, divy@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/cxgb3: suppress a gcc-4.4 warning
has been removed from the -mm tree.  Its filename was
     drivers-net-cxgb3-suppress-a-gcc-44-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/cxgb3: suppress a gcc-4.4 warning
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>

drivers/net/cxgb3/t3_hw.c: In function `t3_prep_adapter':
drivers/net/cxgb3/t3_hw.c:3782: warning: suggest parentheses around operand of `!' or change `|' to `||' or `!' to `~'

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Divy Le Ray <divy@chelsio.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/t3_hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/cxgb3/t3_hw.c~drivers-net-cxgb3-suppress-a-gcc-44-warning drivers/net/cxgb3/t3_hw.c
--- a/drivers/net/cxgb3/t3_hw.c~drivers-net-cxgb3-suppress-a-gcc-44-warning
+++ a/drivers/net/cxgb3/t3_hw.c
@@ -3779,7 +3779,7 @@ int t3_prep_adapter(struct adapter *adap
 
 	adapter->params.info = ai;
 	adapter->params.nports = ai->nports0 + ai->nports1;
-	adapter->params.chan_map = !!ai->nports0 | (!!ai->nports1 << 1);
+	adapter->params.chan_map = (!!ai->nports0) | (!!ai->nports1 << 1);
 	adapter->params.rev = t3_read_reg(adapter, A_PL_REV);
 	/*
 	 * We used to only run the "adapter check task" once a second if
_

Patches currently in -mm which might be from sergey.senozhatsky@mail.by are

linux-next.patch

