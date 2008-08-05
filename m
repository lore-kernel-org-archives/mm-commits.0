From: akpm@linux-foundation.org
Subject: + drivers-net-skfp-essc-fix-compile-warnings.patch added to -mm tree
Date: Tue, 05 Aug 2008 14:19:13 -0700
Message-ID: <200808052119.m75LJDxV023967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755203AbYHEVUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 17:20:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, jeff@garzik.org


The patch titled
     drivers/net/skfp/ess.c: Fix compile warnings
has been added to the -mm tree.  Its filename is
     drivers-net-skfp-essc-fix-compile-warnings.patch

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
Subject: drivers/net/skfp/ess.c: Fix compile warnings
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
drivers-net-skfp-essc-fix-compile-warnings.patch

