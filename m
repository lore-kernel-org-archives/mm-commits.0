Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34AB7EB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 17 Jul 2023 14:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjGQOmR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Jul 2023 10:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjGQOmQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jul 2023 10:42:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41857B1
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 07:42:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D34A6610A1
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 14:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8CCC433C7;
        Mon, 17 Jul 2023 14:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689604934;
        bh=DwClaAJuP1zlJ3N8U7+7ID61MV22cJ8QegHdFtpn+J0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S2Uq3B/xP8IIIOLJAPT5hodQ6LmYfbT9I8EfpAjASzPbXR8Itz8iDknrRaI2RyH7q
         onfe6N+7iIsuTcawRv39Hr8BQwaOLab/fCtRmSW+ITUWtUZYEhtVzj+gG23sp2Yba/
         f+tKPhp2b0g52BOGYsmw0yk1bcq0ziSYT+meime89xhQ0QM7odxAHXLRWuwfeX3x51
         mw2ZQJAzpXyfUhvWUz5sNuIXErsnP0EShyN2wAtvl5420gfz0tdmwT+WCov9e3fChx
         zPgQtma5kFEmBnY6BMUSOdpTsHHZE8kQ6nOAdEH2YSmFu8ymgA0ep+6me9EfksIhlP
         suzqO/WqcWbrg==
Date:   Mon, 17 Jul 2023 16:42:09 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, lkp@intel.com
Subject: Re: + shmem-prepare-shmem-quota-infrastructure-fix.patch added to
 mm-unstable branch
Message-ID: <20230717144209.k54yjy6dejfxfeon@andromeda>
References: <pnlDejgUWzkWSV1KWTH_449wfaQdepjMuu_40gcGGn0v_g65bPE9-0M-korBf7DIk_z40Omy_LapMQk0KTTaxw==@protonmail.internalid>
 <20230714155729.B898EC433C7@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230714155729.B898EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jul 14, 2023 at 08:57:29AM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: shmem-prepare-shmem-quota-infrastructure-fix
> has been added to the -mm mm-unstable branch.  Its filename is
>      shmem-prepare-shmem-quota-infrastructure-fix.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-prepare-shmem-quota-infrastructure-fix.patch
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
> Subject: shmem-prepare-shmem-quota-infrastructure-fix
> Date: Fri Jul 14 08:54:52 AM PDT 2023
> 
> make shmem_mark_dquot_dirty and shmem_dquot_write_info static

I just saw this email (after I submitted the last series), I'll fix that and
re-send.

Thanks.

-- 
Carlos

> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202307141341.R961dyMt-lkp@intel.com/
> Cc: Carlos Maiolino <cem@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/shmem_quota.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/mm/shmem_quota.c~shmem-prepare-shmem-quota-infrastructure-fix
> +++ a/mm/shmem_quota.c
> @@ -283,12 +283,12 @@ out_dqlock:
>  	return 0;
>  }
> 
> -int shmem_mark_dquot_dirty(struct dquot *dquot)
> +static int shmem_mark_dquot_dirty(struct dquot *dquot)
>  {
>  	return 0;
>  }
> 
> -int shmem_dquot_write_info(struct super_block *sb, int type)
> +static int shmem_dquot_write_info(struct super_block *sb, int type)
>  {
>  	return 0;
>  }
> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
> swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
> fs-buffer-clean-up-block_commit_write-fix.patch
> mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
> mm-make-pte_marker_swapin_error-more-general-fix.patch
> selinux-use-vma_is_stack-and-vma_is_heap-fix.patch
> shmem-prepare-shmem-quota-infrastructure-fix.patch
> signal-print-comm-and-exe-name-on-fatal-signals-fix.patch
> 
