Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE1D13C80F
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292044; cv=none; b=QxfZmcmJdSAA5S8I/pK9I5KiwMqAOTCHIIjASFFFH3kQEX8gpU3U4aE7JNqgIFP79kHRpOtI6jtZm8joHnoGiZ9Vrk5u/cjRWzph4cWmByAn+XkpE7W0s2VGH4+kSGXSkcDIjGNvUhJDf5CvXMKH1zPvzQnZ4f2kP09TFKS++Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292044; c=relaxed/simple;
	bh=gKEjWW8EU5zoqrp77NF89SJThAc4dFJitVMx+kbzoi0=;
	h=Date:To:From:Subject:Message-Id; b=QsMr7NPS4UWKo0sPSsPPtD4cSI5o8k5c8nDSOXUeXlo75GE9p8UbN5jNJiPLQRoTuarIag8CK1KBlE940fS5LixHUpNZK3V+7cw6lSdpxaFouxyuhXK2AeZ7OntmDtuFSDicV2h5+d7RmS6fEJnlsIwS23Y5JLjkb197kNKoXgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YI/1AmaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YI/1AmaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6120C2BD10;
	Sat,  6 Jul 2024 18:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292043;
	bh=gKEjWW8EU5zoqrp77NF89SJThAc4dFJitVMx+kbzoi0=;
	h=Date:To:From:Subject:From;
	b=YI/1AmaABQ82RSBTq/1oYCpaqzdT5pmGCK/JRRpew9Tpkb19OGEySBUdII/QeerBA
	 /6kZJkW3urBGi1bO7WSBJpzc19OFbUrBJxI5weH6pm+7lu7cRmgOEjtqQauyXZ3Jwe
	 Vby5DjPkoPJ/o6atYGYTAYTDiiJvAmcUGjXDRiEc=
Date: Sat, 06 Jul 2024 11:54:03 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,tglx@linutronix.de,skhan@linuxfoundation.org,seanjc@google.com,reinette.chatre@intel.com,peterz@infradead.org,pbonzini@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,pabeni@redhat.com,mingo@redhat.com,kuba@kernel.org,kevin.tian@intel.com,kees@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,jarkko@kernel.org,fenghua.yu@intel.com,edumazet@google.com,ebiederm@xmission.com,dvhart@infradead.org,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,aou@eecs.berkeley.edu,andrealmeid@igalia.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-centralize-d_gnu_source=-to-cflags-in-libmk.patch removed from -mm tree
Message-Id: <20240706185403.B6120C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: centralize -D_GNU_SOURCE= to CFLAGS in lib.mk
has been removed from the -mm tree.  Its filename was
     selftests-centralize-d_gnu_source=-to-cflags-in-libmk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Edward Liaw <edliaw@google.com>
Subject: selftests: centralize -D_GNU_SOURCE= to CFLAGS in lib.mk
Date: Tue, 25 Jun 2024 22:34:45 +0000

Centralize the _GNU_SOURCE definition to CFLAGS in lib.mk.  Remove
redundant defines from Makefiles that import lib.mk.  Convert any usage of
"#define _GNU_SOURCE 1" to "#define _GNU_SOURCE".

This uses the form "-D_GNU_SOURCE=", which is equivalent to
"#define _GNU_SOURCE".

Otherwise using "-D_GNU_SOURCE" is equivalent to "-D_GNU_SOURCE=1" and
"#define _GNU_SOURCE 1", which is less commonly seen in source code and
would require many changes in selftests to avoid redefinition warnings.

Link: https://lkml.kernel.org/r/20240625223454.1586259-2-edliaw@google.com
Signed-off-by: Edward Liaw <edliaw@google.com>
Suggested-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: André Almeida <andrealmeid@igalia.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kees Cook <kees@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/exec/Makefile             |    1 -
 tools/testing/selftests/futex/functional/Makefile |    2 +-
 tools/testing/selftests/intel_pstate/Makefile     |    2 +-
 tools/testing/selftests/iommu/Makefile            |    2 --
 tools/testing/selftests/kvm/Makefile              |    2 +-
 tools/testing/selftests/lib.mk                    |    3 +++
 tools/testing/selftests/mm/thuge-gen.c            |    2 +-
 tools/testing/selftests/net/Makefile              |    2 +-
 tools/testing/selftests/net/tcp_ao/Makefile       |    2 +-
 tools/testing/selftests/proc/Makefile             |    1 -
 tools/testing/selftests/resctrl/Makefile          |    2 +-
 tools/testing/selftests/ring-buffer/Makefile      |    1 -
 tools/testing/selftests/riscv/mm/Makefile         |    2 +-
 tools/testing/selftests/sgx/Makefile              |    2 +-
 tools/testing/selftests/tmpfs/Makefile            |    1 -
 15 files changed, 12 insertions(+), 15 deletions(-)

