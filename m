From: akpm@linux-foundation.org
Subject: [merged] selftest-split-mlock2_-funcs-into-separate-mlock2h.patch removed from -mm tree
Date: Mon, 10 Oct 2016 15:44:42 -0700
Message-ID: <57fc19da./VVZFRMoT/Ob2L+8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36797 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752421AbcJJWon (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:44:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.guo.simon@gmail.com, emunson@akamai.com, geert@linux-m68k.org, kirill.shutemov@linux.intel.com, klimov.linux@gmail.com, mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com, shuah@kernel.org, treding@nvidia.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: selftest: split mlock2_ funcs into separate mlock2.h
has been removed from the -mm tree.  Its filename was
     selftest-split-mlock2_-funcs-into-separate-mlock2h.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Simon Guo <wei.guo.simon@gmail.com>
Subject: selftest: split mlock2_ funcs into separate mlock2.h

To prepare mlock2.h whose functionality will be reused.

Link: http://lkml.kernel.org/r/1472554781-9835-4-git-send-email-wei.guo.simon@gmail.com
Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
Cc: Alexey Klimov <klimov.linux@gmail.com>
Cc: Eric B Munson <emunson@akamai.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Simon Guo <wei.guo.simon@gmail.com>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mlock2-tests.c |   21 --------------------
 tools/testing/selftests/vm/mlock2.h       |   20 +++++++++++++++++++
 2 files changed, 21 insertions(+), 20 deletions(-)

diff -puN tools/testing/selftests/vm/mlock2-tests.c~selftest-split-mlock2_-funcs-into-separate-mlock2h tools/testing/selftests/vm/mlock2-tests.c
--- a/tools/testing/selftests/vm/mlock2-tests.c~selftest-split-mlock2_-funcs-into-separate-mlock2h
+++ a/tools/testing/selftests/vm/mlock2-tests.c
@@ -7,27 +7,8 @@
 #include <string.h>
 #include <sys/time.h>
 #include <sys/resource.h>
-#include <syscall.h>
-#include <errno.h>
 #include <stdbool.h>
-
-#ifndef MLOCK_ONFAULT
-#define MLOCK_ONFAULT 1
-#endif
-
-#ifndef MCL_ONFAULT
-#define MCL_ONFAULT (MCL_FUTURE << 1)
-#endif
-
-static int mlock2_(void *start, size_t len, int flags)
-{
-#ifdef __NR_mlock2
-	return syscall(__NR_mlock2, start, len, flags);
-#else
-	errno = ENOSYS;
-	return -1;
-#endif
-}
+#include "mlock2.h"
 
 struct vm_boundaries {
 	unsigned long start;
diff -puN /dev/null tools/testing/selftests/vm/mlock2.h
--- /dev/null
+++ a/tools/testing/selftests/vm/mlock2.h
@@ -0,0 +1,20 @@
+#include <syscall.h>
+#include <errno.h>
+
+#ifndef MLOCK_ONFAULT
+#define MLOCK_ONFAULT 1
+#endif
+
+#ifndef MCL_ONFAULT
+#define MCL_ONFAULT (MCL_FUTURE << 1)
+#endif
+
+static int mlock2_(void *start, size_t len, int flags)
+{
+#ifdef __NR_mlock2
+	return syscall(__NR_mlock2, start, len, flags);
+#else
+	errno = ENOSYS;
+	return -1;
+#endif
+}
_

Patches currently in -mm which might be from wei.guo.simon@gmail.com are


