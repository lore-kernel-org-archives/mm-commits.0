From: akpm@linux-foundation.org
Subject: - cxgb3-safeguard-tcam-size-usage.patch removed from -mm tree
Date: Wed, 04 Apr 2007 19:00:30 -0700
Message-ID: <200704050200.l3520UvB004826@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38050 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932315AbXDECAp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 22:00:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: divy@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     cxgb3: safeguard TCAM size usage
has been removed from the -mm tree.  Its filename was
     cxgb3-safeguard-tcam-size-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cxgb3: safeguard TCAM size usage
From: Divy Le Ray <divy@chelsio.com>

Ensure that the TCAM active region size is at least 16.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/common.h        |    3 +++
 drivers/net/cxgb3/cxgb3_main.c    |    7 +++++--
 drivers/net/cxgb3/cxgb3_offload.c |    4 +++-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff -puN drivers/net/cxgb3/common.h~cxgb3-safeguard-tcam-size-usage drivers/net/cxgb3/common.h
--- a/drivers/net/cxgb3/common.h~cxgb3-safeguard-tcam-size-usage
+++ a/drivers/net/cxgb3/common.h
@@ -358,6 +358,9 @@ enum {
 	MC5_MODE_72_BIT = 2
 };
 
+/* MC5 min active region size */
+enum { MC5_MIN_TIDS = 16 };
+
 struct vpd_params {
 	unsigned int cclk;
 	unsigned int mclk;
diff -puN drivers/net/cxgb3/cxgb3_main.c~cxgb3-safeguard-tcam-size-usage drivers/net/cxgb3/cxgb3_main.c
--- a/drivers/net/cxgb3/cxgb3_main.c~cxgb3-safeguard-tcam-size-usage
+++ a/drivers/net/cxgb3/cxgb3_main.c
@@ -485,12 +485,14 @@ static ssize_t show_##name(struct device
 static ssize_t set_nfilters(struct net_device *dev, unsigned int val)
 {
 	struct adapter *adap = dev->priv;
+	int min_tids = is_offload(adap) ? MC5_MIN_TIDS : 0;
 
 	if (adap->flags & FULL_INIT_DONE)
 		return -EBUSY;
 	if (val && adap->params.rev == 0)
 		return -EINVAL;
-	if (val > t3_mc5_size(&adap->mc5) - adap->params.mc5.nservers)
+	if (val > t3_mc5_size(&adap->mc5) - adap->params.mc5.nservers -
+	    min_tids)
 		return -EINVAL;
 	adap->params.mc5.nfilters = val;
 	return 0;
@@ -508,7 +510,8 @@ static ssize_t set_nservers(struct net_d
 
 	if (adap->flags & FULL_INIT_DONE)
 		return -EBUSY;
-	if (val > t3_mc5_size(&adap->mc5) - adap->params.mc5.nfilters)
+	if (val > t3_mc5_size(&adap->mc5) - adap->params.mc5.nfilters -
+	    MC5_MIN_TIDS)
 		return -EINVAL;
 	adap->params.mc5.nservers = val;
 	return 0;
diff -puN drivers/net/cxgb3/cxgb3_offload.c~cxgb3-safeguard-tcam-size-usage drivers/net/cxgb3/cxgb3_offload.c
--- a/drivers/net/cxgb3/cxgb3_offload.c~cxgb3-safeguard-tcam-size-usage
+++ a/drivers/net/cxgb3/cxgb3_offload.c
@@ -553,7 +553,9 @@ int cxgb3_alloc_atid(struct t3cdev *tdev
 	struct tid_info *t = &(T3C_DATA(tdev))->tid_maps;
 
 	spin_lock_bh(&t->atid_lock);
-	if (t->afree) {
+	if (t->afree &&
+	    t->atids_in_use + atomic_read(&t->tids_in_use) + MC5_MIN_TIDS <=
+	    t->ntids) {
 		union active_open_entry *p = t->afree;
 
 		atid = (p - t->atid_tab) + t->atid_base;
_

Patches currently in -mm which might be from divy@chelsio.com are

origin.patch
