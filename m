From: akpm@linux-foundation.org
Subject: + drivers-net-ehea-remove-unnecessary-memset-after-kzalloc.patch added to -mm tree
Date: Thu, 15 May 2008 14:13:37 -0700
Message-ID: <200805152113.m4FLDbGT010881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669AbYEOVQ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 17:16:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, christophe.jaillet@wanadoo.fr, raisch@de.ibm.com, themann@de.ibm.com, tklein@de.ibm.com


The patch titled
     drivers/net/ehea: remove unnecessary memset after kzalloc
has been added to the -mm tree.  Its filename is
     drivers-net-ehea-remove-unnecessary-memset-after-kzalloc.patch

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
Subject: drivers/net/ehea: remove unnecessary memset after kzalloc
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Cc: Jan-Bernd Themann <themann@de.ibm.com>
Cc: Thomas Klein <tklein@de.ibm.com>
Cc: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea_main.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/net/ehea/ehea_main.c~drivers-net-ehea-remove-unnecessary-memset-after-kzalloc drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~drivers-net-ehea-remove-unnecessary-memset-after-kzalloc
+++ a/drivers/net/ehea/ehea_main.c
@@ -2213,8 +2213,6 @@ static void ehea_vlan_rx_register(struct
 		goto out;
 	}
 
-	memset(cb1->vlan_filter, 0, sizeof(cb1->vlan_filter));
