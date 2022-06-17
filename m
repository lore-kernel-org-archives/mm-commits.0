Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF56C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 11:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382118AbiFQLyN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 07:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382107AbiFQLyN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 07:54:13 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD306D180
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 04:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=8Fbwpy7sJmPBqqHF4U4nXICl3SaJBtItLQm0f+MKx8M=; b=eCcQLjGXyHZeWcN5TRDscDPVKf
        hyz33385Ibk8yZ4j6Dh/IhhjaZsVeXNLF33uSQJzZjHIEzSm9RQYLb5fNPNHxw7ajiJw4FeoEoEiq
        kqp6ciWNJwZGsj1klsDdkQSPV2eeA6/VIPqfbGNyKJSNPu5re1TGUkvYuSZc3cdvRZJfYA1rBGm00
        ZIsWmjds/q4wgqbDkMPjWTb2U+Lzi7kvZXt+Q9NOAHiojpHPMeeQVU7iuqoTdkpczTW4U9hm8J/Tw
        i6VrJw+c/NUnd2fal2uGD9N1xquqKX49FrBJbuj0FB2DDhfERF3AxFI72SoYK6P/jHWRUm1zRKXbJ
        HzxEHFKA==;
Received: from dhcp-077-249-017-003.chello.nl ([77.249.17.3] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o2AY5-008fwc-SC; Fri, 17 Jun 2022 11:54:02 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 66EF59816B5; Fri, 17 Jun 2022 13:54:01 +0200 (CEST)
Date:   Fri, 17 Jun 2022 13:54:01 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "chenjun (AM)" <chenjun102@huawei.com>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>
Subject: Re: + lockdep-make-prove_raw_lock_nesting-depend-on-preempt_rt.patch
 added to mm-nonmm-unstable branch
Message-ID: <YqxrWbNwplfa1A/z@worktop.programming.kicks-ass.net>
References: <20220616194128.A66B3C34114@smtp.kernel.org>
 <YqwX+ppqtMz6O5Y+@linutronix.de>
 <3c8068a1a2be4e94b41c5906a47ecf9e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3c8068a1a2be4e94b41c5906a47ecf9e@huawei.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jun 17, 2022 at 07:14:45AM +0000, chenjun (AM) wrote:
> 在 2022/6/17 13:59, Sebastian Andrzej Siewior 写道:
> > On 2022-06-16 12:41:27 [-0700], Andrew Morton wrote:
> >> ------------------------------------------------------
> >> From: Chen Jun <chenjun102@huawei.com>
> >> Subject: lockdep: make PROVE_RAW_LOCK_NESTING depend on PREEMPT_RT
> >> Date: Thu, 16 Jun 2022 02:29:11 +0000
> >>
> >> CONFIG_PROVE_RAW_LOCK_NESTING is used to check two things.
> >> 1. calling spin_lock in hardirq.
> >> 2. raw_spinlock - spinlock nesting.
> >> The error messages like below:
> >> [   13.485711] [ BUG: Invalid wait context ]
> >>
> >> However there is no problem on non-PREEMPT_RT kernel. The messages may be
> >> confusing and disturbing.
> >>
> >> Therefore, do not check raw_spinlock - spinlock nesting
> >> on non-PREEMPT_RT kernel.
> > 
> > This is not correct. The annotation is used to detect problems on
> > non-PREEMPT_RT kernels which occur on PREEMPT_RT. This is documented in
> > Kconfig. Letting this option depend on PREEMPT_RT renders it pointless
> > because warning are spit on PREEMPT_RT even without that option enabled.
> > 
> > Please drop that patch.
> 
> Maybe we can add some obvious description that the error messages have 
> no effect on non-PREEMPT_RT kernel?

They still need to be fixed though....
