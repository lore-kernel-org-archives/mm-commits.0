Return-Path: <SRS0=pZAw=EM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D59C2D0A3
	for <mm-commits@archiver.kernel.org>; Fri,  6 Nov 2020 23:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CEF22087E
	for <mm-commits@archiver.kernel.org>; Fri,  6 Nov 2020 23:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604705591;
	bh=X6CBLeUk5rR/tt2zaHwokAG6Inj8sszo0KB88DSt5B0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=q/SMnuxZhnSw4qq2XaxsN0XA4nLSReHsO1HdYa/nvE2hfrRtXQdm6y4g/N0BuWY1i
	 i4To6OsBJhPrIY01TPmzoIY2NaPqx5Dd7jOA29WKpwEt/1E0NP+VD70nIcO3Y26eAP
	 GFS2TY/yrQihckRE1SgjNUInjiJYQ75Dh2tfo2PY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgKFXdK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Nov 2020 18:33:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:56336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728220AbgKFXdK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Nov 2020 18:33:10 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD849206D5;
        Fri,  6 Nov 2020 23:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604705589;
        bh=X6CBLeUk5rR/tt2zaHwokAG6Inj8sszo0KB88DSt5B0=;
        h=Date:From:To:Subject:From;
        b=dbVZM1eH9UN2Vn4RSaD98aOo9/arl4fWNuBCWl7EcToXeQam+QTINtar1p5ICrR1+
         KKlp6ZIjY8k1jv3hWoFpENUm4d6H2HTwj56rO8uldLDCP8bMP+JHBxvFpYNdic1Chc
         dMZNTg1Xuhk6FJmweDAC6Gos/yvhlonXA4m4kIo8=
Date:   Fri, 06 Nov 2020 15:33:09 -0800
From:   akpm@linux-foundation.org
To:     elver@google.com, mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  + mm-add-kernel-electric-fence-infrastructure-fix.patch
 added to -mm tree
Message-ID: <20201106233309.RSPPmy_0m%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: Fix parameter description for kfence_object_start()
has been added to the -mm tree.  Its filename is
     mm-add-kernel-electric-fence-infrastructure-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-kernel-electric-fence-infrastructure-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-kernel-electric-fence-infrastructure-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: Fix parameter description for kfence_object_start()

Describe parameter @addr correctly by delimiting with ':'.

Link: https://lkml.kernel.org/r/20201106092149.GA2851373@elver.google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfence.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/kfence.h~mm-add-kernel-electric-fence-infrastructure-fix
+++ a/include/linux/kfence.h
@@ -125,7 +125,7 @@ size_t kfence_ksize(const void *addr);
 
 /**
  * kfence_object_start() - find the beginning of a KFENCE object
- * @addr - address within a KFENCE-allocated object
+ * @addr: address within a KFENCE-allocated object
  *
  * Return: address of the beginning of the object.
  *
_

Patches currently in -mm which might be from elver@google.com are

mm-add-kernel-electric-fence-infrastructure-fix.patch
arm64-kfence-enable-kfence-for-arm64.patch
kfence-documentation-add-kfence-documentation.patch
kfence-add-test-suite.patch
maintainers-add-entry-for-kfence.patch

