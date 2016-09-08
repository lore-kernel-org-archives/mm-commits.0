From: akpm@linux-foundation.org
Subject: + selftest-move-seek_to_smaps_entry-out-of-mlock2-testsc.patch
 added to -mm tree
Date: Thu, 08 Sep 2016 15:38:16 -0700
Message-ID: <57d1e858.Rg5ujnwlxYuhdJ0B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45777 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751143AbcIHWiS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2016 18:38:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.guo.simon@gmail.com, aarcange@redhat.com, emunson@akamai.com, geert@linux-m68k.org, kirill.shutemov@linux.intel.com, klimov.linux@gmail.com, mgorman@techsingularity.net, mhocko@suse.com, mike.kravetz@oracle.com, shuah@kernel.org, treding@nvidia.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: selftest: move seek_to_smaps_entry() out of mlock2-tests.c
has been added to the -mm tree.  Its filename is
     selftest-move-seek_to_smaps_entry-out-of-mlock2-testsc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftest-move-seek_to_smaps_entry-out-of-mlock2-testsc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftest-move-seek_to_smaps_entry-out-of-mlock2-testsc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Simon Guo <wei.guo.simon@gmail.com>
Subject: selftest: move seek_to_smaps_entry() out of mlock2-tests.c

Function seek_to_smaps_entry() can be useful for other selftest
functionalities, so move it out to header file.

Link: http://lkml.kernel.org/r/1473325970-11393-3-git-send-email-wei.guo.simon@gmail.com
Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Eric B Munson <emunson@akamai.com>
Cc: Simon Guo <wei.guo.simon@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Alexey Klimov <klimov.linux@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mlock2-tests.c |   42 -------------------
 tools/testing/selftests/vm/mlock2.h       |   43 ++++++++++++++++++++
 2 files changed, 43 insertions(+), 42 deletions(-)

diff -puN tools/testing/selftests/vm/mlock2-tests.c~selftest-move-seek_to_smaps_entry-out-of-mlock2-testsc tools/testing/selftests/vm/mlock2-tests.c
--- a/tools/testing/selftests/vm/mlock2-tests.c~selftest-move-seek_to_smaps_entry-out-of-mlock2-testsc
+++ a/tools/testing/selftests/vm/mlock2-tests.c
@@ -1,8 +1,6 @@
 #define _GNU_SOURCE
 #include <sys/mman.h>
 #include <stdint.h>
-#include <stdio.h>
-#include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
 #include <sys/time.h>
@@ -119,46 +117,6 @@ static uint64_t get_kpageflags(unsigned
 	return flags;
 }
 
-static FILE *seek_to_smaps_entry(unsigned long addr)
-{
-	FILE *file;
-	char *line = NULL;
-	size_t size = 0;
-	unsigned long start, end;
-	char perms[5];
-	unsigned long offset;
-	char dev[32];
-	unsigned long inode;
-	char path[BUFSIZ];
-
-	file = fopen("/proc/self/smaps", "r");
-	if (!file) {
-		perror("fopen smaps");
-		_exit(1);
-	}
-
-	while (getline(&line, &size, file) > 0) {
-		if (sscanf(line, "%lx-%lx %s %lx %s %lu %s\n",
-			   &start, &end, perms, &offset, dev, &inode, path) < 6)
-			goto next;
-
-		if (start <= addr && addr < end)
-			goto out;
-
-next:
-		free(line);
-		line = NULL;
-		size = 0;
-	}
-
-	fclose(file);
-	file = NULL;
-
-out:
-	free(line);
-	return file;
-}
-
 #define VMFLAGS "VmFlags:"
 
 static bool is_vmflag_set(unsigned long addr, const char *vmflag)
diff -puN tools/testing/selftests/vm/mlock2.h~selftest-move-seek_to_smaps_entry-out-of-mlock2-testsc tools/testing/selftests/vm/mlock2.h
--- a/tools/testing/selftests/vm/mlock2.h~selftest-move-seek_to_smaps_entry-out-of-mlock2-testsc
+++ a/tools/testing/selftests/vm/mlock2.h
@@ -1,5 +1,7 @@
 #include <syscall.h>
 #include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
 
 #ifndef MLOCK_ONFAULT
 #define MLOCK_ONFAULT 1
@@ -18,3 +20,44 @@ static int mlock2_(void *start, size_t l
 	return -1;
 #endif
 }
+
+static FILE *seek_to_smaps_entry(unsigned long addr)
+{
+	FILE *file;
+	char *line = NULL;
+	size_t size = 0;
+	unsigned long start, end;
+	char perms[5];
+	unsigned long offset;
+	char dev[32];
+	unsigned long inode;
+	char path[BUFSIZ];
+
+	file = fopen("/proc/self/smaps", "r");
+	if (!file) {
+		perror("fopen smaps");
+		_exit(1);
+	}
+
+	while (getline(&line, &size, file) > 0) {
+		if (sscanf(line, "%lx-%lx %s %lx %s %lu %s\n",
+			   &start, &end, perms, &offset, dev, &inode, path) < 6)
+			goto next;
+
+		if (start <= addr && addr < end)
+			goto out;
+
+next:
+		free(line);
+		line = NULL;
+		size = 0;
+	}
+
+	fclose(file);
+	file = NULL;
+
+out:
+	free(line);
+	return file;
+}
+
_

Patches currently in -mm which might be from wei.guo.simon@gmail.com are

mm-mlock-check-against-vma-for-actual-mlock-size.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix-2.patch
mm-mlock-avoid-increase-mm-locked_vm-on-mlock-when-already-mlock2mlock_onfault.patch
selftest-split-mlock2_-funcs-into-separate-mlock2h.patch
selftests-vm-add-test-for-mlock-when-areas-are-intersected.patch
selftest-move-seek_to_smaps_entry-out-of-mlock2-testsc.patch
selftests-expanding-more-mlock-selftest.patch

