Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B339AC2B9F7
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 09:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 913C3613D8
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 09:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhEZJc2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 May 2021 05:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232218AbhEZJc2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 May 2021 05:32:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 268FB6023D;
        Wed, 26 May 2021 09:30:50 +0000 (UTC)
Date:   Wed, 26 May 2021 10:30:47 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     sh_def@163.com, mm-commits@vger.kernel.org, linuxarm@openeuler.org,
        linuxarm@huawei.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm,kmemleak-test: add the dependency on CONFIG_SAMPLES
Message-ID: <20210526093047.GC19992@arm.com>
References: <1621995008-116893-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621995008-116893-1-git-send-email-chenxiang66@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, May 26, 2021 at 10:10:08AM +0800, chenxiang wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> As kmemleak-test.c is moved to samples dir, it is not compiled if just
> setting CONFIG_DEBUG_KMEMLEAK_TEST as module and enabling
> CONFIG_DEBUG_KMEMLEAK. Because it depends on CONFIG_SAMPLES after it is
> moved to samples dir.
> So the dependency on CONFIG_SAMPLES is added.
> 
> Fixes: 1abbef4f5172 ("mm,kmemleak-test.c: move kmemleak-test.c to samples dir")
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> ---
>  lib/Kconfig.debug | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 2779c29..9950542 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -716,7 +716,7 @@ config DEBUG_KMEMLEAK_MEM_POOL_SIZE
>  
>  config DEBUG_KMEMLEAK_TEST
>  	tristate "Simple test for the kernel memory leak detector"
> -	depends on DEBUG_KMEMLEAK && m
> +	depends on DEBUG_KMEMLEAK && SAMPLES && m
>  	help
>  	  This option enables a module that explicitly leaks memory.

Would it make more sense to move the DEBUG_KMEMLEAK_TEST option to
samples as well and maybe rename it to SAMPLES_KMEMLEAK?

-- 
Catalin
