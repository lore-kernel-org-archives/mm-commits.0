Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6860C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 11:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381448AbiFQLWc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 07:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiFQLWb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 07:22:31 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B226C57B
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 04:22:31 -0700 (PDT)
Date:   Fri, 17 Jun 2022 13:22:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1655464948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tdw7c5KPYPtGzET170D8Ewf//nk4d1uoZNRLNJGZwvc=;
        b=kgmsTbf6/JxYovrZBQbWvMDiOqY9Og0jZCIx6N8GO0lgjEuFvMJYFd5xTHmAukzEjcN4bR
        zHyWfHhAiNShDDT4pzdQ1jtuWOexj/SoDSYhjdz1riDNo4BEAFpW7vgI0fpf5iM0z4BTUH
        4vOR3Td3M40pqOblzUvHsmUodQwZTNG/321N+TwkJ+SJGj8Yga5gKNs552bVv8PnM46J4H
        xyMx/369L6gbjIEnOblUvrbKyBmrZ4u11H3i2034VEkR71jgEMfc+3u0+GLM5vbQa+FLvs
        mYepXMnXJkcvsLxR4LKSRtSfyLZKhVQhbs1tqaOjtl3ddginWAicvrhgJykFTQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1655464948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tdw7c5KPYPtGzET170D8Ewf//nk4d1uoZNRLNJGZwvc=;
        b=G6Cf/0H7rZiNydZ7IwwxE/OxYLSeVo15+L4Tc9sgIwQDEWt41q7MPGF9a9l/7C8RFEsy2H
        jG2HDkJMGuRi9qBA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     "chenjun (AM)" <chenjun102@huawei.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: + lockdep-make-prove_raw_lock_nesting-depend-on-preempt_rt.patch
 added to mm-nonmm-unstable branch
Message-ID: <Yqxj80M38tiy2yoh@linutronix.de>
References: <20220616194128.A66B3C34114@smtp.kernel.org>
 <YqwX+ppqtMz6O5Y+@linutronix.de>
 <3c8068a1a2be4e94b41c5906a47ecf9e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3c8068a1a2be4e94b41c5906a47ecf9e@huawei.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2022-06-17 07:14:45 [+0000], chenjun (AM) wrote:
> > Please drop that patch.
> 
> Maybe we can add some obvious description that the error messages have 
> no effect on non-PREEMPT_RT kernel?
> 
> Printing can be confusing to people who are not clear about the option.

So this isn't obvious from the current description? It also says that
you should expect splats.
Did you encounter a problem?

Sebastian
