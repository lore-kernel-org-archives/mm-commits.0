Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2248C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 18 May 2022 10:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234800AbiERKCZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 May 2022 06:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234821AbiERKCX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 May 2022 06:02:23 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8655DA6C
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 03:02:21 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2ef5380669cso18309317b3.9
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 03:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rGbXq13Hj0DdTgrkP6uAXSq28STpdmae/Rm+YfRWaVs=;
        b=C7R7Y9zu79J8343fTlwA5pz+Z6fVJQhVhmnZjoDeHjHZlY0MY+ODeV4GpOWwGBGgpy
         YQEtPfogI2UxUMqP2+jMKiklfqJXNEdU8TDLbl8KqDM/kXZwnQlfH6hOEI15yzJSfLgh
         JAN3Y1l+v/J2OfiHGYGx1gblJQen6c55u3g9gjO0x12m82/TsfrtOcfZ9sfGITFIkej9
         T/VnDdomJIWoOafvF9CwTxVDvBihsClpdGGKH05K/fAvDNsbfAltuxXBQXNWkrNwEvoP
         LO4XdWiaxNu1OhHmn8v3R6sGDun20/06yCutLIBao0ISDeHgXf8nORy3lUluG72xNwQf
         OFSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rGbXq13Hj0DdTgrkP6uAXSq28STpdmae/Rm+YfRWaVs=;
        b=u0aaugx5wDyEx6uBkrKPnFwCqeeAnX1nEKgc3jW+imeZZ8/CxnirfvY/vmvIhaGZz7
         3sxnK7AVZylisUSczSucSMcXb3JwJYKgZJ5bBZGEO3QS82ozZaNAohIGkexrD0mbjZMG
         rERLRH9qdXZOFJ8pFpZQX+YwjMPhtvY9f2Mb4llVvaTFPXrDNM9sd7QMvOWMcDKyBJT9
         X/6oxtEsKZ4FTCItSsIaDEwwl5wX2h/EtwKNKGXfrHS/U4bh1K+0Rl5JC16aJseaM1nx
         OfaL7MAui3G7s01nKrv6bqqOf2Rv9snkw2kkC+eeItYH9PYdZXzmMh5sXtL5r5IkTZNe
         9dzQ==
X-Gm-Message-State: AOAM533SEIhVT6wwtpo0/dYdfXbqSbPw5ugQWK9rXRroQgLJndEa/w+7
        i7TLEdvdLT3QRM7XoOxk7pCAz8DWj7kqvNlwwZPPmw==
X-Google-Smtp-Source: ABdhPJypaYrjgdbbm/zbZSG6hyUwkXUzy8dwL0yFeHWcfMwhgdhNONYQLsd012e5w3mfmVmUVNBOmlRU80wKYYwv9Ag=
X-Received: by 2002:a0d:ffc3:0:b0:2eb:2327:3361 with SMTP id
 p186-20020a0dffc3000000b002eb23273361mr29630883ywf.36.1652868140389; Wed, 18
 May 2022 03:02:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220517173936.E461AC34116@smtp.kernel.org>
In-Reply-To: <20220517173936.E461AC34116@smtp.kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 May 2022 15:32:09 +0530
Message-ID: <CA+G9fYsr-=P_LnFoBTpd=HOYbi+r=XDnc7E5bTxNgScdXY56Sw@mail.gmail.com>
Subject: Re: + maple-tree-add-new-data-structure-fix-3.patch added to
 mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>, liam.howlett@oracle.com
Cc:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au, lkft@linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew and Liam R. Howlett,

> From: Liam Howlett <liam.howlett@oracle.com>
> Subject: maple_tree: fix 32b parent pointers
> Date: Tue, 17 May 2022 15:22:20 +0000
>
> 32 bit parent pointers need an extra bit to account for increased slot
> count.  Update the constants and documentation to use the remaining high
> bit.
>
> Link: https://lkml.kernel.org/r/20220517152209.3486724-1-Liam.Howlett@oracle.com
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

My two cents,

I have tested this patch on top of Linux next-20220517
Still I see the following bug.

