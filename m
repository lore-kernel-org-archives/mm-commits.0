Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DFAFC001B0
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 14:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbjHNOLM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 10:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbjHNOKn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 10:10:43 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA51194
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 07:10:41 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id d75a77b69052e-4103cec468fso15199551cf.3
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 07:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20221208.gappssmtp.com; s=20221208; t=1692022241; x=1692627041;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=df4a7aErotapnIZ6Fz97b3regIjj5Nr56gv+6cfM8A0=;
        b=eHyL508/jE8mMlPVttTJcRecU1Z1fbVkmoCPVxEQLI1LQIE6XT0NfZUhZChjXh3L78
         Qn9xf4R0W86+vnHUBaXLs75nrZjC52V5LYvJ3RET+kZYte7PB4C4GTa3IifkGIKjYHDi
         Ln+goDR6mwoKHmMNV79NDSou4LYTvg8PIvpaSUYiltRKCIUuiDw38Ataxk4BUkWs2ajC
         3xHUj2uiAdcBZ9uIx7dkgDQQvLL6l4tPOEZbCSvVwcZAa6+4lpXQDOaDZVKQQ1kFar9/
         n5P1SCe+A3MVpdMWEzhFT6aLGpoRkdjAKWc7OcyBsLfARaFlORo78Jz7QKHECMuG3btK
         qT2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692022241; x=1692627041;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=df4a7aErotapnIZ6Fz97b3regIjj5Nr56gv+6cfM8A0=;
        b=G/D5kYWurkfs/9NslJF+5gczd5nw/Kk2sgfXZQmTZzjzctBOkIB4G53HuOApLY9QiX
         CbhAPmOvZ9jNtqoIPi8LDKFbVIBxiT8e1nLadzgV08k0uQtY0h3E1++Y18pNuaQfN8QG
         YyjjKcgBlzxiRQJ6PhlNBdsmCsjiJJ24+b1L884xzRF6lj/zSokjmI52FKn8ig/wpxaS
         mfwNEAez/puKVTxxS1RVvk+lZzGkaUvBFoL2iZY7ky7+3C728bVBRksUQFO9JqtAIQ+V
         Y2mPh6B5ETGUmNfzNJtIwCgp/Gz6vT39rYmFxR+OrvZPgBQUGJigL9CV1iOksg0FO3FT
         1Q7g==
X-Gm-Message-State: AOJu0YzKmj3gdiG2wcKov+ttrk4wgZ4e85XhxRPeHdjAd5VstE0TGZLe
        cWaCKJGDRV1DDxmzY0mT1s8dAQ==
X-Google-Smtp-Source: AGHT+IEoYq1AIzl1N0KVzRcFBjT2RNkQzxajfvrwl/tlbfTq+l/93FYlIb0EvU7Z7VSPY3yIgJeyXw==
X-Received: by 2002:ac8:58d1:0:b0:40a:eb3e:b27b with SMTP id u17-20020ac858d1000000b0040aeb3eb27bmr14291810qta.43.1692022240849;
        Mon, 14 Aug 2023 07:10:40 -0700 (PDT)
Received: from localhost (2603-7000-0c01-2716-8f57-5681-ccd3-4a2e.res6.spectrum.com. [2603:7000:c01:2716:8f57:5681:ccd3:4a2e])
        by smtp.gmail.com with ESMTPSA id i10-20020a37c20a000000b0076768dfe53esm3026644qkm.105.2023.08.14.07.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 07:10:40 -0700 (PDT)
Date:   Mon, 14 Aug 2023 10:10:39 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, willy@infradead.org,
        fengwei.yin@intel.com
