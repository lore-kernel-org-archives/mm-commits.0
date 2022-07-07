Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89AD3C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jul 2022 21:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236961AbiGGV7B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jul 2022 17:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236931AbiGGV6o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2022 17:58:44 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3842714D
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 14:58:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7AD4C21E66;
        Thu,  7 Jul 2022 21:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1657231121; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5/FyJyUSg2hmpyMjaerHOiTwHJQMdGTYot88bju/IRA=;
        b=cUw6Caz02f06fuuba0j5MeT747MylCjIKsEg2ZPVek2xB9D4DpQrvxFvNm9BabaiSojJbu
        pqZtC/EV1GVAmpc//RJfu+b2W+0AvNlWSiWtE5yqbTaZ/ABSgmGx4/A5uhi75Bk4T5axYl
        3xkC6RTwrIEtjmRx09kIPpMPlKtWiF4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1657231121;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5/FyJyUSg2hmpyMjaerHOiTwHJQMdGTYot88bju/IRA=;
        b=CPMgQRuz3wMBFzWv0fyyBxVAVQjsFVro0e11Nf8IVoL0WpTtxsSUC7Hz/3zghmv+3CaGpL
        HR7urpg/7RXTeRAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 43E0F13461;
        Thu,  7 Jul 2022 21:58:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6zXPDxFXx2L1WAAAMHmgww
        (envelope-from <vbabka@suse.cz>); Thu, 07 Jul 2022 21:58:41 +0000
Message-ID: <fc7101bb-b9b9-4444-1d8b-4a28ce13f333@suse.cz>
Date:   Thu, 7 Jul 2022 23:58:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: + mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch added
 to mm-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, yuzhao@google.com, nsaenzju@redhat.com,
        mtosatti@redhat.com, m.szyprowski@samsung.com, minchan@kernel.org,
        mhocko@kernel.org, mgorman@techsingularity.net, lkp@intel.com,
        hughd@google.com, dan.carpenter@oracle.com
References: <20220707200919.90C41C3411E@smtp.kernel.org>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20220707200919.90C41C3411E@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 7/7/22 22:09, Andrew Morton wrote:
> The patch titled
>      Subject: mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
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
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix
> Date: Thu Jul  7 01:06:35 PM PDT 2022
> 
> add missing local_unlock_irqrestore() on contention path

Doh, that's true and something to fix, although patch 7 did remove the bug
later in the same series so that wouldn't explain the lkp report for patch
7. The reason lkp test robot complained was AFAICS that it was testing v4,
as I just replied there.

> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Nicolas Saenz Julienne <nsaenzju@redhat.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Yu Zhao <yuzhao@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/page_alloc.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/mm/page_alloc.c~mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix
> +++ a/mm/page_alloc.c
> @@ -3792,6 +3792,7 @@ static struct page *rmqueue_pcplist(stru
>  	pcp_trylock_prepare(UP_flags);
>  	if (!spin_trylock(&pcp->lock)) {
>  		pcp_trylock_finish(UP_flags);
> +		local_unlock_irqrestore(&pagesets.lock, flags);
>  		return NULL;
>  	}
>  
> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> android-binder-stop-saving-a-pointer-to-the-vma-fix.patch
> mm-remove-the-vma-linked-list-fix-2-fix.patch
> mm-drop-oom-code-from-exit_mmap-fix-fix.patch
> mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
> mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
> xfs-support-cow-in-fsdax-mode-fix.patch
> mm-thp-kill-transparent_hugepage_active-fix.patch
> mm-thp-kill-transparent_hugepage_active-fix-fix.patch
> mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
> x86-mm-move-protection_map-inside-the-platform-fix.patch
> 

