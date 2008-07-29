From: akpm@linux-foundation.org
Subject: + net-niu-fix-compile-warnings.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:34:36 -0700
Message-ID: <200807292234.m6TMYakR025331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755885AbYG2Wfr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:35:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, davem@davemloft.net, jeff@garzik.org


The patch titled
     net/niu: fix compile warnings
has been added to the -mm tree.  Its filename is
     net-niu-fix-compile-warnings.patch

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
git-alsa-tiwai.patch
net-niu-fix-compile-warnings.patch

