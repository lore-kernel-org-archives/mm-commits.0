From: akpm@linux-foundation.org
Subject: +
 tools-selftests-fixing-build-issue-with-make-kselftests-target.patch added
 to -mm tree
Date: Fri, 22 Aug 2014 14:44:16 -0700
Message-ID: <53f7b9b0.HWG0RepPypjn1FH8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:52118 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaHVVoR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Aug 2014 17:44:17 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so2261439oif.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2014 14:44:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tranmanphong@gmail.com, dh.herrmann@gmail.com, hughd@google.com, mmarek@suse.cz, sam@ravnborg.org, shuah.kh@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools: selftests: fix build issue with make kselftests target
has been added to the -mm tree.  Its filename is
     tools-selftests-fixing-build-issue-with-make-kselftests-target.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-selftests-fixing-build-issue-with-make-kselftests-target.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-selftests-fixing-build-issue-with-make-kselftests-target.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tools-selftests-fixing-build-issue-with-make-kselftests-target.patch
linux-next.patch

