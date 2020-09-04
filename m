Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C12C2BB84
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF2BB208C7
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599262538;
	bh=QOSKsrrLXoxcjYfga80f/BEjYEYfK9RnvvSWET4ozzI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=f9woCVjFZr0k8hRRlqH08omMJOSKGjzMFQjNgDqTwdX0DcXcv1Jfxxi0kL0bxUdbn
	 KRxELTKWFZSY1cENhRrH7Mk9gaN01B7ThhwCzJEo5cZ2FCAuP4IcfRJrwRG1C7IOoz
	 qA/FkImdIF0cYGUPFYjlr7GG/GshD+C+kTDXvl7g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgIDXfi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 19:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIDXfi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 19:35:38 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 601A42100A;
        Fri,  4 Sep 2020 23:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599262537;
        bh=QOSKsrrLXoxcjYfga80f/BEjYEYfK9RnvvSWET4ozzI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PLaTXxGcr1RXzznavVWDfSmhGMVqEdfSlhvbOpzA4pid6JYkdJhJbW9jInqoGAdKv
         cLv2AxGYxRYcO4GjUMlc1KnAqBowNnisEZiJcawaKp2isIf6Qxfp1L0or+oTf/1j7m
         x92UlyrKtM+D2A+buVWr/w9ZvKer7N9ZTfXQOenA=
Date:   Fri, 04 Sep 2020 16:35:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        lukas.bulwahn@gmail.com, masahiroy@kernel.org,
        miguel.ojeda.sandonis@gmail.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        sedat.dilek@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 05/19] MAINTAINERS: add LLVM maintainers
Message-ID: <20200904233537.cpYtnJbUC%akpm@linux-foundation.org>
In-Reply-To: <20200904163454.4db0e6ce0c4584d2653678a3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>
Subject: MAINTAINERS: add LLVM maintainers

Nominate Nathan and myself to be point of contact for clang/LLVM related
support, after a poll at the LLVM BoF at Linux Plumbers Conf 2020.

While corporate sponsorship is beneficial, its important to not entrust
the keys to the nukes with any one entity.  Should Nathan and I find
ourselves at the same employer, I would gladly step down.

Link: https://lkml.kernel.org/r/20200825143540.2948637-1-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Sedat Dilek <sedat.dilek@gmail.com>
Acked-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-llvm-maintainers
+++ a/MAINTAINERS
@@ -4257,6 +4257,8 @@ S:	Maintained
 F:	.clang-format
 
 CLANG/LLVM BUILD SUPPORT
+M:	Nathan Chancellor <natechancellor@gmail.com>
+M:	Nick Desaulniers <ndesaulniers@google.com>
 L:	clang-built-linux@googlegroups.com
 S:	Supported
 W:	https://clangbuiltlinux.github.io/
_
