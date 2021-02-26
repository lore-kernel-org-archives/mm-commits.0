Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE3A2C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 02:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F6EA64EE7
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 02:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhBZC5Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 21:57:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhBZC5Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 21:57:24 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EF5B64EE4;
        Fri, 26 Feb 2021 02:56:42 +0000 (UTC)
Date:   Thu, 25 Feb 2021 21:56:40 -0500
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
Message-ID: <20210225215640.51feee2f@oasis.local.home>
In-Reply-To: <81645797-baee-fb17-6432-6a5cc423f09b@oracle.com>
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
        <20210224200055.U7Xz47kX5%akpm@linux-foundation.org>
        <20210224203708.4489755a@oasis.local.home>
        <20210224210740.73273c7a@oasis.local.home>
        <5a0b6fb4-6efd-e391-45fa-cd188f181d5d@oracle.com>
        <20210225093128.4cd86439@gandalf.local.home>
        <CAHk-=witGXc2FsqkOUy+Fh1_Vdpg=G5-MnDnDHv5DR5d6bRztQ@mail.gmail.com>
        <20210225125741.4fc7e43e@gandalf.local.home>
        <81645797-baee-fb17-6432-6a5cc423f09b@oracle.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 26 Feb 2021 10:02:53 +0800
Jacob Wen <jian.w.wen@oracle.com> wrote:

> Freeing a slab name generally means removing a kernel module.
> See the callers of kmem_cache_destroy.
> 
> We need to fix some of the trace events that call TP_printk with %pS
> to get a symbol of a kernel module that maybe removed later.

No. If the symbol is not found in the kallsyms lookup at the time of
reading the trace, it will act just like a %p and print the address.
Yes, it can change the reading of the trace file form one read to the
next, but it's harmless, and it's been like this since ftrace was
introduced back in 2009.

-- Steve
