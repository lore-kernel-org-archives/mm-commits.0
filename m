Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A1EC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 13:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5C6161438
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 13:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbhEMNZ4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 09:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbhEMNZd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 May 2021 09:25:33 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8A5C06174A
        for <mm-commits@vger.kernel.org>; Thu, 13 May 2021 06:24:22 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id g4so9082406lfv.6
        for <mm-commits@vger.kernel.org>; Thu, 13 May 2021 06:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lWMn6V7kOHjV68aMVasSQkmlACyHkrcE52sVjkk1lK0=;
        b=BG4Cis3K3+0k3qbh1T0pXyC+agmNT9upPLaPYPNT0rVBTIoO1Gw2G7BnMCJipp8DDk
         Vzs4bDwuaeaFBF5nkBQ+rTsvQiG0wP0BapKALiRkrbQHGMhefn/jsTTdXfK2l43DQdam
         QKTwtqC5JYpq9952qCVBsLehfBBP3W+asMbintsHSW5VrRcP/XTaa2AkcsLg84A27oEU
         fQ3zYOub9Sk89qztNDnqSOdSorwZwHJx9cDlNKlp5GW6nmEKONghIyFgjdstoIuJP2e7
         I6fHdegqRi40IoicOkKZud381KrQEzhC1B6cow+CFpHxvhrcTEJ/S+yH1pDZ8jivEbES
         5HVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lWMn6V7kOHjV68aMVasSQkmlACyHkrcE52sVjkk1lK0=;
        b=rOyIFZgJ29cMMJiDw9ExOtEWDzY4VYzsbmc1tXZgxG7691sQ72Har6IfK1IR3//bv5
         JmjIHagu8Ti2oyViXUObjoCzgn/PAa7zVz8HNQ4PTMM+7adeGoqkabWkbJuCbViejV7r
         0/ANtXXvdqFmZwahkEDubSiqN1phkgYwxNd+Ij6YmhbTAC1z3TaBrDpP7HDRhEmqonGS
         0+Hh1FgK3QBQVsxGsdiWqq+SBFkqZ+xAzUexiWY+Fa2GX/d/IhHyo7Fcu88I/L0aFX1B
         iICc+8PvLAWLdLeLgmcGokq7rFFmGuiiU11d+D0gzz4dSGWvF37Xi0TOT/I6CtJRRHyM
         URWw==
X-Gm-Message-State: AOAM532UqXbzyvJL35Y6Ks8TQMy1S3ux+HPUmkhqdpzo9oeNkQsF5pCb
        TVOWCivoorYLkOuCzv5PulMkTq6Hk0I=
X-Google-Smtp-Source: ABdhPJwNRStlgcvKCNVOZZXgNPrhQhcibM/DLRS+qyWIfPBivqoNMEh24IMFsfBav2N/cXN0nXRFKw==
X-Received: by 2002:a19:c111:: with SMTP id r17mr27889999lff.564.1620912260632;
        Thu, 13 May 2021 06:24:20 -0700 (PDT)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id o5sm435126ljj.103.2021.05.13.06.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 06:24:20 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Thu, 13 May 2021 15:24:18 +0200
To:     Mel Gorman <mgorman@suse.de>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>, akpm@linux-foundation.org,
        hdanton@sina.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        npiggin@gmail.com, oleksiy.avramchenko@sonymobile.com,
        rostedt@goodmis.org, willy@infradead.org
Subject: Re: [failures]
 mm-vmalloc-print-a-warning-message-first-on-failure.patch removed from -mm
 tree
Message-ID: <20210513132418.GA1425@pc638.lan>
References: <20210512202952.PRR7JClh8%akpm@linux-foundation.org>
 <20210513085602.6d3f9d63@canb.auug.org.au>
 <20210513103156.GA1856@pc638.lan>
 <20210513111153.GL3672@suse.de>
 <20210513124605.GA3263@pc638.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513124605.GA3263@pc638.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, May 13, 2021 at 02:46:05PM +0200, Uladzislau Rezki wrote:
