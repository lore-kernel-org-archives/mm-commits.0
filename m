From: akpm@linux-foundation.org
Subject: + ipw2200-convert-__list_for_each-usage-to-list_for_each.patch
 added to -mm tree
Date: Tue, 18 Jun 2013 13:37:13 -0700
Message-ID: <51c0c4f9.ljyMwmV1fVhseb6K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab3FRUhO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jun 2013 16:37:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stas.yakovlev@gmail.com, linville@tuxdriver.com, davej@redhat.com

Subject: + ipw2200-convert-__list_for_each-usage-to-list_for_each.patch added to -mm tree
To: davej@redhat.com,linville@tuxdriver.com,stas.yakovlev@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 18 Jun 2013 13:37:13 -0700


The patch titled
     Subject: ipw2200: convert __list_for_each usage to list_for_each
has been added to the -mm tree.  Its filename is
     ipw2200-convert-__list_for_each-usage-to-list_for_each.patch

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
Subject: ipw2200: convert __list_for_each usage to list_for_each

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ipw2x00/ipw2200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/ipw2x00/ipw2200.c~ipw2200-convert-__list_for_each-usage-to-list_for_each drivers/net/wireless/ipw2x00/ipw2200.c
--- a/drivers/net/wireless/ipw2x00/ipw2200.c~ipw2200-convert-__list_for_each-usage-to-list_for_each
+++ a/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -8256,7 +8256,7 @@ static  int is_duplicate_packet(struct i
 			u8 *mac = header->addr2;
 			int index = mac[5] % IPW_IBSS_MAC_HASH_SIZE;
 
-			__list_for_each(p, &priv->ibss_mac_hash[index]) {
+			list_for_each(p, &priv->ibss_mac_hash[index]) {
 				entry =
 				    list_entry(p, struct ipw_ibss_seq, list);
 				if (!memcmp(entry->mac, mac, ETH_ALEN))
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

