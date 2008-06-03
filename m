From: akpm@linux-foundation.org
Subject: + kernel-introduce-gcc_version_lower-macro.patch added to -mm tree
Date: Tue, 03 Jun 2008 16:02:01 -0700
Message-ID: <200806032302.m53N22Ju024440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753384AbYFCXDZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 19:03:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.oberparleiter@de.ibm.com, rusty@rustcorp.com.au, sam@ravnborg.org


The patch titled
     gcov: kernel: introduce GCC_VERSION_LOWER macro
has been added to the -mm tree.  Its filename is
     kernel-introduce-gcc_version_lower-macro.patch

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
Subject: gcov: kernel: introduce GCC_VERSION_LOWER macro
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Use GCC_VERSION_LOWER() to check for gcc versions below a certain level.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/compiler-gcc.h~kernel-introduce-gcc_version_lower-macro include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~kernel-introduce-gcc_version_lower-macro
+++ a/include/linux/compiler-gcc.h
@@ -6,6 +6,9 @@
  * Common definitions for all gcc versions go here.
  */
 
+#define GCC_VERSION_LOWER(major, minor) ((__GNUC__ < major) || \
+					 (__GNUC__ == major) && \
+					 (__GNUC_MINOR__ < minor))
 
 /* Optimization barrier */
 /* The "volatile" is due to gcc bugs */
_

Patches currently in -mm which might be from peter.oberparleiter@de.ibm.com are

origin.patch
linux-next.patch
kernel-call-constructors.patch
kernel-introduce-gcc_version_lower-macro.patch
seq_file-add-function-to-write-binary-data.patch
gcov-add-gcov-profiling-infrastructure.patch
gcov-create-links-to-gcda-files-in-build-directory.patch
gcov-architecture-specific-compile-flag-adjustments.patch

