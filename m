From: akpm@linux-foundation.org
Subject: + move-page-typesc-from-documentation-to-tools-vm.patch added to -mm tree
Date: Thu, 09 Feb 2012 15:03:26 -0800
Message-ID: <20120209230328.44C38A0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:52257 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758577Ab2BIXD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2012 18:03:29 -0500
Received: by yhgm50 with SMTP id m50so257190yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 09 Feb 2012 15:03:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dyoung@redhat.com, cl@linux.com, fengguang.wu@intel.com, fweisbec@gmail.com, penberg@cs.helsinki.fi


The patch titled
     Subject: mm: move page-types.c from Documentation to tools/vm
has been added to the -mm tree.  Its filename is
     move-page-typesc-from-documentation-to-tools-vm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: mm: move page-types.c from Documentation to tools/vm

tools/ is the better place for vm tools which are used by many people. 
Moving them to tools also make them open to more users instead of hide in
Documentation folder.

This patch moves page-types.c to tools/vm/page-types.c.  Also add a
Makefile in tools/vm and fix two coding style problems: a) change const
arrary to 'const char * const', b) change a space to tab for indent.

Signed-off-by: Dave Young <dyoung@redhat.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/Makefile     |    2 +-
 Documentation/vm/page-types.c |    6 +++---
 tools/vm/Makefile             |   11 +++++++++++
 3 files changed, 15 insertions(+), 4 deletions(-)

diff -puN Documentation/vm/Makefile~move-page-typesc-from-documentation-to-tools-vm Documentation/vm/Makefile
--- a/Documentation/vm/Makefile~move-page-typesc-from-documentation-to-tools-vm
+++ a/Documentation/vm/Makefile
@@ -2,7 +2,7 @@
 obj- := dummy.o
 
 # List of programs to build
-hostprogs-y := page-types hugepage-mmap hugepage-shm map_hugetlb
+hostprogs-y := hugepage-mmap hugepage-shm map_hugetlb
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
diff -puN Documentation/vm/page-types.c~move-page-typesc-from-documentation-to-tools-vm Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~move-page-typesc-from-documentation-to-tools-vm
+++ a/Documentation/vm/page-types.c
@@ -123,7 +123,7 @@
 #define BIT(name)		(1ULL << KPF_##name)
 #define BITS_COMPOUND		(BIT(COMPOUND_HEAD) | BIT(COMPOUND_TAIL))
 
-static const char *page_flag_names[] = {
+static const char * const page_flag_names[] = {
 	[KPF_LOCKED]		= "L:locked",
 	[KPF_ERROR]		= "E:error",
 	[KPF_REFERENCED]	= "R:referenced",
@@ -164,7 +164,7 @@ static const char *page_flag_names[] = {
 };
 
 
-static const char *debugfs_known_mountpoints[] = {
+static const char * const debugfs_known_mountpoints[] = {
 	"/sys/kernel/debug",
 	"/debug",
 	0,
@@ -213,7 +213,7 @@ static int		hwpoison_forget_fd;
 
 static unsigned long	total_pages;
 static unsigned long	nr_pages[HASH_SIZE];
-static uint64_t 	page_flags[HASH_SIZE];
+static uint64_t		page_flags[HASH_SIZE];
 
 
 /*
diff -puN /dev/null tools/vm/Makefile
--- /dev/null
+++ a/tools/vm/Makefile
@@ -0,0 +1,11 @@
+# Makefile for vm tools
+
+CC = $(CROSS_COMPILE)gcc
+CFLAGS = -Wall -Wextra
+
+all: page-types
+%: %.c
+	$(CC) $(CFLAGS) -o $@ $^
+
+clean:
+	$(RM) page-types
_
Subject: Subject: mm: move page-types.c from Documentation to tools/vm

Patches currently in -mm which might be from dyoung@redhat.com are

linux-next.patch
loop-zero-fill-bio-instead-of-return-eio-for-partial-read.patch
selftests-launch-individual-selftests-from-the-main-makefile.patch
move-page-typesc-from-documentation-to-tools-vm.patch
move-slabinfoc-to-tools-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch

