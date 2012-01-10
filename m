From: akpm@linux-foundation.org
Subject: [folded] kernelh-add-build_bug-macro-v3.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:44:21 -0800
Message-ID: <20120110224422.942CB5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:40202 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2AJWoY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:44:24 -0500
Received: by mail-ey0-f202.google.com with SMTP id k10so3292eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:44:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.daney@cavium.com, dhowells@redhat.com, dm.n9107@gmail.com, ralf@linux-mips.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: Add BUILD_BUG() macro.
has been removed from the -mm tree.  Its filename was
     kernelh-add-build_bug-macro-v3.patch

This patch was dropped because it was folded into kernelh-add-build_bug-macro.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Daney <david.daney@cavium.com>
Subject: kernel.h: Add BUILD_BUG() macro.

We can place this in definitions that we expect the compiler to remove
by dead code elimination.  If this assertion fails, we get a nice
error message at build time.

The GCC function attribute error("message") was added in version 4.3,
so we define a new macro __linktime_error(message) to expand to this
for GCC-4.3 and later.  This will give us an error diagnostic from the
compiler on the line that fails.  For other compilers
__linktime_error(message) expands to nothing, and we have to be
content with a link time error, but at least we will still get a build
error.

BUILD_BUG() expands to the undefined function __build_bug_failed() and
will fail at link time if the compiler ever emits code for it.  On
GCC-4.3 and later, attribute((error())) is used so that the failure
will be noted at compile time instead.

Acked-by: David Howells <dhowells@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: David Daney <david.daney@cavium.com>
Cc: David Rientjes <rientjes@google.com>
Cc: DM <dm.n9107@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kernel.h~kernelh-add-build_bug-macro-v3 include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-add-build_bug-macro-v3
+++ a/include/linux/kernel.h
@@ -710,7 +710,7 @@ extern int __build_bug_on_failed;
  * BUILD_BUG - break compile if used.
  *
  * If you have some code that you expect the compiler to eliminate at
- * build time, you should use BUILD_BUG_ON_USED to detect if it is
+ * build time, you should use BUILD_BUG to detect if it is
  * unexpectedly used.
  */
 #define BUILD_BUG()						\
_

Patches currently in -mm which might be from david.daney@cavium.com are

origin.patch
kernelh-add-build_bug-macro.patch
fs-binfmt_elf-create-kconfig-variable-for-pie-randomization.patch
mips-randomize-pie-load-address.patch

