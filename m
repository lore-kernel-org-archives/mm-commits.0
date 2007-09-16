From: akpm@linux-foundation.org
Subject: - ptr_align.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:25:53 -0700
Message-ID: <200709160925.l8G9PrCc009139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51287 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbXIPJZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:25:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     PTR_ALIGN
has been removed from the -mm tree.  Its filename was
     ptr_align.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PTR_ALIGN
From: Matthew Wilcox <matthew@wil.cx>

The AdvanSys driver wants to align some pointers, and the ALIGN macro
doesn't work for pointers.  Rather than try to make it work, add a new
PTR_ALIGN macro which is typesafe.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    1 +
 1 files changed, 1 insertion(+)

diff -puN include/linux/kernel.h~ptr_align include/linux/kernel.h
--- a/include/linux/kernel.h~ptr_align
+++ a/include/linux/kernel.h
@@ -34,6 +34,7 @@ extern const char linux_proc_banner[];
 
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
 #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
+#define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
_

Patches currently in -mm which might be from matthew@wil.cx are

origin.patch
fix-dac960-driver-on-machines-which-dont-support-64-bit-dma-fix.patch
git-scsi-misc.patch
drivers-scsi-advansysc-ld-error-re-2623-rc3-mm1.patch
make-sure-nobodys-leaking-resources.patch
