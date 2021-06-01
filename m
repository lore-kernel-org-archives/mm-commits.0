Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57178C47080
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 04:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B5A561376
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 04:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhFAFAG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Jun 2021 01:00:06 -0400
Received: from foss.arm.com ([217.140.110.172]:39436 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229477AbhFAFAF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 1 Jun 2021 01:00:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A66BF1FB;
        Mon, 31 May 2021 21:58:24 -0700 (PDT)
Received: from [10.163.82.105] (unknown [10.163.82.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B8333F774;
        Mon, 31 May 2021 21:58:22 -0700 (PDT)
Subject: Re: + mmmemory_hotplug-drop-unneeded-locking-fix.patch added to -mm
 tree
To:     akpm@linux-foundation.org, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, vbabka@suse.cz
References: <20210601044408.Ygs_iaqpD%akpm@linux-foundation.org>
From:   Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <270fa0b2-bc7e-f8af-61eb-67ccaa3feea0@arm.com>
Date:   Tue, 1 Jun 2021 10:29:07 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210601044408.Ygs_iaqpD%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 6/1/21 10:14 AM, akpm@linux-foundation.org wrote:
> The patch titled
>      Subject: mmmemory_hotplug-drop-unneeded-locking-fix
> has been added to the -mm tree.  Its filename is
>      mmmemory_hotplug-drop-unneeded-locking-fix.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mmmemory_hotplug-drop-unneeded-locking-fix.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mmmemory_hotplug-drop-unneeded-locking-fix.patch
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
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mmmemory_hotplug-drop-unneeded-locking-fix
> 
> remove now-unused locals
> 
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/memory_hotplug.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> --- a/mm/memory_hotplug.c~mmmemory_hotplug-drop-unneeded-locking-fix
> +++ a/mm/memory_hotplug.c
> @@ -397,7 +397,7 @@ void __ref remove_pfn_range_from_zone(st
>  {
>  	const unsigned long end_pfn = start_pfn + nr_pages;
>  	struct pglist_data *pgdat = zone->zone_pgdat;
> -	unsigned long pfn, cur_nr_pages, flags;
> +	unsigned long pfn, cur_nr_pages;
>  
>  	/* Poison struct pages because they are now uninitialized again. */
>  	for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
> @@ -630,7 +630,6 @@ void __ref move_pfn_range_to_zone(struct
>  {
>  	struct pglist_data *pgdat = zone->zone_pgdat;
>  	int nid = pgdat->node_id;
> -	unsigned long flags;
>  
>  	clear_zone_contiguous(zone);
>  
> @@ -727,8 +726,6 @@ struct zone *zone_for_pfn_range(int onli
>   */
>  void adjust_present_page_count(struct zone *zone, long nr_pages)
>  {
> -	unsigned long flags;
> -
>  	zone->present_pages += nr_pages;
>  	zone->zone_pgdat->node_present_pages += nr_pages;
>  }
> _

Yeah indeed. Without this patch, there are some build warnings.

mm/memory_hotplug.c: In function ‘remove_pfn_range_from_zone’:
mm/memory_hotplug.c:516:35: warning: unused variable ‘flags’ [-Wunused-variable]
  unsigned long pfn, cur_nr_pages, flags;
                                   ^~~~~
mm/memory_hotplug.c: In function ‘move_pfn_range_to_zone’:
mm/memory_hotplug.c:749:16: warning: unused variable ‘flags’ [-Wunused-variable]
  unsigned long flags;
                ^~~~~
mm/memory_hotplug.c: In function ‘adjust_present_page_count’:
mm/memory_hotplug.c:846:16: warning: unused variable ‘flags’ [-Wunused-variable]
  unsigned long flags;
                ^~~~~
