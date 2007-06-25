From: akpm@linux-foundation.org
Subject: - include-linux-mutexh-from-attribute_containerc.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:21:33 -0700
Message-ID: <200706250921.l5P9LXWL031124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50970 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783AbXFYJYe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:24:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mst@dev.mellanox.co.il, mm-commits@vger.kernel.org


The patch titled
     include linux/mutex.h from attribute_container.c
has been removed from the -mm tree.  Its filename was
     include-linux-mutexh-from-attribute_containerc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: include linux/mutex.h from attribute_container.c
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>

attribute_container.c uses DEFINE_MUTEX, so while linux/mutex.h seems to be
pulled in indirectly by one of the headers it includes, the right thing is
to include linux/mutex.h directly.

Signed-off-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/attribute_container.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/base/attribute_container.c~include-linux-mutexh-from-attribute_containerc drivers/base/attribute_container.c
--- a/drivers/base/attribute_container.c~include-linux-mutexh-from-attribute_containerc
+++ a/drivers/base/attribute_container.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 
 #include "base.h"
 
_

Patches currently in -mm which might be from mst@dev.mellanox.co.il are

git-infiniband.patch
