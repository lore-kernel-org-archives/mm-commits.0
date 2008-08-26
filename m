From: akpm@linux-foundation.org
Subject: - net-ieee80211-adjust-error-handling.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:45:31 -0700
Message-ID: <200808261845.m7QIjVq0021409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757547AbYHZSqW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:46:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, Larry.Finger@lwfinger.net, jbenc@suse.cz, jketreno@linux.intel.com, linville@tuxdriver.com, yi.zhu@intel.com, mm-commits@vger.kernel.org


The patch titled
     net/ieee80211: adjust error handling
has been removed from the -mm tree.  Its filename was
     net-ieee80211-adjust-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/ieee80211: adjust error handling
From: Julia Lawall <julia@diku.dk>

Converts a test in error handling code to a sequence of labels.

The semantic match that found the problem is:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E,E1,E2;
@@

E = alloc_etherdev(...)
... when != E = E1
if (...) { ... free_netdev(E); ... return ...; }
... when != E = E2
(
  if (...)
   {
   ... when != free_netdev(E);
   return dev; }
|
* if (...)
   {
   ... when != free_netdev(E);
   return ...; }
|
register_netdev(E)
)

// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: James Ketrenos <jketreno@linux.intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ieee80211/ieee80211_module.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN net/ieee80211/ieee80211_module.c~net-ieee80211-adjust-error-handling net/ieee80211/ieee80211_module.c
--- a/net/ieee80211/ieee80211_module.c~net-ieee80211-adjust-error-handling
+++ a/net/ieee80211/ieee80211_module.c
@@ -157,7 +157,7 @@ struct net_device *alloc_ieee80211(int s
 	err = ieee80211_networks_allocate(ieee);
 	if (err) {
 		IEEE80211_ERROR("Unable to allocate beacon storage: %d\n", err);
-		goto failed;
+		goto failed_free_netdev;
 	}
 	ieee80211_networks_initialize(ieee);
 
@@ -193,9 +193,9 @@ struct net_device *alloc_ieee80211(int s
 
 	return dev;
 
-      failed:
-	if (dev)
-		free_netdev(dev);
+failed_free_netdev:
+	free_netdev(dev);
+failed:
 	return NULL;
 }
 
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-media-video-use-div_round_up.patch
drivers-atm-use-div_round_up.patch
drivers-net-wan-use-div_round_up.patch
drivers-isdn-capi-kcapic-adjust-error-handling-code-involving-capi_ctr_put.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
drivers-block-use-div_round_up.patch
drivers-misc-use-div_round_up.patch
drivers-net-xen-netfrontc-use-div_round_up.patch

