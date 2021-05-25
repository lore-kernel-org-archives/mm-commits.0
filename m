Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B24C47087
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 23:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC19361408
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 23:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbhEYXxq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 19:53:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232111AbhEYXxq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 May 2021 19:53:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6442361360;
        Tue, 25 May 2021 23:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621986734;
        bh=in4ySQNKjXb5rx9e66a6YygSoGYibcn5fHyU70IQsfE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XH20GpQ1wDB/H6FdWKjKvyZex6NjVHKVBhTpe+6aG0V5MF1ECs9CSt4oIhUG0fVJl
         23FvKKX6PV2PY2dBVLqbJoY4C6yB2SqDwKA52RXb8EGkpd6PYkRM/zBksgRikAgiMQ
         k2vgpGmwHh5w0T4mDgZxnTdfqypF7aCmyy0QxhoY=
Date:   Tue, 25 May 2021 16:52:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Peter Collingbourne <pcc@google.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, khalid.aziz@oracle.com,
        kirill.shutemov@linux.intel.com, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        rppt@linux.ibm.com, walken@google.com, ying.huang@intel.com,
        zi.yan@cs.rutgers.edu
Subject: Re: [failures]
 mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch removed
 from -mm tree
Message-Id: <20210525165213.9598dedcada905a73bfeb8a4@linux-foundation.org>
In-Reply-To: <CAMn1gO73JghWC4KR3+T+=3+CYa1xnR1_UE0K-05JRTmdwjYUEA@mail.gmail.com>
References: <20210522195522.cR9W0GMvY%akpm@linux-foundation.org>
        <CAMn1gO73JghWC4KR3+T+=3+CYa1xnR1_UE0K-05JRTmdwjYUEA@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 24 May 2021 18:50:14 -0700 Peter Collingbourne <pcc@google.com> wrote:

> On Sat, May 22, 2021 at 12:55 PM <akpm@linux-foundation.org> wrote:
> >
> >
> > The patch titled
> >      Subject: mm: improve mprotect(R|W) efficiency on pages referenced once
> > has been removed from the -mm tree.  Its filename was
> >      mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch
> >
> > This patch was dropped because it had testing failures
> 
> Hi Andrew,
> 
> Do you have a link to more information about these testing failures? I
> don't think I received anything. Or is this about the uffd issue
> reported by Peter Xu?

Yes, just the build error.

> I have a fix for that which I'll include in v4,
> together with a switch from page_refcount to page_count to fix an
> issue reported off-list.

Sounds good, thanks.
