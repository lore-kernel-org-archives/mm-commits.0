From: akpm@linux-foundation.org
Subject: + sctp-convert-__list_for_each-use-to-list_for_each.patch added
 to -mm tree
Date: Tue, 18 Jun 2013 13:37:16 -0700
Message-ID: <51c0c4fc.9AdT09pE88zax/bu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51607 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800Ab3FRUhR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jun 2013 16:37:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net, davej@redhat.com

Subject: + sctp-convert-__list_for_each-use-to-list_for_each.patch added to -mm tree
To: davej@redhat.com,davem@davemloft.net,nhorman@tuxdriver.com,vyasevich@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 18 Jun 2013 13:37:16 -0700


The patch titled
     Subject: sctp: convert __list_for_each use to list_for_each
has been added to the -mm tree.  Its filename is
     sctp-convert-__list_for_each-use-to-list_for_each.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
staging-rtl8192u-remove-commented-out-__list_for_each-usage.patch
staging-rtl8187se-convert-__list_for_each-use-to-list_for_each.patch
sctp-convert-__list_for_each-use-to-list_for_each.patch
sound-usb-misc-ua101c-convert-__list_for_each-usage-to-list_for_each.patch
list-remove-__list_for_each.patch

