Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 883EDC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 23:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbiGDX13 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jul 2022 19:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbiGDX1Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jul 2022 19:27:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5C72DCC
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 16:27:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 956AA617A0
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 23:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEA8C3411E;
        Mon,  4 Jul 2022 23:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656977242;
        bh=s2v3TY+k8RrQW+5tdCBnQ8BlH7ZXorC/m6EClVJO8B0=;
        h=Date:To:From:Subject:From;
        b=owMV1EiNwiLtj2j8VELPqbT0lYPNT3e+RT9j3n3vfry2s26klTI7N8GqG8Yz63gyd
         mMV8y/Uqs7Tfq4vh/vc2GigTFiiWpEqk2K0UcuvwEvAAoYAXCaRq/5yKYiaHip9pPA
         ub/SE6LrhDl50yPzkQ8OrB2vxxNwKGoQyOGdPrhs=
Date:   Mon, 04 Jul 2022 16:27:22 -0700
To:     mm-commits@vger.kernel.org, xiujianfeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-remove-the-redundant-initialization-for-error.patch added to mm-unstable branch
Message-Id: <20220704232722.DEEA8C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect: remove the redundant initialization for error
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mprotect-remove-the-redundant-initialization-for-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-remove-the-redundant-initialization-for-error.patch

This patch will later appear in the mm-unstable branch at
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
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm/mprotect: remove the redundant initialization for error
Date: Mon, 4 Jul 2022 19:41:12 +0800

The variable error will be assigned correctly before it is used, the
initialization is redundant, so remove it.

Link: https://lkml.kernel.org/r/20220704114112.163112-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mprotect.c~mm-mprotect-remove-the-redundant-initialization-for-error
+++ a/mm/mprotect.c
@@ -663,7 +663,7 @@ static int do_mprotect_pkey(unsigned lon
 {
 	unsigned long nstart, end, tmp, reqprot;
 	struct vm_area_struct *vma, *prev;
-	int error = -EINVAL;
+	int error;
 	const int grows = prot & (PROT_GROWSDOWN|PROT_GROWSUP);
 	const bool rier = (current->personality & READ_IMPLIES_EXEC) &&
 				(prot & PROT_READ);
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are

mm-mprotect-remove-the-redundant-initialization-for-error.patch

