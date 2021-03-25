Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7CD2C433C1
	for <mm-commits@archiver.kernel.org>; Thu, 25 Mar 2021 00:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BCE061992
	for <mm-commits@archiver.kernel.org>; Thu, 25 Mar 2021 00:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239435AbhCYAyz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 20:54:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232856AbhCYAy1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 20:54:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8CC461992;
        Thu, 25 Mar 2021 00:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616633666;
        bh=BD8YrlY+/+TLzqQLhKR3pu05CsNZKbqWl+ueYf/k3GU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xlschk8GYT4R3ZTGk18V44VCypHWn3epyFUvnMij+Vdh0eK1uP3fx6nwppXycrs0Y
         GJepFHhjje3KGJUgaOApcO4pg7XJQulYYkqZdsc/kw2OJF3JtJJWB6770uo+oktBIh
         EMSu79d+3Ngmy/HZsyB5D2BRsjQREclsSNZF2X70=
Date:   Wed, 24 Mar 2021 17:54:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jan Kara <jack@suse.cz>, mm-commits@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: + mm-provide-filemap_range_needs_writeback-helper.patch added
 to -mm tree
Message-Id: <20210324175426.a0dc8a8bde6e905af19fe7b7@linux-foundation.org>
In-Reply-To: <d90b8446-22dc-2821-a733-1911c7b0d47f@kernel.dk>
References: <20210302234347.N9evDxn__%akpm@linux-foundation.org>
        <9c04eafc-475d-31fc-e2cc-ea99aafd8972@kernel.dk>
        <20210324150218.bd9f1ebc4af58703ce001f77@linux-foundation.org>
        <a0d094d9-cf6b-8e27-d7f2-a6f86977bfa1@kernel.dk>
        <20210324151902.171d2a295bebc4e511c7e679@linux-foundation.org>
        <d90b8446-22dc-2821-a733-1911c7b0d47f@kernel.dk>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 24 Mar 2021 16:25:52 -0600 Jens Axboe <axboe@kernel.dk> wrote:

> The backstory is that an internal workload complained because it was
> using too much CPU, and when I took a look, we had a lot of io_uring
> workers going to town. For an async buffered read like workload, I am
> normally expecting _zero_ offloads to a worker thread, but this one
> had tons of them. I'd drop caches and things would look good again,
> but then a minute later we'd regress back to using workers. Turns out
> that every minute something was reading parts of the device, which
> would add page cache for that inode. I put patches like these in for
> our kernel, and the problem was solved.

I added the above to the 0/n changelog if tha'ts OK.

> Obviously that's not a great story since there are no hard numbers
> there, and I'd have to generate those for you! Which I surely can.
> While the original premise of the patches was fixing excessive CPU
> usage, the general observation is that outside of just using a lot more
> CPU, it'll also cause worse latencies as offload to a thread always adds
> latency.
> 
> So let me know if you want me to generate some numbers. They will be
> artificial, but at least it'll be something outside of a story.

We really should back it up with numbers, even if they're handwavy.

Particularly because we need to figure out if -stable wants this.  What
are your feelings on that one?
