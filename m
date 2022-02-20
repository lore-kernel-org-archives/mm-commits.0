Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6462C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 20 Feb 2022 04:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241475AbiBTETx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Feb 2022 23:19:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiBTETx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 19 Feb 2022 23:19:53 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DC845511
        for <mm-commits@vger.kernel.org>; Sat, 19 Feb 2022 20:19:32 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id j12so27402505ybh.8
        for <mm-commits@vger.kernel.org>; Sat, 19 Feb 2022 20:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NzStXy+ij/GXIXhymSk0ZBPsedXPziDUSZg1MI2RABk=;
        b=3iGxiuXzrKO23p80sgNUTPUE9KnKJRmDdKNz9VVFfKSkjR98qB4QcBzi3nAl7eEP3R
         jeIxzpnQlvdzRknMmU3pSIH/3wgyVo6+OraP99UxAdhnAqw1Qo2PI0jAGmscyYHee0ij
         E1J29k42Sf2pZCWv6S//f6rd/KIHmMZk5l9pqtOc03GhxToNgTbbv1U8vW+djVJh7ATq
         bphkJBoUurlM9uQb6V9LwCEL/qXgjAcLINdfTMPJ4pE3dhjYumhLN5wMR+X0ahOrbhdQ
         M629rxYGJhk5Md9H3hjdyH0++rq9gKtr8i3FLZRynVjDg4lhfesjnPcNfmjDny71Cv8R
         WX/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NzStXy+ij/GXIXhymSk0ZBPsedXPziDUSZg1MI2RABk=;
        b=SxJayIeW8YxwC4kOBQnTSDAr3jtxdB8QsluGsGnWs6GW+9rDz94z/90TINBe73gXWf
         OgE2L7pVBzDU91qB/oSdKiscrk8f61HV2eTBBwj2/OHvreEfV4wn6zlnLoUR1GuqktxR
         7t7zBEQLpowhzkqVZeILA6c5EUwbACh8CPPhXyftnPeJPjzpTbeGHzCAEh3W18N0Rn++
         t/2X2g6PiXoCeLE7pQGfz8AJVhAAJotI1EUwiFKRwG2KNUPZk9fpDBrmR6KbWFOULd8s
         D7BpqN00vrlXKj1yrKProcLuorldON+EKkMrB9yiGDD+gBarP25QLPsejxTivI8kW6Zv
         YNiA==
X-Gm-Message-State: AOAM531mMp5GwCLKP+lVWq9JX7Imgr3E1tx8lIaH4cumynyi0CJ/Gciq
        z07PQYCarF0MMu6yx9W3Q1xYtVA/OzSNMFryaoAHIw==
X-Google-Smtp-Source: ABdhPJzr29VtsQl01a51tBi+2CQqQk7+R4hp8463imvFXkOarDFjZrl8LRcBnZ05/Y9+rbgHEa4Dl0sHRDqg0+kZqfg=
X-Received: by 2002:a25:e004:0:b0:61d:967a:814e with SMTP id
 x4-20020a25e004000000b0061d967a814emr13334735ybg.261.1645330771835; Sat, 19
 Feb 2022 20:19:31 -0800 (PST)
MIME-Version: 1.0
References: <20220215220006.AC9C7C340EB@smtp.kernel.org>
In-Reply-To: <20220215220006.AC9C7C340EB@smtp.kernel.org>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Sun, 20 Feb 2022 12:18:55 +0800
Message-ID: <CAMZfGtXT_mVvZSgNWN+mBFqp01g84iYwOE0NFtLD8G2YW4C21w@mail.gmail.com>
Subject: Re: + tools-vm-page_owner-filter-out-pid-and-timestamp.patch added to
 -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        lmark@codeaurora.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        georgi.djakov@linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Feb 16, 2022 at 6:00 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: tools/vm/page_owner: filter out pid and timestamp
> has been added to the -mm tree.  Its filename is
>      tools-vm-page_owner-filter-out-pid-and-timestamp.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner-filter-out-pid-and-timestamp.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner-filter-out-pid-and-timestamp.patch
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
> From: Muchun Song <songmuchun@bytedance.com>
> Subject: tools/vm/page_owner: filter out pid and timestamp
>
> Commit 9cc7e96aa846 ("mm/page_owner: record timestamp and pid") introduces
> timestamp and pid for page owner.  However, it is hard to aggregate the
> stack since those are specific (especially timestamp).  Filter out those
> information when aggregating.
>
> Link: https://lkml.kernel.org/r/20220215134045.12004-1-songmuchun@bytedance.com
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Cc: Liam Mark <lmark@codeaurora.org>
> Cc: Georgi Djakov <georgi.djakov@linaro.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Hi Andrew,

I confirmed this patch could be dropped since this issue is fixed in
Yinan's patch [1].  My patch is based on linux 5.17-rc4, so I didn't
notice that it was already fixed in the next branch but not the Linus
tree.  My bad.

[1] https://lore.kernel.org/lkml/f0a8099b-3c60-3e34-078a-be3c1280ca61@gmail.com/T/

Thanks.
