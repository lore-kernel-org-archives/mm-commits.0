From: akpm@linux-foundation.org
Subject: - drivers-misc-use-div_round_up.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:14 -0700
Message-ID: <200810182311.m9INBEj9027700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbYJRXLV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:11:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc: Use DIV_ROUND_UP
has been removed from the -mm tree.  Its filename was
     drivers-misc-use-div_round_up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc: Use DIV_ROUND_UP
From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukservices.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/sgi-gru/grukservices.c~drivers-misc-use-div_round_up drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~drivers-misc-use-div_round_up
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -466,7 +466,7 @@ int gru_send_message_gpa(unsigned long m
 	STAT(mesq_send);
 	BUG_ON(bytes < sizeof(int) || bytes > 2 * GRU_CACHE_LINE_BYTES);
 
-	clines = (bytes + GRU_CACHE_LINE_BYTES - 1) / GRU_CACHE_LINE_BYTES;
+	clines = DIV_ROUND_UP(bytes, GRU_CACHE_LINE_BYTES);
 	if (gru_get_cpu_resources(bytes, &cb, &dsr))
 		return MQE_BUG_NO_RESOURCES;
 	memcpy(dsr, mesg, bytes);
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch

