Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C62EECAAA1
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 07:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiIIHpl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 03:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbiIIHpR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 03:45:17 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F65128961
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 00:41:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D28F31F8E3;
        Fri,  9 Sep 2022 07:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662709177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t76/gJaBRROCE/458Xfx49z+yAYDXcwz7qb5lr90npQ=;
        b=ObPhdVvGORthYhpYhFh9yeBd6Z77RzRTj24Gvh1uzjbyqAiQPdRkbKeBwOmN8y3KqK61n1
        qboEtSEupNd5DeNA4CKccv3clQ5YUALK1wPi2HAEFkxLH1tACqsClPdAjhI218PtX6U7PX
        n+i7dnWMBMkZHw1XiUdRdtlbigYrd4Y=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B19F013A93;
        Fri,  9 Sep 2022 07:39:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id scgKKbntGmNlNAAAMHmgww
        (envelope-from <mhocko@suse.com>); Fri, 09 Sep 2022 07:39:37 +0000
Date:   Fri, 9 Sep 2022 09:39:36 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, hannes@cmpxchg.org, corbet@lwn.net,
        liushixin2@huawei.com
Subject: Re: +
 mm-memcontrol-use-kstrtobool-for-swapaccount-param-parsing.patch added to
 mm-unstable branch
Message-ID: <YxrtuG8K2NYhh+KY@dhcp22.suse.cz>
References: <20220908220200.7946DC433C1@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908220200.7946DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu 08-09-22 15:01:59, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm/memcontrol: use kstrtobool for swapaccount param parsing
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-memcontrol-use-kstrtobool-for-swapaccount-param-parsing.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-use-kstrtobool-for-swapaccount-param-parsing.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Liu Shixin <liushixin2@huawei.com>
> Subject: mm/memcontrol: use kstrtobool for swapaccount param parsing
> Date: Thu, 8 Sep 2022 16:34:52 +0800
> 
> Use kstrtobool which is more powerful to handle all kinds of parameters
> like 'Yy1Nn0' or [oO][NnFf] for "on" and "off".
> 
> Link: https://lkml.kernel.org/r/20220908083452.2844125-1-liushixin2@huawei.com
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Liu Shixin <liushixin2@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I do not have any objection to using kstrtobool but please drop all the
other changes. They do not add clarity and even if some accepted values
remain unspecified I do not think this matters much.
with that changed, feel free to add
Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
> 
>  Documentation/admin-guide/kernel-parameters.txt |    7 ++++---
>  mm/memcontrol.c                                 |    8 ++++----
>  mm/swap_cgroup.c                                |    2 +-
>  3 files changed, 9 insertions(+), 8 deletions(-)
> 
> --- a/Documentation/admin-guide/kernel-parameters.txt~mm-memcontrol-use-kstrtobool-for-swapaccount-param-parsing
> +++ a/Documentation/admin-guide/kernel-parameters.txt
> @@ -6037,10 +6037,11 @@
>  			Execution Facility on pSeries.
>  
>  	swapaccount=	[KNL]
> -			Format: [0|1]
> +			Format: { [oO][Nn]/Y/y/1 | [oO][Ff]/N/n/0 }
>  			Enable accounting of swap in memory resource
> -			controller if no parameter or 1 is given or disable
> -			it if 0 is given (See Documentation/admin-guide/cgroup-v1/memory.rst)
> +			controller if no parameter or [oO][Nn]/Y/y/1 is given
> +			or disable it if [oO][Ff]/N/n/0 is given
> +			(See Documentation/admin-guide/cgroup-v1/memory.rst)
>  
>  	swiotlb=	[ARM,IA-64,PPC,MIPS,X86]
>  			Format: { <int> [,<int>] | force | noforce }
> --- a/mm/memcontrol.c~mm-memcontrol-use-kstrtobool-for-swapaccount-param-parsing
> +++ a/mm/memcontrol.c
> @@ -7507,10 +7507,10 @@ bool mem_cgroup_swap_full(struct folio *
>  
>  static int __init setup_swap_account(char *s)
>  {
> -	if (!strcmp(s, "1"))
> -		cgroup_memory_noswap = false;
> -	else if (!strcmp(s, "0"))
> -		cgroup_memory_noswap = true;
> +	bool res;
> +
> +	if (!kstrtobool(s, &res))
> +		cgroup_memory_noswap = !res;
>  	return 1;
>  }
>  __setup("swapaccount=", setup_swap_account);
> --- a/mm/swap_cgroup.c~mm-memcontrol-use-kstrtobool-for-swapaccount-param-parsing
> +++ a/mm/swap_cgroup.c
> @@ -194,7 +194,7 @@ int swap_cgroup_swapon(int type, unsigne
>  	return 0;
>  nomem:
>  	pr_info("couldn't allocate enough memory for swap_cgroup\n");
> -	pr_info("swap_cgroup can be disabled by swapaccount=0 boot option\n");
> +	pr_info("swap_cgroup can be disabled by swapaccount=[oO][Ff]/N/n/0 boot option\n");
>  	return -ENOMEM;
>  }
>  
> _
> 
> Patches currently in -mm which might be from liushixin2@huawei.com are
> 
> revert-frontswap-remove-support-for-multiple-ops.patch
> revert-mm-mark-swap_lock-and-swap_active_head-static.patch
> revert-frontswap-simplify-frontswap_register_ops.patch
> mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
> mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch
> mm-zswap-skip-confusing-print-info.patch
> mm-thp-simplify-has_transparent_hugepage-by-using-is_builtin.patch
> mm-thp-remove-redundant-config_transparent_hugepage.patch
> mm-kmemleak-make-create_object-return-void.patch
> mm-huge_memory-prevent-thp_zero_page_alloc-increased-twice.patch
> mm-memcontrol-use-kstrtobool-for-swapaccount-param-parsing.patch

-- 
Michal Hocko
SUSE Labs
