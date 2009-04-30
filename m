From: akpm@linux-foundation.org
Subject: + drivers-net-cxgb3-suppress-a-gcc-44-warning.patch added to -mm tree
Date: Thu, 30 Apr 2009 14:28:37 -0700
Message-ID: <200904302128.n3ULSbdl026830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909AbZD3VbD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Apr 2009 17:31:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sergey.senozhatsky@mail.by, davem@davemloft.net, divy@chelsio.com


The patch titled
     drivers/net/cxgb3: suppress a gcc-4.4 warning
has been added to the -mm tree.  Its filename is
     drivers-net-cxgb3-suppress-a-gcc-44-warning.patch

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

drivers-scsi-stc-suppress-gcc-44-warning.patch
drivers-net-cxgb3-suppress-a-gcc-44-warning.patch

