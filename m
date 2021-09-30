Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6525BC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 22:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44498619E7
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 22:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344107AbhI3WzE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 18:55:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230104AbhI3WzE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 18:55:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7315619E2;
        Thu, 30 Sep 2021 22:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633042400;
        bh=e5hz9QpxJ28/RqCbSNL8eFdj7nhWUsYjbMOcxLE+qgE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=grpAD0tPsIO/cEDyjQjekW+2kDa7hc2KlSFFmF84dvxvF01srmwTw9fjDGDLklGJg
         DMJHuBr7zd0bAUaZLy+f0MgbtIYrMXzySnE4QqUTTI9S5SyivX6ryA4gb0qG97lb2+
         Y2PAGcXhU9Q/8IuzGhWFvW/titA8TvDNb+1Bke6DiDsqlBphXrFScV3WwfzCf4fz8w
         QCCsVkMQcj3zAY35NZF6WmOrB20cCasos28Tl4PbNCMkC97/TI5pWrkYJ33ywTK//7
         On9QooHVqm8LrAdmx+kulqJvumCZlzlgp6uGOeNxSQLIkYT6PZ2TwGWJnIpGY/U2Zr
         ElzCjI7+144rg==
Date:   Thu, 30 Sep 2021 15:53:19 -0700
From:   Mike Rapoport <rppt@kernel.org>
To:     akpm@linux-foundation.org
Cc:     david@redhat.com, geert+renesas@glider.be,
        mm-commits@vger.kernel.org, peng.fan@nxp.com
Subject: Re: + memblock-check-memory-total_size.patch added to -mm tree
Message-ID: <YVY/3zdc6ZYmsq6j@kernel.org>
References: <20210930222304.--OL_47EE%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930222304.--OL_47EE%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Sep 30, 2021 at 03:23:04PM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: memblock: check memory total_size
> has been added to the -mm tree.  Its filename is
>      memblock-check-memory-total_size.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/memblock-check-memory-total_size.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/memblock-check-memory-total_size.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Peng Fan <peng.fan@nxp.com>
> Subject: memblock: check memory total_size
> 
> mem=[X][G|M] is broken on ARM64 platform, there are cases that even
> type.cnt is 1, but total_size is not 0 because regions are merged into 1. 
> So only check 'cnt' is not enough, total_size should be used, othersize
> bootargs 'mem=[X][G|B]' not work anymore.
> 
> Link: https://lkml.kernel.org/r/20210930024437.32598-1-peng.fan@oss.nxp.com
> Fixes: e888fa7bb882 ("memblock: Check memory add/cap ordering")
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: David Hildenbrand <david@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I was planing to take it via memblock tree but since it's already in mmotm:

Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>

> ---
> 
>  mm/memblock.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/memblock.c~memblock-check-memory-total_size
> +++ a/mm/memblock.c
> @@ -1687,7 +1687,7 @@ void __init memblock_cap_memory_range(ph
>  	if (!size)
>  		return;
>  
> -	if (memblock.memory.cnt <= 1) {
> +	if (!memblock_memory->total_size) {
>  		pr_warn("%s: No memory registered yet\n", __func__);
>  		return;
>  	}
> _
> 
> Patches currently in -mm which might be from peng.fan@nxp.com are
> 
> memblock-check-memory-total_size.patch
> 

-- 
Sincerely yours,
Mike.
