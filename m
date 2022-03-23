Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 529B2C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 16:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245422AbiCWQ3u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 12:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242091AbiCWQ3u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 12:29:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2BB13F90
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 09:28:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2AA5B81F9C
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FC1C340EE;
        Wed, 23 Mar 2022 16:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648052896;
        bh=yrS1HY5KxE+t5c8K5Mc+TcLkYTsfjaaAJ/Jabh0w58Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pem1i9PBBm63huQpsn/UBE2Q47HW9NlUxjRnN6aLJjjiqyr/7NdkwTI8gudboVeXW
         mqGWbrxsDDXwEJYbs8gg07FYM6JphY37q88nmqkyZOVImzGNVMjUfygGypONc/405Y
         Z93/LLJsSIMPJz2b4o7jG8DQdQctqccqdjwVxDQs=
Date:   Wed, 23 Mar 2022 09:28:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     mm-commits@vger.kernel.org, bhe@redhat.com, feng.tang@intel.com,
        pmladek@suse.com, senozhatsky@chromium.org
Subject: Re: + panic-move-panic_print-before-kmsg-dumpers.patch added to -mm
 tree
Message-Id: <20220323092815.cc84a802d11985996c35cfb0@linux-foundation.org>
In-Reply-To: <6a5bbbfd-3071-20dd-80b9-0e3bda3122ce@igalia.com>
References: <20220228185002.EF7D1C340F1@smtp.kernel.org>
        <6a5bbbfd-3071-20dd-80b9-0e3bda3122ce@igalia.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 23 Mar 2022 11:23:39 -0300 "Guilherme G. Piccoli" <gpiccoli@igalia.com> wrote:

> On 28/02/2022 15:50, Andrew Morton wrote:
> > The patch titled
> >      Subject: panic: move panic_print before kmsg dumpers
> > has been added to the -mm tree.  Its filename is
> >      panic-move-panic_print-before-kmsg-dumpers.patch
> > 
> > This patch should soon appear at
> >     https://ozlabs.org/~akpm/mmots/broken-out/panic-move-panic_print-before-kmsg-dumpers.patch
> > and later at
> >     https://ozlabs.org/~akpm/mmotm/broken-out/panic-move-panic_print-before-kmsg-dumpers.patch
> > 
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> > 
> 
> Hi Andrew, I'd like to ask you if it's possible to merge this patch (and
> also [0]) for 5.18. I've checked Linus tree as for today and it's not
> there, I hope there is still time.
> 

Yes, it's in the queue.
