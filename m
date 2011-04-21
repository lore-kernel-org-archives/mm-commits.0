From: akpm@linux-foundation.org
Subject: [merged] drivers-char-agp-genericc-fix-arbitrary-kernel-memory-writes.patch removed from -mm tree
Date: Thu, 21 Apr 2011 11:16:35 -0700
Message-ID: <201104211812.p3LICKuV021564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750887Ab1DUSNR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Apr 2011 14:13:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drivers/char/agp/generic.c: fix arbitrary kernel memory writes
has been removed from the -mm tree.  Its filename was
     drivers-char-agp-genericc-fix-arbitrary-kernel-memory-writes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/agp/generic.c: fix arbitrary kernel memory writes
From: Vasiliy Kulikov <segoon@openwall.com>

pg_start is copied from userspace on AGPIOC_BIND and AGPIOC_UNBIND ioctl
cmds of agp_ioctl() and passed to agpioc_bind_wrap().  As said in the
comment, (pg_start + mem->page_count) may wrap in case of AGPIOC_BIND, and
it is not checked at all in case of AGPIOC_UNBIND.  As a result, user with
sufficient privileges (usually "video" group) may generate either local
DoS or privilege escalation.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/generic.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/char/agp/generic.c~drivers-char-agp-genericc-fix-arbitrary-kernel-memory-writes drivers/char/agp/generic.c
--- a/drivers/char/agp/generic.c~drivers-char-agp-genericc-fix-arbitrary-kernel-memory-writes
+++ a/drivers/char/agp/generic.c
@@ -1089,8 +1089,8 @@ int agp_generic_insert_memory(struct agp
 		return -EINVAL;
 	}
 
-	/* AK: could wrap */
-	if ((pg_start + mem->page_count) > num_entries)
+	if (((pg_start + mem->page_count) > num_entries) ||
+	    ((pg_start + mem->page_count) < pg_start))
 		return -EINVAL;
 
 	j = pg_start;
@@ -1124,7 +1124,7 @@ int agp_generic_remove_memory(struct agp
 {
 	size_t i;
 	struct agp_bridge_data *bridge;
-	int mask_type;
+	int mask_type, num_entries;
 
 	bridge = mem->bridge;
 	if (!bridge)
@@ -1136,6 +1136,11 @@ int agp_generic_remove_memory(struct agp
 	if (type != mem->type)
 		return -EINVAL;
 
+	num_entries = agp_num_entries();
+	if (((pg_start + mem->page_count) > num_entries) ||
+	    ((pg_start + mem->page_count) < pg_start))
+		return -EINVAL;
+
 	mask_type = bridge->driver->agp_type_to_mask_type(bridge, type);
 	if (mask_type != 0) {
 		/* The generic routines know nothing of memory types */
_

Patches currently in -mm which might be from segoon@openwall.com are

origin.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
aic94xx-world-writable-sysfs-update_bios-file.patch

