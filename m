From: akpm@linux-foundation.org
Subject: [merged] sctp-convert-__list_for_each-use-to-list_for_each.patch
 removed from -mm tree
Date: Tue, 25 Jun 2013 12:23:10 -0700
Message-ID: <51c9ee1e.buXYeyhPCoo/XiO6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3FYTXL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 15:23:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, davej@redhat.com

Subject: [merged] sctp-convert-__list_for_each-use-to-list_for_each.patch removed from -mm tree
To: davej@redhat.com,davem@davemloft.net,nhorman@tuxdriver.com,vyasevich@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 12:23:10 -0700


The patch titled
     Subject: sctp: convert __list_for_each use to list_for_each
has been removed from the -mm tree.  Its filename was
     sctp-convert-__list_for_each-use-to-list_for_each.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
Subject: sctp: convert __list_for_each use to list_for_each

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/protocol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/sctp/protocol.c~sctp-convert-__list_for_each-use-to-list_for_each net/sctp/protocol.c
--- a/net/sctp/protocol.c~sctp-convert-__list_for_each-use-to-list_for_each
+++ a/net/sctp/protocol.c
@@ -178,7 +178,7 @@ static void sctp_get_local_addr_list(str
 
 	rcu_read_lock();
 	for_each_netdev_rcu(net, dev) {
-		__list_for_each(pos, &sctp_address_families) {
+		list_for_each(pos, &sctp_address_families) {
 			af = list_entry(pos, struct sctp_af, list);
 			af->copy_addrlist(&net->sctp.local_addr_list, dev);
 		}
_

Patches currently in -mm which might be from davej@redhat.com are

linux-next.patch
radeon-remove-redundant-__list_for_each-definition-from-mkregtablec.patch
ipw2200-convert-__list_for_each-usage-to-list_for_each.patch
list-remove-__list_for_each.patch

