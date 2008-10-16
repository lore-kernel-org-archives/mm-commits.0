From: akpm@linux-foundation.org
Subject: + frv-switch-unaligned-access-to-the-packed-struct-implementation.patch added to -mm tree
Date: Thu, 16 Oct 2008 14:03:23 -0700
Message-ID: <200810162103.m9GL3NP4019746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754257AbYJPVDf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 17:03:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, dhowells@redhat.com


The patch titled
     frv: switch unaligned access to the packed-struct implementation
has been added to the -mm tree.  Its filename is
     frv-switch-unaligned-access-to-the-packed-struct-implementation.patch

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
Subject: frv: switch unaligned access to the packed-struct implementation
From: Harvey Harrison <harvey.harrison@gmail.com>

Switch unaligned access to the packed-struct implementation for BE
accesses as this reduces the size of the kernel a little.  LE still uses
the byte shift.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/unaligned.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-frv/unaligned.h~frv-switch-unaligned-access-to-the-packed-struct-implementation include/asm-frv/unaligned.h
--- a/include/asm-frv/unaligned.h~frv-switch-unaligned-access-to-the-packed-struct-implementation
+++ a/include/asm-frv/unaligned.h
@@ -13,7 +13,7 @@
 #define _ASM_UNALIGNED_H
 
 #include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/be_byteshift.h>
+#include <linux/unaligned/be_struct.h>
 #include <linux/unaligned/generic.h>
 
 #define get_unaligned	__get_unaligned_be
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
char-moxac-sparse-annotation.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
scsi-remove-private-implementation-of-get_unaligned_be32.patch
usb-avoid-needless-address-taking-of-function-parameters.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
frv-switch-unaligned-access-to-the-packed-struct-implementation.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch
byteorder-provide-swabbh-generically-in-asm-byteorderh.patch
byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch

