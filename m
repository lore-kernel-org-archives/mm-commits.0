From: akpm@linux-foundation.org
Subject: [merged] vt-dont-export-vt_kmsg_redirect-to-userspace.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:26:21 -0800
Message-ID: <200912182026.nBIKQLHv016454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932779AbZLRU01 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:26:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bernhard@bwalle.de, mm-commits@vger.kernel.org


The patch titled
     vt: don't export vt_kmsg_redirect() to userspace
has been removed from the -mm tree.  Its filename was
     vt-dont-export-vt_kmsg_redirect-to-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt: don't export vt_kmsg_redirect() to userspace
From: Bernhard Walle <bernhard@bwalle.de>

Fix following warning in linux-next by guarding the function definition
(both the "extern" and the inline) with #ifdef __KERNEL__.

usr/include/linux/vt.h:89: userspace cannot call function or variable defined in
the kernel

Introduced by commit 5ada918b82399eef3afd6a71e3637697d6bd719f ("vt:
introduce and use vt_kmsg_redirect() function").

Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vt.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/vt.h~vt-dont-export-vt_kmsg_redirect-to-userspace include/linux/vt.h
--- a/include/linux/vt.h~vt-dont-export-vt_kmsg_redirect-to-userspace
+++ a/include/linux/vt.h
@@ -84,6 +84,8 @@ struct vt_setactivate {
 
 #define VT_SETACTIVATE	0x560F	/* Activate and set the mode of a console */
 
+#ifdef __KERNEL__
+
 #ifdef CONFIG_VT_CONSOLE
 
 extern int vt_kmsg_redirect(int new);
@@ -97,6 +99,8 @@ static inline int vt_kmsg_redirect(int n
 
 #endif
 
+#endif /* __KERNEL__ */
+
 #define vt_get_kmsg_redirect() vt_kmsg_redirect(-1)
 
 #endif /* _LINUX_VT_H */
_

Patches currently in -mm which might be from bernhard@bwalle.de are


