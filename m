Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB58BC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 12:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92C25613D3
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 12:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhEMMr0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 08:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhEMMrV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 May 2021 08:47:21 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAA7C061574
        for <mm-commits@vger.kernel.org>; Thu, 13 May 2021 05:46:09 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id x2so38320271lff.10
        for <mm-commits@vger.kernel.org>; Thu, 13 May 2021 05:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qbfwaL6AzjZMDMBzdMJC6TSwq5sdq9iVIf3QqmE4XUQ=;
        b=QgtHrMFw3k8JDiLq5Ngbs871JTRK3ayVbJLK8/Jv35dCDoQFb08QenD0F62n5fBaVR
         iCspNonCCtsshVFkRCGFdWs6yCxdUL9yQWL8OTWyaeDcFgJZNQXXDZEk5KfhviVJTIhL
         JI6ovDUCRoXNHJDEjcPfC62B8Kta4ucfaAplIAOCpTKZREDvWi71fjhLt2EFFVs3Crz3
         I5PrJpc4XQ2gs0rzMEHxrTy/ZdqeyBjWwZuOssTJt4D37dvz6HA1tDZREJocSl0ax0YZ
         b7vl5E2ts75eIZFcxPU0t0HWpqR4p2ogCGqerbUmLGPpWB9yttAiU0hDTc/vyvXzIe9r
         Y1XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qbfwaL6AzjZMDMBzdMJC6TSwq5sdq9iVIf3QqmE4XUQ=;
        b=iuJqX4xwK7XVIenXbJfvMK3WkVHYecG7puC6TsaGopPAMjl8HNjdVIgyTS9CXcLQry
         lxSo8WIZswFglyVg2YcQtMYpqNsULftW6FclC+nyR+OfQUrwu/IVZRL0tEjdXFiN2FF9
         YTlcKRkGfUyCNsmx5Qxl8Lny8c6JkRkRyFgGqrugi+S2Zu2l8Gk/3MaSA7iUYi3n24ic
         AkvYzWAJmXvN2ocUOinazxs+4T2BC3kRJiSWCnzWftUGk8Bf2pFDtJUQqmIMchzh7WB/
         zEQOtKP+EfuUoyCKAOFT8mvO79WE2gJKzNCTiPg3QUmtOCaBfwDdCbDDBBW2V77yvg3n
         8aTQ==
X-Gm-Message-State: AOAM530GDTdT+Ol3w1aVxyRQkcUlIj0zALqA61upGBlBSgpM1WFnWNGs
        B6PcnerKWOlMQV6g5RQTAV8=
X-Google-Smtp-Source: ABdhPJytCqGIE0glkeRCs1ArRHuWUQYjtXhMX1EhL+LjRV7vm80PbpYN9C2AXo3sOhYrftlygHyY+A==
X-Received: by 2002:ac2:4838:: with SMTP id 24mr28058788lft.348.1620909967629;
        Thu, 13 May 2021 05:46:07 -0700 (PDT)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id m4sm447128ljp.9.2021.05.13.05.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 05:46:07 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Thu, 13 May 2021 14:46:05 +0200
To:     Mel Gorman <mgorman@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        akpm@linux-foundation.org
Cc:     Uladzislau Rezki <urezki@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        akpm@linux-foundation.org, hdanton@sina.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        willy@infradead.org
Subject: Re: [failures]
 mm-vmalloc-print-a-warning-message-first-on-failure.patch removed from -mm
 tree
Message-ID: <20210513124605.GA3263@pc638.lan>
References: <20210512202952.PRR7JClh8%akpm@linux-foundation.org>
 <20210513085602.6d3f9d63@canb.auug.org.au>
 <20210513103156.GA1856@pc638.lan>
 <20210513111153.GL3672@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513111153.GL3672@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, May 13, 2021 at 12:11:53PM +0100, Mel Gorman wrote:
> On Thu, May 13, 2021 at 12:31:56PM +0200, Uladzislau Rezki wrote:
> > On Thu, May 13, 2021 at 08:56:02AM +1000, Stephen Rothwell wrote:
> > > Hi Andrew,
> > > 
> > > On Wed, 12 May 2021 13:29:52 -0700 akpm@linux-foundation.org wrote:
> > > >
> > > > The patch titled
> > > >      Subject: mm/vmalloc: print a warning message first on failure
> > > > has been removed from the -mm tree.  Its filename was
> > > >      mm-vmalloc-print-a-warning-message-first-on-failure.patch
> > > > 
> > > > This patch was dropped because it had testing failures
> > > 
> > > Removed from linux-next.
> > > 
> > What can of testing failures does it trigger? Where can i find the
> > details, logs or tracers of it?
> 
> https://lore.kernel.org/linux-next/20210512175359.17793d34@canb.auug.org.au/
> 
Thanks, Mel.

