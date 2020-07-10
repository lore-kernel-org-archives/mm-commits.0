Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5716C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 22:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F713207BB
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 22:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594420169;
	bh=3tZRC35vv1dlPGBLZB3HVdBFEdLX9coBprvwI+ZWfYA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=BJv9r5z2rzGTNm75/dL1j5YBKjvkvLvpMpHCHQqaL8Yl8OQ9snQyu4tot/0yhdGqr
	 5YraBW9E45zRz9ySOfQzAa30NY+oEdPwQ1PKB2OHLWOQHS7HdXtllO3c1sQZ9QJ/Hw
	 4n+3fqTo+PgQdFaKXaPTDFT//iP5lFen2+rwXT34=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgGJW33 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 18:29:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgGJW33 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 18:29:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EEB42075D;
        Fri, 10 Jul 2020 22:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594420168;
        bh=3tZRC35vv1dlPGBLZB3HVdBFEdLX9coBprvwI+ZWfYA=;
        h=Date:From:To:Subject:From;
        b=OwmUgtr57ML5BJ+0TOnOIhMEpcKZbHISBwvnB8u37jOjtlf1J/V7SVebX8CofBcCn
         57tkzXmFw8zWZT3ZnUyEsP2Q2VmfoIFX5rA4wdH9G0+PrfWEBkGpVSJUJpECL4Q2XH
         olzyEkXvsCugC32J9NWAc6xs2PwFMkFxMhcArP24=
Date:   Fri, 10 Jul 2020 15:29:27 -0700
From:   akpm@linux-foundation.org
To:     broonie@kernel.org, catalin.marinas@arm.com,
        mm-commits@vger.kernel.org, peterx@redhat.com, sfr@canb.auug.org.au
Subject:  +
 mm-gup-remove-task_struct-pointer-for-all-gup-code-fix.patch added to -mm
 tree
Message-ID: <20200710222927.Vkz6LXPXK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup-remove-task_struct-pointer-for-all-gup-code-fix
has been added to the -mm tree.  Its filename is
     mm-gup-remove-task_struct-pointer-for-all-gup-code-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-remove-task_struct-pointer-for-all-gup-code-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-remove-task_struct-pointer-for-all-gup-code-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm-gup-remove-task_struct-pointer-for-all-gup-code-fix

fix arch/arm64/kernel/mte.c

Link: http://lkml.kernel.org/r/20200710122457.GK199122@xz-x1
Cc: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/mte.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/mte.c~mm-gup-remove-task_struct-pointer-for-all-gup-code-fix
+++ a/arch/arm64/kernel/mte.c
@@ -221,7 +221,7 @@ static int __access_remote_tags(struct t
 		void *maddr;
 		struct page *page = NULL;
 
-		ret = get_user_pages_remote(tsk, mm, addr, 1, gup_flags,
+		ret = get_user_pages_remote(mm, addr, 1, gup_flags,
 					    &page, &vma, NULL);
 		if (ret <= 0)
 			break;
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-do-page-fault-accounting-in-handle_mm_fault.patch
mm-alpha-use-general-page-fault-accounting.patch
mm-arc-use-general-page-fault-accounting.patch
mm-arm-use-general-page-fault-accounting.patch
mm-arm64-use-general-page-fault-accounting.patch
mm-csky-use-general-page-fault-accounting.patch
mm-hexagon-use-general-page-fault-accounting.patch
mm-ia64-use-general-page-fault-accounting.patch
mm-m68k-use-general-page-fault-accounting.patch
mm-microblaze-use-general-page-fault-accounting.patch
mm-mips-use-general-page-fault-accounting.patch
mm-nds32-use-general-page-fault-accounting.patch
mm-nios2-use-general-page-fault-accounting.patch
mm-openrisc-use-general-page-fault-accounting.patch
mm-parisc-use-general-page-fault-accounting.patch
mm-powerpc-use-general-page-fault-accounting.patch
mm-riscv-use-general-page-fault-accounting.patch
mm-s390-use-general-page-fault-accounting.patch
mm-sh-use-general-page-fault-accounting.patch
mm-sparc32-use-general-page-fault-accounting.patch
mm-sparc64-use-general-page-fault-accounting.patch
mm-x86-use-general-page-fault-accounting.patch
mm-xtensa-use-general-page-fault-accounting.patch
mm-clean-up-the-last-pieces-of-page-fault-accountings.patch
mm-gup-remove-task_struct-pointer-for-all-gup-code.patch
mm-gup-remove-task_struct-pointer-for-all-gup-code-fix.patch

