From: akpm@linux-foundation.org
Subject: - dm-ioctl-on-amd64-with-32bit-userspace.patch removed from -mm tree
Date: Wed, 19 Sep 2007 18:30:06 -0700
Message-ID: <200709200130.l8K1U6sZ022302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33892 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbXITBaj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Sep 2007 21:30:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agx@sigxcpu.org, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm-ioctl on amd64 with 32bit userspace
has been removed from the -mm tree.  Its filename was
     dm-ioctl-on-amd64-with-32bit-userspace.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: dm-ioctl on amd64 with 32bit userspace
From: Guido Guenther <agx@sigxcpu.org>

using something like:

dmsetup message <mpath> 0 fail_if_no_path

on a 32 bit dmsetup with a amd64 kernel currently fails with: "Invalid
target message parameters."

since the structure padding is 8 bytes and so we're looking at a 4 byte to
high address in target_message() - this also affects dev_rename() and
dev_set_geometry().  The attached patch works around the problem but
doesn't look like a proper fix.  But since all the 32bit to 64bit ioctl
conversion in device mapper seems a bit strange, I'm not sure where to fix
this properly.

The bad thing about this is that multipath failover after a trespas on such
a system won't work (among other things).  This at least has been broken
since 2.6.18 (I doubt it ever worked) and is still broken in
2.6.23-rc6-git7.  With this patch, failover after a trespas and device
renaming works as expected.

Signed-off-by: Guido Guenther <agx@sigxcpu.org>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-ioctl.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/md/dm-ioctl.c~dm-ioctl-on-amd64-with-32bit-userspace drivers/md/dm-ioctl.c
--- a/drivers/md/dm-ioctl.c~dm-ioctl-on-amd64-with-32bit-userspace
+++ a/drivers/md/dm-ioctl.c
@@ -700,7 +700,7 @@ static int dev_rename(struct dm_ioctl *p
 	int r;
 	char *new_name = (char *) param + param->data_start;
 
-	if (new_name < (char *) (param + 1) ||
+	if (new_name < (char *) ((void*)(param + 1) - 4) ||
 	    invalid_str(new_name, (void *) param + param_size)) {
 		DMWARN("Invalid new logical volume name supplied.");
 		return -EINVAL;
@@ -726,7 +726,7 @@ static int dev_set_geometry(struct dm_io
 	if (!md)
 		return -ENXIO;
 
-	if (geostr < (char *) (param + 1) ||
+	if (geostr < (char *) ((void *)(param + 1) - 4) ||
 	    invalid_str(geostr, (void *) param + param_size)) {
 		DMWARN("Invalid geometry supplied.");
 		goto out;
@@ -1233,7 +1233,7 @@ static int target_message(struct dm_ioct
 	if (r)
 		goto out;
 
-	if (tmsg < (struct dm_target_msg *) (param + 1) ||
+	if (tmsg < (struct dm_target_msg *) ((void*)(param + 1) - 4) ||
 	    invalid_str(tmsg->message, (void *) param + param_size)) {
 		DMWARN("Invalid target message parameters.");
 		r = -EINVAL;
_

Patches currently in -mm which might be from agx@sigxcpu.org are

dm-ioctl-on-amd64-with-32bit-userspace.patch
