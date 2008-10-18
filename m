From: akpm@linux-foundation.org
Subject: - frv-switch-unaligned-access-to-the-packed-struct-implementation.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:21:16 -0700
Message-ID: <200810182321.m9INLGYl029926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbYJRXVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:21:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: switch unaligned access to the packed-struct implementation
has been removed from the -mm tree.  Its filename was
     frv-switch-unaligned-access-to-the-packed-struct-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch
byteorder-provide-swabbh-generically-in-asm-byteorderh.patch
byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch

