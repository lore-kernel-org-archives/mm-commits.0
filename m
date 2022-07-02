Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A13C43334
	for <mm-commits@archiver.kernel.org>; Sat,  2 Jul 2022 20:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiGBUjy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Jul 2022 16:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGBUjx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Jul 2022 16:39:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A1C6567
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 13:39:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CB57B80189
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 20:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E7BC34114;
        Sat,  2 Jul 2022 20:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656794390;
        bh=BtOf8F71OLP4gkUn+qJaMC8b2iEO/r01JVuoq692Dyc=;
        h=Date:To:From:Subject:From;
        b=XPR6ih1CFmTezx4x1Zb4YmSFk0nvsBRGqu+AtLCsVvyTvrQ/U5Mzi4jDtshKm4HtE
         RShg5evk4bXoLofGUAkrEleqAkm5te/91Z1HHstXFDVj6F56ETXUfqpeBf0is790sX
         i1g8szOPTs4VwuqFf3KI/m1Wi6varRRpNHpRzgAI=
Date:   Sat, 02 Jul 2022 13:39:49 -0700
To:     mm-commits@vger.kernel.org, yury.norov@gmail.com,
        vschneid@redhat.com, tglx@linutronix.de, peterz@infradead.org,
        mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org,
        elver@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        andriy.shevchenko@linux.intel.com, sander@svanheule.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cpumask-update-cpumask_next_wrap-signature.patch added to mm-nonmm-unstable branch
Message-Id: <20220702203950.54E7BC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask: update cpumask_next_wrap() signature
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     cpumask-update-cpumask_next_wrap-signature.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cpumask-update-cpumask_next_wrap-signature.patch

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
From: Sander Vanheule <sander@svanheule.net>
Subject: cpumask: update cpumask_next_wrap() signature
Date: Sat, 2 Jul 2022 18:08:28 +0200

The extern specifier is not needed for this declaration, so drop it.  The
function also depends only on the input parameters, and has no side
effects, so it can be marked __pure like other functions in cpumask.h.

Link: https://lkml.kernel.org/r/72ab755695b74bb5fbaa756ae4c0edd708d172f1.1656777646.git.sander@svanheule.net
Signed-off-by: Sander Vanheule <sander@svanheule.net>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/cpumask.h~cpumask-update-cpumask_next_wrap-signature
+++ a/include/linux/cpumask.h
@@ -229,7 +229,7 @@ int cpumask_any_distribute(const struct
 		(cpu) = cpumask_next_zero((cpu), (mask)),	\
 		(cpu) < nr_cpu_ids;)
 
-extern int cpumask_next_wrap(int n, const struct cpumask *mask, int start, bool wrap);
+int __pure cpumask_next_wrap(int n, const struct cpumask *mask, int start, bool wrap);
 
 /**
  * for_each_cpu_wrap - iterate over every cpu in a mask, starting at a specified location
_

Patches currently in -mm which might be from sander@svanheule.net are

x86-cacheinfo-move-shared-cache-map-definitions.patch
cpumask-fix-invalid-uniprocessor-mask-assumption.patch
lib-test-introduce-cpumask-kunit-test-suite.patch
cpumask-add-up-optimised-for_each__cpu-versions.patch
cpumask-update-cpumask_next_wrap-signature.patch

