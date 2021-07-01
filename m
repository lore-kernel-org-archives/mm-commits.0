Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BDC5C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F311E6146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238573AbhGAB71 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238569AbhGAB70 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:59:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6FD661469;
        Thu,  1 Jul 2021 01:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104617;
        bh=tBU1UmFCF+nvvGh9zqvUY0uSqlTwG6FcC0wPmXxNgJM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tGoiRx1rmhdgClcaMbADGP0IHyziBJrwcjJ2mia7LY1sCL4Yt/Twj7jdvdMGHyjgA
         kT0GsXnabU5Jcf2YKCdsPCw8yiOaSHQ83nJMp8PqoXyZPgx+JMn8aIe/ecv4Yp91zE
         7Yfe8eRjG0QI5sg29XRIHhfO3oSZalqmdpDVWQko=
Date:   Wed, 30 Jun 2021 18:56:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        bauerman@linux.ibm.com, dave.hansen@linux.intel.com,
        desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linux-mm@kvack.org,
        linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de,
        sandipan@linux.ibm.com, shuah@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject:  [patch 185/192] selftests/vm/pkeys: handle negative
 sys_pkey_alloc() return code
Message-ID: <20210701015656.FzKVF4eCF%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
