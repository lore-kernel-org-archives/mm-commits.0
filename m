Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FB59C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 19:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFFDF64F1F
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 19:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhBZTRO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 14:17:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229698AbhBZTRN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 14:17:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33B5E64ED2;
        Fri, 26 Feb 2021 19:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614366993;
        bh=L8ZrTmN4uzH0M/raJE8zbldOw/9q5JAeAug0gX/FdFc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KaGKsvU70ZiQi4koS0UGF8sKEimuQAufN4ZyDMEB7pkppHBtMXHQUnHm6RwHrPgv5
         CsQmHM/dvKnK5k8rfcbs4itGbvmP1Jpu7qnBfQU7l25xFcAkw30FfuAg5h0EtcBVex
         ZgUtEDaDG4p39UzpjI5ZW8oV76zggGa63rlJ+c+U=
Date:   Fri, 26 Feb 2021 11:16:32 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Subject: Re: incoming
Message-Id: <20210226111632.ddaccb9e2c35aaccb95d16b0@linux-foundation.org>
In-Reply-To: <CAHk-=whe0oboEyaUk-p8-wFWWCNDKWwy5vZbCEzm2ZNJTVLY-Q@mail.gmail.com>
References: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
        <CAHk-=whe0oboEyaUk-p8-wFWWCNDKWwy5vZbCEzm2ZNJTVLY-Q@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 26 Feb 2021 09:55:27 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Feb 25, 2021 at 5:14 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > - The rest of MM.
> >
> >   Includes kfence - another runtime memory validator.  Not as
> >   thorough as KASAN, but it has unmeasurable overhead and is intended
> >   to be usable in production builds.
> >
> > - Everything else
> 
> Just to clarify: you have nothing else really pending?

Yes, that's it from me for -rc1.


