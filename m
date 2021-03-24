Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EA8C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84E6261A14
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238679AbhCXWCx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 18:02:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238732AbhCXWCT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 18:02:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AC3161A14;
        Wed, 24 Mar 2021 22:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616623339;
        bh=6wNCpaE5CVGQde6Q+SE3zbSvTYjCvIa9Sv3FRyfhkO8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KsBq6uqUBIJLzAuWkCt/w6wCLDpgclxMMN8GVKP//T9lTYggR1e3JMpNWxOeHoPPP
         8xQpaKYNFY/rjrapH2SiINqncErd35MRKVACvOgo9pCO1j0Fonq0d8Zg0dvd/olgRP
         hOU/x/SsTJ5CeY/Dm1szE8xyXBoRC8pdkUGyxwZM=
Date:   Wed, 24 Mar 2021 15:02:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jan Kara <jack@suse.cz>, mm-commits@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: + mm-provide-filemap_range_needs_writeback-helper.patch added
 to -mm tree
Message-Id: <20210324150218.bd9f1ebc4af58703ce001f77@linux-foundation.org>
In-Reply-To: <9c04eafc-475d-31fc-e2cc-ea99aafd8972@kernel.dk>
References: <20210302234347.N9evDxn__%akpm@linux-foundation.org>
        <9c04eafc-475d-31fc-e2cc-ea99aafd8972@kernel.dk>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 24 Mar 2021 13:48:08 -0600 Jens Axboe <axboe@kernel.dk> wrote:

> On Tue, Mar 2, 2021 at 4:43 PM <akpm@linux-foundation.org> wrote:
> >
> >
> > The patch titled
> >      Subject: mm: provide filemap_range_needs_writeback() helper
> > has been added to the -mm tree.  Its filename is
> >      mm-provide-filemap_range_needs_writeback-helper.patch
> 
> Are you still planning on flushing this out for 5.12??

Oh.  No, I wasn't planning on that.  I saw nothing which made me think
it was that urgent.

What is the justification?  How much performance benefit are we talking
here?
