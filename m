Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA791C433B4
	for <mm-commits@archiver.kernel.org>; Mon, 19 Apr 2021 21:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A56B3613AC
	for <mm-commits@archiver.kernel.org>; Mon, 19 Apr 2021 21:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240387AbhDSVhd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Apr 2021 17:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229714AbhDSVhc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 19 Apr 2021 17:37:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70B3F6113C;
        Mon, 19 Apr 2021 21:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618868221;
        bh=YnVav9b2X8BK437Ycy2zQXeK5R1Vi6ULJV95mmEM4l4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EI1wBfo0xtdY0joSyyKzShYA0Pga5EG2LIV5/8DChIL9W2DIYzIi6029niHZHtnev
         1qJydGLBDhqzO0dKt3C8s0bBy7bcHS/PAitfln3FrxJ4gWAPpuh/bNv1E6It1lyR3A
         uFqPAaBEM2ugQIAX8iFdBBolBgnRXtXiqffC7jse9KO8bEiuGwdEdG83mlnGqQlFlK
         im6hV+uNMfb3IwC8FDsTccbFFq01IsnwHJUwlsi/0z0pfwa1FywH3ixCCWtqSsKpJF
         jJOG5yXW1QcSEYOePKQa0E9s6yQLRP8MF4Gch+oTLjyfBUkO8sxGrJO0prT0dDPJa6
         n2tSUH0/vXGAw==
Date:   Mon, 19 Apr 2021 14:36:57 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     akpm@linux-foundation.org, johannes.berg@intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, torvalds@linux-foundation.org
Subject: Re: [patch 11/12] gcov: clang: fix clang-11+ build
Message-ID: <YH33+R8pwviVysY5@archlinux-ax161>
References: <20210416154523.3f9794326e8e1db549873cf8@linux-foundation.org>
 <20210416224623.nZhisHrwM%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416224623.nZhisHrwM%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Apr 16, 2021 at 03:46:23PM -0700, Andrew Morton wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> Subject: gcov: clang: fix clang-11+ build
> 
> With clang-11+, the code is broken due to my kvmalloc() conversion (which
> predated the clang-11 support code) leaving one vmalloc() in place.  Fix
> that.
> 
> Link: https://lkml.kernel.org/r/20210412214210.6e1ecca9cdc5.I24459763acf0591d5e6b31c7e3a59890d802f79c@changeid
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/gcov/clang.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/kernel/gcov/clang.c~gcov-clang-fix-clang-11-build
> +++ a/kernel/gcov/clang.c
> @@ -369,7 +369,7 @@ static struct gcov_fn_info *gcov_fn_info
>  	INIT_LIST_HEAD(&fn_dup->head);
>  
>  	cv_size = fn->num_counters * sizeof(fn->counters[0]);
> -	fn_dup->counters = vmalloc(cv_size);
> +	fn_dup->counters = kvmalloc(cv_size, GFP_KERNEL);
>  	if (!fn_dup->counters) {
>  		kfree(fn_dup);
>  		return NULL;
> _

This should not have been merged into mainline by itself. It was a fix
for "gcov: use kvmalloc()", which is still in -mm/-next. Merging it
alone has now broken the build:

https://github.com/ClangBuiltLinux/continuous-integration2/runs/2384465683?check_suite_focus=true

Could it please be reverted in mainline then added as a fix patch for
the patch that is still in -mm:

https://www.ozlabs.org/~akpm/mmotm/broken-out/gcov-use-kvmalloc.patch

Cheers,
Nathan
