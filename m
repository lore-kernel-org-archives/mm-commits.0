From: akpm@linux-foundation.org
Subject: [merged]
 staging-rtl8187se-convert-__list_for_each-use-to-list_for_each.patch
 removed from -mm tree
Date: Tue, 25 Jun 2013 12:23:08 -0700
Message-ID: <51c9ee1c./kx1YfgwkoTXECfu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3FYTXJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 15:23:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yamanetoshi@gmail.com, gregkh@linuxfoundation.org, davej@redhat.com

Subject: [merged] staging-rtl8187se-convert-__list_for_each-use-to-list_for_each.patch removed from -mm tree
To: davej@redhat.com,gregkh@linuxfoundation.org,yamanetoshi@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 12:23:08 -0700


The patch titled
     Subject: staging/rtl8187se: Convert __list_for_each use to list_for_each
has been removed from the -mm tree.  Its filename was
     staging-rtl8187se-convert-__list_for_each-use-to-list_for_each.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
Subject: staging/rtl8187se: Convert __list_for_each use to list_for_each

Also remove commented out list manipulation

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c~staging-rtl8187se-convert-__list_for_each-use-to-list_for_each drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c~staging-rtl8187se-convert-__list_for_each-use-to-list_for_each
+++ a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -399,8 +399,8 @@ static int is_duplicate_packet(struct ie
 		struct ieee_ibss_seq *entry = NULL;
 		u8 *mac = header->addr2;
 		int index = mac[5] % IEEE_IBSS_MAC_HASH_SIZE;
-		//for (pos = (head)->next; pos != (head); pos = pos->next)
-		__list_for_each(p, &ieee->ibss_mac_hash[index]) {
+
+		list_for_each(p, &ieee->ibss_mac_hash[index]) {
 			entry = list_entry(p, struct ieee_ibss_seq, list);
 			if (!memcmp(entry->mac, mac, ETH_ALEN))
 				break;
_

Patches currently in -mm which might be from davej@redhat.com are

linux-next.patch
radeon-remove-redundant-__list_for_each-definition-from-mkregtablec.patch
ipw2200-convert-__list_for_each-usage-to-list_for_each.patch
list-remove-__list_for_each.patch

