From: akpm@linux-foundation.org
Subject: - kvm-fix-mismatch-between-32-bit-and-64-bit-abi.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:55 -0800
Message-ID: <200702122248.l1CMmtWg014066@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45588 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030370AbXBLWtC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:49:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kvm: Fix mismatch between 32-bit and 64-bit abi
has been removed from the -mm tree.  Its filename was
     kvm-fix-mismatch-between-32-bit-and-64-bit-abi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kvm: Fix mismatch between 32-bit and 64-bit abi
From: Avi Kivity <avi@qumranet.com>

Unfortunately requiring a version bump.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kvm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/kvm.h~kvm-fix-mismatch-between-32-bit-and-64-bit-abi include/linux/kvm.h
--- a/include/linux/kvm.h~kvm-fix-mismatch-between-32-bit-and-64-bit-abi
+++ a/include/linux/kvm.h
@@ -11,7 +11,7 @@
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
-#define KVM_API_VERSION 2
+#define KVM_API_VERSION 3
 
 /*
  * Architectural interrupt line count, and the size of the bitmap needed
@@ -187,6 +187,7 @@ struct kvm_translation {
 	__u8  valid;
 	__u8  writeable;
 	__u8  usermode;
+	__u8  pad[5];
 };
 
 /* for KVM_INTERRUPT */
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
