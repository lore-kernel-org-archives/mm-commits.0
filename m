Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC96C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 21 Nov 2022 09:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiKUJiq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Nov 2022 04:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiKUJip (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2022 04:38:45 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117B626AE2
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 01:38:45 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id 205so12902989ybe.7
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 01:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RW9IBDD0uZJ6pMP7qtEDdhoxd4RvXGjTOjQvtk9/wIw=;
        b=mcZXGk6lta6RzzJDE6/k/9CacgWsG64js68/tRcM7a9rniiys4zhP72K9zjjc17KQW
         ZKj/NbJ3ytSCAs61d37IW3QNvtdgfX/UEVPy4wtdarmnw+nldziteXg3Nw9j7uJY5uRE
         YXSuLTjrbNFCN+9VxFOgNuGzfV0KyEx9X8DqeHXQoizZ8dqOwihaFbTICJFNxxzIxbjs
         g1BuEJIbMGn5Ge31FwUBxAoXrK4n25hGyungNj/p9kMKusUqvoHPYPnc2ivbchWpXEOT
         T4wbYUY/ChJUBqlQzYskrNN7vO+8xla+IAYVGJXpbCg2WZXTjx158bsBB0Dv4BvLXZfd
         aXpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RW9IBDD0uZJ6pMP7qtEDdhoxd4RvXGjTOjQvtk9/wIw=;
        b=kzDvY28mW3YLuVpj52O7DmgjOPr497FEdZfDen1VMCKTd9kvCGQWMRvdrW8CbEmteJ
         6PVCBz5gE4sYpl/r1Wy7+CXO84XgB3O5GinDTcA4RRJbKiB21lgTv5q3otVnbTyP9NLW
         YsBC6WHcyo1Ri+ocuwWmumaPJovV6ihwP5fTcy8HXZC+KFAxvn20ze+jluEMdJ9U88uI
         Odan59CYWb1rqbXudy0ktH5e8fwh33CwLLbbDyexWlGligSBWDNdBG+m/wYRG0w4M47c
         tjtef1gdBlatGf2NnKqVE41pLe2HgV2AEKZkeW7kniS+jvG1tWKDNe/+VY01sbgwziFA
         YuMw==
X-Gm-Message-State: ANoB5pnXi7vtuXl4Fr0QqjMeTkNkSZU3LPtQ6H2Tzx9KJNg7PIcqzhOl
        ifFrme5nlWzZ8i2TglYH+Tty3JnFow9baFjTHDMUDw==
X-Google-Smtp-Source: AA0mqf6W4fs5rdXuTkTFrHu/ay4orIWsrCe2+dYn9A3xTl2e/8FHoSwaGmvEzmM4tWQtKzI6d+6MkDkn308L6L7oF8k=
X-Received: by 2002:a25:ad14:0:b0:6cf:c851:905e with SMTP id
 y20-20020a25ad14000000b006cfc851905emr1651604ybi.549.1669023524118; Mon, 21
 Nov 2022 01:38:44 -0800 (PST)
MIME-Version: 1.0
References: <20221111231502.1238DC433C1@smtp.kernel.org>
In-Reply-To: <20221111231502.1238DC433C1@smtp.kernel.org>
From:   Alexander Potapenko <glider@google.com>
Date:   Mon, 21 Nov 2022 10:38:07 +0100
Message-ID: <CAG_fn=WeE=_jP0sQ8Hvwr4chdZupZp-cJd0v268Pdo1n1ROpug@mail.gmail.com>
Subject: Re: + revert-kmsan-unpoison-tlb-in-arch_tlb_gather_mmu.patch added to
 mm-hotfixes-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, will@kernel.org, peterz@infradead.org,
        elver@google.com, ebiggers@google.com, dvyukov@google.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Nov 12, 2022 at 12:15 AM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: Revert "kmsan: unpoison @tlb in arch_tlb_gather_mmu()"
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      revert-kmsan-unpoison-tlb-in-arch_tlb_gather_mmu.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-kmsan-unpoison-tlb-in-arch_tlb_gather_mmu.patch
>
> This patch will later appear in the mm-hotfixes-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Alexander Potapenko <glider@google.com>
> Subject: Revert "kmsan: unpoison @tlb in arch_tlb_gather_mmu()"
> Date: Thu, 10 Nov 2022 12:35:41 +0100
>
> This reverts commit ac801e7e252c5588325e3c983c7d4167fc68c024.
>
> The patch in question was picked to -mm from the KMSAN v6 patch series
> (https://lore.kernel.org/linux-mm/20220905122452.2258262-1-glider@google.com/)
> and sneaked into mainline despite its removal from the v7 series
> (https://lore.kernel.org/linux-mm/20220915150417.722975-1-glider@google.com/)
>
> Currently KMSAN does not warn about origin chains hitting the maximum
> depth, so keeping @tlb poisoned won't result in any inconveniences.
>

@Linus as a heads-up, this revert is still missing in 6.1
It's not strictly required for the release, but, as noted on the other
thread, the original patch is not needed anymore, so reverting it will
make mmu_gather less ugly.
