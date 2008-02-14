From: akpm@linux-foundation.org
Subject: + fix-module_update_markers-compile-error.patch added to -mm tree
Date: Wed, 13 Feb 2008 19:35:50 -0800
Message-ID: <200802140335.m1E3ZpIC029024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50169 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754663AbYBNDgP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 22:36:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, mathieu.desnoyers@polymtl.ca


The patch titled
     fix module_update_markers() compile error
has been added to the -mm tree.  Its filename is
     fix-module_update_markers-compile-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix module_update_markers() compile error
From: Adrian Bunk <bunk@kernel.org>

This patch fixes the following compile error with CONFIG_MODULES=n
caused by commit fb40bd78b0f91b274879cf5db8facd1e04b6052e:

/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/marker.c: In function `marker_update_probes':
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/marker.c:627: error: too few arguments to function `module_update_markers'

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/module.h~fix-module_update_markers-compile-error include/linux/module.h
--- a/include/linux/module.h~fix-module_update_markers-compile-error
+++ a/include/linux/module.h
@@ -567,8 +567,7 @@ static inline void print_modules(void)
 {
 }
 
-static inline void module_update_markers(struct module *probe_module,
-		int *refcount)
+static inline void module_update_markers(void)
 {
 }
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
fix-module_update_markers-compile-error.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-net.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
sparc-fix-build.patch
reiser4.patch
