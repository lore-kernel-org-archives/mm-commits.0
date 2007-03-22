From: akpm@linux-foundation.org
Subject: - unionfs-sioq-not-__exit.patch removed from -mm tree
Date: Thu, 22 Mar 2007 12:21:22 -0800
Message-ID: <200703222021.l2MKLMxj029453@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49941 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934220AbXCVUV2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 16:21:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     unionfs: sioq not __exit
has been removed from the -mm tree.  Its filename was
     unionfs-sioq-not-__exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: unionfs: sioq not __exit
From: Randy Dunlap <randy.dunlap@oracle.com>

stop_sioq() is called from both __init and __exit functions, so it
shouldn't be marked __exit.

Reported on the kernelnewbies mailing list, but no patch offered there.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/unionfs/sioq.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/unionfs/sioq.c~unionfs-sioq-not-__exit fs/unionfs/sioq.c
--- a/fs/unionfs/sioq.c~unionfs-sioq-not-__exit
+++ a/fs/unionfs/sioq.c
@@ -40,7 +40,7 @@ int __init init_sioq(void)
 	return err;
 }
 
-void __exit stop_sioq(void)
+void stop_sioq(void)
 {
 	if (superio_workqueue)
 		destroy_workqueue(superio_workqueue);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
cpuidle-unsigned-bitfield.patch
acpi-dock-use-null-for-pointer.patch
nozomi-use-null-for-pointers.patch
git-drm.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
i386-fix-gdts-number-of-quadwords-in.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
ext4-use-null-for-pointers.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
profile-likely-unlikely-macros.patch
