From: akpm@linux-foundation.org
Subject: - drivers-net-skfp-essc-fix-compile-warnings.patch removed from -mm tree
Date: Thu, 28 Aug 2008 14:49:06 -0700
Message-ID: <200808282149.m7SLn6YP016163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755234AbYH1Vto (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 17:49:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tiwai@suse.de, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     drivers/net/skfp/ess.c: fix compile warnings
has been removed from the -mm tree.  Its filename was
     drivers-net-skfp-essc-fix-compile-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/skfp/ess.c: fix compile warnings
From: Takashi Iwai <tiwai@suse.de>

  CC [M]  drivers/net/skfp/ess.o
drivers/net/skfp/ess.c: In function 'ess_send_response':
drivers/net/skfp/ess.c:513: warning: cast from pointer to integer of different size
drivers/net/skfp/ess.c: In function 'ess_send_alc_req':
drivers/net/skfp/ess.c:609: warning: cast from pointer to integer of different size
drivers/net/skfp/ess.c:639: warning: cast from pointer to integer of different size

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/skfp/ess.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/skfp/ess.c~drivers-net-skfp-essc-fix-compile-warnings drivers/net/skfp/ess.c
--- a/drivers/net/skfp/ess.c~drivers-net-skfp-essc-fix-compile-warnings
+++ a/drivers/net/skfp/ess.c
@@ -510,7 +510,7 @@ static void ess_send_response(struct s_s
 	chg->path.para.p_type = SMT_P320B ;
 	chg->path.para.p_len = sizeof(struct smt_p_320b) - PARA_LEN ;
 	chg->path.mib_index = SBAPATHINDEX ;
-	chg->path.path_pad = (u_short)NULL ;
+	chg->path.path_pad = 0;
 	chg->path.path_index = PRIMARY_RING ;
 
 	/* set P320F */
@@ -606,7 +606,7 @@ static void ess_send_alc_req(struct s_sm
 	req->path.para.p_type = SMT_P320B ;
 	req->path.para.p_len = sizeof(struct smt_p_320b) - PARA_LEN ;
 	req->path.mib_index = SBAPATHINDEX ;
-	req->path.path_pad = (u_short)NULL ;
+	req->path.path_pad = 0;
 	req->path.path_index = PRIMARY_RING ;
 
 	/* set P0017 */
@@ -636,7 +636,7 @@ static void ess_send_alc_req(struct s_sm
 	/* set P19 */
 	req->a_addr.para.p_type = SMT_P0019 ;
 	req->a_addr.para.p_len = sizeof(struct smt_p_0019) - PARA_LEN ;
-	req->a_addr.sba_pad = (u_short)NULL ;
+	req->a_addr.sba_pad = 0;
 	req->a_addr.alloc_addr = null_addr ;
 
 	/* set P1A */
_

Patches currently in -mm which might be from tiwai@suse.de are

origin.patch
linux-next.patch
drivers-net-skfp-pmfc-use-offsetof-macro.patch

