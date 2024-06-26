Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B231CA85
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 02:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719368397; cv=none; b=RBtQAGethKgZIgTBB5IAXjPlZgZxOkwJAlxZVkzw45MDYP70ZPpqKz3euP45hMPQ3YieKPpVCCpNwLdKrTD5ymQj2WpkEX2YNxOu2GRwSmxO4vfxZvovzm1NDhnde6rKftyMEpOA08Hbx1LR0nPJJPqn+heEaI5oZ5zCr/4pMpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719368397; c=relaxed/simple;
	bh=TRVvnJpMgWKF3W781Mo9F4naB/9yZZ4q/8j5UPcNAnA=;
	h=Date:To:From:Subject:Message-Id; b=hSaN9rvmONHC6gz5EtvcHL6ys/SDyacoQmAAe8QwyfDOMiSWhxg57yZWNXOfTNAC34kBKE4bT36jpS7J1H9/DMACTgAgA4O7r0id5K92ZD+neQx+ED+hv6LAMtc3hVibTsH/pHZXy3KeH+k6Oc3UHpNxAASI7v5zwhqp1bg/em0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l/vaK+Ve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l/vaK+Ve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491A9C32781;
	Wed, 26 Jun 2024 02:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719368396;
	bh=TRVvnJpMgWKF3W781Mo9F4naB/9yZZ4q/8j5UPcNAnA=;
	h=Date:To:From:Subject:From;
	b=l/vaK+VegZnfjIkmWYmaNyF8HRQlgLwk/LwoooqwwZw4V/lr40FjLBoLt/QatQVVb
	 tPa20or5TohnhnrdHyRSihInsJ/cxodx4yi9PaAfJkBnLb8OyaNz3NP0tbDpIT1jl5
	 hKcyFlu0jgetORr0O8gH1jPgmOcBSybIFcpe1xFU=
Date: Tue, 25 Jun 2024 19:19:54 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,tglx@linutronix.de,shuah@kernel.org,seanjc@google.com,reinette.chatre@intel.com,peterz@infradead.org,pbonzini@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,pabeni@redhat.com,mingo@redhat.com,kuba@kernel.org,kevin.tian@intel.com,kees@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,jarkko@kernel.org,fenghua.yu@intel.com,edumazet@google.com,ebiederm@xmission.com,dvhart@infradead.org,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,aou@eecs.berkeley.edu,andrealmeid@igalia.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-centralize-d_gnu_source=-to-cflags-in-libmk.patch added to mm-nonmm-unstable branch
Message-Id: <20240626021956.491A9C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: centralize -D_GNU_SOURCE= to CFLAGS in lib.mk
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-centralize-d_gnu_source=-to-cflags-in-libmk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-centralize-d_gnu_source=-to-cflags-in-libmk.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
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

selftests-centralize-d_gnu_source=-to-cflags-in-libmk.patch

