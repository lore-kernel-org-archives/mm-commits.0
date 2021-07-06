Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7449C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFD7B61CAA
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhGFT0D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:26:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhGFT0C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:26:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76D7761C9E;
        Tue,  6 Jul 2021 19:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599403;
        bh=PqXCit0sFI64tRF/siY4jAYAOEksnV/MnAiRvm0XUVs=;
        h=Date:From:To:Subject:From;
        b=dWOjWYd8Ry76q7J/M4S72VkBeh2hQ0vgtIt8LhEGxxdl5LRxBx5jW9rjXcg3xvD2S
         tpfJON0BOAsigVOKv37rjV8x2wpTiVQx+NyAdd8dlsEhMEz1G4tM1gT2nwFlXz3CAC
         kYP+XQFtyduo6vpD9gRNGh7dvdUCHoA/p5X7M/io=
Date:   Tue, 06 Jul 2021 12:23:23 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com,
        dave.hansen@linux.intel.com, desnesn@linux.vnet.ibm.com,
        fweimer@redhat.com, linuxram@us.ibm.com, mhocko@kernel.org,
        mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org,
        tglx@linutronix.de
Subject:  [merged]
 selftests-vm-pkeys-handle-negative-sys_pkey_alloc-return-code.patch removed
 from -mm tree
Message-ID: <20210706192323.tUobW_3b6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm/pkeys: handle negative sys_pkey_alloc() return code
has been removed from the -mm tree.  Its filename was
     selftests-vm-pkeys-handle-negative-sys_pkey_alloc-return-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: selftests/vm/pkeys: handle negative sys_pkey_alloc() return code

The alloc_pkey() sefltest function wraps the sys_pkey_alloc() system call.
On success, it updates its "shadow" register value because
sys_pkey_alloc() updates the real register.

But, the success check is wrong.  pkey_alloc() considers any non-zero
return code to indicate success where the pkey register will be modified. 
This fails to take negative return codes into account.

Consider only a positive return value as a successful call.

Link: https://lkml.kernel.org/r/20210611164157.87AB4246@viggo.jf.intel.com
Fixes: 5f23f6d082a9 ("x86/pkeys: Add self-tests")
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
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

 tools/testing/selftests/vm/protection_keys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/protection_keys.c~selftests-vm-pkeys-handle-negative-sys_pkey_alloc-return-code
+++ a/tools/testing/selftests/vm/protection_keys.c
@@ -510,7 +510,7 @@ int alloc_pkey(void)
 			" shadow: 0x%016llx\n",
 			__func__, __LINE__, ret, __read_pkey_reg(),
 			shadow_pkey_reg);
-	if (ret) {
+	if (ret > 0) {
 		/* clear both the bits: */
 		shadow_pkey_reg = set_pkey_bits(shadow_pkey_reg, ret,
 						~PKEY_MASK);
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are