--- a/tools/testing/selftests/exec/Makefile~selftests-centralize-d_gnu_source=-to-cflags-in-libmk
+++ a/tools/testing/selftests/exec/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 CFLAGS = -Wall
 CFLAGS += -Wno-nonnull
-CFLAGS += -D_GNU_SOURCE
 
 TEST_PROGS := binfmt_script.py
 TEST_GEN_PROGS := execveat load_address_4096 load_address_2097152 load_address_16777216 non-regular
--- a/tools/testing/selftests/futex/functional/Makefile~selftests-centralize-d_gnu_source=-to-cflags-in-libmk
+++ a/tools/testing/selftests/futex/functional/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 INCLUDES := -I../include -I../../ $(KHDR_INCLUDES)
-CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE= -pthread $(INCLUDES) $(KHDR_INCLUDES)
+CFLAGS := $(CFLAGS) -g -O2 -Wall -pthread $(INCLUDES) $(KHDR_INCLUDES)
 LDLIBS := -lpthread -lrt
 
 LOCAL_HDRS := \
--- a/tools/testing/selftests/intel_pstate/Makefile~selftests-centralize-d_gnu_source=-to-cflags-in-libmk
+++ a/tools/testing/selftests/intel_pstate/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS := $(CFLAGS) -Wall -D_GNU_SOURCE
+CFLAGS := $(CFLAGS) -Wall
 LDLIBS += -lm
 
 ARCH ?= $(shell uname -m 2>/dev/null || echo not)
--- a/tools/testing/selftests/iommu/Makefile~selftests-centralize-d_gnu_source=-to-cflags-in-libmk
+++ a/tools/testing/selftests/iommu/Makefile
@@ -2,8 +2,6 @@
 CFLAGS += -Wall -O2 -Wno-unused-function
 CFLAGS += $(KHDR_INCLUDES)
 
-CFLAGS += -D_GNU_SOURCE
-
 TEST_GEN_PROGS :=
 TEST_GEN_PROGS += iommufd
 TEST_GEN_PROGS += iommufd_fail_nth
--- a/tools/testing/selftests/kvm/Makefile~selftests-centralize-d_gnu_source=-to-cflags-in-libmk
+++ a/tools/testing/selftests/kvm/Makefile
@@ -231,7 +231,7 @@ LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/
 endif
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCONFIG_64BIT \
-	-D_GNU_SOURCE -fno-builtin-memcmp -fno-builtin-memcpy \
+	-fno-builtin-memcmp -fno-builtin-memcpy \
 	-fno-builtin-memset -fno-builtin-strnlen \
 	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
--- a/tools/testing/selftests/lib.mk~selftests-centralize-d_gnu_source=-to-cflags-in-libmk
+++ a/tools/testing/selftests/lib.mk
@@ -188,6 +188,9 @@ endef
 clean: $(if $(TEST_GEN_MODS_DIR),clean_mods_dir)
 	$(CLEAN)
 
+# Build with _GNU_SOURCE by default
+CFLAGS += -D_GNU_SOURCE=
+
 # Enables to extend CFLAGS and LDFLAGS from command line, e.g.
 # make USERCFLAGS=-Werror USERLDFLAGS=-static
 CFLAGS += $(USERCFLAGS)
--- a/tools/testing/selftests/mm/thuge-gen.c~selftests-centralize-d_gnu_source=-to-cflags-in-libmk
+++ a/tools/testing/selftests/mm/thuge-gen.c
@@ -13,7 +13,7 @@
    sudo ipcs | awk '$1 == "0x00000000" {print $2}' | xargs -n1 sudo ipcrm -m
    (warning this will remove all if someone else uses them) */
 
-#define _GNU_SOURCE 1
+#define _GNU_SOURCE
 #include <sys/mman.h>
 #include <linux/mman.h>
 #include <stdlib.h>
