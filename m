From: akpm@linux-foundation.org
Subject: - drivers-net-ehea-remove-unnecessary-memset-after-kzalloc.patch removed from -mm tree
Date: Fri, 23 May 2008 11:58:57 -0700
Message-ID: <200805231858.m4NIwv7Y004188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754014AbYEWTAd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 15:00:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, christophe.jaillet@wanadoo.fr, raisch@de.ibm.com, themann@de.ibm.com, tklein@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/ehea: remove unnecessary memset after kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-net-ehea-remove-unnecessary-memset-after-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
