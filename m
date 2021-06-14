Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E27C2B9F4
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 22:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC04261166
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 22:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhFNWF1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 18:05:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229685AbhFNWF0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 18:05:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C40CF61183;
        Mon, 14 Jun 2021 22:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623708190;
        bh=Q40MJlsIl86UaVxJRTDFn6yVYs9+kYMFh9f8+HyrI50=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xmYYcabxhyakcAfcLkGlglDMmjKMn022JYukhCzy+xWZYFRu38XrDehR6UD4rrVJM
         rpr/tu6ll05IPNNKdywmd7r9Zy/jL8H8wcS/JIAi8E5iX4k59buKGzvzVAIUXV8wMn
         sTXlqAp73AgDeg6ZZBSR8b5uJbtztdvaBdyZUI0c=
Date:   Mon, 14 Jun 2021 15:03:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Peter Collingbourne <pcc@google.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Kostya Kortchinsky <kostyak@google.com>,
        mm-commits@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Hridya Valsaraju <hridya@google.com>
Subject: Re: +
 mm-improve-mprotectrw-efficiency-on-pages-referenced-once-v5.patch added to
 -mm tree
Message-Id: <20210614150309.34a280a8809542b214a5cf2b@linux-foundation.org>
In-Reply-To: <CAMn1gO4QjCseNe9WR6iuBXnzdQ-CKv9qvcags8xs04LPbGizjA@mail.gmail.com>
References: <20210601202257.eHEQRmS9t%akpm@linux-foundation.org>
        <CAMn1gO4QjCseNe9WR6iuBXnzdQ-CKv9qvcags8xs04LPbGizjA@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 14 Jun 2021 13:58:09 -0700 Peter Collingbourne <pcc@google.com> wrote:

> > The -mm tree is included into linux-next and is updated
> > there every 3-4 working days
> >
> > ------------------------------------------------------
> > From: Peter Collingbourne <pcc@google.com>
> > Subject: mm: improve mprotect(R|W) efficiency on pages referenced once
> >
> > add comments, prohibit optimization for NUMA pages
> 
> Hi Andrew,
> 
> I was wondering why this was added as a separate patch instead of
> being combined into the previous one. It seems like combining the
> patches will be less likely to cause issues in the future (e.g.
> someone cherry-picks the v4 patch but not the v4->v5 patch and ends up
> breaking NUMA).

I usually do this when sent a replacement patch.  So that I and others
can see what changed, so that bisection can determine whether the new
version caused problems, etc, etc.

I'll collapse the follow-on patches back into the base patch (with
suitable metadata in the changelog to show what happened) prior to
sending to Linus.

