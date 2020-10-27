Return-Path: <SRS0=3fxC=EC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1242DC4363A
	for <mm-commits@archiver.kernel.org>; Tue, 27 Oct 2020 07:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D26821655
	for <mm-commits@archiver.kernel.org>; Tue, 27 Oct 2020 07:22:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=suse.com header.i=@suse.com header.b="d6M8TpMg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507479AbgJ0HWA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Oct 2020 03:22:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:59106 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729271AbgJ0HWA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Oct 2020 03:22:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1603783318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TmuZ8zhZPmepFRxM6bt5pmLkWrCFK9JQ4JV+HfzBf9g=;
        b=d6M8TpMg4lq+XO5l6wv7jmIGxD1IzC6/phBKAyJ0cH6GDhssFwRbr9gFhcdrupn9NKsV7o
        SVH/RzcCJWaDJFxcwz6VrvvM1beEnLAPc1xPKyKdoxIfJlrxtB2IcE2GW4Aq5zTWVgFV9F
        dlQkvZZCOvGMWOhLg99JiJTE49Ro2A0=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 678DEAF43;
        Tue, 27 Oct 2020 07:21:58 +0000 (UTC)
Date:   Tue, 27 Oct 2020 08:21:57 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     linux-kernel@vger.kernel.org
Cc:     akpm@linux-foundation.org, hannes@cmpxchg.org,
        mm-commits@vger.kernel.org, zhongjiang-ali@linux.alibaba.com
Subject: Re: +
 mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix.patch
 added to -mm tree
Message-ID: <20201027072157.GO20500@dhcp22.suse.cz>
References: <20201026210801.n9JtTzchy%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026210801.n9JtTzchy%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon 26-10-20 14:08:01, Andrew Morton wrote:
[...]
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix
> 
> fix printk warning
> 
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/memcontrol.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/memcontrol.c~mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix
> +++ a/mm/memcontrol.c
> @@ -4107,7 +4107,7 @@ static int memcg_stat_show(struct seq_fi
>  		if (memcg1_stats[i] == NR_ANON_THPS)
>  			nr *= HPAGE_PMD_NR;
>  #endif
> -		seq_printf(m, "total_%s %llu\n", memcg1_stat_names[i],
> +		seq_printf(m, "total_%s %lu\n", memcg1_stat_names[i],
>  						nr * PAGE_SIZE);

Shouldn't we cast to u64 instead? 32b systems with a lot of memory are
quite rare but going over 4G here is not something unimaginable. The
similar is true for other counters.
-- 
Michal Hocko
SUSE Labs
