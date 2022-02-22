Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E94EFC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 11:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbiBVLDu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Feb 2022 06:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiBVLDt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Feb 2022 06:03:49 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7E9A9A48
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 03:03:22 -0800 (PST)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 911531EC01A8;
        Tue, 22 Feb 2022 12:03:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1645527795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=7xgGtxTo1JVMlqNw21RIKoy6LVkicunSqIfI+uL+FU0=;
        b=bcTgadbJMS/8TV5ZGSaSi+tQM9A9wvzWh1sYD4Lcp9jyOZilAXYlpk+e9cEeWAWvLw7eXk
        awmr9gQ2vd2X3QancbPKNw+oCogqJy6swOtfzxQadNE5n/x9K+8Zwd94c0l88/tweE40uN
        pLzVbI3rHyXKvj8PJOHPzXb0o816uyw=
Date:   Tue, 22 Feb 2022 12:03:17 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        tglx@linutronix.de, naoya.horiguchi@nec.com, mingo@redhat.com,
        linmiaohe@huawei.com, hpa@zytor.com, dave.hansen@linux.intel.com,
        luofei@unicloud.com
Subject: Re: +
 mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler.patch
 added to -mm tree
Message-ID: <YhTC9SlKg5oYdXtH@zn.tnic>
References: <20220222034821.14260C340E8@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220222034821.14260C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Feb 21, 2022 at 07:48:20PM -0800, Andrew Morton wrote:
> The patch titled
>      Subject: mm/hwpoison: avoid the impact of hwpoison_filter() return value on mce handler
> has been added to the -mm tree.  Its filename is
>      mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler.patch

Andrew, please drop this patch from your queue. Review below:

> From: luofei <luofei@unicloud.com>
> Subject: mm/hwpoison: avoid the impact of hwpoison_filter() return value on mce handler
> 
> When the hwpoison page meets the filter conditions, it should not be
> regarded as successful memory_failure() processing for mce handler, but
> should return a value(-EHWPOISON), otherwise mce handler regards the error
> page has been identified and isolated, which may lead to calling
> set_mce_nospec() to change page attribute, etc.
> 
> Here a new MF_MCE_HANDLE flag is introduced to identify the call from the
> mce handler and instruct hwpoison_filter() to return -EHWPOISON, otherwise
> return 0 for compatibility with the hwpoison injector.
> 
> Link: https://lkml.kernel.org/r/20220221021415.2328992-1-luofei@unicloud.com
> Signed-off-by: luofei <luofei@unicloud.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Fei Luo <luofei@unicloud.com>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/x86/kernel/cpu/mce/core.c |   15 +++++++++------
>  include/linux/mm.h             |    1 +
>  mm/memory-failure.c            |   14 ++++++++++++--
>  3 files changed, 22 insertions(+), 8 deletions(-)
> 
> --- a/arch/x86/kernel/cpu/mce/core.c~mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler
> +++ a/arch/x86/kernel/cpu/mce/core.c
> @@ -612,7 +612,7 @@ static int uc_decode_notifier(struct not
>  		return NOTIFY_DONE;
>  
>  	pfn = mce->addr >> PAGE_SHIFT;
> -	if (!memory_failure(pfn, 0)) {
> +	if (!memory_failure(pfn, MF_MCE_HANDLE)) {
>  		set_mce_nospec(pfn, whole_page(mce));
>  		mce->kflags |= MCE_HANDLED_UC;
>  	}
> @@ -1286,7 +1286,7 @@ static void kill_me_now(struct callback_
>  static void kill_me_maybe(struct callback_head *cb)
>  {
>  	struct task_struct *p = container_of(cb, struct task_struct, mce_kill_me);
> -	int flags = MF_ACTION_REQUIRED;
> +	int flags = MF_ACTION_REQUIRED | MF_MCE_HANDLE;
>  	int ret;
>  
>  	p->mce_count = 0;
> @@ -1303,9 +1303,12 @@ static void kill_me_maybe(struct callbac
>  	}
>  
>  	/*
> -	 * -EHWPOISON from memory_failure() means that it already sent SIGBUS
> -	 * to the current process with the proper error info, so no need to
> -	 * send SIGBUS here again.
> +	 * -EHWPOISON from memory_failure() means that memory_failure() did
> +	 * not handle the error event for the following reason:
> +	 *  - SIGBUS has already been sent to the current process with the
> +	 *    proper error info, or
> +	 *  - hwpoison_filter() filtered the event,
> +	 * so no need to deal with it more.

So you're overloading what we do for -EHWPOISON because it is just fits?

The right way to do this is to return a *distinct* error value which
means "ignore this error" and the MCE code can then ignore it.

> --- a/include/linux/mm.h~mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler
> +++ a/include/linux/mm.h
> @@ -3173,6 +3173,7 @@ enum mf_flags {
>  	MF_MUST_KILL = 1 << 2,
>  	MF_SOFT_OFFLINE = 1 << 3,
>  	MF_UNPOISON = 1 << 4,
> +	MF_MCE_HANDLE = 1 << 5,

This thing is too x86-specific and means nothing for other arches which
use memory_failure().

And I don't like this jumping through hoops one bit:

MCE code sets MF_MCE_HANDLE to tell the memory failure code to return a
special error which it does and then the MCE code again looks looks at
that special error. That's just nuts.

As said above, all you wanna do is have memory_failure() return a
distinct error value which says "ignore this error and don't do any
further processing". Without a new MF flag.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
