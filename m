Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E23D3C48BD1
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 22:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7F72613DE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 22:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhFKWY7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Jun 2021 18:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230181AbhFKWY7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Jun 2021 18:24:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B77361263;
        Fri, 11 Jun 2021 22:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623450164;
        bh=E4OSXxcWS8CYU3E1XaAmXUEbxTzTPg2cyH+PcKI5lpc=;
        h=Date:From:To:Subject:From;
        b=PcNurwpzLwDqdYYFnWUl1VBiDbrMo6vjLLx4x/uxZ490AqbZvZAcqHxw3vjy0p58u
         zHIkbAJUb1f8UxPqxrjF8TyeK1H3u/8E9OPud2dsojEyU9UGcnnYHLE09XKdeFK/pv
         BTdAKA5z78WZOQMfa1dAcodG2EioXQBD+CVBheCc=
Date:   Fri, 11 Jun 2021 15:22:43 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com,
        dave.hansen@linux.intel.com, desnesn@linux.vnet.ibm.com,
        fweimer@redhat.com, linuxram@us.ibm.com, mhocko@kernel.org,
        mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org,
        tglx@linutronix.de
Subject:  +
 =?US-ASCII?Q?selftests-vm-pkeys-fix-alloc=5Frandom=5Fpkey-to-make-it-re?=
 =?US-ASCII?Q?ally-really-random.patch?= added to -mm tree
Message-ID: <20210611222243.vNy8ylsLZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm/pkeys: fix alloc_random_pkey() to make it really, really random
has been added to the -mm tree.  Its filename is
     selftests-vm-pkeys-fix-alloc_random_pkey-to-make-it-really-really-random.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-pkeys-fix-alloc_random_pkey-to-make-it-really-really-random.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-pkeys-fix-alloc_random_pkey-to-make-it-really-really-random.patch

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
Subject: selftests/vm/pkeys: fix alloc_random_pkey() to make it really, really random

Patch series "selftests/vm/pkeys: Bug fixes and a new test".

There has been a lot of activity on the x86 front around the XSAVE
architecture which is used to context-switch processor state (among other
things).  In addition, AMD has recently joined the protection keys club by
adding processor support for PKU.

The AMD implementation helped uncover a kernel bug around the PKRU "init
state", which actually applied to Intel's implementation but was just
harder to hit.  This series adds a test which is expected to help find
this class of bug both on AMD and Intel.  All the work around pkeys on x86
also uncovered a few bugs in the selftest.


This patch (of 4):

The "random" pkey allocation code currently does the good old:

	srand((unsigned int)time(NULL));

*But*, it unfortunately does this on every random pkey allocation.

There may be thousands of these a second.  time() has a one second
resolution.  So, each time alloc_random_pkey() is called, the PRNG is
*RESET* to time().  This is nasty.  Normally, if you do:

	srand(<ANYTHING>);
	foo = rand();
	bar = rand();

You'll be quite guaranteed that 'foo' and 'bar' are different.  But, if
you do:

	srand(1);
	foo = rand();
	srand(1);
	bar = rand();

You are quite guaranteed that 'foo' and 'bar' are the *SAME*.  The recent
"fix" effectively forced the test case to use the same "random" pkey for
the whole test, unless the test run crossed a second boundary.

Only run srand() once at program startup.

This explains some very odd and persistent test failures I've been seeing.

Link: https://lkml.kernel.org/r/20210611164153.91B76FB8@viggo.jf.intel.com
Link: https://lkml.kernel.org/r/20210611164155.192D00FF@viggo.jf.intel.com
Fixes: 6e373263ce07 ("selftests/vm/pkeys: fix alloc_random_pkey() to make it really random")
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

 tools/testing/selftests/vm/protection_keys.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/protection_keys.c~selftests-vm-pkeys-fix-alloc_random_pkey-to-make-it-really-really-random
+++ a/tools/testing/selftests/vm/protection_keys.c
@@ -561,7 +561,6 @@ int alloc_random_pkey(void)
 	int nr_alloced = 0;
 	int random_index;
 	memset(alloced_pkeys, 0, sizeof(alloced_pkeys));
-	srand((unsigned int)time(NULL));
 
 	/* allocate every possible key and make a note of which ones we got */
 	max_nr_pkey_allocs = NR_PKEYS;
@@ -1552,6 +1551,8 @@ int main(void)
 	int nr_iterations = 22;
 	int pkeys_supported = is_pkeys_supported();
 
+	srand((unsigned int)time(NULL));
+
 	setup_handlers();
 
 	printf("has pkeys: %d\n", pkeys_supported);
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

selftests-vm-pkeys-fix-alloc_random_pkey-to-make-it-really-really-random.patch
selftests-vm-pkeys-handle-negative-sys_pkey_alloc-return-code.patch
selftests-vm-pkeys-refill-shadow-register-after-implicit-kernel-write.patch
selftests-vm-pkeys-exercise-x86-xsave-init-state.patch

