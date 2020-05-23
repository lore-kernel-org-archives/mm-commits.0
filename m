From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: +
 mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
 added to -mm tree
Date: Fri, 22 May 2020 17:54:13 -0700
Message-ID: <20200522175413.5a26736e94d21c3281d05119@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
        <20200522030125.5p0fwkx-m%akpm@linux-foundation.org>
        <CANN689HdE5d9ADE=8uRajTRL47oUcEV5mtCO0kRRWR8Jy_J3hg@mail.gmail.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387413AbgEWAyO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 22 May 2020 20:54:14 -0400
In-Reply-To: <CANN689HdE5d9ADE=8uRajTRL47oUcEV5mtCO0kRRWR8Jy_J3hg@mail.gmail.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Michel Lespinasse <walken@google.com>
Cc: mm-commits@vger.kernel.org

On Thu, 21 May 2020 20:23:52 -0700 Michel Lespinasse <walken@google.com> wrote:

> Hi Andrew,
> 
> Thanks for going through this to fix the conflicts. is your current
> git tree exported somewhere, so that I could help fixing such
> conflicts with a coccinelle run ?

My tree changes a lot :( 658 patches so far this cycle, tons on them in
MM.

linux-next is probably the best way to get at it when it's in a
reasonable shape.  Perhaps you could keep an eye on linux-next, do the
occasional grep send me any fixups for anything which I missed?

> On an unrelated note, I wanted to ask about the status of "mm/mmap.c:
> fix the adjusted length error", which I noticed is still in your tree.
> The code there is correct, but changes an O(log N) algorithm into an
> O(N) one, so I am somewhat concerned about it...

It's completely stuck - I'm awaiting some sort of resolution.

It seems that the bug is real - is there any alternative solution on
offer?
