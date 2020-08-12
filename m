Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22BC8C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB6A82080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266251;
	bh=LaHucdp/1sPH6ZnHOpA5lrqcwVC3ahBEO/dAq6ElHak=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=RXwH5KoF0VYcXv9JCdWApet95C7QU1nquSiNf9C/CpiRIz7FNLt+ImctnMQ+AXDx+
	 88i6Rv8kNrX9mrHIHJ/rIoFRNBc06cMZzwFQwjwEGsGQ0d8PtPKmS/3tZqSGBfRd+5
	 VcB6nZ9WNBmt4s39kYo3qBuaDDl1kzly4VvJEMPQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgHLVEK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbgHLVEK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:10 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 781B32078B;
        Wed, 12 Aug 2020 21:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266248;
        bh=LaHucdp/1sPH6ZnHOpA5lrqcwVC3ahBEO/dAq6ElHak=;
        h=Date:From:To:Subject:From;
        b=dvw9mYL6PJVyte5IO3ef/TrwCwsmEM3jedbcRvSqmt1tHgfabjBHJhsV3K9AThKIL
         nT7VaBgoVMAIjfvNWr+xErpUVqcZEjbNEXm1xS+vWA3ggNikbJQZgWHX/yJEIxlXKF
         0miIJgA30qwdhCzQQ3dxsJ5Cmh9gbySKm1kb6Qpk=
Date:   Wed, 12 Aug 2020 14:04:08 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, khlebnikov@yandex-team.ru,
        linux@roeck-us.net, mm-commits@vger.kernel.org,
        yangtiezhu@loongson.cn
Subject:  [merged]
 lib-kconfigdebug-make-test_lockup-depend-on-module.patch removed from -mm
 tree
Message-ID: <20200812210408._aU5h7sYv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: make TEST_LOCKUP depend on module
has been removed from the -mm tree.  Its filename was
     lib-kconfigdebug-make-test_lockup-depend-on-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1078,6 +1078,7 @@ config WQ_WATCHDOG
 
 config TEST_LOCKUP
 	tristate "Test module to generate lockups"
+	depends on m
 	help
 	  This builds the "test_lockup" module that helps to make sure
 	  that watchdogs and lockup detectors are working properly.
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are


