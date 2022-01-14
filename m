Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A708C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbiANWHX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiANWHX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:07:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F95C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:07:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D4656201E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02B3C36AEC;
        Fri, 14 Jan 2022 22:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198042;
        bh=7LuOOK14eXnlNYG8J9QodfnSLJlEQv7H2NUrOoEMzOg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1VTAfQ26b7Cf/+PEbx+koxZ9z1iHu7NVfozhK3Mavil4Z9dF3ykrt2QN4EXKsFfFn
         izn3v2SrAiCiWn0G7idmUCpQhb47utLlRIL6qcUDzQoVAqBvM5QHTBO/Hdh28D7WJI
         2qZLM3KREM+WAiGe7SeUNXBzs8owD5IBEdvCDnpc=
Date:   Fri, 14 Jan 2022 14:07:21 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, deng.changcheng@zte.com.cn,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, zealci@zte.com.cn
Subject:  [patch 080/146] mm: fix boolreturn.cocci warning
Message-ID: <20220114220721.-NgiYC23R%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>
Subject: mm: fix boolreturn.cocci warning

Return statements in functions returning bool should use true/false
instead of 1/0.

Link: https://lkml.kernel.org/r/20211126073327.74815-1-deng.changcheng@zte.com.cn
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-fix-boolreturncocci-warning
+++ a/include/linux/page-flags.h
@@ -383,7 +383,7 @@ static __always_inline int TestClearPage
 	TESTCLEARFLAG(uname, lname, policy)
 
 #define TESTPAGEFLAG_FALSE(uname, lname)				\
-static inline bool folio_test_##lname(const struct folio *folio) { return 0; } \
+static inline bool folio_test_##lname(const struct folio *folio) { return false; } \
 static inline int Page##uname(const struct page *page) { return 0; }
 
 #define SETPAGEFLAG_NOOP(uname, lname)					\
_
