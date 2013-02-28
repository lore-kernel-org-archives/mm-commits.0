From: akpm@linux-foundation.org
Subject: [folded-dropped] firewire-convert-to-idr_alloc-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:42:56 -0800
Message-ID: <20130228004257.323A631C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:47791 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3B1Am6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:42:58 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so138711ghb.3
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:42:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.gardner@canonical.com, stefanr@s5r6.in-berlin.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: firewire: fw_device_init: 'minor' may be used uninitialized
has been removed from the -mm tree.  Its filename was
     firewire-convert-to-idr_alloc-fix.patch

This patch was dropped because it was folded into firewire-convert-to-idr_alloc.patch

------------------------------------------------------
From: Tim Gardner <tim.gardner@canonical.com>
Subject: firewire: fw_device_init: 'minor' may be used uninitialized

'firewire: convert to idr_alloc()' accidentally orphaned 'minor'.

drivers/firewire/core-device.c: In function `fw_device_init':
drivers/firewire/core-device.c:1029:24: warning: `minor' may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firewire/core-device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/firewire/core-device.c~firewire-convert-to-idr_alloc-fix drivers/firewire/core-device.c
--- a/drivers/firewire/core-device.c~firewire-convert-to-idr_alloc-fix
+++ a/drivers/firewire/core-device.c
@@ -1017,10 +1017,11 @@ static void fw_device_init(struct work_s
 
 	fw_device_get(device);
 	down_write(&fw_device_rwsem);
-	ret = idr_alloc(&fw_device_idr, device, 0, 1 << MINORBITS, GFP_KERNEL);
+	minor = idr_alloc(&fw_device_idr, device, 0, 1 << MINORBITS,
+			GFP_KERNEL);
 	up_write(&fw_device_rwsem);
 
-	if (ret < 0)
+	if (minor < 0)
 		goto error;
 
 	device->device.bus = &fw_bus_type;
_

Patches currently in -mm which might be from tim.gardner@canonical.com are

origin.patch
firewire-convert-to-idr_alloc.patch

