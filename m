Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 502A2C4361B
	for <mm-commits@archiver.kernel.org>; Mon,  7 Dec 2020 09:00:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BA6623341
	for <mm-commits@archiver.kernel.org>; Mon,  7 Dec 2020 09:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgLGJAM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:00:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42411 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726083AbgLGJAM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2020 04:00:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607331529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8K41Zx9hmF0XbY232+l+gSsS96Mr1ICD4AgjtdBRXzo=;
        b=VSXN//4jtIjXtbOukXQWu2l450aOql9VITvQwbgEuJpfIM2hn58FXIlK9qnSYGPKaf6kqH
        5py8KXS/pR3NALdggXnOFwe2bCQhj/05m+Ae4fhGmlFGuqQCx9RPvaNra53cR1H3S+1nM+
        yoUQcCkvje8WLBikgvsn/tbjRggOhAA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-l15_P3LQP72ZCuSiMEZ5Tw-1; Mon, 07 Dec 2020 03:58:42 -0500
X-MC-Unique: l15_P3LQP72ZCuSiMEZ5Tw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 240E4809DCD;
        Mon,  7 Dec 2020 08:58:40 +0000 (UTC)
Received: from [10.36.114.33] (ovpn-114-33.ams2.redhat.com [10.36.114.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29BC960BD8;
        Mon,  7 Dec 2020 08:58:37 +0000 (UTC)
Subject: Re: +
 mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
 added to -mm tree
To:     akpm@linux-foundation.org, aarcange@redhat.com, bhe@redhat.com,
        cai@lca.pw, mgorman@suse.de, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        stable@vger.kernel.org, vbabka@suse.cz
References: <20201206005401.qKuAVgOXr%akpm@linux-foundation.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <cb3bfacb-821d-6251-03c5-498dd07727cd@redhat.com>
Date:   Mon, 7 Dec 2020 09:58:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201206005401.qKuAVgOXr%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 06.12.20 01:54, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm: initialize struct pages in reserved regions outside of the zone ranges
> has been added to the -mm tree.  Its filename is
>      mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
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
> From: Andrea Arcangeli <aarcange@redhat.com>
> Subject: mm: initialize struct pages in reserved regions outside of the zone ranges
> 
> Without this change, the pfn 0 isn't in any zone spanned range, and it's
> also not in any memory.memblock range, so the struct page of pfn 0 wasn't
> initialized and the PagePoison remained set when reserve_bootmem_region
> called __SetPageReserved, inducing a silent boot failure with DEBUG_VM
> (and correctly so, because the crash signaled the nodeid/nid of pfn 0
> would be again wrong).
> 
> There's no enforcement that all memblock.reserved ranges must overlap
> memblock.memory ranges, so the memblock.reserved ranges also require an
> explicit initialization and the zones ranges need to be extended to
> include all memblock.reserved ranges with struct pages too or they'll be
> left uninitialized with PagePoison as it happened to pfn 0.
> 
> Link: https://lkml.kernel.org/r/20201205013238.21663-2-aarcange@redhat.com
> Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Mike Rapoport <rppt@linux.ibm.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Qian Cai <cai@lca.pw>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[...]

I've lost track which patches are we considering right now to solve the
overall issue. I'd appreciate a proper patch series with all relevant
patches.

-- 
Thanks,

David / dhildenb