OK. Now i see. The problem is with this patch:

mm/vmalloc: switch to bulk allocator in __vmalloc_area_node()

<snip>
[    0.097819][    T1] BUG: Unable to handle kernel data access on read at 0x200000c0a
[    0.098533][    T1] Faulting instruction address: 0xc0000000003f6fa0
[    0.099044][    T1] Oops: Kernel access of bad area, sig: 11 [#1]
[    0.099182][    T1] LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
[    0.099506][    T1] Modules linked in:
[    0.099896][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-rc1-00142-g6053672bb612 #12
[    0.100254][    T1] NIP:  c0000000003f6fa0 LR: c0000000003f6f68 CTR: 0000000000000000
[    0.100342][    T1] REGS: c0000000063a3480 TRAP: 0380   Not tainted  (5.13.0-rc1-00142-g6053672bb612)
[    0.100550][    T1] MSR:  8000000002009033 <SF,VEC,EE,ME,IR,DR,RI,LE>  CR: 24402840  XER: 00000000
[    0.100900][    T1] CFAR: c0000000003f6f7c IRQMASK: 0 
[    0.100900][    T1] GPR00: c0000000003f6f68 c0000000063a3720 c00000000146b100 0000000000000000 
[    0.100900][    T1] GPR04: 0000000000000000 0000000000000000 0000000000000000 0000000000000002 
[    0.100900][    T1] GPR08: c0000000015219e8 0000000000000000 0000000200000c02 c000000006030010 
[    0.100900][    T1] GPR12: 0000000000008000 c000000001640000 0000000000000001 c000000000262f84 
[    0.100900][    T1] GPR16: c00a000000000000 c008000000000000 0000000000000dc0 0000000000000008 
[    0.100900][    T1] GPR20: 0000000000000522 0000000000010000 0000000000000cc0 c008000000000000 
[    0.100900][    T1] GPR24: 0000000000000001 0000000000000000 0000000000002cc2 0000000000000000 
[    0.100900][    T1] GPR28: 0000000000000000 0000000000000000 0000000200000c02 0000000000002cc2 
[    0.101927][    T1] NIP [c0000000003f6fa0] __alloc_pages+0x140/0x3f0
[    0.102733][    T1] LR [c0000000003f6f68] __alloc_pages+0x108/0x3f0
[    0.103032][    T1] Call Trace:
[    0.103165][    T1] [c0000000063a3720] [0000000000000900] 0x900 (unreliable)
[    0.103616][    T1] [c0000000063a37b0] [c0000000003f7810] __alloc_pages_bulk+0x5c0/0x840
[    0.103787][    T1] [c0000000063a3890] [c0000000003ecf74] __vmalloc_node_range+0x4c4/0x600
[    0.103871][    T1] [c0000000063a39b0] [c00000000004f598] module_alloc+0x58/0x70
[    0.103962][    T1] [c0000000063a3a20] [c000000000262f84] alloc_insn_page+0x24/0x40
[    0.104046][    T1] [c0000000063a3a40] [c00000000026629c] __get_insn_slot+0x1dc/0x280
[    0.104143][    T1] [c0000000063a3a80] [c00000000005770c] arch_prepare_kprobe+0x15c/0x1f0
[    0.104290][    T1] [c0000000063a3b00] [c000000000267880] register_kprobe+0x6d0/0x850
[    0.104392][    T1] [c0000000063a3b60] [c00000000108fe2c] arch_init_kprobes+0x28/0x3c
[    0.104524][    T1] [c0000000063a3b80] [c0000000010addb0] init_kprobes+0x120/0x174
[    0.104629][    T1] [c0000000063a3bf0] [c000000000012190] do_one_initcall+0x60/0x2c0
[    0.104722][    T1] [c0000000063a3cc0] [c0000000010845a0] kernel_init_freeable+0x1bc/0x3a0
[    0.104826][    T1] [c0000000063a3da0] [c000000000012764] kernel_init+0x2c/0x168
[    0.104911][    T1] [c0000000063a3e10] [c00000000000d5ec] ret_from_kernel_thread+0x5c/0x70
[    0.105178][    T1] Instruction dump:
[    0.105516][    T1] 40920018 57e9efbe 2c090001 4082000c 63050080 78b80020 e8a10028 57e9a7fe 
[    0.105759][    T1] 7fcaf378 99210040 2c250000 408201f4 <813e0008> 7c09c840 418101e8 57e50528 
[    0.107188][    T1] ---[ end trace 9bd7c2fac4d061e2 ]---
[    0.107319][    T1] 
[    1.108818][    T1] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
<snip>

So during the boot process when the module is about to be loaded, the vmalloc allocation
gets failed in the __alloc_pages_bulk(). 

Will try to reproduce. It would be good to get a kernel config.
Appreciate for any thoughts about it?

Thanks!

--
Vlad Rezki
