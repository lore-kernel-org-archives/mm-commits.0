From: akpm@linux-foundation.org
Subject: + net-compile-fix-depcac.patch added to -mm tree
Date: Wed, 17 Sep 2008 12:09:12 -0700
Message-ID: <200809171909.m8HJ9CFD025931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752352AbYIQTJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 15:09:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, gregkh@suse.de, hare@suse.de


The patch titled
     net: compile fix depca.c
has been added to the -mm tree.  Its filename is
     net-compile-fix-depcac.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net: compile fix depca.c
From: Harvey Harrison <harvey.harrison@gmail.com>

Adding accessors to the ->driver_data field missed a forward
declaration that is needed to compile.

Caused by:
commit 107aeb9753159da848f066b26557f0aaab900a90
Author: Hannes Reinecke <hare@suse.de>
Date:   Wed Sep 10 14:16:04 2008 +0200

    Driver core: Use dev_get_drvdata() accessors

Otherwise:
drivers/net/depca.c:404:9: error: undefined identifier 'depca_common_remove'
drivers/net/depca.c: In function `depca_isa_remove':
drivers/net/depca.c:404: error: implicit declaration of function `depca_common_remove'
drivers/net/depca.c: At top level:
drivers/net/depca.c:1601: error: static declaration of `depca_common_remove' follows non-static declaration
drivers/net/depca.c:404: error: previous implicit declaration of `depca_common_remove' was here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/depca.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/depca.c~net-compile-fix-depcac drivers/net/depca.c
--- a/drivers/net/depca.c~net-compile-fix-depcac
+++ a/drivers/net/depca.c
@@ -398,6 +398,7 @@ static struct mca_driver depca_mca_drive
 #endif
 
 static int depca_isa_probe (struct platform_device *);
+static int depca_common_remove(struct net_device *dev);
 
 static int __devexit depca_isa_remove(struct platform_device *pdev)
 {
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
net-compile-fix-depcac.patch
input-ads7846c-sparse-lock-annotation.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
bq27x00_battery-use-unaligned-access-helper.patch
rcu-fix-sparse-shadowed-variable-warning.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
fbcon-fix-monochrome-color-value-calculation.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
char-moxac-sparse-annotation.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch

