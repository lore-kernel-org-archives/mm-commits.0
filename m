Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2FC4C433B4
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 20:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7443C613B5
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 20:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbhEMUUH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 16:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbhEMUUG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 May 2021 16:20:06 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA6BC061574
        for <mm-commits@vger.kernel.org>; Thu, 13 May 2021 13:18:55 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id f12so22668275ljp.2
        for <mm-commits@vger.kernel.org>; Thu, 13 May 2021 13:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LSZ3O17SkqT99NwF7rw0f06JHeh09vW12YOh0BsVlxc=;
        b=eCTC0yv81eY0MzfrvTPfpmgwKfJ7ZSEe+RjDJKUxpm6sV0+T0mmaCuhYiOLzRf+pjU
         QgiHJjcAF8t01O2ZCnG8FyrJOGC8npjLzuln+l+aqKGbNDBni6r3kI5rmU8cefj8QClr
         6jtZBRIqCtjiuQhIhmM5TxDLynsFUZSD7LuRyfdwZfrNv7aLHWkqUU94j+f8mABVJVwa
         qotA+cAO1QiqP0SPhXNPGUcrc7XLTYDxYJ4L0baiSFtQVt0N6QmdgJ6ppWkFlOgh07c6
         ouiU43u9EHkL+wTy/1atT4fqH8Co0Q+fAMSrrgCmbUmzBbM9nmP6Cv8h1saHpGLNTCnl
         qzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LSZ3O17SkqT99NwF7rw0f06JHeh09vW12YOh0BsVlxc=;
        b=VMSY1aUI7iFeGOhiU9F/YrB75twQE5w8vkdj6qDDO4GvlnTmCXNFbYZuiUEx5Kq72y
         /qnhBO6HI1BPA7HK+6x+pgIIIz3h2J+BNjXGGhHAPYSwcjI1DlfMehkgfqxbH/ibou3P
         aVWudeoflS7yMYP8KQq56Je7SsRPZKrYgBCrR/tx/ixQJ0udrPUrVgfm1rHfE4NtYsGs
         GeJBF0BH4lucf0NZ/N1898OoJiEe9hTfW/ol5nmTok2xSLf3KBIS8T4ChbDdHiW8IesS
         0Ml+O9y4aso0G14R4zdyPWpRBVNQXbnLA8JKeqbUc9wj/UeGD2XzE0q7ouZYS2HJFz4W
         o3Uw==
X-Gm-Message-State: AOAM531lt47iKu3Js7w7mwaYybJMr2IbpRrDVa9MSjyOWm6LQim+nWx5
        JavnOBagMCdx/JANkwQ9IZHnC6/I1y8=
X-Google-Smtp-Source: ABdhPJwEDIj2sbCT+9Q0aLl/kmTVEq34HpZFMl54zIK1erbeQY2tHl9V9kKdNKRjuccbYTROyqdKbg==
X-Received: by 2002:a2e:9a54:: with SMTP id k20mr35684938ljj.448.1620937133780;
        Thu, 13 May 2021 13:18:53 -0700 (PDT)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id z204sm382610lfa.212.2021.05.13.13.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 13:18:53 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Thu, 13 May 2021 22:18:51 +0200
To:     Mel Gorman <mgorman@suse.de>
Cc:     Uladzislau Rezki <urezki@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <hdanton@sina.com>,
        Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [failures]
 mm-vmalloc-print-a-warning-message-first-on-failure.patch removed from -mm
 tree
Message-ID: <20210513201851.GA55390@pc638.lan>
References: <20210512202952.PRR7JClh8%akpm@linux-foundation.org>
 <20210513085602.6d3f9d63@canb.auug.org.au>
 <20210513103156.GA1856@pc638.lan>
 <20210513111153.GL3672@suse.de>
 <20210513124605.GA3263@pc638.lan>
 <20210513132418.GA1425@pc638.lan>
 <20210513141858.GM3672@suse.de>
 <CA+KHdyXwdkosDYk4bKtRLVodrwUJnq3NN39xuRQzKJSPTn7+bQ@mail.gmail.com>
 <20210513155133.GN3672@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513155133.GN3672@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, May 13, 2021 at 04:51:33PM +0100, Mel Gorman wrote:
> On Thu, May 13, 2021 at 05:29:05PM +0200, Uladzislau Rezki wrote:
> > Could you please send your config? I will try to reproduce with it.
> > 
> 
> Attached.
> 
Thanks.

With your .config file i am able to reproduce the kernel panic. Actually
when a one page is requested the __alloc_pages_bulk() enters to the single
page allocator:

<snip>
    /* Use the single page allocator for one page. */
    if (nr_pages - nr_populated == 1)
        goto failed;

...

failed:
    page = __alloc_pages(gfp, 0, preferred_nid, nodemask);
    if (page) {
        if (page_list)
            list_add(&page->lru, page_list);
        else
            page_array[nr_populated] = page;
                nr_populated++;
    }

    return nr_populated;
<snip>

From the trace i get:

<snip>
[    0.243916] RIP: 0010:__alloc_pages+0x11e/0x310
[    0.243916] Code: 84 c0 0f 85 02 01 00 00 89 d8 48 8b 54 24 08 8b 74 24 1c c1 e8 0c 83 e0 01 88 44 24 20 48 8b 04 24 48 85 d2 0f 85 71 01 00 00 <3b> 70 08 0f 82 68 01 00 00 48 89 44 24 10 48 8b 00 89 da 81 e2 00
[    0.243916] RSP: 0000:ffffffffae803c38 EFLAGS: 00010246
[    0.243916] RAX: 0000000000001cc0 RBX: 0000000000002102 RCX: 0000000000000004
[    0.243916] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000002102
[    0.243916] RBP: 0000000000000000 R08: 0000000000000000 R09: c0000000ffffdfff
[    0.243916] R10: 0000000000000001 R11: ffffffffae803ac0 R12: 0000000000000000
[    0.243916] R13: 0000000000002102 R14: 0000000000000001 R15: ffffa0938000d000
[    0.243916] FS:  0000000000000000(0000) GS:ffff893ab7c00000(0000) knlGS:0000000000000000
[    0.243916] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.243916] CR2: 0000000000001cc8 CR3: 0000000176e10000 CR4: 00000000000006b0
[    0.243916] Call Trace:
[    0.243916]  __alloc_pages_bulk+0xaa1/0xb50
<snip>

(gdb) l *__alloc_pages+0x11e
0xffffffff8129d87e is in __alloc_pages (./include/linux/mmzone.h:1095).
1090            return zoneref->zone;
1091    }
1092
1093    static inline int zonelist_zone_idx(struct zoneref *zoneref)
1094    {
1095            return zoneref->zone_idx;
1096    }
1097
1098    static inline int zonelist_node_idx(struct zoneref *zoneref)
1099    {
(gdb)

Seems like "zoneref" refers to invalid address.

Thoughts?

--
Vlad Rezki
