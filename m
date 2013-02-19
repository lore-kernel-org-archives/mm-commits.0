From: akpm@linux-foundation.org
Subject: + firewire-convert-to-idr_alloc-fix.patch added to -mm tree
Date: Tue, 19 Feb 2013 13:37:26 -0800
Message-ID: <20130219213726.972325A4376@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:51438 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933761Ab3BSVh1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Feb 2013 16:37:27 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so716311yhz.1
        for <mm-commits@vger.kernel.org>; Tue, 19 Feb 2013 13:37:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tim.gardner@canonical.com, stefanr@s5r6.in-berlin.de, tj@kernel.org


The patch titled
     Subject: firewire: fw_device_init: 'minor' may be used uninitialized
has been added to the -mm tree.  Its filename is
     firewire-convert-to-idr_alloc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
ocfs2-remove-kfree-redundant-null-checks.patch
ocfs2-remove-kfree-redundant-null-checks-fix.patch
firewire-convert-to-idr_alloc-fix.patch