# [RUN] Test an alternate signal stack of sufficient size.
# Raise SIGALRM. It is[   57.525042] BUG: kernel NULL pointer
dereference, address: 0000000000000000
[   57.532197] #PF: supervisor read access in kernel mode
[   57.537334] #PF: error_code(0x0000) - not-present page
[   57.542464] PGD 800000010f5a4067 P4D 800000010f5a4067 PUD 10b67e067 PMD 0
[   57.549338] Oops: 0000 [#1] PREEMPT SMP PTI
[   57.553523] CPU: 2 PID: 819 Comm: sysret_rip_64 Not tainted
5.18.0-rc7-next-20220517 #1
[   57.561515] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.5 11/26/2020
[   57.568917] RIP: 0010:copy_vma+0x61/0x220
[   57.572952] Code: 48 89 45 d0 31 c0 49 8b 07 49 83 7f 60 00 48 89
45 b8 0f 84 47 01 00 00 48 8d 55 c8 4c 89 ee 4c 89 f7 4c 01 eb e8 7f
e8 ff ff <48> 39 18 72 7e 4d 8b 47 20 4d 8b 4f 58 6a 00 48 89 d9 41 ff
b7 90
[   57.591691] RSP: 0018:ffffa70381353cb0 EFLAGS: 00010296
[   57.596917] RAX: 0000000000000000 RBX: 00007fffffffe000 RCX: 0000000000000001
[   57.604042] RDX: ffffffffffffffff RSI: ffff8a8d4aeaeb00 RDI: ffffa70381353c48
[   57.611172] RBP: ffffa70381353d00 R08: 000000000000000b R09: 000000000000000b
[   57.618297] R10: ffff8a8d4b4651f8 R11: 0000000000000058 R12: ffffa70381353d58
[   57.625420] R13: 00007fffffffd000 R14: ffff8a8d4b2748c0 R15: ffff8a8d4b4651f8
[   57.632545] FS:  00007feba4c8fb80(0000) GS:ffff8a90a7b00000(0000)
knlGS:0000000000000000
[   57.640624] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   57.646368] CR2: 0000000000000000 CR3: 000000010f444003 CR4: 00000000003706e0
[   57.653491] Call Trace:
[   57.655936]  <TASK>
[   57.658035]  move_vma+0x131/0x4a0
[   57.661381]  __do_sys_mremap+0x35c/0x890
[   57.665333]  ? syscall_trace_enter.constprop.0+0x176/0x230
[   57.670855]  __x64_sys_mremap+0x25/0x30
[   57.674701]  do_syscall_64+0x5c/0x80
[   57.678279]  ? lockdep_hardirqs_on+0x7e/0x100
[   57.682639]  ? syscall_exit_to_user_mode+0x3a/0x50
[   57.687432]  ? do_syscall_64+0x69/0x80
[   57.691185]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[   57.696235] RIP: 0033:0x7feba4189bda
[   57.699807] Code: 73 01 c3 48 8b 0d be a2 2b 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 49 89 ca b8 19 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8e a2 2b 00 f7 d8 64 89
01 48
[   57.718545] RSP: 002b:00007ffd41372198 EFLAGS: 00000202 ORIG_RAX:
0000000000000019
[   57.726111] RAX: ffffffffffffffda RBX: 00007fffffffd000 RCX: 00007feba4189bda
[   57.733233] RDX: 0000000000001000 RSI: 0000000000001000 RDI: 0000000000402000
[   57.740359] RBP: 0000000000000001 R08: 00007fffffffd000 R09: 00007ffd4137206c
[   57.747482] R10: 0000000000000003 R11: 0000000000000202 R12: 0000000000000001
[   57.754606] R13: 00007ffd41372350 R14: 0000000000000000 R15: 0000000000000000
[   57.761731]  </TASK>
[   57.763914] Modules linked in: x86_pkg_temp_thermal fuse
[   57.769226] CR2: 0000000000000000
 expected to be [   57.772536] ---[ end trace 0000000000000000 ]---


Full test log link,
https://lkft.validation.linaro.org/scheduler/job/5057712


>
>  include/linux/maple_tree.h |    2 +-
>  lib/maple_tree.c           |   14 +++++++-------
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> --- a/include/linux/maple_tree.h~maple-tree-add-new-data-structure-fix-3
> +++ a/include/linux/maple_tree.h
> @@ -37,7 +37,7 @@
>  #define MAPLE_NODE_SLOTS       63      /* 256 bytes including ->parent */
>  #define MAPLE_RANGE64_SLOTS    32      /* 256 bytes */
>  #define MAPLE_ARANGE64_SLOTS   21      /* 240 bytes */
> -#define MAPLE_ARANGE64_META_MAX        22      /* Out of range for metadata */
> +#define MAPLE_ARANGE64_META_MAX        31      /* Out of range for metadata */
>  #define MAPLE_ALLOC_SLOTS      (MAPLE_NODE_SLOTS - 2)
>  #endif /* defined(CONFIG_64BIT) || defined(BUILD_VDSO32_64) */
>
> --- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix-3
> +++ a/lib/maple_tree.c
> @@ -354,7 +354,7 @@ static inline bool mt_is_alloc(struct ma
>  /*
>   * The Parent Pointer
>   * Excluding root, the parent pointer is 256B aligned like all other tree nodes.
> - * When storing a 32 or 64 bit values, the offset can fit into 4 bits.  The 16
> + * When storing a 32 or 64 bit values, the offset can fit into 5 bits.  The 16
>   * bit values need an extra bit to store the offset.  This extra bit comes from
>   * a reuse of the last bit in the node type.  This is possible by using bit 1 to
>   * indicate if bit 2 is part of the type or the slot.
> @@ -366,19 +366,19 @@ static inline bool mt_is_alloc(struct ma
>   *  0x110 = 64 bit nodes
>   *
>   * Slot size and alignment
> - *  0x??1 : Root
> - *  0x?00 : 16 bit values, type in 0-1, slot in 2-6
> - *  0x010 : 32 bit values, type in 0-2, slot in 3-6
> - *  0x110 : 64 bit values, type in 0-2, slot in 3-6
> + *  0b??1 : Root
> + *  0b?00 : 16 bit values, type in 0-1, slot in 2-7
> + *  0b010 : 32 bit values, type in 0-2, slot in 3-7
> + *  0b110 : 64 bit values, type in 0-2, slot in 3-7
>   */
>
>  #define MAPLE_PARENT_ROOT              0x01
>
>  #define MAPLE_PARENT_SLOT_SHIFT                0x03
> -#define MAPLE_PARENT_SLOT_MASK         0x78
> +#define MAPLE_PARENT_SLOT_MASK         0xF8
>
>  #define MAPLE_PARENT_16B_SLOT_SHIFT    0x02
> -#define MAPLE_PARENT_16B_SLOT_MASK     0x7C
> +#define MAPLE_PARENT_16B_SLOT_MASK     0xFC
>
>  #define MAPLE_PARENT_RANGE64           0x06
>  #define MAPLE_PARENT_RANGE32           0x04
> _
>
> Patches currently in -mm which might be from liam.howlett@oracle.com are
>
> maple-tree-add-new-data-structure-fix.patch
> maple-tree-add-new-data-structure-fix-2.patch
> maple-tree-add-new-data-structure-fix-3.patch
> lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
> mm-start-tracking-vmas-with-maple-tree-fix-2.patch
> mm-remove-the-vma-linked-list-fix.patch
>
