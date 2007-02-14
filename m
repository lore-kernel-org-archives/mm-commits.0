From: akpm@linux-foundation.org
Subject: + cdrom-use-unsigned-bitfields.patch added to -mm tree
Date: Wed, 14 Feb 2007 14:44:06 -0800
Message-ID: <200702142244.l1EMi6pB011658@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49741 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbXBNWoN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 17:44:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, axboe@suse.de


The patch titled
     cdrom: use unsigned bitfields
has been added to the -mm tree.  Its filename is
     cdrom-use-unsigned-bitfields.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cdrom: use unsigned bitfields
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix 23 of these sparse warnings on x86_64 allmodconfig:
include/linux/cdrom.h:942:19: error: dubious bitfield without explicit
`signed' or `unsigned'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jens Axboe <axboe@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cdrom.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/cdrom.h~cdrom-use-unsigned-bitfields include/linux/cdrom.h
--- a/include/linux/cdrom.h~cdrom-use-unsigned-bitfields
+++ a/include/linux/cdrom.h
@@ -939,7 +939,7 @@ struct cdrom_device_info {
 	int speed;			/* maximum speed for reading data */
 	int capacity;			/* number of discs in jukebox */
 /* device-related storage */
-	int options		: 30;	/* options flags */
+	unsigned int options	: 30;	/* options flags */
 	unsigned mc_flags	: 2;	/* media change buffer flags */
     	int use_count;                  /* number of times device opened */
     	char name[20];                  /* name of the device type */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
build-errors-uevent-with-config_sysfs=n.patch
acpi-use-null-for-ptrs.patch
git-drm.patch
sata-use-null-for-ptrs.patch
git-netdev-all.patch
phy-layer-add-kernel-doc-docbook.patch
parisc-fix-module_param-iommu-permission.patch
pci-sysfs-kobject-kernel-doc-fixes.patch
ueagle-atmc-needs-schedh.patch
kernel-doc-include-struct-short-description-in-title.patch
tty-use-null-for-ptrs.patch
cdrom-use-unsigned-bitfields.patch
irq-kernel-doc-fixes.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
