From: akpm@linux-foundation.org
Subject: [merged]
 kexec-dont-invoke-oom-killer-for-control-page-allocation.patch removed from -mm tree
Date: Wed, 03 Aug 2016 11:13:40 -0700
Message-ID: <57a23454.dOKezxM7pT7HmQ34%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758005AbcHCSNy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk+kernel@arm.linux.org.uk, bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, horms@verge.net.au, j-keerthy@ti.com, panand@redhat.com, vgoyal@redhat.com, vitalya@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: don't invoke OOM-killer for control page allocation
has been removed from the -mm tree.  Its filename was
     kexec-dont-invoke-oom-killer-for-control-page-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: kexec: don't invoke OOM-killer for control page allocation

If we are unable to find a suitable page when allocating the control page,
do not invoke the OOM-killer: killing processes probably isn't going to
help.

Link: http://lkml.kernel.org/r/E1b8ko9-0004HG-R5@rmk-PC.armlinux.org.uk
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Reviewed-by: Pratyush Anand <panand@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Keerthy <j-keerthy@ti.com>
Cc: Vitaly Andrianov <vitalya@ti.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kexec.h~kexec-dont-invoke-oom-killer-for-control-page-allocation include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-dont-invoke-oom-killer-for-control-page-allocation
+++ a/include/linux/kexec.h
@@ -41,7 +41,7 @@
 #endif
 
 #ifndef KEXEC_CONTROL_MEMORY_GFP
-#define KEXEC_CONTROL_MEMORY_GFP GFP_KERNEL
+#define KEXEC_CONTROL_MEMORY_GFP (GFP_KERNEL | __GFP_NORETRY)
 #endif
 
 #ifndef KEXEC_CONTROL_PAGE_SIZE
_

Patches currently in -mm which might be from rmk+kernel@arm.linux.org.uk are


