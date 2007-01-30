From: akpm@osdl.org
Subject: + use-__u32-in-asm-x86_64-msrh.patch added to -mm tree
Date: Mon, 29 Jan 2007 18:44:47 -0800
Message-ID: <200701300244.l0U2il25007246@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38969 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbXA3CpA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 21:45:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, ak@suse.de


The patch titled
     use __u32 in asm-x86_64/msr.h
has been added to the -mm tree.  Its filename is
     use-__u32-in-asm-x86_64-msrh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use __u32 in asm-x86_64/msr.h
From: Mike Frysinger <vapier@gentoo.org>

Use __u32 rather than u32 in checking_wrmsrl() exported to userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

origin.patch
use-__u8-__u32-in-userspace-ioctl-defines-for-i2o.patch
use-__u8-rather-than-u8-in-userspace-size-defines-in-hdregh.patch
translate-dashes-in-filenames-for-headers-install.patch
search-a-little-harder-for-mkimage.patch
use-__u64-rather-than-u64-in-parisc-statfs-structs.patch
use-__u32-rather-than-u32-in-userspace-ioctls-in-usbdevice_fsh.patch
use-__u32-in-asm-x86_64-msrh.patch
some-rtc-documentation-updates.patch
