From: akpm@linux-foundation.org
Subject: [merged] md-dm-log-fix-cn_ulog_callback-declaration.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:37:45 -0700
Message-ID: <200909241937.n8OJbjew005224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754003AbZIXTiS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:38:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, agk@redhat.com, davem@davemloft.net, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     md: dm-log: fix cn_ulog_callback declaration
has been removed from the -mm tree.  Its filename was
     md-dm-log-fix-cn_ulog_callback-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: dm-log: fix cn_ulog_callback declaration
From: Jiri Slaby <jirislaby@gmail.com>

The third parameter of cn_add_callback accepts functions with void
*()(struct cn_msg *) prototype.  Change cn_ulog_callback to match it by
removing void * and adding struct cn_msg * directly.

It's introduced by commit:
connector: make callback argument type explicit

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-log-userspace-transfer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/md/dm-log-userspace-transfer.c~md-dm-log-fix-cn_ulog_callback-declaration drivers/md/dm-log-userspace-transfer.c
--- a/drivers/md/dm-log-userspace-transfer.c~md-dm-log-fix-cn_ulog_callback-declaration
+++ a/drivers/md/dm-log-userspace-transfer.c
@@ -129,9 +129,8 @@ static int fill_pkg(struct cn_msg *msg, 
  * This is the connector callback that delivers data
  * that was sent from userspace.
  */
-static void cn_ulog_callback(void *data)
+static void cn_ulog_callback(struct cn_msg *msg)
 {
-	struct cn_msg *msg = (struct cn_msg *)data;
 	struct dm_ulog_request *tfr = (struct dm_ulog_request *)(msg + 1);
 
 	spin_lock(&receiving_list_lock);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
isdn-hisax-fix-lock-imbalance.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

