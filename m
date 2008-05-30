From: akpm@linux-foundation.org
Subject: - smack-respect-unlabeled-netlabel-mode.patch removed from -mm tree
Date: Fri, 30 May 2008 16:25:11 -0700
Message-ID: <200805302325.m4UNPBgv016834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753856AbYE3XZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 19:25:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, casey@schaufler-ca.com, paul.moore@hp.com, mm-commits@vger.kernel.org


The patch titled
     smack: respect 'unlabeled' netlabel mode
has been removed from the -mm tree.  Its filename was
     smack-respect-unlabeled-netlabel-mode.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smack: respect 'unlabeled' netlabel mode
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

In case of Smack 'unlabeled' netlabel option, Smack passes a _zero_
initialized 'secattr' to label a packet/sock.  This causes an [unfound
domain label error]/-ENOENT by netlbl_sock_setattr().  Above Netlabel
failure leads to Smack socket hooks failure causing an always-on socket()
-EPERM error.

Such packets should have a netlabel domain agreed with netlabel to
represent unlabeled packets.  Fortunately Smack net ambient label packets
are agreed with netlabel to be treated as unlabeled packets.

Treat all packets coming out from a 'unlabeled' Smack system as coming
from the smack net ambient label.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Paul Moore <paul.moore@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/smack/smack_lsm.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN security/smack/smack_lsm.c~smack-respect-unlabeled-netlabel-mode security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~smack-respect-unlabeled-netlabel-mode
+++ a/security/smack/smack_lsm.c
@@ -1293,6 +1293,8 @@ static void smack_to_secattr(char *smack
 		}
 		break;
 	default:
+		nlsp->domain = kstrdup(smack_net_ambient, GFP_ATOMIC);
+		nlsp->flags = NETLBL_SECATTR_DOMAIN;
 		break;
 	}
 }
_

Patches currently in -mm which might be from darwish.07@gmail.com are

linux-next.patch
smack-respect-unlabeled-netlabel-mode.patch

