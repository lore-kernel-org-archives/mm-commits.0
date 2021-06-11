Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF30C48BD1
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 22:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D580613DE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 22:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhFKWYv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Jun 2021 18:24:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230181AbhFKWYu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Jun 2021 18:24:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D2AB613D9;
        Fri, 11 Jun 2021 22:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623450170;
        bh=+RjJ+xGdQ/yF19VjvglBE8h/JGJlHixl3obkrlo/Xvg=;
        h=Date:From:To:Subject:From;
        b=LNYFa51iNCkgr4kxGleVVaa1WrqMnw8l/Otp7MFo0Qyqqjt3U1HwZlpw9UBlJtImk
         V7lIMtBvuZAY2FBz8cMKcev2/j6y761g9CfAy++4u49vyzWuEKONEkDT+Kj3FTfVng
         EZa26hIZMiuUZL6X9jYoMPqtdmVEeEhwOke06a3Q=
Date:   Fri, 11 Jun 2021 15:22:49 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com,
        dave.hansen@linux.intel.com, desnesn@linux.vnet.ibm.com,
        fweimer@redhat.com, linuxram@us.ibm.com, mhocko@kernel.org,
        mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org,
        tglx@linutronix.de
Subject:  +
 selftests-vm-pkeys-refill-shadow-register-after-implicit-kernel-write.patch
 added to -mm tree
Message-ID: <20210611222249.6HCEkeb9E%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm/pkeys: refill shadow register after implicit kernel write
has been added to the -mm tree.  Its filename is
     selftests-vm-pkeys-refill-shadow-register-after-implicit-kernel-write.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-pkeys-refill-shadow-register-after-implicit-kernel-write.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-pkeys-refill-shadow-register-after-implicit-kernel-write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: selftests/vm/pkeys: refill shadow register after implicit kernel write

The pkey test code keeps a "shadow" of the pkey register around.  This
ensures that any bugs which might write to the register can be caught more
quickly.

Generally, userspace has a good idea when the kernel is going to write to
the register.  For instance, alloc_pkey() is passed a permission mask. 
The caller of alloc_pkey() can update the shadow based on the return value
and the mask.

But, the kernel can also modify the pkey register in a more sneaky way. 
For mprotect(PROT_EXEC) mappings, the kernel will allocate a pkey and
write the pkey register to create an execute-only mapping.  The kernel
never tells userspace what key it uses for this.

This can cause the test to fail with messages like:

	protection_keys_64.2: pkey-helpers.h:132: _read_pkey_reg: Assertion `pkey_reg == shadow_pkey_reg' failed.

because the shadow was not updated with the new kernel-set value.

Forcibly update the shadow value immediately after an mprotect().

Link: https://lkml.kernel.org/r/20210611164200.EF76AB73@viggo.jf.intel.com
Fixes: 6af17cf89e99 ("x86/pkeys/selftests: Add PROT_EXEC test")
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: "Desnes A. Nunes do Rosario" <desnesn@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Suchanek <msuchanek@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/protection_keys.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/vm/protection_keys.c~selftests-vm-pkeys-refill-shadow-register-after-implicit-kernel-write
+++ a/tools/testing/selftests/vm/protection_keys.c
@@ -1448,6 +1448,13 @@ void test_implicit_mprotect_exec_only_me
 	ret = mprotect(p1, PAGE_SIZE, PROT_EXEC);
 	pkey_assert(!ret);
 
+	/*
+	 * Reset the shadow, assuming that the above mprotect()
+	 * correctly changed PKRU, but to an unknown value since
+	 * the actual alllocated pkey is unknown.
+	 */
+	shadow_pkey_reg = __read_pkey_reg();
+
 	dprintf2("pkey_reg: %016llx\n", read_pkey_reg());
 
 	/* Make sure this is an *instruction* fault */
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

selftests-vm-pkeys-fix-alloc_random_pkey-to-make-it-really-really-random.patch
selftests-vm-pkeys-handle-negative-sys_pkey_alloc-return-code.patch
selftests-vm-pkeys-refill-shadow-register-after-implicit-kernel-write.patch
selftests-vm-pkeys-exercise-x86-xsave-init-state.patch

