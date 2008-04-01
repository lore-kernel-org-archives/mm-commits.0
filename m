From: akpm@linux-foundation.org
Subject: + mac80211-fix-deadlocks-in-debugfs_netdevc.patch added to -mm tree
Date: Tue, 01 Apr 2008 14:12:59 -0700
Message-ID: <200804012112.m31LCxYM013701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760863AbYDAVOY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 17:14:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: luisca@cozybit.com, davem@davemloft.net, johannes@sipsolutions.net, linville@tuxdriver.com


The patch titled
     mac80211: fix deadlocks in debugfs_netdev.c
has been added to the -mm tree.  Its filename is
     mac80211-fix-deadlocks-in-debugfs_netdevc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
net-mac80211-debugfs_netdevc-use-of-bool-triggers-a-gcc-bug.patch
mac80211-fix-deadlocks-in-debugfs_netdevc.patch

