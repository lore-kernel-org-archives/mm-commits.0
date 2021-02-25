Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7565BC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 02:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 211D864ECE
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 02:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235863AbhBYCDt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 21:03:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235738AbhBYCDq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 21:03:46 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E415964ECB;
        Thu, 25 Feb 2021 02:03:04 +0000 (UTC)
Date:   Wed, 24 Feb 2021 21:03:02 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, jian.w.wen@oracle.com,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [patch 014/173] mm, tracing: record slab name for
 kmem_cache_free()
Message-ID: <20210224210302.0e0a196a@oasis.local.home>
In-Reply-To: <CAHk-=whoqLWCcUXOBfWsEu49jLRJFkwnCRq6dyjg_M=dO1FhcQ@mail.gmail.com>
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
        <20210224200055.U7Xz47kX5%akpm@linux-foundation.org>
        <20210224203708.4489755a@oasis.local.home>
        <CAHk-=whoqLWCcUXOBfWsEu49jLRJFkwnCRq6dyjg_M=dO1FhcQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 24 Feb 2021 17:51:46 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Feb 24, 2021 at 5:37 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > Please do not apply this patch as is, it is very buggy!  
> 
> Sadly, it's already there and pushed out.  I try to wait a few hours
> (sometimes overnight) with Andrew's series before pushing things out
> in order to catch comments like this, but this one came too late.

I try to look at patches like this for these very mistakes. I don't
seem to be Cc'd on the original patch, and this looks to be the first
time I've seen this patch. I should update my lkml filter to send me
any patches that touch include/trace/ code or has TRACE_EVENT in it,
and forward it to my inbox if I'm not already on the Cc.

> 
> I can obviously revert, but if the fix is the two-liner you outlined,
> perhaps that is better? Mind sending it as a patch (or just putting it
> in your tracing tree)? Or Jacob? A tested patch along the lines that
> Steven outlined?

I'm done for the night, but if nobody does anything by tomorrow, I can
write up a quick fix in a few minutes. I prefer the original author to
do it, just so they get into the habit of understanding strings in
events.

But even though it's very buggy, it wont break anything unless people
really try to. The breakage would require enabling the event, then
doing something that would free a slab and its name, then reading the
trace file that has the events. In other words, the risk is low, but
something you don't want on a production system. I don't see this
breaking current mainline testing, so its not urgent to get fixed
immediately.

-- Steve
