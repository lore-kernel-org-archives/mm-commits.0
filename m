Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E6D3C004D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 14:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjASOnP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 09:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbjASOl6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 09:41:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F860798F2
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 06:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7E0361982
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 14:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAC0C433D2;
        Thu, 19 Jan 2023 14:40:20 +0000 (UTC)
Date:   Thu, 19 Jan 2023 14:40:17 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, vbabka@suse.cz, peterz@infradead.org,
        nathan@kernel.org, ke.wang@unisoc.com, huangzhaoyang@gmail.com,
        zhaoyang.huang@unisoc.com
Subject: Re: + mm-use-stack_depot_early_init-for-kmemleak.patch added to
 mm-hotfixes-unstable branch
Message-ID: <Y8lWUVIcOasoLYEZ@arm.com>
References: <20230118001933.5E38DC433F1@smtp.kernel.org>
 <a6ff1869-d90e-3d3c-b023-3a95b4bc7eaf@alu.unizg.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6ff1869-d90e-3d3c-b023-3a95b4bc7eaf@alu.unizg.hr>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Jan 19, 2023 at 02:02:29PM +0100, Mirsad Goran Todorovac wrote:
> On 18.1.2023. 1:19, Andrew Morton wrote:
> > --- a/mm/kmemleak.c~mm-use-stack_depot_early_init-for-kmemleak
> > +++ a/mm/kmemleak.c
> > @@ -2070,8 +2070,10 @@ static int __init kmemleak_boot_config(c
> >   		return -EINVAL;
> >   	if (strcmp(str, "off") == 0)
> >   		kmemleak_disable();
> > -	else if (strcmp(str, "on") == 0)
> > +	else if (strcmp(str, "on") == 0) {
> >   		kmemleak_skip_disable = 1;
> > +		stack_depot_want_early_init();
> > +	}
> >   	else
> >   		return -EINVAL;
> >   	return 0;
> > _
> > 
> > Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are
> > 
> > mm-use-stack_depot_early_init-for-kmemleak.patch
> 
> Please note that this patch activates stack_depot_want_early_init() only when
> kernel boot param "kmemleak=on" is used.
> 
> When the following configuration is used:
> 
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> CONFIG_DEBUG_KMEMLEAK=y
> CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE=16000
> # CONFIG_DEBUG_KMEMLEAK_TEST is not set
> # CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
> CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y

Indeed, I commented here already:

https://lore.kernel.org/all/Y8gDdnpvkCKvVV1t@arm.com/

-- 
Catalin
