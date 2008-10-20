From: akpm@linux-foundation.org
Subject: - byteorder-provide-swabbh-generically-in-asm-byteorderh.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:29 -0700
Message-ID: <200810202037.m9KKbTuJ011641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752269AbYJTUqf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     byteorder: provide swabb.h generically in asm/byteorder.h
has been removed from the -mm tree.  Its filename was
     byteorder-provide-swabbh-generically-in-asm-byteorderh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: byteorder: provide swabb.h generically in asm/byteorder.h
From: Harvey Harrison <harvey.harrison@gmail.com>

This is needed during the transition to the new byteorder headers as the
swabb.h functionality will be provided from asm/byteorder.h in the new
version.  To avoid breakage on arches still using the old implementation,
provide swabb.h from asm/byteorder.h as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/byteorder/Kbuild          |    1 +
 include/linux/byteorder/big_endian.h    |    1 +
 include/linux/byteorder/little_endian.h |    1 +
 3 files changed, 3 insertions(+)

diff -puN include/linux/byteorder/Kbuild~byteorder-provide-swabbh-generically-in-asm-byteorderh include/linux/byteorder/Kbuild
--- a/include/linux/byteorder/Kbuild~byteorder-provide-swabbh-generically-in-asm-byteorderh
+++ a/include/linux/byteorder/Kbuild
@@ -1,3 +1,4 @@
 unifdef-y += big_endian.h
 unifdef-y += little_endian.h
 unifdef-y += swab.h
+unifdef-y += swabb.h
diff -puN include/linux/byteorder/big_endian.h~byteorder-provide-swabbh-generically-in-asm-byteorderh include/linux/byteorder/big_endian.h
--- a/include/linux/byteorder/big_endian.h~byteorder-provide-swabbh-generically-in-asm-byteorderh
+++ a/include/linux/byteorder/big_endian.h
@@ -10,6 +10,7 @@
 
 #include <linux/types.h>
 #include <linux/byteorder/swab.h>
+#include <linux/byteorder/swabb.h>
 
 #define __constant_htonl(x) ((__force __be32)(__u32)(x))
 #define __constant_ntohl(x) ((__force __u32)(__be32)(x))
diff -puN include/linux/byteorder/little_endian.h~byteorder-provide-swabbh-generically-in-asm-byteorderh include/linux/byteorder/little_endian.h
--- a/include/linux/byteorder/little_endian.h~byteorder-provide-swabbh-generically-in-asm-byteorderh
+++ a/include/linux/byteorder/little_endian.h
@@ -10,6 +10,7 @@
 
 #include <linux/types.h>
 #include <linux/byteorder/swab.h>
+#include <linux/byteorder/swabb.h>
 
 #define __constant_htonl(x) ((__force __be32)___constant_swab32((x)))
 #define __constant_ntohl(x) ___constant_swab32((__force __be32)(x))
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
scsi-remove-private-implementation-of-get_unaligned_be32.patch
usb-avoid-needless-address-taking-of-function-parameters.patch

