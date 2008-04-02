From: akpm@linux-foundation.org
Subject: - mac80211-fix-deadlocks-in-debugfs_netdevc.patch removed from -mm tree
Date: Wed, 02 Apr 2008 12:20:37 -0700
Message-ID: <200804021920.m32JKbHk030280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759826AbYDBTV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Apr 2008 15:21:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luisca@cozybit.com, davem@davemloft.net, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     mac80211: fix deadlocks in debugfs_netdev.c
has been removed from the -mm tree.  Its filename was
     mac80211-fix-deadlocks-in-debugfs_netdevc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mac80211: fix deadlocks in debugfs_netdev.c
From: Luis Carlos Cobo <luisca@cozybit.com>

The bug shows up with CONFIG_PREEMPT enabled. Pointed out by Andrew Morton.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/debugfs_netdev.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN net/mac80211/debugfs_netdev.c~mac80211-fix-deadlocks-in-debugfs_netdevc net/mac80211/debugfs_netdev.c
--- a/net/mac80211/debugfs_netdev.c~mac80211-fix-deadlocks-in-debugfs_netdevc
+++ a/net/mac80211/debugfs_netdev.c
@@ -31,11 +31,13 @@ static ssize_t ieee80211_if_read(
 	ssize_t ret = -EINVAL;
 
 	read_lock(&dev_base_lock);
-	if (sdata->dev->reg_state == NETREG_REGISTERED) {
+	if (sdata->dev->reg_state == NETREG_REGISTERED)
 		ret = (*format)(sdata, buf, sizeof(buf));
-		ret = simple_read_from_buffer(userbuf, count, ppos, buf, ret);
-	}
 	read_unlock(&dev_base_lock);
+
+	if (ret != -EINVAL)
+		ret = simple_read_from_buffer(userbuf, count, ppos, buf, ret);
+
 	return ret;
 }
 
@@ -51,13 +53,13 @@ static ssize_t ieee80211_if_write(
 
 	memset(buf, 0x00, sizeof(buf));
 	buf_size = min(count, (sizeof(buf)-1));
-	read_lock(&dev_base_lock);
 	if (copy_from_user(buf, userbuf, buf_size))
-		goto endwrite;
+		return count;
+	read_lock(&dev_base_lock);
 	if (sdata->dev->reg_state == NETREG_REGISTERED)
 		(*format)(sdata, buf);
-endwrite:
 	read_unlock(&dev_base_lock);
+
 	return count;
 }
 #endif
_

Patches currently in -mm which might be from luisca@cozybit.com are

git-net.patch

