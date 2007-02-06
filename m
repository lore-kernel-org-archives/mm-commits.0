From: akpm@linux-foundation.org
Subject: - use-__u32-in-asm-x86_64-msrh.patch removed from -mm tree
Date: Tue, 06 Feb 2007 00:32:02 -0800
Message-ID: <200702060832.l168W2LV013915@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55152 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbXBFIcI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 03:32:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     use __u32 in asm-x86_64/msr.h
has been removed from the -mm tree.  Its filename was
     use-__u32-in-asm-x86_64-msrh.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: use __u32 in asm-x86_64/msr.h
From: Mike Frysinger <vapier@gentoo.org>

Use __u32 rather than u32 in checking_wrmsrl() exported to userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86_64/msr.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN include/asm-x86_64/msr.h~use-__u32-in-asm-x86_64-msrh include/asm-x86_64/msr.h
--- a/include/asm-x86_64/msr.h~use-__u32-in-asm-x86_64-msrh
+++ a/include/asm-x86_64/msr.h
@@ -2,6 +2,9 @@
 #define X86_64_MSR_H 1
 
 #ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+
 /*
  * Access to machine-specific registers (available on 586 and better only)
  * Note: the rd* operations modify the parameters directly (without using
@@ -43,7 +46,7 @@
 		     : "c" (msr), "0" (a), "d" (b), "i" (-EFAULT)); \
 	ret__; })
 
-#define checking_wrmsrl(msr,val) wrmsr_safe(msr,(u32)(val),(u32)((val)>>32))
+#define checking_wrmsrl(msr,val) wrmsr_safe(msr,(__u32)(val),(__u32)((val)>>32))
 
 #define rdmsr_safe(msr,a,b) \
 	({ int ret__;						\
_

Patches currently in -mm which might be from vapier@gentoo.org are

search-a-little-harder-for-mkimage.patch
new-toplevel-target-headers_check_all.patch
use-__u64-rather-than-u64-in-parisc-statfs-structs.patch
use-__u32-rather-than-u32-in-userspace-ioctls-in-usbdevice_fsh.patch
use-__u32-in-asm-x86_64-msrh.patch
some-rtc-documentation-updates.patch
