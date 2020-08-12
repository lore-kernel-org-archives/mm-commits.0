Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 235B7C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00816207DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196211;
	bh=0gz6p+m+UuB66vc8U2RYDWzd6g5Cw8YAgHrFBigCl7g=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=LVOpvl94KVcB7aU5heRwXE7y+XEKXNiezq65+kX0lNIx9jwxV/vn0ezWH+IBQ1bbh
	 Bq/ndm9O1owBM6901abNYdNoqoiM2ZskwY8HA9vmZ8bDHohBRd2vu241Jr4Q2KJ5yU
	 LGho/R7hQe92uiE7pvaYK8s+E2QHnqUivku5etT8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgHLBgu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgHLBgu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:36:50 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06D1D20658;
        Wed, 12 Aug 2020 01:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196210;
        bh=0gz6p+m+UuB66vc8U2RYDWzd6g5Cw8YAgHrFBigCl7g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rKgGmZNrAO0fzLYcwkKJM+x6uKt+cffyAY0Ql34slV/7fWYbVg9TjkBjr/2E9/kiW
         Nc+n2nsdRLNiBPe7R09Ul25rPqUgeK9WRIiVoHZsowLREUipPb7NLj4zwbOmYcXWE1
         jRBSOEmw7yznxf111p8zN1vOOLxmGnG1CEMPz3cM=
Date:   Tue, 11 Aug 2020 18:36:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, keescook@chromium.org,
        linux-mm@kvack.org, lixuefeng@loongson.cn,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        yangtiezhu@loongson.cn
Subject:  [patch 124/165] lib/Kconfig.debug: fix typo in the help
 text of CONFIG_PANIC_TIMEOUT
Message-ID: <20200812013649.1MwXgXH3F%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: lib/Kconfig.debug: fix typo in the help text of CONFIG_PANIC_TIMEOUT

There exists duplicated "the" in the help text of CONFIG_PANIC_TIMEOUT,
Remove it.

Link: http://lkml.kernel.org/r/1591103358-32087-2-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-kconfigdebug-fix-typo-in-the-help-text-of-config_panic_timeout
+++ a/lib/Kconfig.debug
@@ -917,7 +917,7 @@ config PANIC_TIMEOUT
 	int "panic timeout"
 	default 0
 	help
-	  Set the timeout value (in seconds) until a reboot occurs when the
+	  Set the timeout value (in seconds) until a reboot occurs when
 	  the kernel panics. If n = 0, then we wait forever. A timeout
 	  value n > 0 will wait n seconds before rebooting, while a timeout
 	  value n < 0 will reboot immediately.
_
