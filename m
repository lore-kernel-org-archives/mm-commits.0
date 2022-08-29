Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5ACAC0502C
	for <mm-commits@archiver.kernel.org>; Mon, 29 Aug 2022 07:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiH2HkZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Aug 2022 03:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiH2HkX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2022 03:40:23 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97054635F
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 00:40:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4BD6D1F97F;
        Mon, 29 Aug 2022 07:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661758821; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JngmQewY1Yz/iELx9FbL0aryLQ/EM6C/hI1HUuujc+w=;
        b=swVO81QpruFmANkBw7i0xdGhAR6aU03Vw0qcposyzgbpgEkhA4ivuhK1aJX7ex93fm3GYS
        kORx3HzEQUWKeEcyt6/XR3TkPc1g32QfTddrLloYOFcolPw47SA5PzDPMm38vWG2DC+atT
        TccRTXUxfcfaRSL2kc1OLAVeotFJfd8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2E57F133A6;
        Mon, 29 Aug 2022 07:40:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id u/s0CGVtDGPNcgAAMHmgww
        (envelope-from <mhocko@suse.com>); Mon, 29 Aug 2022 07:40:21 +0000
Date:   Mon, 29 Aug 2022 09:40:20 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, lkp@intel.com
Subject: Re: + mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix-2.patch
 added to mm-unstable branch
Message-ID: <YwxtZGk0w3m8gqu+@dhcp22.suse.cz>
References: <20220828001055.7C0D8C433C1@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220828001055.7C0D8C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat 27-08-22 17:10:54, Andrew Morton wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix-2
> Date: Sat Aug 27 05:06:06 PM PDT 2022
> 
> fix arch/sparc/kernel/setup_32.c

Thanks for fixing this up Andrew!

> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/sparc/kernel/setup_32.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/arch/sparc/kernel/setup_32.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix-2
> +++ a/arch/sparc/kernel/setup_32.c
> @@ -83,7 +83,7 @@ static void prom_sync_me(void)
>  			     "nop\n\t" : : "r" (&trapbase));
>  
>  	prom_printf("PROM SYNC COMMAND...\n");
> -	show_free_areas(0, NULL);
> +	show_free_areas(0, NULL, GFP_HIGHUSER_MOVABLE);
>  	if (!is_idle_task(current)) {
>  		local_irq_enable();
>  		ksys_sync();
> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> asm-generic-sections-refactor-memory_intersects-fix.patch
> mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix.patch
> procfs-add-path-to-proc-pid-fdinfo-fix.patch
> zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
> mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
> mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
> zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
> mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
> mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
> mm-drop-oom-code-from-exit_mmap-fix-fix.patch
> mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
> mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
> mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
> hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache-fix.patch
> hugetlb-handle-truncate-racing-with-page-faults-fix-fix.patch
> mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix-2.patch
> mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
> page_ext-introduce-boot-parameter-early_page_ext-fix.patch
> mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch
> ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

-- 
Michal Hocko
SUSE Labs
