From: akpm@linux-foundation.org
Subject: + drivers-char-agp-genericc-fix-arbitrary-kernel-memory-writes.patch added to -mm tree
Date: Thu, 14 Apr 2011 13:23:21 -0700
Message-ID: <201104142023.p3EKNL6h004282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705Ab1DNUYY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Apr 2011 16:24:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segoon@openwall.com, airlied@linux.ie


The patch titled
     drivers/char/agp/generic.c: fix arbitrary kernel memory writes
has been added to the -mm tree.  Its filename is
     drivers-char-agp-genericc-fix-arbitrary-kernel-memory-writes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

drivers-char-agp-genericc-fix-arbitrary-kernel-memory-writes.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
aic94xx-world-writable-sysfs-update_bios-file.patch

