From: akpm@linux-foundation.org
Subject: [merged]
 staging-rtl8192u-remove-commented-out-__list_for_each-usage.patch removed
 from -mm tree
Date: Tue, 25 Jun 2013 12:23:06 -0700
Message-ID: <51c9ee1a.M+VvFvFCBL4zh9CX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3FYTXH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 15:23:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, snsehahn@cip.cs.fau.de, gregkh@linuxfoundation.org, Jennifer.Naumann@informatik.stud.uni-erlangen.de, davej@redhat.com

Subject: [merged] staging-rtl8192u-remove-commented-out-__list_for_each-usage.patch removed from -mm tree
To: davej@redhat.com,Jennifer.Naumann@informatik.stud.uni-erlangen.de,gregkh@linuxfoundation.org,snsehahn@cip.cs.fau.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 12:23:06 -0700


The patch titled
     Subject: staging/rtl8192u: remove commented out __list_for_each usage
has been removed from the -mm tree.  Its filename was
     staging-rtl8192u-remove-commented-out-__list_for_each-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
Subject: staging/rtl8192u: remove commented out __list_for_each usage

Also remove another commented out open-coded list manipulation while we're
there.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sebastian Hahn <snsehahn@cip.cs.fau.de>
Cc: Jennifer Naumann <Jennifer.Naumann@informatik.stud.uni-erlangen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c~staging-rtl8192u-remove-commented-out-__list_for_each-usage drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c~staging-rtl8192u-remove-commented-out-__list_for_each-usage
+++ a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -454,8 +454,7 @@ static int is_duplicate_packet(struct ie
 		struct ieee_ibss_seq *entry = NULL;
 		u8 *mac = header->addr2;
 		int index = mac[5] % IEEE_IBSS_MAC_HASH_SIZE;
-		//for (pos = (head)->next; pos != (head); pos = pos->next)
-		//__list_for_each(p, &ieee->ibss_mac_hash[index]) {
+
 		list_for_each(p, &ieee->ibss_mac_hash[index]) {
 			entry = list_entry(p, struct ieee_ibss_seq, list);
 			if (!memcmp(entry->mac, mac, ETH_ALEN))
_

Patches currently in -mm which might be from davej@redhat.com are

linux-next.patch
radeon-remove-redundant-__list_for_each-definition-from-mkregtablec.patch
ipw2200-convert-__list_for_each-usage-to-list_for_each.patch
list-remove-__list_for_each.patch

