Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D44C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 708DE6147D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238574AbhGAB7b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238569AbhGAB7b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:59:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E79A6146D;
        Thu,  1 Jul 2021 01:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104620;
        bh=PGCoSFkJ8mh+vwAjxrskYiMiUmdXj0EnVYM979+NM3k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ONDVul+bNZiSStzeXDogeokxFldHKJUrU18QOT0a74H7plN3oZBACG8Sm7/oVriWs
         9Z7oiAE2L5nMIPntliLCCwmZ9cUHt57DHwkThW01ULJZcLA2kCZ/yE/btMArweYLVu
         rjjJKXIKaj0Hjkzz4NbGYSBXZgEKspuo4wBSPJSw=
Date:   Wed, 30 Jun 2021 18:56:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        bauerman@linux.ibm.com, dave.hansen@linux.intel.com,
        desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linux-mm@kvack.org,
        linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de,
        sandipan@linux.ibm.com, shuah@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject:  [patch 186/192] selftests/vm/pkeys: refill shadow
 register after implicit kernel write
Message-ID: <20210701015659.gankA7b3z%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
