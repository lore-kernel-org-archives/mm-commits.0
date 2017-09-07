From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 071/119] mm: test code to write THP to swap device as a
 whole
Date: Wed, 6 Sep 2017 17:32:52 -0700
Message-ID: <20170906173252.11b42a0f4dfbdd6a2407207e@linux-foundation.org>
References: <20170906232230.hMxC_oT-_%akpm@linux-foundation.org>
        <CA+55aFwrLDgnS1mJxSf55n0-kfFnxW+e41N=wroV0dQKWSqkrA@mail.gmail.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57206 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751985AbdIGAcy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 20:32:54 -0400
In-Reply-To: <CA+55aFwrLDgnS1mJxSf55n0-kfFnxW+e41N=wroV0dQKWSqkrA@mail.gmail.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Jens Axboe <axboe@kernel.dk>, Dan Williams <dan.j.williams@intel.com>, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michal Hocko <mhocko@kernel.org>, Minchan Kim <minchan@kernel.org>, mm-commits@vger.kernel.org, Rik van Riel <riel@redhat.com>, ross.zwisler@intel.com, Shaohua Li <shli@kernel.org>, Vishal L Verma <vishal.l.verma@intel.com>, Huang Ying <ying.huang@intel.com>

On Wed, 6 Sep 2017 17:16:05 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 2017-09-06 16:22 GMT-07:00  <akpm@linux-foundation.org>:
> >
> 
> This email was just an odd 'noname' attachment.
> 
> That *did* contain the patch and the commit message, but it's odd. The
> commit message seems corrupt, and has a ^P in it (hex 0x10, octal
> 020).
> 
> That's probably also the reason it got sent as an attachment instead
> of inline plain text.
> 
> I can fix this up, but please - your automation really should catch
> "oh, there's garbage in there" instead of sending me invalid emails.
> Ok?
> 

Point.

Adding grep -q -P "[\x00-\x08\x0b-\x1f]" to my nightly
check-for-crap-that-people-sent-me script seems to do the trick.

