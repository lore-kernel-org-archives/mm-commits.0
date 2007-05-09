From: akpm@linux-foundation.org
Subject: - dm-mpath-log-device-name.patch removed from -mm tree
Date: Wed, 09 May 2007 14:48:42 -0700
Message-ID: <200705092148.l49Lmg1g002614@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759358AbXEIVsx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:48:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: egoggin@emc.com, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm mpath: log device name
has been removed from the -mm tree.  Its filename was
     dm-mpath-log-device-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm mpath: log device name
From: Edward Goggin <egoggin@emc.com>

Make the mapped device structure accessible to hardware handlers so error
messages can include the device name.

Signed-off-by: Edward Goggin <egoggin@emc.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-hw-handler.h |    1 +
 drivers/md/dm-mpath.c      |    3 +++
 drivers/md/dm.c            |    1 +
 3 files changed, 5 insertions(+)

diff -puN drivers/md/dm-hw-handler.h~dm-mpath-log-device-name drivers/md/dm-hw-handler.h
--- a/drivers/md/dm-hw-handler.h~dm-mpath-log-device-name
+++ a/drivers/md/dm-hw-handler.h
@@ -16,6 +16,7 @@
 struct hw_handler_type;
 struct hw_handler {
 	struct hw_handler_type *type;
+	struct mapped_device *md;
 	void *context;
 };
 
diff -puN drivers/md/dm-mpath.c~dm-mpath-log-device-name drivers/md/dm-mpath.c
--- a/drivers/md/dm-mpath.c~dm-mpath-log-device-name
+++ a/drivers/md/dm-mpath.c
@@ -668,6 +668,9 @@ static int parse_hw_handler(struct arg_s
 		return -EINVAL;
 	}
 
+	m->hw_handler.md = dm_table_get_md(ti->table);
+	dm_put(m->hw_handler.md);
+
 	r = hwht->create(&m->hw_handler, hw_argc - 1, as->argv);
 	if (r) {
 		dm_put_hw_handler(hwht);
diff -puN drivers/md/dm.c~dm-mpath-log-device-name drivers/md/dm.c
--- a/drivers/md/dm.c~dm-mpath-log-device-name
+++ a/drivers/md/dm.c
@@ -1236,6 +1236,7 @@ void dm_put(struct mapped_device *md)
 		free_dev(md);
 	}
 }
+EXPORT_SYMBOL_GPL(dm_put);
 
 /*
  * Process the deferred bios
_

Patches currently in -mm which might be from egoggin@emc.com are

origin.patch
