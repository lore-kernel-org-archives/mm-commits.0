Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A3BCC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4212C2076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196087;
	bh=Od+C+ecaXh8SAUBKYXNEZ/TAOjHocyxgRaBXFBNRgI8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=kK2d4PP4VerAmirgl3y7BPT4F/jTytHTSO1rUy+1UgbZBWPATJ7AaGPQ6BGYFIbqH
	 Ffbfvq5LkYqM9yl7sbBD18IUwifmQr7VTPq3Ljm0EhzCyKkEXwv887l8bn/6sInTms
	 bDZwtTjKj4ezr63fngDXsfg3uhcHcI1WkL1RFcxE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgHLBer (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:34:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgHLBeq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:34:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 815BC2080C;
        Wed, 12 Aug 2020 01:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196084;
        bh=Od+C+ecaXh8SAUBKYXNEZ/TAOjHocyxgRaBXFBNRgI8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JhY3H7cO18hLkthazwhrc/SDyjn4H0aLvdc4Gv0K5oGq2mztRW4hixybNLxKBLTHO
         OS3AFv1I/k1p3NU7Kf94n1T28bNrlVUP1skyhMdXpely7V2kIgygzFv6zavBqV8i8e
         ML1JZAWV+LTPh3+FFSQi6E5JF92OQQJPB1/hMbHs=
Date:   Tue, 11 Aug 2020 18:34:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, keescook@chromium.org,
        khlebnikov@yandex-team.ru, linux-mm@kvack.org, linux@roeck-us.net,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        yangtiezhu@loongson.cn
Subject:  [patch 085/165] lib/Kconfig.debug: make TEST_LOCKUP
 depend on module
Message-ID: <20200812013444.VVZ-B-30M%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: lib/Kconfig.debug: make TEST_LOCKUP depend on module

Since test_lockup is a test module to generate lockups, it is better to
limit TEST_LOCKUP to module (=m) or disabled (=n) because we can not use
the module parameters when CONFIG_TEST_LOCKUP=y.

Link: http://lkml.kernel.org/r/1595555407-29875-1-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.debug~lib-kconfigdebug-make-test_lockup-depend-on-module
+++ a/lib/Kconfig.debug
@@ -1078,6 +1078,7 @@ config WQ_WATCHDOG
 
 config TEST_LOCKUP
 	tristate "Test module to generate lockups"
+	depends on m
 	help
 	  This builds the "test_lockup" module that helps to make sure
 	  that watchdogs and lockup detectors are working properly.
_
