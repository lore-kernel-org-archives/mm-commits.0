From: akpm@linux-foundation.org
Subject: - i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:15 -0700
Message-ID: <200707192010.l6JKAFJ4020653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44408 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759391AbXGSUPM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     i386 uaccess.h: replace hard-coded constant with appropriate macro from kernel.h
has been removed from the -mm tree.  Its filename was
     i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 uaccess.h: replace hard-coded constant with appropriate macro from kernel.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/uaccess.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-i386/uaccess.h~i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh include/asm-i386/uaccess.h
--- a/include/asm-i386/uaccess.h~i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh
+++ a/include/asm-i386/uaccess.h
@@ -581,7 +581,7 @@ long __must_check __strncpy_from_user(ch
  * If there is a limit on the length of a valid string, you may wish to
  * consider using strnlen_user() instead.
  */
-#define strlen_user(str) strnlen_user(str, ~0UL >> 1)
+#define strlen_user(str) strnlen_user(str, LONG_MAX)
 
 long strnlen_user(const char __user *str, long n);
 unsigned long __must_check clear_user(void __user *mem, unsigned long len);
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
git-kbuild.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
