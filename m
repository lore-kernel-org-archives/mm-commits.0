Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3534C43603
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 21:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0DDC23127
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 21:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437026AbhALVhZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Jan 2021 16:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436994AbhALUjM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Jan 2021 15:39:12 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1E2C061794;
        Tue, 12 Jan 2021 12:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=k6lEBkORUS2MIUUFLMjUpYs9sBD3vnQq1nQpFeRGsZ0=; b=g6odQrZ7u3cYNZnQG3QjejfxzN
        O1f0IN6wC1zuwUZvVPpVw/GsxuWMPffmCf2c4TPLdMNygd1iihBJZVOGPt1q1kMJw7+yLDHrv4k+I
        84Q29lHYt3zCRPL8CIMpsMAZ94Z7UJBCjYkTM95vAYJMGAYgjhVqZcNq5mTMdNdlcYwyr2QESIRDv
        jOe+SA49Bbf3XXpD/nc2EcrBSOOOtc4yeN/VVI9GRp8S+WxrQiPFE4r+pgNtfDk4Rvy/Qk2PHru5X
        qfPLCerlnyELrstiyCTYceC+J6j2yc6TwPjvU1ffv7lg7QHwsNl+htEJUZztOlr7tivpz4ayTiGuY
        3IZbJrwA==;
Received: from [2601:1c0:6280:3f0::79df]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kzQQr-0002Y7-Bn; Tue, 12 Jan 2021 20:38:25 +0000
Subject: Re: mmotm 2021-01-12-01-57 uploaded (NR_SWAPCACHE in mm/)
To:     akpm@linux-foundation.org, broonie@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        Shakeel Butt <shakeelb@google.com>
References: <20210112095806.I2Z6as5al%akpm@linux-foundation.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ac517aa0-2396-321c-3396-13aafba46116@infradead.org>
Date:   Tue, 12 Jan 2021 12:38:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210112095806.I2Z6as5al%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 1/12/21 1:58 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2021-01-12-01-57 has been uploaded to
> 
>    https://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> https://www.ozlabs.org/~akpm/mmotm/
> 
> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> more than once a week.
> 

on i386 and x86_64:

when CONFIG_SWAP is not set/enabled:

../mm/migrate.c: In function ‘migrate_page_move_mapping’:
../mm/migrate.c:504:35: error: ‘NR_SWAPCACHE’ undeclared (first use in this function); did you mean ‘QC_SPACE’?
    __mod_lruvec_state(old_lruvec, NR_SWAPCACHE, -nr);
                                   ^~~~~~~~~~~~

../mm/memcontrol.c:1529:20: error: ‘NR_SWAPCACHE’ undeclared here (not in a function); did you mean ‘SGP_CACHE’?
  { "swapcached",   NR_SWAPCACHE   },
                    ^~~~~~~~~~~~



Reported-by: Randy Dunlap <rdunlap@infradead.org>

-- 
~Randy

