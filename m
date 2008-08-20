From: akpm@linux-foundation.org
Subject: - xtensa-warn-about-including-asm-rwsemh-directly.patch removed from -mm tree
Date: Wed, 20 Aug 2008 13:12:57 -0700
Message-ID: <200808202012.m7KKCv5d029377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754140AbYHTUNB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 16:13:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     XTENSA: warn about including <asm/rwsem.h> directly.
has been removed from the -mm tree.  Its filename was
     xtensa-warn-about-including-asm-rwsemh-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: XTENSA: warn about including <asm/rwsem.h> directly.
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

For consistency with other architectures, warn about including
<asm-xtensa/rwsem.h> directly.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-xtensa/rwsem.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/asm-xtensa/rwsem.h~xtensa-warn-about-including-asm-rwsemh-directly include/asm-xtensa/rwsem.h
--- a/include/asm-xtensa/rwsem.h~xtensa-warn-about-including-asm-rwsemh-directly
+++ a/include/asm-xtensa/rwsem.h
@@ -13,6 +13,10 @@
 #ifndef _XTENSA_RWSEM_H
 #define _XTENSA_RWSEM_H
 
+#ifndef _LINUX_RWSEM_H
+#error "Please don't include <asm/rwsem.h> directly, use <linux/rwsem.h> instead."
+#endif
+
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <asm/atomic.h>
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
uml-remove-the-dead-tty_log-code.patch
inith-remove-long-dead-__setup_null_param-macro.patch
oss-remove-references-to-dead-sound-oss-vars-aedsp16_msssbpro.patch
fs-partitions-acornc-remove-dead-code.patch

