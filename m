From: akpm@linux-foundation.org
Subject: + drivers-net-cxgb3-remove-several-unneeded-zero-initialization.patch added to -mm tree
Date: Wed, 18 Jul 2007 15:36:47 -0700
Message-ID: <200707182236.l6IMalWZ032547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35001 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759405AbXGRWhf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 18:37:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com, linux-bugs@chelsio.com


The patch titled
     drivers/net/cxgb3: remove several unneeded zero initialization
has been added to the -mm tree.  Its filename is
     drivers-net-cxgb3-remove-several-unneeded-zero-initialization.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/net/cxgb3: remove several unneeded zero initialization
From: Denis Cheng <crquan@gmail.com>

Signed-off-by: Denis Cheng <crquan@gmail.com>
Cc: <linux-bugs@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/cxgb3_main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/cxgb3/cxgb3_main.c~drivers-net-cxgb3-remove-several-unneeded-zero-initialization drivers/net/cxgb3/cxgb3_main.c
--- a/drivers/net/cxgb3/cxgb3_main.c~drivers-net-cxgb3-remove-several-unneeded-zero-initialization
+++ a/drivers/net/cxgb3/cxgb3_main.c
@@ -754,7 +754,7 @@ static int upgrade_fw(struct adapter *ad
  */
 static int cxgb_up(struct adapter *adap)
 {
-	int err = 0;
+	int err;
 
 	if (!(adap->flags & FULL_INIT_DONE)) {
 		err = t3_check_fw_version(adap);
@@ -861,7 +861,7 @@ static int offload_open(struct net_devic
 	struct adapter *adapter = dev->priv;
 	struct t3cdev *tdev = T3CDEV(dev);
 	int adap_up = adapter->open_device_map & PORT_MASK;
-	int err = 0;
+	int err;
 
 	if (test_and_set_bit(OFFLOAD_DEVMAP_BIT, &adapter->open_device_map))
 		return 0;
@@ -1502,7 +1502,7 @@ static int set_eeprom(struct net_device 
 		      u8 * data)
 {
 	u8 *buf;
-	int err = 0;
+	int err;
 	u32 aligned_offset, aligned_len, *p;
 	struct adapter *adapter = dev->priv;
 
_

Patches currently in -mm which might be from crquan@gmail.com are

origin.patch
drivers-net-cxgb3-remove-several-unneeded-zero-initialization.patch
