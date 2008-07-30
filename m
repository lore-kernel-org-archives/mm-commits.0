From: akpm@linux-foundation.org
Subject: - net-niu-fix-compile-warnings.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:18:08 -0700
Message-ID: <200807301918.m6UJI8xm011274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969AbYG3TTf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:19:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tiwai@suse.de, davem@davemloft.net, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     net/niu: fix compile warnings
has been removed from the -mm tree.  Its filename was
     net-niu-fix-compile-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/niu: fix compile warnings
From: Takashi Iwai <tiwai@suse.de>

Fix the wrong return value from niu_ethflow_to_class().

  drivers/net/niu.c: In function 'niu_get_hash_opts':
  drivers/net/niu.c:6481: warning: 'class' may be used uninitialized in this function
  drivers/net/niu.c: In function 'niu_set_hash_opts':
  drivers/net/niu.c:6501: warning: 'class' may be used uninitialized in this function

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/niu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/niu.c~net-niu-fix-compile-warnings drivers/net/niu.c
--- a/drivers/net/niu.c~net-niu-fix-compile-warnings
+++ a/drivers/net/niu.c
@@ -6417,7 +6417,7 @@ static int niu_ethflow_to_class(int flow
 		*class = CLASS_CODE_SCTP_IPV6;
 		break;
 	default:
-		return -1;
+		return 0;
 	}
 
 	return 1;
_

Patches currently in -mm which might be from tiwai@suse.de are

linux-next.patch

