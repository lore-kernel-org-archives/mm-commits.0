From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 21/28] kmemleak: add scheduling point to kmemleak_scan()
Date: Thu, 30 Nov 2017 13:02:05 -0800
Message-ID: <20171130130205.274e684ac5d0dcd36c957bd5@linux-foundation.org>
References: <5a1f4c9c.QpYu2SBbU5scUdTD%akpm@linux-foundation.org>
        <CA+55aFx2T-mEEqV=Jwy+sZvgiLWCM6E=GVNeFrS9V+K=-KO3fA@mail.gmail.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54998 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbdK3VCH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 16:02:07 -0500
In-Reply-To: <CA+55aFx2T-mEEqV=Jwy+sZvgiLWCM6E=GVNeFrS9V+K=-KO3fA@mail.gmail.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, Yisheng Xie <xieyisheng1@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Michal Hocko <mhocko@kernel.org>

On Thu, 30 Nov 2017 04:10:34 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Nov 29, 2017 at 4:11 PM,  <akpm@linux-foundation.org> wrote:
> >
> > kmemleak_scan() will scan struct page for each node and it can be really
> > large and resulting in a soft lockup.
> ..
> > +                       if (!(pfn % (MAX_SCAN_SIZE / sizeof(*page))))
> > +                               cond_resched();
> 
> I applied this already, but looking at it, doesn't the above cause a
> completely pointless divide to get the remainder?
> 
> It seems like it's a pretty damn arbitrary scheduling point too.
> 
> Why isn't it just something like
> 
>         if (!(pfn & 63))
>                 cond_resched();
> 
> which is also entirely arbitrary, but at least generates ok code?
> 
> I guess that depending on config options etc, 'sizeof(struct page)'
> could be just right to hide this all, but it still just seems silly
> and pointless to use some arbitrary and possibly expensive modulus
> operation.
> 

Yup.  In fact it's probably more efficient to just do a bare
cond_resched() on each pass through the loop.

I did this:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/kmemleak.c: make cond_resched() rate-limiting more efficient

bde5f6bc68db5 ("kmemleak: add scheduling point to kmemleak_scan()") tries
to rate-limit the frequency of cond_resched() calls, but does it in a way
which might incur an expensive division operation in the inner loop. 
Simplify this.

Fixes: bde5f6bc68db5 ("kmemleak: add scheduling point to kmemleak_scan()")
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/kmemleak.c~a mm/kmemleak.c
--- a/mm/kmemleak.c~a
+++ a/mm/kmemleak.c
@@ -1523,7 +1523,7 @@ static void kmemleak_scan(void)
 			if (page_count(page) == 0)
 				continue;
 			scan_block(page, page + 1, NULL);
-			if (!(pfn % (MAX_SCAN_SIZE / sizeof(*page))))
+			if (!(pfn & 63))
 				cond_resched();
 		}
 	}
_

