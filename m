Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5760C43334
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 00:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbiGHAwI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jul 2022 20:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGHAwH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2022 20:52:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A358270E47
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 17:52:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41543B823CC
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 00:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EE9C3411E;
        Fri,  8 Jul 2022 00:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657241523;
        bh=paRWsZPGbGgjdJh+Kw0aMfHgfcD6DiPNmzpghJhkR7o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JFcuxPk2l5PfW3TjlmbPbzrm6O+xWJtzoU6b6oVJmG66qjzX/vIGv+3ldsYb5+hZo
         QKh4pgrTnWzjgPgZTmcDUhkToy3YKmqIbRpaG46bRPJfs4/CZN99DfF+rI3nnwljhg
         575LKaPfCVf5Do32gRKv93w/9brx6FQBJ9vyHV6Y=
Date:   Thu, 7 Jul 2022 17:52:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@suse.cz>,
        mm-commits@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        kernel test robot <lkp@intel.com>, dan.carpenter@oracle.com
Subject: Re: + mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
 added to mm-unstable branch
Message-Id: <20220707175202.19c28f0f711f025c1dc233b6@linux-foundation.org>
In-Reply-To: <CAOUHufZXmSfM78+uLhifozOQacbZX0xM9fjc52Bw5zi+nm8FgQ@mail.gmail.com>
References: <20220707200919.90C41C3411E@smtp.kernel.org>
        <fc7101bb-b9b9-4444-1d8b-4a28ce13f333@suse.cz>
        <CAOUHufZEwtvOhKQZqBp7Lg41eC9tK7hyL_UOUb2RdLKva8U02g@mail.gmail.com>
        <44ae6dd9-c290-ae4a-15e8-593a9cb587ad@suse.cz>
        <2030965f-5f68-c5ea-80a0-34be503de47f@google.com>
        <CAOUHufZXmSfM78+uLhifozOQacbZX0xM9fjc52Bw5zi+nm8FgQ@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 7 Jul 2022 18:35:12 -0600 Yu Zhao <yuzhao@google.com> wrote:

> > This relentless drive towards mm-stable: I for one cannot keep up.
> > I'd like to ask for slowing down a bit - my intention had been to
> > reach testing maple tree again (it's not yet what I'd call stable),
> > but this and a couple of other issues got in the way.  More mails
> > to write.
> 
> Sorry for not being clear (it doesn't seem confusing to me because I
> don't trust the bot):
> 
> There were two reports, the first one [1] tested v4 without the fix
> [2]; the second one [3] tested v5 at patch 5/7 (not the whole series).
> 
> v4 + the fix is good; v5 the whole series is good.
> 
> Please do not drop patch 7/7 and do not add this fix.

As Vlastimil has sleuthed out that the
"BUG:sleeping_function_called_from_invalid_context_at_mm/gup.c"
reporter was using the v4 series, I've restored 7/7 ("mm/page_alloc:
replace local_lock with normal spinlock") for tomorrow's linux-next.

I retained this fix against 2/7 and reworked 7/7 appropriately.  So it
is now

/* Lock and remove page from the per-cpu list */
static struct page *rmqueue_pcplist(struct zone *preferred_zone,
			struct zone *zone, unsigned int order,
			gfp_t gfp_flags, int migratetype,
			unsigned int alloc_flags)
{
	struct per_cpu_pages *pcp;
	struct list_head *list;
	struct page *page;
	unsigned long flags;
	unsigned long __maybe_unused UP_flags;

	/*
	 * spin_trylock may fail due to a parallel drain. In the future, the
	 * trylock will also protect against IRQ reentrancy.
	 */
	pcp_trylock_prepare(UP_flags);
	pcp = pcp_spin_trylock_irqsave(zone->per_cpu_pageset, flags);
	if (!pcp) {
		pcp_trylock_finish(UP_flags);
		return NULL;
	}

	/*
	 * On allocation, reduce the number of pages that are batch freed.
	 * See nr_pcp_free() where free_factor is increased for subsequent
	 * frees.
	 */
	pcp->free_factor >>= 1;
	list = &pcp->lists[order_to_pindex(migratetype, order)];
	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
	pcp_spin_unlock_irqrestore(pcp, flags);
	pcp_trylock_finish(UP_flags);
	if (page) {
		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1);
		zone_statistics(preferred_zone, zone, 1);
	}
	return page;
}

btw, the leading comment implies (to me) that the page is to be locked.
The comment could do with a rethink.