--- a/tools/testing/selftests/net/Makefile~selftests-centralize-d_gnu_source=-to-cflags-in-libmk
+++ a/tools/testing/selftests/net/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for net selftests
 
-CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g
+CFLAGS +=  -Wall -Wl,--no-as-needed -O2 -g
 CFLAGS += -I../../../../usr/include/ $(KHDR_INCLUDES)
 # Additional include paths needed by kselftest.h
 CFLAGS += -I../
--- a/tools/testing/selftests/net/tcp_ao/Makefile~selftests-centralize-d_gnu_source=-to-cflags-in-libmk
+++ a/tools/testing/selftests/net/tcp_ao/Makefile
@@ -26,7 +26,7 @@ LIB	:= $(LIBDIR)/libaotst.a
 LDLIBS	+= $(LIB) -pthread
 LIBDEPS	:= lib/aolib.h Makefile
 
-CFLAGS	:= -Wall -O2 -g -D_GNU_SOURCE -fno-strict-aliasing
+CFLAGS	+= -Wall -O2 -g -fno-strict-aliasing
 CFLAGS	+= $(KHDR_INCLUDES)
 CFLAGS	+= -iquote ./lib/ -I ../../../../include/
 
--- a/tools/testing/selftests/proc/Makefile~selftests-centralize-d_gnu_source=-to-cflags-in-libmk
+++ a/tools/testing/selftests/proc/Makefile
@@ -1,6 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 CFLAGS += -Wall -O2 -Wno-unused-function
-CFLAGS += -D_GNU_SOURCE
 LDFLAGS += -pthread
 
 TEST_GEN_PROGS :=
--- a/tools/testing/selftests/resctrl/Makefile~selftests-centralize-d_gnu_source=-to-cflags-in-libmk
+++ a/tools/testing/selftests/resctrl/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS = -g -Wall -O2 -D_FORTIFY_SOURCE=2 -D_GNU_SOURCE
+CFLAGS = -g -Wall -O2 -D_FORTIFY_SOURCE=2
 CFLAGS += $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := resctrl_tests
--- a/tools/testing/selftests/ring-buffer/Makefile~selftests-centralize-d_gnu_source=-to-cflags-in-libmk
+++ a/tools/testing/selftests/ring-buffer/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 CFLAGS += -Wl,-no-as-needed -Wall
 CFLAGS += $(KHDR_INCLUDES)
-CFLAGS += -D_GNU_SOURCE
 
 TEST_GEN_PROGS = map_test
 
--- a/tools/testing/selftests/riscv/mm/Makefile~selftests-centralize-d_gnu_source=-to-cflags-in-libmk
+++ a/tools/testing/selftests/riscv/mm/Makefile
@@ -3,7 +3,7 @@
 # Originally tools/testing/arm64/abi/Makefile
 
 # Additional include paths needed by kselftest.h and local headers
-CFLAGS += -D_GNU_SOURCE -std=gnu99 -I.
+CFLAGS += -std=gnu99 -I.
 
 TEST_GEN_FILES := mmap_default mmap_bottomup
 
--- a/tools/testing/selftests/sgx/Makefile~selftests-centralize-d_gnu_source=-to-cflags-in-libmk
+++ a/tools/testing/selftests/sgx/Makefile
@@ -12,7 +12,7 @@ OBJCOPY := $(CROSS_COMPILE)objcopy
 endif
 
 INCLUDES := -I$(top_srcdir)/tools/include
-HOST_CFLAGS := -Wall -Werror -g $(INCLUDES) -fPIC
+HOST_CFLAGS := -Wall -Werror -g $(INCLUDES) -fPIC $(CFLAGS)
 HOST_LDFLAGS := -z noexecstack -lcrypto
 ENCL_CFLAGS += -Wall -Werror -static-pie -nostdlib -ffreestanding -fPIE \
 	       -fno-stack-protector -mrdrnd $(INCLUDES)
--- a/tools/testing/selftests/tmpfs/Makefile~selftests-centralize-d_gnu_source=-to-cflags-in-libmk
+++ a/tools/testing/selftests/tmpfs/Makefile
@@ -1,6 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 CFLAGS += -Wall -O2
-CFLAGS += -D_GNU_SOURCE
 
 TEST_GEN_PROGS :=
 TEST_GEN_PROGS += bug-link-o-tmpfile
_

Patches currently in -mm which might be from edliaw@google.com are


