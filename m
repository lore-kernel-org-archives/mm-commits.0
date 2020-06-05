From: akpm@linux-foundation.org
Subject: [merged]
 selftests-vm-pkeys-fix-multilib-builds-for-x86.patch removed from -mm tree
Date: Fri, 05 Jun 2020 13:21:12 -0700
Message-ID: <20200605202112.xEfsNpgAm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbgFEUVN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:21:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com, dave.hansen@intel.com, desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org


The patch titled
     Subject: selftests: vm: pkeys: fix multilib builds for x86
has been removed from the -mm tree.  Its filename was
     selftests-vm-pkeys-fix-multilib-builds-for-x86.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sandipan Das <sandipan@linux.ibm.com>
Subject: selftests: vm: pkeys: fix multilib builds for x86

This ensures that both 32-bit and 64-bit binaries are generated when this
is built on a x86_64 system.  Most of the changes have been borrowed from
tools/testing/selftests/x86/Makefile.

Link: http://lkml.kernel.org/r/0326a442214d7a1b970d38296e63df3b217f5912.1585646528.git.sandipan@linux.ibm.com
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Tested-by: Dave Hansen <dave.hansen@intel.com>
Cc: "Desnes A. Nunes do Rosario" <desnesn@linux.vnet.ibm.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Suchanek <msuchanek@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |   74 +++++++++++++++++++++++++-
 1 file changed, 73 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/Makefile~selftests-vm-pkeys-fix-multilib-builds-for-x86
+++ a/tools/testing/selftests/vm/Makefile
@@ -15,7 +15,6 @@ TEST_GEN_FILES += map_fixed_noreplace
 TEST_GEN_FILES += map_populate
 TEST_GEN_FILES += mlock-random-test
 TEST_GEN_FILES += mlock2-tests
-TEST_GEN_FILES += protection_keys
 TEST_GEN_FILES += mremap_dontunmap
 TEST_GEN_FILES += on-fault-limit
 TEST_GEN_FILES += thuge-gen
@@ -23,6 +22,30 @@ TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += userfaultfd
 TEST_GEN_FILES += khugepaged
 
+ifeq ($(ARCH),x86_64)
+CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_32bit_program.c -m32)
+CAN_BUILD_X86_64 := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_64bit_program.c)
+CAN_BUILD_WITH_NOPIE := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_program.c -no-pie)
+
+TARGETS := protection_keys
+BINARIES_32 := $(TARGETS:%=%_32)
+BINARIES_64 := $(TARGETS:%=%_64)
+
+ifeq ($(CAN_BUILD_WITH_NOPIE),1)
+CFLAGS += -no-pie
+endif
+
+ifeq ($(CAN_BUILD_I386),1)
+TEST_GEN_FILES += $(BINARIES_32)
+endif
+
+ifeq ($(CAN_BUILD_X86_64),1)
+TEST_GEN_FILES += $(BINARIES_64)
+endif
+else
+TEST_GEN_FILES += protection_keys
+endif
+
 ifneq (,$(filter $(MACHINE),arm64 ia64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sh64 sparc64 x86_64))
 TEST_GEN_FILES += va_128TBswitch
 TEST_GEN_FILES += virtual_address_range
@@ -38,6 +61,55 @@ include ../lib.mk
 
 $(OUTPUT)/hmm-tests: LDLIBS += -lhugetlbfs -lpthread
 
+ifeq ($(ARCH),x86_64)
+BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
+BINARIES_64 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_64))
+
+define gen-target-rule-32
+$(1) $(1)_32: $(OUTPUT)/$(1)_32
+.PHONY: $(1) $(1)_32
+endef
+
+define gen-target-rule-64
+$(1) $(1)_64: $(OUTPUT)/$(1)_64
+.PHONY: $(1) $(1)_64
+endef
+
+ifeq ($(CAN_BUILD_I386),1)
+$(BINARIES_32): CFLAGS += -m32
+$(BINARIES_32): LDLIBS += -lrt -ldl -lm
+$(BINARIES_32): %_32: %.c
+	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
+$(foreach t,$(TARGETS),$(eval $(call gen-target-rule-32,$(t))))
+endif
+
+ifeq ($(CAN_BUILD_X86_64),1)
+$(BINARIES_64): CFLAGS += -m64
+$(BINARIES_64): LDLIBS += -lrt -ldl
+$(BINARIES_64): %_64: %.c
+	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
+$(foreach t,$(TARGETS),$(eval $(call gen-target-rule-64,$(t))))
+endif
+
+# x86_64 users should be encouraged to install 32-bit libraries
+ifeq ($(CAN_BUILD_I386)$(CAN_BUILD_X86_64),01)
+all: warn_32bit_failure
+
+warn_32bit_failure:
+	@echo "Warning: you seem to have a broken 32-bit build" 2>&1;		\
+	echo  "environment. This will reduce test coverage of 64-bit" 2>&1;	\
+	echo  "kernels. If you are using a Debian-like distribution," 2>&1;	\
+	echo  "try:"; 2>&1;							\
+	echo  "";								\
+	echo  "  apt-get install gcc-multilib libc6-i386 libc6-dev-i386";	\
+	echo  "";								\
+	echo  "If you are using a Fedora-like distribution, try:";		\
+	echo  "";								\
+	echo  "  yum install glibc-devel.*i686";				\
+	exit 0;
+endif
+endif
+
 $(OUTPUT)/userfaultfd: LDLIBS += -lpthread
 
 $(OUTPUT)/mlock-random-test: LDLIBS += -lcap
_

Patches currently in -mm which might be from sandipan@linux.ibm.com are
