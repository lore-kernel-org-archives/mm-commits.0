Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F6C17C3;
	Wed, 13 Dec 2023 01:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="msc/n1ee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8E0C433C7;
	Wed, 13 Dec 2023 01:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702430455;
	bh=sQlXaihJfdrZPZXgSsiyAt6AkjqApmiKSb8Av/AWQiw=;
	h=Date:To:From:Subject:From;
	b=msc/n1eeZijXRh/m3oFjXqn3zn9jVvyJ4hbFu/hS2lsvCLYndYZXFL9MZpBMtOrLQ
	 NsVYumseYTUJfTo282Yw1msz+4oaFfbvMbaMnZP6xemcJ3MJxLEn4FDuM6AyOgjJzL
	 63couPrlm4asjQXTEd7h/hdn8ZAyBxCr11hzFFxU=
Date: Tue, 12 Dec 2023 17:20:54 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,stable@vger.kernel.org,shuah@kernel.org,peterz@infradead.org,peterx@redhat.com,nathan@kernel.org,mpdesouza@suse.com,david@redhat.com,corbet@lwn.net,anders.roxell@linaro.org,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-selftests-error-out-if-kernel-header-files-are-not-yet-built.patch removed from -mm tree
Message-Id: <20231213012055.4C8E0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "selftests: error out if kernel header files are not yet built"
has been removed from the -mm tree.  Its filename was
     revert-selftests-error-out-if-kernel-header-files-are-not-yet-built.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: Revert "selftests: error out if kernel header files are not yet built"
Date: Fri, 8 Dec 2023 18:01:44 -0800

This reverts commit 9fc96c7c19df ("selftests: error out if kernel header
files are not yet built").

It turns out that requiring the kernel headers to be built as a
prerequisite to building selftests, does not work in many cases. For
example, Peter Zijlstra writes:

"My biggest beef with the whole thing is that I simply do not want to use
'make headers', it doesn't work for me.

I have a ton of output directories and I don't care to build tools into
the output dirs, in fact some of them flat out refuse to work that way
(bpf comes to mind)." [1]

Therefore, stop erroring out on the selftests build. Additional patches
will be required in order to change over to not requiring the kernel
headers.

[1] https://lore.kernel.org/20231208221007.GO28727@noisy.programming.kicks-ass.net

Link: https://lkml.kernel.org/r/20231209020144.244759-1-jhubbard@nvidia.com
Fixes: 9fc96c7c19df ("selftests: error out if kernel header files are not yet built")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile |   21 ---------------
 tools/testing/selftests/lib.mk   |   40 ++---------------------------
 2 files changed, 4 insertions(+), 57 deletions(-)

--- a/tools/testing/selftests/lib.mk~revert-selftests-error-out-if-kernel-header-files-are-not-yet-built
+++ a/tools/testing/selftests/lib.mk
@@ -44,26 +44,10 @@ endif
 selfdir = $(realpath $(dir $(filter %/lib.mk,$(MAKEFILE_LIST))))
 top_srcdir = $(selfdir)/../../..
 
-ifeq ("$(origin O)", "command line")
-  KBUILD_OUTPUT := $(O)
+ifeq ($(KHDR_INCLUDES),)
+KHDR_INCLUDES := -isystem $(top_srcdir)/usr/include
 endif
 
-ifneq ($(KBUILD_OUTPUT),)
-  # Make's built-in functions such as $(abspath ...), $(realpath ...) cannot
-  # expand a shell special character '~'. We use a somewhat tedious way here.
-  abs_objtree := $(shell cd $(top_srcdir) && mkdir -p $(KBUILD_OUTPUT) && cd $(KBUILD_OUTPUT) && pwd)
-  $(if $(abs_objtree),, \
-    $(error failed to create output directory "$(KBUILD_OUTPUT)"))
-  # $(realpath ...) resolves symlinks
-  abs_objtree := $(realpath $(abs_objtree))
-  KHDR_DIR := ${abs_objtree}/usr/include
-else
-  abs_srctree := $(shell cd $(top_srcdir) && pwd)
-  KHDR_DIR := ${abs_srctree}/usr/include
-endif
-
-KHDR_INCLUDES := -isystem $(KHDR_DIR)
-
 # The following are built by lib.mk common compile rules.
 # TEST_CUSTOM_PROGS should be used by tests that require
 # custom build rule and prevent common build rule use.
@@ -74,25 +58,7 @@ TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)
 TEST_GEN_PROGS_EXTENDED := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS_EXTENDED))
 TEST_GEN_FILES := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_FILES))
 
-all: kernel_header_files $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) \
-     $(TEST_GEN_FILES)
-
-kernel_header_files:
-	@ls $(KHDR_DIR)/linux/*.h >/dev/null 2>/dev/null;                      \
-	if [ $$? -ne 0 ]; then                                                 \
-            RED='\033[1;31m';                                                  \
-            NOCOLOR='\033[0m';                                                 \
-            echo;                                                              \
-            echo -e "$${RED}error$${NOCOLOR}: missing kernel header files.";   \
-            echo "Please run this and try again:";                             \
-            echo;                                                              \
-            echo "    cd $(top_srcdir)";                                       \
-            echo "    make headers";                                           \
-            echo;                                                              \
-	    exit 1; \
-	fi
-
-.PHONY: kernel_header_files
+all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES)
 
 define RUN_TESTS
 	BASE_DIR="$(selfdir)";			\
--- a/tools/testing/selftests/Makefile~revert-selftests-error-out-if-kernel-header-files-are-not-yet-built
+++ a/tools/testing/selftests/Makefile
@@ -155,12 +155,10 @@ ifneq ($(KBUILD_OUTPUT),)
   abs_objtree := $(realpath $(abs_objtree))
   BUILD := $(abs_objtree)/kselftest
   KHDR_INCLUDES := -isystem ${abs_objtree}/usr/include
-  KHDR_DIR := ${abs_objtree}/usr/include
 else
   BUILD := $(CURDIR)
   abs_srctree := $(shell cd $(top_srcdir) && pwd)
   KHDR_INCLUDES := -isystem ${abs_srctree}/usr/include
-  KHDR_DIR := ${abs_srctree}/usr/include
   DEFAULT_INSTALL_HDR_PATH := 1
 endif
 
@@ -174,7 +172,7 @@ export KHDR_INCLUDES
 # all isn't the first target in the file.
 .DEFAULT_GOAL := all
 
-all: kernel_header_files
+all:
 	@ret=1;							\
 	for TARGET in $(TARGETS); do				\
 		BUILD_TARGET=$$BUILD/$$TARGET;			\
@@ -185,23 +183,6 @@ all: kernel_header_files
 		ret=$$((ret * $$?));				\
 	done; exit $$ret;
 
-kernel_header_files:
-	@ls $(KHDR_DIR)/linux/*.h >/dev/null 2>/dev/null;                          \
-	if [ $$? -ne 0 ]; then                                                     \
-            RED='\033[1;31m';                                                  \
-            NOCOLOR='\033[0m';                                                 \
-            echo;                                                              \
-            echo -e "$${RED}error$${NOCOLOR}: missing kernel header files.";   \
-            echo "Please run this and try again:";                             \
-            echo;                                                              \
-            echo "    cd $(top_srcdir)";                                       \
-            echo "    make headers";                                           \
-            echo;                                                              \
-	    exit 1;                                                                \
-	fi
-
-.PHONY: kernel_header_files
-
 run_tests: all
 	@for TARGET in $(TARGETS); do \
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


