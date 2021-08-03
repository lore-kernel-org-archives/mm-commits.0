Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_RED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90035C4320E
	for <mm-commits@archiver.kernel.org>; Tue,  3 Aug 2021 05:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CA7560FC2
	for <mm-commits@archiver.kernel.org>; Tue,  3 Aug 2021 05:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbhHCF7l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Aug 2021 01:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbhHCF7k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Aug 2021 01:59:40 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947E3C06175F;
        Mon,  2 Aug 2021 22:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=JFNAfoid2EflvMqbUdr93kxhjGBAuQTt0bwl7NJG+yI=; b=Jao0VIrbTAZbSu26/KOpMR6jzU
        yUOfrChLrufy0HVxHl4tXESKFph39/WYHnXER5g0q9SlbNrAVvo2AxXPW5WE6BrpfOSGsiYH/4D3+
        P8cgv9IXkKVSSYotxIr7YBGDTdWPifEugAG/399Vm2/pUBgXS1oeoQ0e3H5CC19Hvql3Xc05YrlvQ
        wqHHgJjsiuB74D6JJZX4s3rJ/PyzPu9p7cqm1r97ovxUNEKiRRZXtIWuVO8F7kg/8++H1PJWYqo3k
        FOSU3v7VDvJij42T877qTBjoLWGehMBzHqEmw3Zl+9kypsdnvPS41W49gSrCFnet8GWQW1++YAurE
        MiZiFfhQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mAnSY-005LHc-KX; Tue, 03 Aug 2021 05:59:27 +0000
Subject: Re: mmotm 2021-08-02-18-51 uploaded
To:     akpm@linux-foundation.org, broonie@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
References: <20210803015202.vA3c5O7uP%akpm@linux-foundation.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <3ac66120-99f0-c627-c783-500993ff3da0@infradead.org>
Date:   Mon, 2 Aug 2021 22:59:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210803015202.vA3c5O7uP%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 8/2/21 6:52 PM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2021-08-02-18-51 has been uploaded to
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
> 

Andrew:

In linux-next.patch, drivers/net/mctp/Makefile is an empty file, so
patch tools don't include/track it.  Not having it causes build errors
in mmotm.  Just put a comment in it like so:

# dummy file for now

and builds will not have so many errors.


-- 
~Randy

