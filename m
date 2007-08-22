From: akpm@linux-foundation.org
Subject: + drivers-scsi-advansysc-ld-error-re-2623-rc3-mm1.patch added to -mm tree
Date: Wed, 22 Aug 2007 15:59:38 -0700
Message-ID: <200708222259.l7MMxcWX009269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46731 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762811AbXHVW7t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 18:59:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthew@wil.cx, James.Bottomley@steeleye.com


The patch titled
     drivers/scsi/advansys.c: ld error
has been added to the -mm tree.  Its filename is
     drivers-scsi-advansysc-ld-error-re-2623-rc3-mm1.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-scsi-misc.patch
drivers-scsi-advansysc-ld-error-re-2623-rc3-mm1.patch
make-sure-nobodys-leaking-resources.patch
