From: akpm@linux-foundation.org
Subject: + selftest-add-simple-test-for-soft-dirty-bit.patch added to -mm tree
Date: Mon, 15 Apr 2013 15:03:20 -0700
Message-ID: <20130415220320.656A631C082@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:40841 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab3DOWDV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Apr 2013 18:03:21 -0400
Received: by mail-vb0-f74.google.com with SMTP id w16so517361vbb.3
        for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2013 15:03:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@parallels.com


The patch titled
     Subject: selftest: add simple test for soft-dirty bit
has been added to the -mm tree.  Its filename is
     selftest-add-simple-test-for-soft-dirty-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Emelyanov <xemul@parallels.com>
Subject: selftest: add simple test for soft-dirty bit

It creates a mapping of 3 pages and checks that reads, writes and
clear-refs result in present and soft-dirt bits reported from pagemap2 set
as expected.

[akpm@linux-foundation.org: alphasort the Makefile TARGETS to reduce rejects]
Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile                |   11 -
 tools/testing/selftests/soft-dirty/Makefile     |   10 +
 tools/testing/selftests/soft-dirty/soft-dirty.c |  114 ++++++++++++++
 3 files changed, 130 insertions(+), 5 deletions(-)

diff -puN tools/testing/selftests/Makefile~selftest-add-simple-test-for-soft-dirty-bit tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~selftest-add-simple-test-for-soft-dirty-bit
+++ a/tools/testing/selftests/Makefile
@@ -1,12 +1,13 @@
 TARGETS = breakpoints
-TARGETS += kcmp
-TARGETS += timers
-TARGETS += mqueue
-TARGETS += vm
 TARGETS += cpu-hotplug
-TARGETS += memory-hotplug
 TARGETS += efivarfs
+TARGETS += kcmp
+TARGETS += memory-hotplug
+TARGETS += mqueue
 TARGETS += net
+TARGETS += soft-dirty
+TARGETS += timers
+TARGETS += vm
 
 all:
 	for TARGET in $(TARGETS); do \
diff -puN /dev/null tools/testing/selftests/soft-dirty/Makefile
--- /dev/null
+++ a/tools/testing/selftests/soft-dirty/Makefile
@@ -0,0 +1,10 @@
+CFLAGS += -iquote../../../../include/uapi -Wall
+soft-dirty: soft-dirty.c
+
+all: soft-dirty
+
+clean:
+	rm -f soft-dirty
+
+run_tests: all
+	@./soft-dirty || echo "soft-dirty selftests: [FAIL]"
diff -puN /dev/null tools/testing/selftests/soft-dirty/soft-dirty.c
--- /dev/null
+++ a/tools/testing/selftests/soft-dirty/soft-dirty.c
@@ -0,0 +1,114 @@
+#include <stdlib.h>
+#include <stdio.h>
+#include <sys/mman.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/types.h>
+
+typedef unsigned long long u64;
+
+#define PME_PRESENT	(1ULL << 63)
+#define PME_SOFT_DIRTY	(1Ull << 55)
+
+#define PAGES_TO_TEST	3
+#ifndef PAGE_SIZE
+#define PAGE_SIZE	4096
+#endif
+
+static void get_pagemap2(char *mem, u64 *map)
+{
+	int fd;
+
+	fd = open("/proc/self/pagemap2", O_RDONLY);
+	if (fd < 0) {
+		perror("Can't open pagemap2");
+		exit(1);
+	}
+
+	lseek(fd, (unsigned long)mem / PAGE_SIZE * sizeof(u64), SEEK_SET);
+	read(fd, map, sizeof(u64) * PAGES_TO_TEST);
+	close(fd);
+}
+
+static inline char map_p(u64 map)
+{
+	return map & PME_PRESENT ? 'p' : '-';
+}
+
+static inline char map_sd(u64 map)
+{
+	return map & PME_SOFT_DIRTY ? 'd' : '-';
+}
+
+static int check_pte(int step, int page, u64 *map, u64 want)
+{
+	if ((map[page] & want) != want) {
+		printf("Step %d Page %d has %c%c, want %c%c\n",
+				step, page,
+				map_p(map[page]), map_sd(map[page]),
+				map_p(want), map_sd(want));
+		return 1;
+	}
+
+	return 0;
+}
+
+static void clear_refs(void)
+{
+	int fd;
+	char *v = "4";
+
+	fd = open("/proc/self/clear_refs", O_WRONLY);
+	if (write(fd, v, 3) < 3) {
+		perror("Can't clear soft-dirty bit");
+		exit(1);
+	}
+	close(fd);
+}
+
+int main(void)
+{
+	char *mem, x;
+	u64 map[PAGES_TO_TEST];
+
+	mem = mmap(NULL, PAGES_TO_TEST * PAGE_SIZE,
+			PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, 0, 0);
+
+	x = mem[0];
+	mem[2 * PAGE_SIZE] = 'c';
+	get_pagemap2(mem, map);
+
+	if (check_pte(1, 0, map, PME_PRESENT))
+		return 1;
+	if (check_pte(1, 1, map, 0))
+		return 1;
+	if (check_pte(1, 2, map, PME_PRESENT | PME_SOFT_DIRTY))
+		return 1;
+
+	clear_refs();
+	get_pagemap2(mem, map);
+
+	if (check_pte(2, 0, map, PME_PRESENT))
+		return 1;
+	if (check_pte(2, 1, map, 0))
+		return 1;
+	if (check_pte(2, 2, map, PME_PRESENT))
+		return 1;
+
+	mem[0] = 'a';
+	mem[PAGE_SIZE] = 'b';
+	x = mem[2 * PAGE_SIZE];
+	get_pagemap2(mem, map);
+
+	if (check_pte(3, 0, map, PME_PRESENT | PME_SOFT_DIRTY))
+		return 1;
+	if (check_pte(3, 1, map, PME_PRESENT | PME_SOFT_DIRTY))
+		return 1;
+	if (check_pte(3, 2, map, PME_PRESENT))
+		return 1;
+
+	(void)x; /* gcc warn */
+
+	printf("PASS\n");
+	return 0;
+}
_

Patches currently in -mm which might be from xemul@parallels.com are

linux-next.patch
clear_refs-sanitize-accepted-commands-declaration.patch
clear_refs-sanitize-accepted-commands-declaration-fix.patch
clear_refs-introduce-private-struct-for-mm_walk.patch
pagemap-introduce-pagemap_entry_t-without-pmshift-bits.patch
pagemap-introduce-the-proc-pid-pagemap2-file.patch
mm-soft-dirty-bits-for-user-memory-changes-tracking.patch
selftest-add-simple-test-for-soft-dirty-bit.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
kernel-sysc-make-prctlpr_set_mm-generally-available.patch