Subject: Re: + mm-kill-frontswap-fix-fix.patch added to mm-unstable branch
Message-ID: <20230814141039.GA5860@cmpxchg.org>
References: <20230811171954.7F381C433C7@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230811171954.7F381C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Aug 11, 2023 at 10:19:53AM -0700, Andrew Morton wrote:
> From: Yin Fengwei <fengwei.yin@intel.com>
> Subject: zswap: don't warn if none swapcache folio is passed to zswap_load
> Date: Thu, 10 Aug 2023 17:56:52 +0800
> 
> With mm-unstable branch, if trigger swap activity and it's possible
> see following warning:
> [  178.093511][  T651] WARNING: CPU: 2 PID: 651 at mm/zswap.c:1387 zswap_load+0x67/0x570
> [  178.095155][  T651] Modules linked in:
> [  178.096103][  T651] CPU: 2 PID: 651 Comm: gmain Not tainted 6.5.0-rc4-00492-gad3232df3e41 #148
> [  178.098372][  T651] Hardware name: QEMU Standard PC (i440FX + PIIX,1996), BIOS 1.14.0-2 04/01/2014
> [  178.101114][  T651] RIP: 0010:zswap_load+0x67/0x570
> [  178.102359][  T651] Code: a0 78 4b 85 e8 ea db ff ff 48 8b 00 a8 01 0f 84 84 04 00 00 48 89 df e8 d7 db ff ff 48 8b 00 a9 00 00 08 00 0f 85 c4
> [  178.106376][  T651] RSP: 0018:ffffc900011b3760 EFLAGS: 00010246
> [  178.107675][  T651] RAX: 0017ffffc0080001 RBX: ffffea0004a991c0 RCX:ffffc900011b37dc
> [  178.109242][  T651] RDX: 0000000000000000 RSI: 0000000000000001 RDI:ffffea0004a991c0
> [  178.110916][  T651] RBP: ffffea0004a991c0 R08: 0000000000000243 R09:00000000c9a1aafc
> [  178.112377][  T651] R10: 00000000c9657db3 R11: 000000003c9657db R12:0000000000014b9c
> [  178.113698][  T651] R13: ffff88813501e710 R14: ffff88810d591000 R15:0000000000000000
> [  178.115008][  T651] FS:  00007fb21a9ff700(0000) GS:ffff88813bc80000(0000) knlGS:0000000000000000
> [  178.116423][  T651] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  178.117421][  T651] CR2: 00005632cbfc81f6 CR3: 0000000131450002 CR4:0000000000370ee0
> [  178.118683][  T651] DR0: 0000000000000000 DR1: 0000000000000000 DR2:0000000000000000
> [  178.119894][  T651] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:0000000000000400
> [  178.121087][  T651] Call Trace:
> [  178.121654][  T651]  <TASK>
> [  178.122109][  T651]  ? zswap_load+0x67/0x570
> [  178.122658][  T651]  ? __warn+0x81/0x170
> [  178.123119][  T651]  ? zswap_load+0x67/0x570
> [  178.123608][  T651]  ? report_bug+0x167/0x190
> [  178.124150][  T651]  ? handle_bug+0x3c/0x70
> [  178.124615][  T651]  ? exc_invalid_op+0x13/0x60
> [  178.125192][  T651]  ? asm_exc_invalid_op+0x16/0x20
> [  178.125753][  T651]  ? zswap_load+0x67/0x570
> [  178.126231][  T651]  ? lock_acquire+0xbb/0x290
> [  178.126745][  T651]  ? folio_add_lru+0x40/0x1c0
> [  178.127261][  T651]  ? find_held_lock+0x2b/0x80
> [  178.127776][  T651]  swap_readpage+0xc7/0x5c0
> [  178.128273][  T651]  do_swap_page+0x86d/0xf50
> [  178.128770][  T651]  ? __pte_offset_map+0x3e/0x290
> [  178.129321][  T651]  ? __pte_offset_map+0x1c4/0x290
> [  178.129883][  T651]  __handle_mm_fault+0x6ad/0xca0
> [  178.130419][  T651]  handle_mm_fault+0x18b/0x410
> [  178.130992][  T651]  do_user_addr_fault+0x1f1/0x820
> [  178.132076][  T651]  exc_page_fault+0x63/0x1a0
> [  178.132599][  T651]  asm_exc_page_fault+0x22/0x30
> 
> It's possible that swap_readpage() is called with a non swapcache page in
> do_swap_page() and triggers this warning.  So we shouldn't assume
> zswap_load() always takes swapcache pages.
> 
> Link: https://lkml.kernel.org/r/20230810095652.3905184-1-fengwei.yin@intel.com
> Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Looks good to me, thanks for the fix.
