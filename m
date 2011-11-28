From: akpm@linux-foundation.org
Subject: + kernelh-add-build_bug-macro-v3.patch added to -mm tree
Date: Mon, 28 Nov 2011 15:21:35 -0800
Message-ID: <201111282321.pASNLZDh014752@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:37562 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab1K1XVi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 18:21:38 -0500
Received: by ywb26 with SMTP id 26so514440ywb.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 15:21:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david.daney@cavium.com, dhowells@redhat.com, dm.n9107@gmail.com, ralf@linux-mips.org, rientjes@google.com


The patch titled
     Subject: kernel.h: Add BUILD_BUG() macro.
has been added to the -mm tree.  Its filename is
     kernelh-add-build_bug-macro-v3.patch

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
@@ -709,7 +709,7 @@ extern int __build_bug_on_failed;
  * BUILD_BUG - break compile if used.
  *
  * If you have some code that you expect the compiler to eliminate at
- * build time, you should use BUILD_BUG_ON_USED to detect if it is
+ * build time, you should use BUILD_BUG to detect if it is
  * unexpectedly used.
  */
 #define BUILD_BUG()						\
_
Subject: Subject: kernel.h: Add BUILD_BUG() macro.

Patches currently in -mm which might be from david.daney@cavium.com are

linux-next.patch
kernelh-add-build_bug-macro.patch
kernelh-add-build_bug-macro-v3.patch
hugetlb-replace-bug-with-build_bug-for-dummy-definitions.patch
fs-binfmt_elf-create-kconfig-variable-for-pie-randomization.patch
mips-randomize-pie-load-address.patch

