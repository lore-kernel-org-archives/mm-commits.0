From: akpm@linux-foundation.org
Subject: - drop-the-superfluous-test-for-an-old-version-of-gcc.patch removed from -mm tree
Date: Sat, 09 Jun 2007 09:32:24 -0700
Message-ID: <200706091632.l59GWOiw008241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54311 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755383AbXFIQcc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 9 Jun 2007 12:32:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     Drop the superfluous test for an old version of gcc.
has been removed from the -mm tree.  Its filename was
     drop-the-superfluous-test-for-an-old-version-of-gcc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Drop the superfluous test for an old version of gcc.
From: "Robert P. J. Day" <rpjday@mindspring.com>

The header file <linux/compiler.h> already enforces a suitably recent
version of gcc, so there's no point checking for that again.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN init/main.c~drop-the-superfluous-test-for-an-old-version-of-gcc init/main.c
--- a/init/main.c~drop-the-superfluous-test-for-an-old-version-of-gcc
+++ a/init/main.c
@@ -69,15 +69,7 @@
 /*
  * This is one of the first .c files built. Error out early if we have compiler
  * trouble.
- *
- * Versions of gcc older than that listed below may actually compile and link
- * okay, but the end product can have subtle run time bugs.  To avoid associated
- * bogus bug reports, we flatly refuse to compile with a gcc that is known to be
- * too old from the very beginning.
  */
-#if (__GNUC__ < 3) || (__GNUC__ == 3 && __GNUC_MINOR__ < 2)
-#error Sorry, your GCC is too old. It builds incorrect kernels.
-#endif
 
 #if __GNUC__ == 4 && __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ == 0
 #warning gcc-4.1.0 is known to miscompile the kernel.  A different compiler version is recommended.
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
viotape-use-designated-initializers-for-fops-member.patch
git-dvb.patch
git-ieee1394.patch
input-delete-useless-reference-to-dead-module_parm-macro.patch
git-kbuild.patch
git-kvm.patch
git-mmc.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-s390.patch
git-scsi-misc.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
cris-replace-old-style-member-inits-with-designated-inits.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
cobalt-remove-all-traces-of-cobalt-from-nvramc.patch
remove-apparently-useless-commented-apm_get_battery_status.patch
drop-the-superfluous-test-for-an-old-version-of-gcc.patch
