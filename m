From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + ipc-convert-ipcs_idr-to-xarray-update.patch added to -mm tree
Date: Fri, 5 Jun 2020 14:20:39 -0700
Message-ID: <20200605142039.b8a81c08bf5ba34fa0181545@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
        <20200424014753.DfBuzjmzo%akpm@linux-foundation.org>
        <20200605195848.GB5393@lca.pw>
        <20200605201134.GJ19604@bombadil.infradead.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728180AbgFEVUk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 17:20:40 -0400
In-Reply-To: <20200605201134.GJ19604@bombadil.infradead.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Qian Cai <cai@lca.pw>, linux-kernel@vger.kernel.org, dave@stgolabs.net, manfred@colorfullife.com, mm-commits@vger.kernel.org

On Fri, 5 Jun 2020 13:11:34 -0700 Matthew Wilcox <willy@infradead.org> wrote:

> On Fri, Jun 05, 2020 at 03:58:48PM -0400, Qian Cai wrote:
> > This will trigger,
> > 
> > [ 8853.759549] LTP: starting semget05
> > [ 8867.257088] BUG: sleeping function called from invalid context at mm/slab.h:567
> > [ 8867.270259] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 22556, name: semget05
> > [ 8867.270309] 2 locks held by semget05/22556:
> > [ 8867.270345]  #0: 00000000512de7e0 (&ids->rwsem){++++}-{3:3}, at: ipcget+0x4e/0x230
> > [ 8867.270426]  #1: 00000000552b9018 (&new->lock){+.+.}-{2:2}, at: ipc_addid+0xf4/0xf50
> 
> Did the fix for this not make it into -next?

I don't think I've seen this fix before.  And I'm unclear on how it
pertains to the current patch(es) in -mm.  And it has no changelog!

Perhaps it would be best to do a formal send of the latest version?
