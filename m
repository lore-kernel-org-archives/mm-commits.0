From: akpm@linux-foundation.org
Subject: - cdrom-use-unsigned-bitfields.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:45:56 -0800
Message-ID: <200702211045.l1LAjuFf006410@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46978 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965363AbXBUKqq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:46:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, axboe@suse.de, mm-commits@vger.kernel.org


The patch titled
     cdrom: use unsigned bitfields
has been removed from the -mm tree.  Its filename was
     cdrom-use-unsigned-bitfields.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 insertion(+), 1 deletion(-)

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

git-drm.patch
git-libata-all.patch
phy-layer-add-kernel-doc-docbook.patch
git-parisc.patch
x86-dont-probe-for-ddc-on-vbe12.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
