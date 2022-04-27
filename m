Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB49AC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 14:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237488AbiD0OTT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 10:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237495AbiD0OTT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 10:19:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD71F2196
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 07:16:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5931861D73
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 14:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB95C385A9;
        Wed, 27 Apr 2022 14:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651068962;
        bh=HyqqSjZM3quGeu1P4ZO2T3reUxnansNz3M0+E5w5woU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jqSSCsjbb5xxHOaeYByYI4w9Ts2B9xL1beb3i4i2eddmNjd+UsOPFlz7vYfMmjsLP
         h5QDJ1fXvPkDJ0bh1FVIfKBJYGyXSUa6gkm+ORmlR8BqWzGXpIWw7stMZet4AbQnR0
         G6NK1zHg05UCPLdUqeukJZhnNnGsYW4I46jHp9ic=
Date:   Wed, 27 Apr 2022 07:16:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     <mm-commits@vger.kernel.org>, <ying.huang@intel.com>,
        <osalvador@suse.de>, <iamjoonsoo.kim@lge.com>, <hch@lst.de>
Subject: Re: [nacked]
 mm-vmscan-activate-swap-backed-executable-folios-after-first-usage.patch
 removed from -mm tree
Message-Id: <20220427071601.d18f105d4934f0362f33472c@linux-foundation.org>
In-Reply-To: <2e567a92-171e-26d5-2830-927c7f2f68a9@huawei.com>
References: <20220427062533.80485C385A7@smtp.kernel.org>
        <2e567a92-171e-26d5-2830-927c7f2f68a9@huawei.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 27 Apr 2022 14:41:30 +0800 Miaohe Lin <linmiaohe@huawei.com> wrote:

> On 2022/4/27 14:25, Andrew Morton wrote:
> > 
> > The patch titled
> >      Subject: mm/vmscan: activate swap-backed executable folios after first usage
> > has been removed from the -mm tree.  Its filename was
> >      mm-vmscan-activate-swap-backed-executable-folios-after-first-usage.patch
> > 
> > This patch was dropped because it was nacked
> 
> Hi Andrew,
> 
> Since this patch is nacked, should I resend the whole series with this patch dropped?
> And I'd like to change this patch to use the helper folio_is_file_lru too, something like below:
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ed484a0e9cd0..60ccbebec4c8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1412,9 +1412,9 @@ static enum page_references folio_check_references(struct folio *folio,
>                         return PAGEREF_ACTIVATE;
> 
>                 /*
> -                * Activate executable folios after first usage.
> +                * Activate file-backed executable folios after first usage.
>                  */
> -               if (vm_flags & VM_EXEC)
> +               if ((vm_flags & VM_EXEC) && folio_is_file_lru(folio))
>                         return PAGEREF_ACTIVATE;
> 
>                 return PAGEREF_KEEP;
> 
> Should I send this patch separately or resend the whole series with this new change attached?
> 

I dropped this patch individually, so there's no need to resend the others.
