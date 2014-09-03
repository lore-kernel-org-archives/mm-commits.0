From: akpm@linux-foundation.org
Subject: [merged]
 tools-selftests-fixing-build-issue-with-make-kselftests-target.patch
 removed from -mm tree
Date: Wed, 03 Sep 2014 10:57:53 -0700
Message-ID: <540756a1.KZz5x4bOv8Ed9GL0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbaICR5y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:57:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tranmanphong@gmail.com, dh.herrmann@gmail.com, hughd@google.com, mmarek@suse.cz, sam@ravnborg.org, shuah.kh@samsung.com, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools: selftests: fix build issue with make kselftests target
has been removed from the -mm tree.  Its filename was
     tools-selftests-fixing-build-issue-with-make-kselftests-target.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Phong Tran <tranmanphong@gmail.com>
Subject: tools: selftests: fix build issue with make kselftests target

Fix the typo of ARCH when running 'make kselftests'.  Change the 'X86' to
'x86'.  Test by compilation.

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shuah Khan <shuah.kh@samsung.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/ipc/Makefile   |    6 +++---
 tools/testing/selftests/kcmp/Makefile  |    6 +++---
 tools/testing/selftests/memfd/Makefile |   10 +++++-----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff -puN tools/testing/selftests/ipc/Makefile~tools-selftests-fixing-build-issue-with-make-kselftests-target tools/testing/selftests/ipc/Makefile
--- a/tools/testing/selftests/ipc/Makefile~tools-selftests-fixing-build-issue-with-make-kselftests-target
+++ a/tools/testing/selftests/ipc/Makefile
@@ -1,18 +1,18 @@
 uname_M := $(shell uname -m 2>/dev/null || echo not)
 ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
 ifeq ($(ARCH),i386)
-        ARCH := X86
+        ARCH := x86
 	CFLAGS := -DCONFIG_X86_32 -D__i386__
 endif
 ifeq ($(ARCH),x86_64)
-	ARCH := X86
+	ARCH := x86
 	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
 endif
 
 CFLAGS += -I../../../../usr/include/
 
 all:
-ifeq ($(ARCH),X86)
+ifeq ($(ARCH),x86)
 	gcc $(CFLAGS) msgque.c -o msgque_test
 else
 	echo "Not an x86 target, can't build msgque selftest"
diff -puN tools/testing/selftests/kcmp/Makefile~tools-selftests-fixing-build-issue-with-make-kselftests-target tools/testing/selftests/kcmp/Makefile
--- a/tools/testing/selftests/kcmp/Makefile~tools-selftests-fixing-build-issue-with-make-kselftests-target
+++ a/tools/testing/selftests/kcmp/Makefile
@@ -1,11 +1,11 @@
 uname_M := $(shell uname -m 2>/dev/null || echo not)
 ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
 ifeq ($(ARCH),i386)
-        ARCH := X86
+        ARCH := x86
 	CFLAGS := -DCONFIG_X86_32 -D__i386__
 endif
 ifeq ($(ARCH),x86_64)
-	ARCH := X86
+	ARCH := x86
 	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
 endif
 
@@ -15,7 +15,7 @@ CFLAGS += -I../../../../usr/include/
 CFLAGS += -I../../../../arch/x86/include/
 
 all:
-ifeq ($(ARCH),X86)
+ifeq ($(ARCH),x86)
 	gcc $(CFLAGS) kcmp_test.c -o kcmp_test
 else
 	echo "Not an x86 target, can't build kcmp selftest"
diff -puN tools/testing/selftests/memfd/Makefile~tools-selftests-fixing-build-issue-with-make-kselftests-target tools/testing/selftests/memfd/Makefile
--- a/tools/testing/selftests/memfd/Makefile~tools-selftests-fixing-build-issue-with-make-kselftests-target
+++ a/tools/testing/selftests/memfd/Makefile
@@ -1,10 +1,10 @@
 uname_M := $(shell uname -m 2>/dev/null || echo not)
 ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
 ifeq ($(ARCH),i386)
-	ARCH := X86
+	ARCH := x86
 endif
 ifeq ($(ARCH),x86_64)
-	ARCH := X86
+	ARCH := x86
 endif
 
 CFLAGS += -D_FILE_OFFSET_BITS=64
@@ -14,20 +14,20 @@ CFLAGS += -I../../../../include/uapi/
 CFLAGS += -I../../../../include/
 
 all:
-ifeq ($(ARCH),X86)
+ifeq ($(ARCH),x86)
 	gcc $(CFLAGS) memfd_test.c -o memfd_test
 else
 	echo "Not an x86 target, can't build memfd selftest"
 endif
 
 run_tests: all
-ifeq ($(ARCH),X86)
+ifeq ($(ARCH),x86)
 	gcc $(CFLAGS) memfd_test.c -o memfd_test
 endif
 	@./memfd_test || echo "memfd_test: [FAIL]"
 
 build_fuse:
-ifeq ($(ARCH),X86)
+ifeq ($(ARCH),x86)
 	gcc $(CFLAGS) fuse_mnt.c `pkg-config fuse --cflags --libs` -o fuse_mnt
 	gcc $(CFLAGS) fuse_test.c -o fuse_test
 else
_

Patches currently in -mm which might be from tranmanphong@gmail.com are

linux-next.patch

