From: akpm@linux-foundation.org
Subject: + drm-radeon-kms-fix-memory-leak-in-radeon_driver_load_kms.patch added to -mm tree
Date: Mon, 03 Aug 2009 13:38:47 -0700
Message-ID: <200908032038.n73Kcl8D002807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753368AbZHCUli (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2009 16:41:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dfeng@redhat.com


The patch titled
     drm/radeon/kms: fix memory leak in radeon_driver_load_kms
has been added to the -mm tree.  Its filename is
     drm-radeon-kms-fix-memory-leak-in-radeon_driver_load_kms.patch

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
Subject: drm/radeon/kms: fix memory leak in radeon_driver_load_kms
From: Xiaotian Feng <dfeng@redhat.com>

Fix the following kmemleak report:

unreferenced object 0xffff88022cb53000 (size 4096):
  comm "work_for_cpu", pid 97, jiffies 4294672345
  backtrace:
    [<ffffffff810eb222>] create_object+0x19f/0x2a0
    [<ffffffff810eb422>] kmemleak_alloc+0x26/0x4c
    [<ffffffff810e363f>] __kmalloc+0x187/0x1b0
    [<ffffffffa005f3db>] kzalloc.clone.0+0x13/0x15 [radeon]
    [<ffffffffa005f403>] radeon_driver_load_kms+0x26/0xe1 [radeon]
    [<ffffffffa0017432>] drm_get_dev+0x37f/0x480 [drm]
    [<ffffffffa007f424>] radeon_pci_probe+0x15/0x269 [radeon]
    [<ffffffff811f8779>] local_pci_probe+0x17/0x1b
    [<ffffffff8105ffbb>] do_work_for_cpu+0x18/0x2a
    [<ffffffff81063c38>] kthread+0x8a/0x92
    [<ffffffff81012cba>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/radeon_kms.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/gpu/drm/radeon/radeon_kms.c~drm-radeon-kms-fix-memory-leak-in-radeon_driver_load_kms drivers/gpu/drm/radeon/radeon_kms.c
--- a/drivers/gpu/drm/radeon/radeon_kms.c~drm-radeon-kms-fix-memory-leak-in-radeon_driver_load_kms
+++ a/drivers/gpu/drm/radeon/radeon_kms.c
@@ -58,6 +58,8 @@ int radeon_driver_load_kms(struct drm_de
 	if (r) {
 		DRM_ERROR("Failed to initialize radeon, disabling IOCTL\n");
 		radeon_device_fini(rdev);
+		kfree(rdev);
+		dev->dev_private = NULL;
 		return r;
 	}
 	return 0;
_

Patches currently in -mm which might be from dfeng@redhat.com are

linux-next.patch
drm-radeon-kms-fix-memory-leak-in-radeon_driver_load_kms.patch
cgroups-make-unlock-sequence-in-cgroup_get_sb-consistent.patch

