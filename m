Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FA2C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F354861480
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238575AbhGAB7e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:59:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238569AbhGAB7d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:59:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9083B61469;
        Thu,  1 Jul 2021 01:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104624;
        bh=Qc5T4Uzo85QvDvT3Mdj6zFleyJ2Y1yRjwceMxt/sHOc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tOl/wRxkquvr0O9VD7ICeGeh1lFwVNv7fdXUagBRn0nibjYtC1NEBNBWwtT8WrYu5
         novmZhAD/ZRff++TO4Icn1OSotuYq4+4fEOyKDpN817grn9NWf7J5E0kz2hse/3AOy
         mGe3zatjaz7Uhma8QcIHJrHlT1J1vz7XOAoKvFK8=
Date:   Wed, 30 Jun 2021 18:57:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        bauerman@linux.ibm.com, dave.hansen@linux.intel.com,
        desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linux-mm@kvack.org,
        linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de,
        sandipan@linux.ibm.com, shuah@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject:  [patch 187/192] selftests/vm/pkeys: exercise x86 XSAVE
 init state
Message-ID: <20210701015703.jlojc0hpo%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: selftests/vm/pkeys: exercise x86 XSAVE init state

On x86, there is a set of instructions used to save and restore register
state collectively known as the XSAVE architecture.  There are about a
dozen different features managed with XSAVE.  The protection keys
register, PKRU, is one of those features.

The hardware optimizes XSAVE by tracking when the state has not changed
from its initial (init) state.  In this case, it can avoid the cost of
writing state to memory (it would usually just be a bunch of 0's).

When the pkey register is 0x0 the hardware optionally choose to track the
register as being in the init state (optimize away the writes).  AMD CPUs
do this more aggressively compared to Intel.

On x86, PKRU is rarely in its (very permissive) init state.  Instead, the
value defaults to something very restrictive.  It is not surprising that
bugs have popped up in the rare cases when PKRU reaches its init state.

Add a protection key selftest which gets the protection keys register into
its init state in a way that should work on Intel and AMD.  Then, do a
bunch of pkey register reads to watch for inadvertent changes.

This adds "-mxsave" to CFLAGS for all the x86 vm selftests in order to
allow use of the XSAVE instruction __builtin functions.  This will make
the builtins available on all of the vm selftests, but is expected to be
harmless.

Link: https://lkml.kernel.org/r/20210611164202.1849B712@viggo.jf.intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: "Desnes A. Nunes do Rosario" <desnesn@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Suchanek <msuchanek@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile          |    4 
 tools/testing/selftests/vm/pkey-x86.h        |    1 
 tools/testing/selftests/vm/protection_keys.c |   73 +++++++++++++++++
 3 files changed, 76 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/Makefile~selftests-vm-pkeys-exercise-x86-xsave-init-state
+++ a/tools/testing/selftests/vm/Makefile
@@ -101,7 +101,7 @@ $(1) $(1)_64: $(OUTPUT)/$(1)_64
 endef
 
 ifeq ($(CAN_BUILD_I386),1)
-$(BINARIES_32): CFLAGS += -m32
+$(BINARIES_32): CFLAGS += -m32 -mxsave
 $(BINARIES_32): LDLIBS += -lrt -ldl -lm
 $(BINARIES_32): $(OUTPUT)/%_32: %.c
 	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
@@ -109,7 +109,7 @@ $(foreach t,$(TARGETS),$(eval $(call gen
 endif
 
 ifeq ($(CAN_BUILD_X86_64),1)
-$(BINARIES_64): CFLAGS += -m64
+$(BINARIES_64): CFLAGS += -m64 -mxsave
 $(BINARIES_64): LDLIBS += -lrt -ldl
 $(BINARIES_64): $(OUTPUT)/%_64: %.c
 	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
--- a/tools/testing/selftests/vm/pkey-x86.h~selftests-vm-pkeys-exercise-x86-xsave-init-state
+++ a/tools/testing/selftests/vm/pkey-x86.h
@@ -126,6 +126,7 @@ static inline u32 pkey_bit_position(int
 
 #define XSTATE_PKEY_BIT	(9)
 #define XSTATE_PKEY	0x200
+#define XSTATE_BV_OFFSET	512
 
 int pkey_reg_xstate_offset(void)
 {
--- a/tools/testing/selftests/vm/protection_keys.c~selftests-vm-pkeys-exercise-x86-xsave-init-state
+++ a/tools/testing/selftests/vm/protection_keys.c
@@ -1277,6 +1277,78 @@ void test_pkey_alloc_exhaust(int *ptr, u
 	}
 }
 
+void arch_force_pkey_reg_init(void)
+{
+#if defined(__i386__) || defined(__x86_64__) /* arch */
+	u64 *buf;
+
+	/*
+	 * All keys should be allocated and set to allow reads and
+	 * writes, so the register should be all 0.  If not, just
+	 * skip the test.
+	 */
+	if (read_pkey_reg())
+		return;
+
+	/*
+	 * Just allocate an absurd about of memory rather than
+	 * doing the XSAVE size enumeration dance.
+	 */
+	buf = mmap(NULL, 1*MB, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
+
+	/* These __builtins require compiling with -mxsave */
+
+	/* XSAVE to build a valid buffer: */
+	__builtin_ia32_xsave(buf, XSTATE_PKEY);
+	/* Clear XSTATE_BV[PKRU]: */
+	buf[XSTATE_BV_OFFSET/sizeof(u64)] &= ~XSTATE_PKEY;
+	/* XRSTOR will likely get PKRU back to the init state: */
+	__builtin_ia32_xrstor(buf, XSTATE_PKEY);
+
+	munmap(buf, 1*MB);
+#endif
+}
+
+
+/*
+ * This is mostly useless on ppc for now.  But it will not
+ * hurt anything and should give some better coverage as
+ * a long-running test that continually checks the pkey
+ * register.
+ */
+void test_pkey_init_state(int *ptr, u16 pkey)
+{
+	int err;
+	int allocated_pkeys[NR_PKEYS] = {0};
+	int nr_allocated_pkeys = 0;
+	int i;
+
+	for (i = 0; i < NR_PKEYS; i++) {
+		int new_pkey = alloc_pkey();
+
+		if (new_pkey < 0)
+			continue;
+		allocated_pkeys[nr_allocated_pkeys++] = new_pkey;
+	}
+
+	dprintf3("%s()::%d\n", __func__, __LINE__);
+
+	arch_force_pkey_reg_init();
+
+	/*
+	 * Loop for a bit, hoping to get exercise the kernel
+	 * context switch code.
+	 */
+	for (i = 0; i < 1000000; i++)
+		read_pkey_reg();
+
+	for (i = 0; i < nr_allocated_pkeys; i++) {
+		err = sys_pkey_free(allocated_pkeys[i]);
+		pkey_assert(!err);
+		read_pkey_reg(); /* for shadow checking */
+	}
+}
+
 /*
  * pkey 0 is special.  It is allocated by default, so you do not
  * have to call pkey_alloc() to use it first.  Make sure that it
@@ -1508,6 +1580,7 @@ void (*pkey_tests[])(int *ptr, u16 pkey)
 	test_implicit_mprotect_exec_only_memory,
 	test_mprotect_with_pkey_0,
 	test_ptrace_of_child,
+	test_pkey_init_state,
 	test_pkey_syscalls_on_non_allocated_pkey,
 	test_pkey_syscalls_bad_args,
 	test_pkey_alloc_exhaust,
_
