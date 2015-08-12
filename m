From: akpm@linux-foundation.org
Subject: + selftests-vm-add-tests-for-lock-on-fault-fix.patch added to -mm tree
Date: Wed, 12 Aug 2015 16:33:35 -0700
Message-ID: <55cbd7cf.QD/F7PyN3thk0+FF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbbHLXdg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Aug 2015 19:33:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: treding@nvidia.com, emunson@akamai.com, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: Fix mlock2-tests for 32-bit architectures
has been added to the -mm tree.  Its filename is
     selftests-vm-add-tests-for-lock-on-fault-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-add-tests-for-lock-on-fault-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-add-tests-for-lock-on-fault-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thierry Reding <treding@nvidia.com>
Subject: selftests: vm: Fix mlock2-tests for 32-bit architectures

According to Documentation/vm/pagemap.txt, the /proc/pid/pagemap file
contains one 64-bit value for each virtual page. The test code relies
on the size of unsigned long being 64-bit, which breaks the test when
run on 32-bit architectures. Use a uint64_t to store values read from
the file instead, so that it works irrespective of the architecture's
word size.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Eric B Munson <emunson@akamai.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mlock2-tests.c |   33 ++++++++------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff -puN tools/testing/selftests/vm/mlock2-tests.c~selftests-vm-add-tests-for-lock-on-fault-fix tools/testing/selftests/vm/mlock2-tests.c
--- a/tools/testing/selftests/vm/mlock2-tests.c~selftests-vm-add-tests-for-lock-on-fault-fix
+++ a/tools/testing/selftests/vm/mlock2-tests.c
@@ -1,4 +1,5 @@
 #include <sys/mman.h>
+#include <stdint.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -82,10 +83,10 @@ out:
 	return ret;
 }
 
-static unsigned long get_pageflags(unsigned long addr)
+static uint64_t get_pageflags(unsigned long addr)
 {
 	FILE *file;
-	unsigned long pfn;
+	uint64_t pfn;
 	unsigned long offset;
 
 	file = fopen("/proc/self/pagemap", "r");
@@ -94,13 +95,14 @@ static unsigned long get_pageflags(unsig
 		_exit(1);
 	}
 
-	offset = addr / getpagesize() * sizeof(unsigned long);
+	offset = addr / getpagesize() * sizeof(pfn);
+
 	if (fseek(file, offset, SEEK_SET)) {
 		perror("fseek pagemap");
 		_exit(1);
 	}
 
-	if (fread(&pfn, sizeof(unsigned long), 1, file) != 1) {
+	if (fread(&pfn, sizeof(pfn), 1, file) != 1) {
 		perror("fread pagemap");
 		_exit(1);
 	}
@@ -111,7 +113,7 @@ static unsigned long get_pageflags(unsig
 
 static unsigned long get_kpageflags(unsigned long pfn)
 {
-	unsigned long flags;
+	uint64_t flags;
 	FILE *file;
 
 	file = fopen("/proc/kpageflags", "r");
@@ -120,12 +122,12 @@ static unsigned long get_kpageflags(unsi
 		_exit(1);
 	}
 
-	if (fseek(file, pfn * sizeof(unsigned long), SEEK_SET)) {
+	if (fseek(file, pfn * sizeof(flags), SEEK_SET)) {
 		perror("fseek kpageflags");
 		_exit(1);
 	}
 
-	if (fread(&flags, sizeof(unsigned long), 1, file) != 1) {
+	if (fread(&flags, sizeof(flags), 1, file) != 1) {
 		perror("fread kpageflags");
 		_exit(1);
 	}
@@ -211,9 +213,8 @@ out:
 
 static int lock_check(char *map)
 {
-	unsigned long page1_flags;
-	unsigned long page2_flags;
 	unsigned long page_size = getpagesize();
+	uint64_t page1_flags, page2_flags;
 
 	page1_flags = get_pageflags((unsigned long)map);
 	page2_flags = get_pageflags((unsigned long)map + page_size);
@@ -246,9 +247,8 @@ static int lock_check(char *map)
 
 static int unlock_lock_check(char *map)
 {
-	unsigned long page1_flags;
-	unsigned long page2_flags;
 	unsigned long page_size = getpagesize();
+	uint64_t page1_flags, page2_flags;
 
 	page1_flags = get_pageflags((unsigned long)map);
 	page2_flags = get_pageflags((unsigned long)map + page_size);
@@ -310,9 +310,8 @@ out:
 
 static int onfault_check(char *map)
 {
-	unsigned long page1_flags;
-	unsigned long page2_flags;
 	unsigned long page_size = getpagesize();
+	uint64_t page1_flags, page2_flags;
 
 	page1_flags = get_pageflags((unsigned long)map);
 	page2_flags = get_pageflags((unsigned long)map + page_size);
@@ -355,9 +354,8 @@ static int onfault_check(char *map)
 
 static int unlock_onfault_check(char *map)
 {
-	unsigned long page1_flags;
-	unsigned long page2_flags;
 	unsigned long page_size = getpagesize();
+	uint64_t page1_flags;
 
 	page1_flags = get_pageflags((unsigned long)map);
 	page1_flags = get_kpageflags(page1_flags & PFN_MASK);
@@ -422,9 +420,8 @@ static int test_lock_onfault_of_present(
 {
 	char *map;
 	int ret = 1;
-	unsigned long page1_flags;
-	unsigned long page2_flags;
 	unsigned long page_size = getpagesize();
+	uint64_t page1_flags, page2_flags;
 
 	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
 		   MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
@@ -471,8 +468,6 @@ static int test_munlockall()
 {
 	char *map;
 	int ret = 1;
-	unsigned long page1_flags;
-	unsigned long page2_flags;
 	unsigned long page_size = getpagesize();
 
 	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
_

Patches currently in -mm which might be from treding@nvidia.com are

selftests-vm-add-tests-for-lock-on-fault-fix.patch
selftests-vm-add-tests-for-lock-on-fault-fix-2.patch
selftests-vm-add-tests-for-lock-on-fault-fix-3.patch
linux-next.patch

