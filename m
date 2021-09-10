Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2456DC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 03:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BF5A610CE
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 03:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhIJDUU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 23:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbhIJDUN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Sep 2021 23:20:13 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D936FC061574
        for <mm-commits@vger.kernel.org>; Thu,  9 Sep 2021 20:19:02 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id k23so480613pji.0
        for <mm-commits@vger.kernel.org>; Thu, 09 Sep 2021 20:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=ZyJ5aJ688YFP5BdUD862ESctJBWAWrpF4LKhAWAYN2g=;
        b=BY+b79GknjxGwAAgpE5nAVSQyrNZGFlMCFaZG1JeQDak4ZakmRsTeAUTwdH80M2NAY
         pzQFK36SH1HJ+G1XciQIpWkdD5ueJ/SR1CGWB3/UYkDJfxFfZxpbTBCQgSC1tYsBbW3q
         SQrC7Id2an/nqfMJkYYuGzUhqX0VvSvdBoCD7P5TfAXuYmYaUz9j9WT9C0+YbpMJUNM/
         m+kn6uMxVfJQwuMEFgP1g7xc3c480UmZ/8tJL+EzGgtn8H40DOgDk75W7uAgx3jEzzOH
         vF8BIWbRi1GfJSlTZMyetDl4cEnD+qwWBYA+CGCcV/Q/5IHtatHcf6+FNPTDQefyximK
         O5Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=ZyJ5aJ688YFP5BdUD862ESctJBWAWrpF4LKhAWAYN2g=;
        b=oOUqQ4R8kFq4AamEHVJqvwst+K7QAnXqwi0CoSqYthqD8cV95ytgomgm1aQVzrSKK4
         8XGZ9/VCBJxqTfrHUZwO1c40iUexZPhSMZTFghqfFEwQzOa7iNtIOyEUboP5aM31jq36
         DAJKiwrZ6gtGY4ebbig0q21tDdXpWwlYi8489PFMLrAauaMEuFiatnffkWsnYq9TkvGs
         sA7Qe1hkMEBIhw7veiVnEMF1xZlXh0OTxXRxobbeRQyVJ8he73TajsS2TZDj7y4g73Tm
         PDMc8+NLnO9YrZ+N/x+K6C9PI/UnNQvFo9GZsFv82vM7WoPX1grYCWEMqt/qAUijlju4
         +N/Q==
X-Gm-Message-State: AOAM5304mkB9kBUzVpBARc75W+5rjpfl0EDrmi/4cFUvRXP2qd/VAXSR
        iBOcDbXmcdFs4+zKoCqVvjs1aQ==
X-Google-Smtp-Source: ABdhPJzt6A1D9lv/BKeUU4b8iyy//L0XSDBEiURXKKdgF//bplhW5cU2qe7bzx0SFrImJHNiSUGGdg==
X-Received: by 2002:a17:903:1251:b0:13a:1f5e:20da with SMTP id u17-20020a170903125100b0013a1f5e20damr5760041plh.75.1631243942405;
        Thu, 09 Sep 2021 20:19:02 -0700 (PDT)
Received: from [10.86.116.180] ([139.177.225.230])
        by smtp.gmail.com with ESMTPSA id q12sm3488773pfj.153.2021.09.09.20.18.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 20:19:01 -0700 (PDT)
Subject: Re: [External] Re: [patch 079/147] fs/proc/kcore.c: add mmap
 interface
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        chenying.kernel@bytedance.com, Linux-MM <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <songmuchun@bytedance.com>,
        zhouchengming@bytedance.com, zhengqi.arch@bytedance.com
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
 <20210908025730.S88ylmikU%akpm@linux-foundation.org>
 <CAHk-=wgQ+8kmczLLKCY7yDsGHQBRcZESKd1dNaKbrjUgbWeb3A@mail.gmail.com>
 <fab939c0-42c1-f6ee-f7f8-14280cb5b411@bytedance.com>
 <CAHk-=wjb=emq204cCuW9VWKawbmLRXfHCLHWmyiDysOfs03TiA@mail.gmail.com>
 <CAHk-=wjaBqNTksWwV3OieN7CA0XwBXLnE1PaGJHhb_tQS6=M4Q@mail.gmail.com>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
Message-ID: <dcc3722f-1411-76d3-2c5a-ac87a21276c1@bytedance.com>
Date:   Fri, 10 Sep 2021 11:18:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjaBqNTksWwV3OieN7CA0XwBXLnE1PaGJHhb_tQS6=M4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


在 2021/9/10 上午1:34, Linus Torvalds 写道:
> On Thu, Sep 9, 2021 at 10:32 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> This is basically a very dangerous interface. The fact that it is
>> read-only doesn't change that at all.
> Just to clarify - we've done dangerous interfaces in the past. We
> probably have tons of them still that I haven't even thought about,
> and I think I can hear somebody sniggering from miles away about
> various bugs that cause much more obvious security holes that I didn't
> think of.
>
> But the fact that we might have other holes that can be misused,
> doesn't mean we have to add new ones that seem to be almost designed
> for misuse.
>
>            Linus

Ok, got it.

