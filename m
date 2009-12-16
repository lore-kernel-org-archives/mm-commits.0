From: akpm@linux-foundation.org
Subject: + vt-dont-export-vt_kmsg_redirect-to-userspace.patch added to -mm tree
Date: Wed, 16 Dec 2009 14:16:00 -0800
Message-ID: <200912162216.nBGMG0U4017893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935823AbZLPWQF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 17:16:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bernhard@bwalle.de


The patch titled
     vt: don't export vt_kmsg_redirect() to userspace
has been added to the -mm tree.  Its filename is
     vt-dont-export-vt_kmsg_redirect-to-userspace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
vt-dont-export-vt_kmsg_redirect-to-userspace.patch

