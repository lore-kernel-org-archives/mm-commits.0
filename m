Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E261C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 19:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiKOTuT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 14:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiKOTuT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 14:50:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FFD5F8E
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 11:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B72766199D
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 19:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D131C433C1;
        Tue, 15 Nov 2022 19:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668541817;
        bh=BJm80b96Vbv5Z7fVyub0Rk7ZeZzbYKQmuznZld2j1w8=;
        h=Date:To:From:Subject:From;
        b=WBn0qaNxYOZ+ajQPPfjSpBg+PlUAVcaXpZx8nugRy1clRPGzxopCjVq/jMYKOKAKd
         0pFuzaTxzw+FQFMBvPuS1IUxicExWOFTYRCRenY70QC2CYtKR/vSVDLHK2dnFVU2Ek
         hy2kg/yjE1PgpMVKkROSd+w2Tnf0UKkJP+TEyDy4=
Date:   Tue, 15 Nov 2022 11:50:16 -0800
To:     mm-commits@vger.kernel.org, zhangjinhao2@huawei.com,
        vbabka@suse.cz, rdunlap@infradead.org, guohanjun@huawei.com,
        zhengyejian1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + acct-fix-accuracy-loss-for-input-value-of-encode_comp_t.patch added to mm-nonmm-unstable branch
Message-Id: <20221115195017.1D131C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: acct: fix accuracy loss for input value of encode_comp_t()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     acct-fix-accuracy-loss-for-input-value-of-encode_comp_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/acct-fix-accuracy-loss-for-input-value-of-encode_comp_t.patch

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
From: Zheng Yejian <zhengyejian1@huawei.com>
Subject: acct: fix accuracy loss for input value of encode_comp_t()
Date: Sat, 15 May 2021 22:06:30 +0800

Patch series "Fix encode_comp_t()".

Type conversion in encode_comp_t() may look a bit problematic.


This patch (of 2):

See calculation of ac_{u,s}time in fill_ac():
  > ac->ac_utime = encode_comp_t(nsec_to_AHZ(pacct->ac_utime));
  > ac->ac_stime = encode_comp_t(nsec_to_AHZ(pacct->ac_stime));

Return value of nsec_to_AHZ() is always type of 'u64', but it is handled
as type of 'unsigned long' in encode_comp_t, and accuracy loss would
happen on 32-bit platform when 'unsigned long' value is 32-bit-width.

So 'u64' value of encode_comp_t() may look better.

Link: https://lkml.kernel.org/r/20210515140631.369106-1-zhengyejian1@huawei.com
Link: https://lkml.kernel.org/r/20210515140631.369106-2-zhengyejian1@huawei.com
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Randy Dunlap <rdunlap@infradead.org> # build-tested
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Jinhao <zhangjinhao2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/acct.c~acct-fix-accuracy-loss-for-input-value-of-encode_comp_t
+++ a/kernel/acct.c
@@ -320,7 +320,7 @@ void acct_exit_ns(struct pid_namespace *
 }
 
 /*
- *  encode an unsigned long into a comp_t
+ *  encode an u64 into a comp_t
  *
  *  This routine has been adopted from the encode_comp_t() function in
  *  the kern_acct.c file of the FreeBSD operating system. The encoding
@@ -331,7 +331,7 @@ void acct_exit_ns(struct pid_namespace *
 #define	EXPSIZE		3			/* Base 8 (3 bit) exponent. */
 #define	MAXFRACT	((1 << MANTSIZE) - 1)	/* Maximum fractional value. */
 
-static comp_t encode_comp_t(unsigned long value)
+static comp_t encode_comp_t(u64 value)
 {
 	int exp, rnd;
 
_

Patches currently in -mm which might be from zhengyejian1@huawei.com are

acct-fix-accuracy-loss-for-input-value-of-encode_comp_t.patch
acct-fix-potential-integer-overflow-in-encode_comp_t.patch

