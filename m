Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05B2C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 08:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F37961BE6
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 08:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbhKPIyj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Nov 2021 03:54:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232568AbhKPIyg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Nov 2021 03:54:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49FAB63212;
        Tue, 16 Nov 2021 08:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637052694;
        bh=cIzB479FcTi1YKYTcD0IGBDrG02RW0TBnXUfYE62vRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:From;
        b=ZwqiDbYkMJWSut/cURK+5yLwMQmMStCOs2jV09pcKXA43Da3BLrzTR4OyOg9dJ7EZ
         YmkvYqGom5lwrxyZgQKZnL4x0VwnhkGHXkVLhyB0ONjS27qO82uhYSqcGYsYtfj8wa
         gdMOod2+Mkv1JLpIGKKHfSUpRrD5VmsgF0OTUNeXY/DuAFxbIQRO+o0jvCM8e94OBt
         O2Nxz27Ep6EtjhC0F3NKwhOr99KRHetmOguUUAzKw/7bjPcF8rk+J4i6Fpj3FnsJ5R
         ydmtXt3aEBlhEqzpC1QFt0UWoYqirFZdbQV3hZmRe4abd/EiauAunJ+X7dBUBKfMAP
         zndbsexs9Q5MQ==
From:   SeongJae Park <sj@kernel.org>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, sj@kernel.org,
        songmuchun@bytedance.com, xhao@linux.alibaba.com
Subject: Re: + mm-damon-add-age-of-region-tracepoint-support.patch added to -mm tree
Date:   Tue, 16 Nov 2021 08:51:31 +0000
Message-Id: <20211116085131.14719-1-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
In-Reply-To: <20211115174833.d3p7k2klS%akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 15 Nov 2021 09:48:33 -0800 akpm@linux-foundation.org wrote:

> 
> The patch titled
>      Subject: mm/damon: add 'age' of region tracepoint support
> has been added to the -mm tree.  Its filename is
>      mm-damon-add-age-of-region-tracepoint-support.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-add-age-of-region-tracepoint-support.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-add-age-of-region-tracepoint-support.patch
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
> From: Xin Hao <xhao@linux.alibaba.com>
> Subject: mm/damon: add 'age' of region tracepoint support
> 
> In Damon, we can get age information by analyzing the nr_access change,
> But short time sampling is not effective, we have to obtain enough data
> for analysis through long time trace, this also means that we need to
> consume more cpu resources and storage space.
> 
> Now the region add a new 'age' variable, we only need to get the change of
> age value through a little time trace, for example, age has been
> increasing to 141, but nr_access shows a value of 0 at the same time,
> Through this，we can conclude that the region has a very low nr_access
> value for a long time.
> 
> Link: https://lkml.kernel.org/r/b9def1262af95e0dc1d0caea447886434db01161.1636989871.git.xhao@linux.alibaba.com
> Fixes: 2fcb93629ad8 ("mm/damon: add a tracepoint")

This is not true, as 'age' information was not invented at that time.

Other than this,

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

> Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Cc: SeongJae Park <sj@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/trace/events/damon.h |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> --- a/include/trace/events/damon.h~mm-damon-add-age-of-region-tracepoint-support
> +++ a/include/trace/events/damon.h
> @@ -22,6 +22,7 @@ TRACE_EVENT(damon_aggregated,
>  		__field(unsigned long, start)
>  		__field(unsigned long, end)
>  		__field(unsigned int, nr_accesses)
> +		__field(unsigned int, age)
>  	),
>  
>  	TP_fast_assign(
> @@ -30,11 +31,13 @@ TRACE_EVENT(damon_aggregated,
>  		__entry->start = r->ar.start;
>  		__entry->end = r->ar.end;
>  		__entry->nr_accesses = r->nr_accesses;
> +		__entry->age = r->age;
>  	),
>  
> -	TP_printk("target_id=%lu nr_regions=%u %lu-%lu: %u",
> +	TP_printk("target_id=%lu nr_regions=%u %lu-%lu: %u %u",
>  			__entry->target_id, __entry->nr_regions,
> -			__entry->start, __entry->end, __entry->nr_accesses)
> +			__entry->start, __entry->end,
> +			__entry->nr_accesses, __entry->age)
>  );
>  
>  #endif /* _TRACE_DAMON_H */
> _
> 
> Patches currently in -mm which might be from xhao@linux.alibaba.com are
> 
> mm-damon-unified-access_check-function-naming-rules.patch
> mm-damon-add-age-of-region-tracepoint-support.patch
> mm-damon-core-using-function-abs-instead-of-diff_of.patch
> mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch
