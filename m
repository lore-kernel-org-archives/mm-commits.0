From: akpm@linux-foundation.org
Subject: + sysfs-sysfs_update_group-stub-for-config_sysfs=n.patch added to -mm tree
Date: Wed, 30 Apr 2008 10:32:32 -0700
Message-ID: <200804301732.m3UHWWLF025887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758298AbYD3RdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 13:33:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, greg@kroah.com


The patch titled
     sysfs: sysfs_update_group stub for CONFIG_SYSFS=n
has been added to the -mm tree.  Its filename is
     sysfs-sysfs_update_group-stub-for-config_sysfs=n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: sysfs_update_group stub for CONFIG_SYSFS=n
From: Randy Dunlap <randy.dunlap@oracle.com>

scsi_transport_spi uses sysfs_update_group() when CONFIG_SYSFS=n, so provide a
stub for it.

next-20080423/drivers/scsi/scsi_transport_spi.c:1467: error: implicit declaration of function 'sysfs_update_group'
make[3]: *** [drivers/scsi/scsi_transport_spi.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysfs.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/sysfs.h~sysfs-sysfs_update_group-stub-for-config_sysfs=n include/linux/sysfs.h
--- a/include/linux/sysfs.h~sysfs-sysfs_update_group-stub-for-config_sysfs=n
+++ a/include/linux/sysfs.h
@@ -190,6 +190,12 @@ static inline int sysfs_create_group(str
 	return 0;
 }
 
+static inline int sysfs_update_group(struct kobject *kobj,
+				const struct attribute_group *grp)
+{
+	return 0;
+}
+
 static inline void sysfs_remove_group(struct kobject *kobj,
 				      const struct attribute_group *grp)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
basic-braille-screen-reader-support.patch
add-macros-similar-to-min-max-min_t-max_t.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
sysfs-sysfs_update_group-stub-for-config_sysfs=n.patch
rapidio-fix-docbook-references.patch
rapidio-fix-kernel-doc-problems.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-unionfs.patch
docbook-some-kernel-locking-fixes.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
profile-likely-unlikely-macros.patch

