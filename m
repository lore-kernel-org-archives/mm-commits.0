From: akpm@linux-foundation.org
Subject: - smbh-do-not-include-linux-timeh-in-userspace.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:49:47 -0700
Message-ID: <200810012149.m91LnlgN005718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753410AbYJAVt6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:49:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     smb.h: do not include linux/time.h in userspace
has been removed from the -mm tree.  Its filename was
     smbh-do-not-include-linux-timeh-in-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smb.h: do not include linux/time.h in userspace
From: "Kirill A. Shutemov" <kirill@shutemov.name>

linux/time.h conflicts with time.h from glibc

It breaks building smbmount from samba.  It's regression introduced by
commit 76308da (" smb.h: uses struct timespec but didn't include
linux/time.h").

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: <stable@kernel.org>             [2.6.26.x]

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smb.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/smb.h~smbh-do-not-include-linux-timeh-in-userspace include/linux/smb.h
--- a/include/linux/smb.h~smbh-do-not-include-linux-timeh-in-userspace
+++ a/include/linux/smb.h
@@ -11,7 +11,9 @@
 
 #include <linux/types.h>
 #include <linux/magic.h>
+#ifdef __KERNEL__
 #include <linux/time.h>
+#endif
 
 enum smb_protocol { 
 	SMB_PROTOCOL_NONE, 
_

Patches currently in -mm which might be from kirill@shutemov.name are

alpha-introduce-field-taso-into-struct-linux_binprm.patch
allow-recursion-in-binfmt_script-and-binfmt_misc.patch
allow-recursion-in-binfmt_script-and-binfmt_misc-fix.patch

