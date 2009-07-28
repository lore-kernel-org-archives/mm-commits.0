From: akpm@linux-foundation.org
Subject: [merged] drivers-base-do-not-send-kobj_add-uevent-if-kobject_init_and_add-fails.patch removed from -mm tree
Date: Tue, 28 Jul 2009 12:28:17 -0700
Message-ID: <200907281928.n6SJSHBk022512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121AbZG1T2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jul 2009 15:28:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dfeng@redhat.com, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     drivers/base: do not send KOBJ_ADD uevent if kobject_init_and_add fails
has been removed from the -mm tree.  Its filename was
     drivers-base-do-not-send-kobj_add-uevent-if-kobject_init_and_add-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/base: do not send KOBJ_ADD uevent if kobject_init_and_add fails
From: Xiaotian Feng <dfeng@redhat.com>

If kobject_init_and_add fails, sysdev_register should not send KOBJ_ADD
uevent to userspace.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/sys.c~drivers-base-do-not-send-kobj_add-uevent-if-kobject_init_and_add-fails drivers/base/sys.c
--- a/drivers/base/sys.c~drivers-base-do-not-send-kobj_add-uevent-if-kobject_init_and_add-fails
+++ a/drivers/base/sys.c
@@ -275,9 +275,9 @@ int sysdev_register(struct sys_device *s
 				drv->add(sysdev);
 		}
 		mutex_unlock(&sysdev_drivers_lock);
+		kobject_uevent(&sysdev->kobj, KOBJ_ADD);
 	}
 
-	kobject_uevent(&sysdev->kobj, KOBJ_ADD);
 	return error;
 }
 
_

Patches currently in -mm which might be from dfeng@redhat.com are

origin.patch
linux-next.patch
block-fix-improper-kobject-release-in-blk_integrity_unregister.patch
cgroups-make-unlock-sequence-in-cgroup_get_sb-consistent.patch

