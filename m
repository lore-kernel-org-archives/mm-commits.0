From: akpm@linux-foundation.org
Subject: - kobject-kobject_add-reference-leak.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:29:37 -0700
Message-ID: <200704132329.l3DNTb24012639@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60551 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161173AbXDMX3w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:29:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cornelia.huck@de.ibm.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     kobject: kobject_add() reference leak
has been removed from the -mm tree.  Its filename was
     kobject-kobject_add-reference-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kobject: kobject_add() reference leak
From: Cornelia Huck <cornelia.huck@de.ibm.com>

We leak a reference if we attempt to add a kobject with no name.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN lib/kobject.c~kobject-kobject_add-reference-leak lib/kobject.c
--- a/lib/kobject.c~kobject-kobject_add-reference-leak
+++ a/lib/kobject.c
@@ -218,6 +218,7 @@ int kobject_shadow_add(struct kobject * 
 	if (!*kobj->k_name) {
 		pr_debug("kobject attempted to be registered with no name!\n");
 		WARN_ON(1);
+		kobject_put(kobj);
 		return -EINVAL;
 	}
 	parent = kobject_get(kobj->parent);
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

s390-cio-delay-uevents-for-subchannels.patch
uevent-use-add_uevent_var-instead-of-open-coding-it.patch
device_schedule_callback-needs-a-module-reference-fix.patch
git-s390.patch
partitions-check-the-return-value-of-kobject_add-etc.patch
kprobes-the-on-off-knob-thru-debugfs-updated-s390-fix.patch
