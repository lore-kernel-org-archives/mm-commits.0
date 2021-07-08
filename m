Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89016C07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 03:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6768E61964
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 03:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhGHDTG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 23:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhGHDTG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jul 2021 23:19:06 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB576C061574
        for <mm-commits@vger.kernel.org>; Wed,  7 Jul 2021 20:16:23 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id gb6so6909779ejc.5
        for <mm-commits@vger.kernel.org>; Wed, 07 Jul 2021 20:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iQkhgc4vWZYU2b8dnDdTcTWRP8gpSBH76oPx0kv632A=;
        b=F9UqpMaSRPcazxsBYAKZF5tuF0hzcTaNzn6s+tK/ajt0I7feuGlUx58lZf1U4bH/Uj
         gqR1Ly6OZmaZHq/nWOqzepVGMCcflsGQ7r+7fBVsHDvRF4xpkxSOFjUD8EwHitbKWpB8
         KhKUSuFzewh5PD9P41VRWbCNFK4geAWvDqznU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iQkhgc4vWZYU2b8dnDdTcTWRP8gpSBH76oPx0kv632A=;
        b=TuaXxcEBlUKl8N30hIPlF2q5SsFIatHFuze4dEP44ap4Qz3tfYBHopH+qiDTBj3e5/
         BEdAG+ZtLPtH2P9ugeoDzy8bS/snhZhGDjGZ7bn2VyPQUEVj0ZE6SD53mAdR0yFZQTz4
         X20BuQPwzAOe1eOO9hSleV2aiRyVS4S4/7hQPMWCF+njxXhEo0ryEXIOYeOxis14H0Xp
         lzHOkjn75Dln18pdRivm1gXqcl141p6oDqaGbbrbwgabYmM/c+dGYKAS5z7LRct7OfMp
         92O8H390o074K/p+0DJJJZWN0Y9VpydzGOKBWGw3b/IiWbC4WvQUOTjtPPL/dW3vrtgQ
         77jw==
X-Gm-Message-State: AOAM5312a2fZA6fQCU+oKr6MdIv3aIhBRCupWDWa52jIZLikGc6LJp57
        aNAGWtQu0fgoFBAiqzwmoC0JBmCW4PfJY+OY9bA=
X-Google-Smtp-Source: ABdhPJzAtfOkL00lfWeYDdG3gxe1uuQVI8s/yG8/aibIEdX8MQSCx1Q139Q6WIU5502qy59tv7WMnw==
X-Received: by 2002:a17:907:20b7:: with SMTP id pw23mr8894162ejb.198.1625714182231;
        Wed, 07 Jul 2021 20:16:22 -0700 (PDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id d13sm411846edz.53.2021.07.07.20.16.20
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 20:16:21 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id q17so5565310wrv.2
        for <mm-commits@vger.kernel.org>; Wed, 07 Jul 2021 20:16:20 -0700 (PDT)
X-Received: by 2002:a2e:b55b:: with SMTP id a27mr11302203ljn.251.1625714169485;
 Wed, 07 Jul 2021 20:16:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org> <20210708010807.hHILhs811%akpm@linux-foundation.org>
In-Reply-To: <20210708010807.hHILhs811%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 7 Jul 2021 20:15:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=whwj1JGnGChkRyzbY4BBOvDfiv=xKbvMenoC4P2dDP5pw@mail.gmail.com>
Message-ID: <CAHk-=whwj1JGnGChkRyzbY4BBOvDfiv=xKbvMenoC4P2dDP5pw@mail.gmail.com>
Subject: Re: [patch 12/54] PM: hibernate: disable when there are active
 secretmem users
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        Roman Gushchin <guro@fb.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        Peter Anvin <hpa@zytor.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Linux-MM <linux-mm@kvack.org>, kernel test robot <lkp@intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ingo Molnar <mingo@redhat.com>, mm-commits@vger.kernel.org,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Shakeel Butt <shakeelb@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tycho Andersen <tycho@tycho.ws>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jul 7, 2021 at 6:08 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Prevent hibernation whenever there are active secret memory users.

So now anybody can not only use up all memory resources with these
fake mlock regions, they can also force laptops to run out of battery
and crash.

Again, maybe I'm missing something, but I didn't see any capability
checks or anything at all to limit this once it is enabled.

                    Linus
