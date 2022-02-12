Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3018DC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 12 Feb 2022 05:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiBLFYr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Feb 2022 00:24:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiBLFYq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Feb 2022 00:24:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5995928E19
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 21:24:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB4A3B82E4E
        for <mm-commits@vger.kernel.org>; Sat, 12 Feb 2022 05:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697EBC340E7;
        Sat, 12 Feb 2022 05:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644643481;
        bh=uEDAhcRzsKIbuXy+ThKnGGt3zbBE61T6oJdwQm2QIa0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UXXWPbTYZiIBrZ+2sX42s2jsYvKEFidIJ8x0EU2Ta+IsjY0skCdhTn8/5KC2Ee81e
         XUA0PmG2xUpKLS2AEvMBUpbcaJA9B4ft3cjc0xUAnipR0xR2/l6KiNtco4To/ZwBFf
         xke1oIh6uQVmZLabkox12Q9cwnyN/iZN/e0tloYM=
Date:   Fri, 11 Feb 2022 21:24:40 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        patches@lists.linux.dev
Subject: Re: incoming
Message-Id: <20220211212440.7fc283e731d05d5ce33dfd43@linux-foundation.org>
In-Reply-To: <CAHk-=wjxzxa36L0hO6FG9BQT9xsjLhi2G61r1EPjO3v7kofEHg@mail.gmail.com>
References: <20220211162756.9f8e8baef81183041ccfc16f@linux-foundation.org>
        <CAHk-=wjxzxa36L0hO6FG9BQT9xsjLhi2G61r1EPjO3v7kofEHg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 11 Feb 2022 18:02:53 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Feb 11, 2022 at 4:27 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > 5 patches, based on f1baf68e1383f6ed93eb9cff2866d46562607a43.
> 
> So this *completely* flummoxed 'b4', because you first sent the wrong
> series, and then sent the right one in the same thread.
> 
> I fetched the emails  manually, but honestly, this was confusing even
> then, with two "[PATCH x/5]" series where the only way to tell the
> right one was basically by date of email. They did arrive in the same
> order in my mailbox, but even that wouldn't have been guaranteed if
> there had been some mailer delays somewhere..

Yes, I wondered.  Sorry bout that.

> So next time when you mess up, resend it all as a completely new
> series and completely new threading - so with a new header email too.
> Please?

Wilco.

> And since I'm here, let me just verify that yes, the series you
> actually want me to apply is this one (as described by the head
> email):
> 
>   Subject: [patch 1/5] fs/binfmt_elf: fix PT_LOAD p_align values ..
>   Subject: [patch 2/5] fs/proc: task_mmu.c: don't read mapcount f..
>   Subject: [patch 3/5] mm: vmscan: remove deadlock due to throttl..
>   Subject: [patch 4/5] mm: memcg: synchronize objcg lists with a ..
>   Subject: [patch 5/5] kfence: make test case compatible with run..
> 
> and not the other one with GUP patches?

Those are the ones.  Five fixes, three with cc:stable.
