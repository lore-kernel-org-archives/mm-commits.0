Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA938C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  7 Apr 2022 10:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbiDGKQe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Apr 2022 06:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiDGKQe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2022 06:16:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92A6346143
        for <mm-commits@vger.kernel.org>; Thu,  7 Apr 2022 03:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649326473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xg/VZ8tasqRPnaI2wLtpB17g9X4vJD+c3jUQkg8EESU=;
        b=cQlv6AcoNfol8SwhxdnxwpPAHCbC2hW0nrJ/6fsjB3LEL1h0oirThMwSjYSckuNqxjaXsx
        Ip8jP7tgP/2VAP/QvW+huooEqMoZLA9I4eSqEgNQ0nYY3ZubOZ6Oz00ia9EYKEQcueSrC3
        Q8/uj8VWF6rmqShbryCtdvuYmxpi9cA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-57--D51dnK6NmK4U8NoNNza2A-1; Thu, 07 Apr 2022 06:14:32 -0400
X-MC-Unique: -D51dnK6NmK4U8NoNNza2A-1
Received: by mail-wm1-f70.google.com with SMTP id t2-20020a7bc3c2000000b003528fe59cb9so2756166wmj.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Apr 2022 03:14:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=Xg/VZ8tasqRPnaI2wLtpB17g9X4vJD+c3jUQkg8EESU=;
        b=wjvT32eV3onLDOJBLqN1RDbNOGs3cYuVYNVP0Mu3t01HkoA5Lv1aMrcr+xtzThyeDO
         F/CpL3h/4HiJUKQkJ4CPCnxVM41ui5SvxiGy8peu5vOOocnSDuUQQXryafD6F/V/x/nV
         CL5NCeucKTcMZebzU6F0N11NIQ0tC8DxKfpVwkQmRSVB7G40+PHAjEpvK5i+ZvX3eXdM
         bZ4Ecin6mapRHqZHQH/yyBcENgdGUO6SKhMSf/s7xooU5vqIZ+mFbZJQmRee7HIJZclx
         dTQHM2ByseX28PlVwD/lGjx0sCIrlXf2nXGb2+c4NatHOpRfV9ZJfehE7qoHberVbAsK
         i6zQ==
X-Gm-Message-State: AOAM532uj4UOFXsUP9SM19jK2nyoizsMp9N2j30w47ZY+0zXfGxNhfWT
        5O7FvZDefmWLuT3nKbDdwWKOeLXZdcTEL8QzOi6QA6ViEz2OWCUO3wWAaX6JjC3x+u3NzG/G3eQ
        r3FJ18Qr5m/brSDLa1+iccA==
X-Received: by 2002:a5d:47c5:0:b0:205:dfac:4d66 with SMTP id o5-20020a5d47c5000000b00205dfac4d66mr10599642wrc.660.1649326471425;
        Thu, 07 Apr 2022 03:14:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfphK4UKHEyvMjjXGqGllHPIko4HesSzrXk+vrIuT/u63hVThQIHpD+75Ra3hl+KSAiZJxWA==
X-Received: by 2002:a5d:47c5:0:b0:205:dfac:4d66 with SMTP id o5-20020a5d47c5000000b00205dfac4d66mr10599612wrc.660.1649326471179;
        Thu, 07 Apr 2022 03:14:31 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:20af:34be:985b:b6c8? ([2a09:80c0:192:0:20af:34be:985b:b6c8])
        by smtp.gmail.com with ESMTPSA id m187-20020a1c26c4000000b0038e9a8b2139sm239081wmm.11.2022.04.07.03.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 03:14:30 -0700 (PDT)
Message-ID: <f268496c-fedb-12b4-21d3-fd034a607ccb@redhat.com>
Date:   Thu, 7 Apr 2022 12:14:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: +
 mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page.patch
 added to -mm tree
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, rppt@kernel.org,
        rostedt@goodmis.org, osalvador@suse.de,
        mgorman@techsingularity.net, ziy@nvidia.com
References: <20220404215046.0B0ADC2BBE4@smtp.kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220404215046.0B0ADC2BBE4@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 04.04.22 23:50, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm: page_alloc: simplify pageblock migratetype check in __free_one_page()
> has been added to the -mm tree.  Its filename is
>      mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page.patch
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
> From: Zi Yan <ziy@nvidia.com>
> Subject: mm: page_alloc: simplify pageblock migratetype check in __free_one_page()
> 
> Move pageblock migratetype check code in the while loop to simplify the
> logic. It also saves redundant buddy page checking code.
> 

Again, sorry for having to reply here. Looks like a really nice cleanup
to me!

Acked-by: David Hildenbrand <david@redhat.com>

> Link: https://lkml.kernel.org/r/20220401230804.1658207-1-zi.yan@sent.com
> Link: https://lore.kernel.org/linux-mm/27ff69f9-60c5-9e59-feb2-295250077551@suse.cz/
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---




-- 
Thanks,

David / dhildenb

