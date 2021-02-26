Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FB8C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 14:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46AD864D9F
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 14:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhBZOQi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 09:16:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:36326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229566AbhBZOQe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 09:16:34 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB7B464ED5;
        Fri, 26 Feb 2021 14:15:51 +0000 (UTC)
Date:   Fri, 26 Feb 2021 09:15:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jacob Wen <jian.w.wen@oracle.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [patch 014/173] mm, tracing: record slab name for
 kmem_cache_free()
Message-ID: <20210226091550.36473054@gandalf.local.home>
In-Reply-To: <301b57a6-8630-d3a0-699a-361c2df9f561@oracle.com>
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
        <20210224200055.U7Xz47kX5%akpm@linux-foundation.org>
        <20210224203708.4489755a@oasis.local.home>
        <20210224210740.73273c7a@oasis.local.home>
        <5a0b6fb4-6efd-e391-45fa-cd188f181d5d@oracle.com>
        <20210225093128.4cd86439@gandalf.local.home>
        <CAHk-=witGXc2FsqkOUy+Fh1_Vdpg=G5-MnDnDHv5DR5d6bRztQ@mail.gmail.com>
        <20210225125741.4fc7e43e@gandalf.local.home>
        <81645797-baee-fb17-6432-6a5cc423f09b@oracle.com>
        <20210225215640.51feee2f@oasis.local.home>
        <301b57a6-8630-d3a0-699a-361c2df9f561@oracle.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 26 Feb 2021 11:48:18 +0800
Jacob Wen <jian.w.wen@oracle.com> wrote:

> Removing a kernel module to see if it releases a lot of memory is
> helpful to quickly find out the root causes of some issues.
> 
> It seems nice to reserve the symbols. I don't have a relevant use case
> so it's just my 2 cents.

It's much more complex than that. We do something similar, where we keep
the kallsyms for the module init code (otherwise when tracing a module that
is loaded, you wont be able to see its functions).

But the complexity comes from the fact that kallsyms has addresses
associated to functions that no longer exist. Now what happens when new
code maps at those addresses? It confuses kallsyms.

Yeah, unloading of a module will turn function names into their original
address, and worse, can even show function names for new code added. But
there's not much we can do without having to save all kallsyms that were
ever loaded, along with time stamps to know when they were valid. And
remember, this is all in kernel memory that is never swapped out.

If you want to add a feature to do something like that go ahead. I would
recommend a "time out" where after a given time (user defined) that older
symbols are flushed from the system, and perhaps even allow the user to
define the number of symbols to keep around after they are gone. At least
this will let the users decide how much memory they want to waste for this.

-- Steve
