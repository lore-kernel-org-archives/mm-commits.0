From: akpm@linux-foundation.org
Subject: - drivers-scsi-advansysc-ld-error-re-2623-rc3-mm1.patch removed from -mm tree
Date: Sun, 16 Sep 2007 23:52:12 -0700
Message-ID: <200709170657.l8H6vuja027630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35069 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752031AbXIQG6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Sep 2007 02:58:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/advansys.c: ld error
has been removed from the -mm tree.  Its filename was
     drivers-scsi-advansysc-ld-error-re-2623-rc3-mm1.patch

This patch was dropped because it was a dupe

------------------------------------------------------
Subject: drivers/scsi/advansys.c: ld error
From: Matthew Wilcox <matthew@wil.cx>

When CONFIG_ISA is disabled, the isa_driver support will not be compiled
in.  Define stubs so that we don't get link-time errors.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/isa.h |   11 +++++++++++
 1 files changed, 11 insertions(+)

diff -puN include/linux/isa.h~drivers-scsi-advansysc-ld-error-re-2623-rc3-mm1 include/linux/isa.h
--- a/include/linux/isa.h~drivers-scsi-advansysc-ld-error-re-2623-rc3-mm1
+++ a/include/linux/isa.h
@@ -22,7 +22,18 @@ struct isa_driver {
 
 #define to_isa_driver(x) container_of((x), struct isa_driver, driver)
 
+#ifdef CONFIG_ISA
 int isa_register_driver(struct isa_driver *, unsigned int);
 void isa_unregister_driver(struct isa_driver *);
+#else
+static inline int isa_register_driver(struct isa_driver *d, unsigned int i)
+{
+	return 0;
+}
+
+static inline void isa_unregister_driver(struct isa_driver *d)
+{
+}
+#endif
 
 #endif /* __LINUX_ISA_H */
_

Patches currently in -mm which might be from matthew@wil.cx are

origin.patch
fix-dac960-driver-on-machines-which-dont-support-64-bit-dma-fix.patch
drivers-scsi-advansysc-linkage-fix.patch
git-scsi-misc.patch
drivers-scsi-advansysc-ld-error-re-2623-rc3-mm1.patch
make-sure-nobodys-leaking-resources.patch
