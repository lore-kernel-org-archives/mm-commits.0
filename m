From: akpm@linux-foundation.org
Subject: [folded-merged]
 kobject-dont-block-for-each-kobject_uevent-v2.patch removed from -mm tree
Date: Thu, 03 Apr 2014 14:08:49 -0700
Message-ID: <533dcde1.Wlfcby8K5MXF5251%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbaDCVIu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:08:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, greg@kroah.com, cl@linux.com, vdavydov@parallels.com

Subject: [folded-merged] kobject-dont-block-for-each-kobject_uevent-v2.patch removed from -mm tree
To: vdavydov@parallels.com,cl@linux.com,greg@kroah.com,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:08:49 -0700


The patch titled
     Subject: kobject-dont-block-for-each-kobject_uevent-v2
has been removed from the -mm tree.  Its filename was
     kobject-dont-block-for-each-kobject_uevent-v2.patch

This patch was dropped because it was folded into kobject-dont-block-for-each-kobject_uevent.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: kobject-dont-block-for-each-kobject_uevent-v2

I missed that call_usermodehelper_exec() calls cleanup not only on
success, but also on failure resulting in a bunch of double frees at early
boot when khelper hasn't been initialized yet :-(

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Greg KH <greg@kroah.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject_uevent.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/kobject_uevent.c~kobject-dont-block-for-each-kobject_uevent-v2 lib/kobject_uevent.c
--- a/lib/kobject_uevent.c~kobject-dont-block-for-each-kobject_uevent-v2
+++ a/lib/kobject_uevent.c
@@ -342,10 +342,10 @@ int kobject_uevent_env(struct kobject *k
 		info = call_usermodehelper_setup(env->argv[0], env->argv,
 						 env->envp, GFP_KERNEL,
 						 NULL, cleanup_uevent_env, env);
-		if (info)
+		if (info) {
 			retval = call_usermodehelper_exec(info, UMH_NO_WAIT);
-		if (!retval)
-			env = NULL;	/* will be freed by cleanup_uevent_env */
+			env = NULL;	/* freed by cleanup_uevent_env */
+		}
 	}
 
 exit:
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-vmscan-shrink_slab-rename-max_pass-freeable.patch
kobject-dont-block-for-each-kobject_uevent.patch
slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch

