From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 06/67] mm: factor out next_present_section_nr()
Date: Mon, 3 Feb 2020 20:29:00 -0800
Message-ID: <20200203202900.bda79c8f28ddaa63ddd8c740@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
        <20200204013402.UfNC2Pqe3%akpm@linux-foundation.org>
        <CAHk-=widODg0oV6uNrpTvA3tFVN706o-nrWC5XBL9RZ4y3RFcg@mail.gmail.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726994AbgBDE3D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 23:29:03 -0500
In-Reply-To: <CAHk-=widODg0oV6uNrpTvA3tFVN706o-nrWC5XBL9RZ4y3RFcg@mail.gmail.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Baoquan He <bhe@redhat.com>, Dan Williams <dan.j.williams@intel.com>, David Hildenbrand <david@redhat.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Kirill A . Shutemov" <kirill@shutemov.name>, Linux-MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>, Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org, osalvador@suse.de, Pavel Tatashin <pasha.tatashin@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, zhi.jin@intel.com

On Tue, 4 Feb 2020 03:04:40 +0000 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Feb 4, 2020 at 1:34 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > From: David Hildenbrand <david@redhat.com>
> > Subject: mm: factor out next_present_section_nr()
> >
> > Let's move it to the header and use the shorter variant from
> > mm/page_alloc.c (the original one will also check
> > "__highest_present_section_nr + 1", which is not necessary).  While at it,
> > make the section_nr in next_pfn() const.
> >
> > In next_pfn(), we now return section_nr_to_pfn(-1) instead of -1 once we
> > exceed __highest_present_section_nr, which doesn't make a difference i= n
> > the caller as it is big enough (>=3D all sane end_pfn).
> 
> Here, look at that "i= n". It looks like it was a MIME line-break (so
> "in" was MIME-encoded and turned into "i=\nn") followed by you or
> David re-flowing the text without MIME-decoding it.

Yes, my MUA is not good about converting all input.  I have tools to fix
up the patches post-facto but changelogs have been a challenge.

I have updated my nightly check-patches-for-crap-and-email-it-to-andrew
script to check for this.
