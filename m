From: akpm@linux-foundation.org
Subject: + drivers-net-igb-use-field_sizeof.patch added to -mm tree
Date: Thu, 14 Feb 2008 14:09:32 -0800
Message-ID: <200802142209.m1EM9WQH005477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43519 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760652AbYBNWJm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 17:09:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, auke-jan.h.kok@intel.com


The patch titled
     drivers/net/igb: Use FIELD_SIZEOF
has been added to the -mm tree.  Its filename is
     drivers-net-igb-use-field_sizeof.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/igb: Use FIELD_SIZEOF
From: Julia Lawall <julia@diku.dk>

Robert P.J. Day proposed to use the macro FIELD_SIZEOF in replace of code
that matches its definition.

The modification was made using the following semantic patch
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
type t;
identifier f;
@@

- (sizeof(((t*)0)->f))
+ FIELD_SIZEOF(t, f)

@depends on haskernel@
type t;
identifier f;
@@

- sizeof(((t*)0)->f)
+ FIELD_SIZEOF(t, f)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/igb/igb_ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/igb/igb_ethtool.c~drivers-net-igb-use-field_sizeof drivers/net/igb/igb_ethtool.c
--- a/drivers/net/igb/igb_ethtool.c~drivers-net-igb-use-field_sizeof
+++ a/drivers/net/igb/igb_ethtool.c
@@ -43,7 +43,7 @@ struct igb_stats {
 	int stat_offset;
 };
 
-#define IGB_STAT(m) sizeof(((struct igb_adapter *)0)->m), \
+#define IGB_STAT(m) FIELD_SIZEOF(struct igb_adapter, m), \
 		      offsetof(struct igb_adapter, m)
 static const struct igb_stats igb_gstrings_stats[] = {
 	{ "rx_packets", IGB_STAT(stats.gprc) },
_

Patches currently in -mm which might be from julia@diku.dk are

drivers-cpufreq-add-calls-to-cpufreq_cpu_put.patch
drivers-net-igb-use-field_sizeof.patch
drivers-net-mv643xx_ethc-use-field_sizeof.patch
drivers-net-ixgb-ixgb_ethtoolc-use-field_sizeof.patch
drivers-net-e1000-use-field_sizeof.patch
drivers-block-viodasdc-use-field_sizeof.patch
