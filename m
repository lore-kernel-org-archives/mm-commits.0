From: akpm@linux-foundation.org
Subject: - drivers-scsi-advansysc-linkage-fix.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:14:53 -0700
Message-ID: <200709202114.l8KLEreQ002785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39365 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753604AbXITVPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:15:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, James.Bottomley@steeleye.com, nix.or.die@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/advansys.c: linkage fix
has been removed from the -mm tree.  Its filename was
     drivers-scsi-advansysc-linkage-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/scsi/advansys.c: linkage fix
From: Matthew Wilcox <matthew@wil.cx>

advansys.c:(.init.text+0x38ea): undefined reference to `isa_register_driver'

When CONFIG_ISA is disabled, the isa_driver support will not be compiled
in.  Define stubs so that we don't get link-time errors.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
Cc: Gabriel C <nix.or.die@googlemail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/isa.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN include/linux/isa.h~drivers-scsi-advansysc-linkage-fix include/linux/isa.h
--- a/include/linux/isa.h~drivers-scsi-advansysc-linkage-fix
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

git-scsi-misc.patch
make-sure-nobodys-leaking-resources.patch
