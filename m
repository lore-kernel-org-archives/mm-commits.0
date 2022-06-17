Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66180C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 05:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380226AbiFQF6Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 01:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380216AbiFQF6Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 01:58:25 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1354011C30
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 22:58:23 -0700 (PDT)
Date:   Fri, 17 Jun 2022 07:58:18 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1655445501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mPnT6u0AHhB/GQzbylQmG6HcfEBwmiQSXvCq0kkmvb4=;
        b=n2ZHN2TttG1PmmCxbAhTZUFC0+mANla16V0GKgyqIGiNPm1pjpcvhEkAOrPZp6YLj/yj45
        7xBq8jmUfIzE/X6rLpqAN2hNlezBl3BE6BACn7z8WF26HxR+J8uoNMT3JPCYHY+Or2/69+
        5RH2yA3OzNGsFSDUdJ6rxMX1r1r93Fuur8VOhpRPXNBHTVIePiBaFV0g58Ha+AdeLSLIwn
        V6GELggO2LqWCY0kZn1Yvef1E4OfxC8WLdUnabcTlC/L/e0bNfdgTq4aHSOuQyD2s8gKgY
        7wwt6UqhvgB5Ac/5GR/TV31u+umCNYO22SjcOzLJttrcbQUJxG6/Y34x6wGA0Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1655445501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mPnT6u0AHhB/GQzbylQmG6HcfEBwmiQSXvCq0kkmvb4=;
        b=1letf84fi+Wgpk9NeOhCXIYqrp9vUBLb74n44KS6bd5s6bzWpcTjPWUnw/R61XZ+dw1PxF
        9YHxhzFmuq02ZVCg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, peterz@infradead.org,
        chenjun102@huawei.com
Subject: Re: + lockdep-make-prove_raw_lock_nesting-depend-on-preempt_rt.patch
 added to mm-nonmm-unstable branch
Message-ID: <YqwX+ppqtMz6O5Y+@linutronix.de>
References: <20220616194128.A66B3C34114@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220616194128.A66B3C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2022-06-16 12:41:27 [-0700], Andrew Morton wrote:
> ------------------------------------------------------
> From: Chen Jun <chenjun102@huawei.com>
> Subject: lockdep: make PROVE_RAW_LOCK_NESTING depend on PREEMPT_RT
> Date: Thu, 16 Jun 2022 02:29:11 +0000
> 
> CONFIG_PROVE_RAW_LOCK_NESTING is used to check two things.
> 1. calling spin_lock in hardirq.
> 2. raw_spinlock - spinlock nesting.
> The error messages like below:
> [   13.485711] [ BUG: Invalid wait context ]
> 
> However there is no problem on non-PREEMPT_RT kernel. The messages may be
> confusing and disturbing.
> 
> Therefore, do not check raw_spinlock - spinlock nesting
> on non-PREEMPT_RT kernel.

This is not correct. The annotation is used to detect problems on
non-PREEMPT_RT kernels which occur on PREEMPT_RT. This is documented in
Kconfig. Letting this option depend on PREEMPT_RT renders it pointless
because warning are spit on PREEMPT_RT even without that option enabled.

Please drop that patch.

> Link: https://lkml.kernel.org/r/20220616022911.35826-1-chenjun102@huawei.com
> Signed-off-by: Chen Jun <chenjun102@huawei.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Sebastian