> On Thu, May 13, 2021 at 12:11:53PM +0100, Mel Gorman wrote:
> > On Thu, May 13, 2021 at 12:31:56PM +0200, Uladzislau Rezki wrote:
> > > On Thu, May 13, 2021 at 08:56:02AM +1000, Stephen Rothwell wrote:
> > > > Hi Andrew,
> > > > 
> > > > On Wed, 12 May 2021 13:29:52 -0700 akpm@linux-foundation.org wrote:
> > > > >
> > > > > The patch titled
> > > > >      Subject: mm/vmalloc: print a warning message first on failure
> > > > > has been removed from the -mm tree.  Its filename was
> > > > >      mm-vmalloc-print-a-warning-message-first-on-failure.patch
> > > > > 
> > > > > This patch was dropped because it had testing failures
> > > > 
> > > > Removed from linux-next.
> > > > 
> > > What can of testing failures does it trigger? Where can i find the
> > > details, logs or tracers of it?
> > 
> > https://lore.kernel.org/linux-next/20210512175359.17793d34@canb.auug.org.au/
> > 
> Thanks, Mel.
> 
> OK. Now i see. The problem is with this patch:
> 
> mm/vmalloc: switch to bulk allocator in __vmalloc_area_node()
> 
> <snip>
> [    0.097819][    T1] BUG: Unable to handle kernel data access on read at 0x200000c0a
> [    0.098533][    T1] Faulting instruction address: 0xc0000000003f6fa0
> [    0.099044][    T1] Oops: Kernel access of bad area, sig: 11 [#1]
> [    0.099182][    T1] LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
> [    0.099506][    T1] Modules linked in:
> [    0.099896][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-rc1-00142-g6053672bb612 #12
> [    0.100254][    T1] NIP:  c0000000003f6fa0 LR: c0000000003f6f68 CTR: 0000000000000000
> [    0.100342][    T1] REGS: c0000000063a3480 TRAP: 0380   Not tainted  (5.13.0-rc1-00142-g6053672bb612)
> [    0.100550][    T1] MSR:  8000000002009033 <SF,VEC,EE,ME,IR,DR,RI,LE>  CR: 24402840  XER: 00000000
> [    0.100900][    T1] CFAR: c0000000003f6f7c IRQMASK: 0 
> [    0.100900][    T1] GPR00: c0000000003f6f68 c0000000063a3720 c00000000146b100 0000000000000000 
> [    0.100900][    T1] GPR04: 0000000000000000 0000000000000000 0000000000000000 0000000000000002 
> [    0.100900][    T1] GPR08: c0000000015219e8 0000000000000000 0000000200000c02 c000000006030010 
> [    0.100900][    T1] GPR12: 0000000000008000 c000000001640000 0000000000000001 c000000000262f84 
> [    0.100900][    T1] GPR16: c00a000000000000 c008000000000000 0000000000000dc0 0000000000000008 
> [    0.100900][    T1] GPR20: 0000000000000522 0000000000010000 0000000000000cc0 c008000000000000 
> [    0.100900][    T1] GPR24: 0000000000000001 0000000000000000 0000000000002cc2 0000000000000000 
> [    0.100900][    T1] GPR28: 0000000000000000 0000000000000000 0000000200000c02 0000000000002cc2 
> [    0.101927][    T1] NIP [c0000000003f6fa0] __alloc_pages+0x140/0x3f0
> [    0.102733][    T1] LR [c0000000003f6f68] __alloc_pages+0x108/0x3f0
> [    0.103032][    T1] Call Trace:
> [    0.103165][    T1] [c0000000063a3720] [0000000000000900] 0x900 (unreliable)
> [    0.103616][    T1] [c0000000063a37b0] [c0000000003f7810] __alloc_pages_bulk+0x5c0/0x840
> [    0.103787][    T1] [c0000000063a3890] [c0000000003ecf74] __vmalloc_node_range+0x4c4/0x600
> [    0.103871][    T1] [c0000000063a39b0] [c00000000004f598] module_alloc+0x58/0x70
> [    0.103962][    T1] [c0000000063a3a20] [c000000000262f84] alloc_insn_page+0x24/0x40
> [    0.104046][    T1] [c0000000063a3a40] [c00000000026629c] __get_insn_slot+0x1dc/0x280
> [    0.104143][    T1] [c0000000063a3a80] [c00000000005770c] arch_prepare_kprobe+0x15c/0x1f0
> [    0.104290][    T1] [c0000000063a3b00] [c000000000267880] register_kprobe+0x6d0/0x850
> [    0.104392][    T1] [c0000000063a3b60] [c00000000108fe2c] arch_init_kprobes+0x28/0x3c
> [    0.104524][    T1] [c0000000063a3b80] [c0000000010addb0] init_kprobes+0x120/0x174
> [    0.104629][    T1] [c0000000063a3bf0] [c000000000012190] do_one_initcall+0x60/0x2c0
> [    0.104722][    T1] [c0000000063a3cc0] [c0000000010845a0] kernel_init_freeable+0x1bc/0x3a0
> [    0.104826][    T1] [c0000000063a3da0] [c000000000012764] kernel_init+0x2c/0x168
> [    0.104911][    T1] [c0000000063a3e10] [c00000000000d5ec] ret_from_kernel_thread+0x5c/0x70
> [    0.105178][    T1] Instruction dump:
> [    0.105516][    T1] 40920018 57e9efbe 2c090001 4082000c 63050080 78b80020 e8a10028 57e9a7fe 
> [    0.105759][    T1] 7fcaf378 99210040 2c250000 408201f4 <813e0008> 7c09c840 418101e8 57e50528 
> [    0.107188][    T1] ---[ end trace 9bd7c2fac4d061e2 ]---
> [    0.107319][    T1] 
> [    1.108818][    T1] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> <snip>
> 
> So during the boot process when the module is about to be loaded, the vmalloc allocation
> gets failed in the __alloc_pages_bulk(). 
> 
> Will try to reproduce. It would be good to get a kernel config.
> Appreciate for any thoughts about it?
> 

I see that on the target machine when the problem occurs the PAGE_SIZE is 64K. 

Can it be somehow connected to it? Also one question, just guessing, the crash
happens during the boot, therefore the question is: is __alloc_pages_bulk()
fully initialized by that time? 

Thanks!

--
Vlad Rezki
