From: akpm@linux-foundation.org
Subject: + linux-next-fix-2.patch added to -mm tree
Date: Thu, 09 Jan 2020 16:36:40 -0800
Message-ID: <20200110003640.OkYDJZ--Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730334AbgAJAgl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jan 2020 19:36:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: a
has been added to the -mm tree.  Its filename is
     linux-next-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: a

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c~linux-next-fix-2
+++ a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -767,13 +767,6 @@ __mlxsw_sp_qdisc_ets_graft(struct mlxsw_
 	    mlxsw_sp_port->tclass_qdiscs[tclass_num].handle == child_handle)
 		return 0;
 
-	if (!p->child_handle) {
-		/* This is an invisible FIFO replacing the original Qdisc.
-		 * Ignore it--the original Qdisc's destroy will follow.
-		 */
-		return 0;
-	}
