Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C88C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9062561A1D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbhCXWT2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 18:19:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231854AbhCXWTD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 18:19:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFC1E619BB;
        Wed, 24 Mar 2021 22:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616624342;
        bh=J/cFCpFhojSwq/EJybyYuoGtHosmXHgSYJRRPyn/cwI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QXPW7evgp7NRn9Tzj3S/pY4xgA10TbD0p6Ct72fFZKKb+lRUSIXGEdxUbAnu+g5pJ
         3Pf+OkhI4CxRFmQ1qHxUCAtpT75F9BFSi9pFovek2qj6sOErLCp4ZQM+elsa5bLN6k
         8bipwhDSRs9wc65ACdaBgW/e2nlCEDYz47U4XlRg=
Date:   Wed, 24 Mar 2021 15:19:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jan Kara <jack@suse.cz>, mm-commits@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: + mm-provide-filemap_range_needs_writeback-helper.patch added
 to -mm tree
Message-Id: <20210324151902.171d2a295bebc4e511c7e679@linux-foundation.org>
In-Reply-To: <a0d094d9-cf6b-8e27-d7f2-a6f86977bfa1@kernel.dk>
References: <20210302234347.N9evDxn__%akpm@linux-foundation.org>
        <9c04eafc-475d-31fc-e2cc-ea99aafd8972@kernel.dk>
        <20210324150218.bd9f1ebc4af58703ce001f77@linux-foundation.org>
        <a0d094d9-cf6b-8e27-d7f2-a6f86977bfa1@kernel.dk>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 24 Mar 2021 16:13:48 -0600 Jens Axboe <axboe@kernel.dk> wrote:

> On 3/24/21 4:02 PM, Andrew Morton wrote:
> > On Wed, 24 Mar 2021 13:48:08 -0600 Jens Axboe <axboe@kernel.dk> wrote:
> > 
> >> On Tue, Mar 2, 2021 at 4:43 PM <akpm@linux-foundation.org> wrote:
> >>>
> >>>
> >>> The patch titled
> >>>      Subject: mm: provide filemap_range_needs_writeback() helper
> >>> has been added to the -mm tree.  Its filename is
> >>>      mm-provide-filemap_range_needs_writeback-helper.patch
> >>
> >> Are you still planning on flushing this out for 5.12??
> > 
> > Oh.  No, I wasn't planning on that.  I saw nothing which made me think
> > it was that urgent.
> 
> Ehm ok, I think that was the plan though when we originally talked about
> this series. At least that was what was in my original emails on this
> topic :-)
> 
> > What is the justification?  How much performance benefit are we talking
> > here?
> 
> Well it's pretty huge, since if we return "nope can't do this
> non-blocking" it'll mean that io_uring has to bump the operation to an
> async threads. So CPU cost goes way up, and latencies does too.
> 
> Problem is, we're now at -rc4, and it was my understanding that we'd get
> this in for 5.12, but obviously way sooner than this. But I kind of lost
> track when it went into your tree, until I started thinking about it
> earlier today. While it's not the end of the world to wait for 5.13,
> though the current situation does suck a lot for certain workloads.

I'd be OK with sending it to Linus now, but we really should put some
numbers behind "suck a lot" to justify it.  And a -stable backport
might be justified if the benefit is large enough, and if "certain
workloads" are common enough.

But with what have here, I and everyone else who considers these
patches is going in blind!
