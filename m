Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B4FC4320A
	for <mm-commits@archiver.kernel.org>; Tue, 10 Aug 2021 04:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 594EE61078
	for <mm-commits@archiver.kernel.org>; Tue, 10 Aug 2021 04:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbhHJEZw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Aug 2021 00:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhHJEZw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Aug 2021 00:25:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C406C0613D3;
        Mon,  9 Aug 2021 21:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=NEGF5gDAt4pUq5a1i0sb0u/njmzgcJkcsNysFdjs6Ds=; b=cCdkc11sAU8lof2Ri5/OeyAj+c
        lsJc+gaVGkKfob+Bq5asqITNBoKBwsSbgCjL8imznn9NPNXhNhjZo22FEi3V9nt6t46vXiBp0yHY2
        PDYBltHpjuBUpvSH+v0jtiDUZjfCUmquWZtxFeTrUM6CivxlJQwNKE/BCSuKZkjxWhpSYgi/i/6/g
        2ZK++S85SGsTBvaWFAyCJf/oO8tyKrC/r20P0+jyT3ZuZXYpGLsfs65lMHz5i5j7RqqkkZ0kpnuGL
        kyMKSOoePFAts0Hnx7f/8VYYx1r+sA+KQEF1nVCy78XNfkHVtCgYxPMrVjx2rRTMkxsBPL4r4oIFd
        M+7V+CRA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDJKS-002OMd-R5; Tue, 10 Aug 2021 04:25:28 +0000
Subject: Re: mmotm 2021-08-09-19-18 uploaded
To:     akpm@linux-foundation.org, broonie@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
References: <20210810021934.XcpwGUEMn%akpm@linux-foundation.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <3bc14281-4cfe-7cd6-1b88-128e51d08c3a@infradead.org>
Date:   Mon, 9 Aug 2021 21:25:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210810021934.XcpwGUEMn%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 8/9/21 7:19 PM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2021-08-09-19-18 has been uploaded to
> 
>     https://www.ozlabs.org/~akpm/mmotm/
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
> You will need quilt to apply these patches to the latest Linus release (5.x
> or 5.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> https://ozlabs.org/~akpm/mmotm/series
> 
> The file broken-out.tar.gz contains two datestamp files: .DATE and
> .DATE-yyyy-mm-dd-hh-mm-ss.  Both contain the string yyyy-mm-dd-hh-mm-ss,
> followed by the base kernel version against which this patch series is to
> be applied.

Hm, my patch scripts usually work, but this one gives me:

Hunk #5 FAILED at 603.
Hunk #6 FAILED at 701.
2 out of 19 hunks FAILED -- rejects in file include/linux/memcontrol.h
Hunk #6 FAILED at 65.
1 out of 6 hunks FAILED -- rejects in file include/linux/page_idle.h
Hunk #25 FAILED at 6691.
Hunk #26 FAILED at 6702.
Hunk #27 FAILED at 6735.
Hunk #29 FAILED at 6771.
Hunk #33 FAILED at 6900.
Hunk #34 FAILED at 6938.
6 out of 36 hunks FAILED -- rejects in file mm/memcontrol.c
Hunk #9 FAILED at 2711.
Hunk #11 FAILED at 2820.
2 out of 11 hunks FAILED -- rejects in file mm/page-writeback.c

-- 
~Randy

