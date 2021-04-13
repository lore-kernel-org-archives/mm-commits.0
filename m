Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD33C433ED
	for <mm-commits@archiver.kernel.org>; Tue, 13 Apr 2021 19:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83012613C8
	for <mm-commits@archiver.kernel.org>; Tue, 13 Apr 2021 19:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345214AbhDMT06 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Apr 2021 15:26:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:39004 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344831AbhDMT05 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Apr 2021 15:26:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 16A6AAE8D;
        Tue, 13 Apr 2021 19:26:36 +0000 (UTC)
MIME-Version: 1.0
Date:   Tue, 13 Apr 2021 21:26:35 +0200
From:   Oscar Salvador <osalvador@suse.de>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        anshuman.khandual@arm.com
Subject: Re: + mm-drop-redundant-arch_enable__migration-fix.patch added to -mm
 tree
In-Reply-To: <20210413173927.BqF-i%akpm@linux-foundation.org>
References: <20210413173927.BqF-i%akpm@linux-foundation.org>
User-Agent: Roundcube Webmail
Message-ID: <f4663f9b009089561caba2641153c871@suse.de>
X-Sender: osalvador@suse.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2021-04-13 19:39, akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-drop-redundant-arch_enable__migration-fix
> 
> s/X86_64/X86_64/, per Oscar
> 
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Hi Andrew,

Still something missing, see below:

> ---
> 
>  arch/x86/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/arch/x86/Kconfig~mm-drop-redundant-arch_enable__migration-fix
> +++ a/arch/x86/Kconfig
>  	select ARCH_ENABLE_THP_MIGRATION if x86_64 && TRANSPARENT_HUGEPAGE

That one right there needs fixing as well

Thanks
> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org 
> are
> 
> scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
> mm.patch
> mm-memcontrol-switch-to-rstat-fix.patch
> mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
> mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
> mm-vmscan-add-shrinker_info_protected-helper-fix.patch
> mm-drop-redundant-arch_enable__migration-fix.patch
> mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
> linux-next-rejects.patch
> kernel-forkc-export-kernel_thread-to-modules.patch

-- 
Oscar Salvador
SUSE L3
