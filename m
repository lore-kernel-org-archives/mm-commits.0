From: akpm@linux-foundation.org
Subject: - libertas-select-wireless_ext.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:38:35 -0800
Message-ID: <200712202338.lBKNcZCZ018985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38744 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756432AbXLTXtA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:49:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcbw@redhat.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     libertas: select WIRELESS_EXT
has been removed from the -mm tree.  Its filename was
     libertas-select-wireless_ext.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libertas: select WIRELESS_EXT
From: Dan Williams <dcbw@redhat.com>

Ensure that libertas selects WIRELESS_EXT, since selecting other stuff that
should depend on WEXT, like IEEE80211, doesn't seem to drag that in for us.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/wireless/Kconfig~libertas-select-wireless_ext drivers/net/wireless/Kconfig
--- a/drivers/net/wireless/Kconfig~libertas-select-wireless_ext
+++ a/drivers/net/wireless/Kconfig
@@ -264,6 +264,7 @@ config IPW2200_DEBUG
 config LIBERTAS
 	tristate "Marvell 8xxx Libertas WLAN driver support"
 	depends on WLAN_80211
+	select WIRELESS_EXT
 	select IEEE80211
 	select FW_LOADER
 	---help---
_

Patches currently in -mm which might be from dcbw@redhat.com are

origin.patch
git-net.patch
git-netdev-all.patch
