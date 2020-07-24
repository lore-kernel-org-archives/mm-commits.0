Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44AF1C433E3
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 02:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22657207FC
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 02:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595557230;
	bh=CQRkEBwhx5CHPucZoTtoT3wdewt3oL3HlRmh5QsLnH4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=b2hbsV1+RCi1I0xq1WcTtH+fRMIMUoovoNMmQp1espPq4+uwikdjYTtxmhkRllEg8
	 LYjVEQ43Rcn0F+61OtralEL3QaIny8YHVTxSM+kCdRaAyihqRIG+SVZac3Wnn+XWkR
	 EsXju9g4UwTzY30vTdcvdgqssX4HccK6nKfFZkJs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgGXCU2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Jul 2020 22:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726284AbgGXCU2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jul 2020 22:20:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB50420737;
        Fri, 24 Jul 2020 02:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595557228;
        bh=CQRkEBwhx5CHPucZoTtoT3wdewt3oL3HlRmh5QsLnH4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nNJ+Z880YdGuIepiiXgPXvGEypfXGceiGIMhogprn3nbXNTQUpLp7jy0E70zKEIpw
         gxpCdMYK4AZ9jb7EBTEttNJ0mCUXQG1VxeRmIFywnnvLYsrxbt1JGTgwUNTB78SlHY
         8GHWP5ytXxODyA7PGhvByji2B0OXnzrNqBdFBrx8=
Date:   Thu, 23 Jul 2020 19:20:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     keescook@chromium.org, khlebnikov@yandex-team.ru,
        linux@roeck-us.net, mm-commits@vger.kernel.org,
        yangtiezhu@loongson.cn
Subject:  +
 lib-kconfigdebug-make-test_lockup-depend-on-module.patch added to -mm tree
Message-ID: <20200724022027.jiouTjV_x%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: make TEST_LOCKUP depend on module
has been added to the -mm tree.  Its filename is
     lib-kconfigdebug-make-test_lockup-depend-on-module.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-kconfigdebug-make-test_lockup-depend-on-module.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-kconfigdebug-make-test_lockup-depend-on-module.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1046,6 +1046,7 @@ config WQ_WATCHDOG
 
 config TEST_LOCKUP
 	tristate "Test module to generate lockups"
+	depends on m
 	help
 	  This builds the "test_lockup" module that helps to make sure
 	  that watchdogs and lockup detectors are working properly.
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

lib-kconfigdebug-make-test_lockup-depend-on-module.patch
lib-test_lockupc-fix-return-value-of-test_lockup_init.patch
selftests-kmod-use-variable-name-in-kmod_test_0001.patch
kmod-remove-redundant-be-an-in-the-comment.patch
test_kmod-avoid-potential-double-free-in-trigger_config_run_type.patch
kernel-panicc-make-oops_may_print-return-bool.patch
lib-kconfigdebug-fix-typo-in-the-help-text-of-config_panic_timeout.patch

