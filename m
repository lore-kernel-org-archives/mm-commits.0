From: akpm@linux-foundation.org
Subject: + drivers-base-do-not-send-kobj_add-uevent-if-kobject_init_and_add-fails.patch added to -mm tree
Date: Mon, 27 Jul 2009 14:51:45 -0700
Message-ID: <200907272151.n6RLpjmP010049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754661AbZG0VwC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 17:52:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dfeng@redhat.com, greg@kroah.com, kay.sievers@vrfy.org


The patch titled
     drivers/base: do not send KOBJ_ADD uevent if kobject_init_and_add fails
has been added to the -mm tree.  Its filename is
     drivers-base-do-not-send-kobj_add-uevent-if-kobject_init_and_add-fails.patch

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

linux-next.patch
block-fix-improper-kobject-release-in-blk_integrity_unregister.patch
drivers-base-do-not-send-kobj_add-uevent-if-kobject_init_and_add-fails.patch
cgroups-make-unlock-sequence-in-cgroup_get_sb-consistent.patch

