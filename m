From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-fix.patch added to
 -mm tree
Date: Mon, 28 Dec 2015 15:33:38 -0800
Message-ID: <20151228153338.18559bd03937e815c2d8210b@linux-foundation.org>
References: <5681c369.NUC7dyHWDtPkGXzu%akpm@linux-foundation.org>
	<5681C5DB.90207@oracle.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbbL1Xdj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Dec 2015 18:33:39 -0500
In-Reply-To: <5681C5DB.90207@oracle.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Sasha Levin <sasha.levin@oracle.com>
Cc: kirill.shutemov@linux.intel.com, dan.j.williams@intel.com, mm-commits@vger.kernel.org

On Mon, 28 Dec 2015 18:29:31 -0500 Sasha Levin <sasha.levin@oracle.com> wrote:

> On 12/28/2015 06:19 PM, akpm@linux-foundation.org wrote:
> > The patch titled
> >      Subject: thp: fix regression in handling mlocked pages in  __split_huge_pmd()
> > has been added to the -mm tree.  Its filename is
> >      mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-fix.patch
> > 
> > This patch should soon appear at
> >     http://ozlabs.org/~akpm/mmots/broken-out/mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-fix.patch
> > and later at
> >     http://ozlabs.org/~akpm/mmotm/broken-out/mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-fix.patch
> > 
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> > 
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > 
> > The -mm tree is included into linux-next and is updated
> > there every 3-4 working days
> > 
> > ------------------------------------------------------
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > Subject: thp: fix regression in handling mlocked pages in  __split_huge_pmd()
> > 
> > This patch fixes regression caused by patch
> >  "mm, dax: dax-pmd vs thp-pmd vs hugetlbfs-pmd"
> > 
> > The patch makes pmd_trans_huge() check and "page = pmd_page(*pmd)" after
> > __split_huge_pmd_locked(). It can never succeed, since the pmd already
> > points to a page table. As result the page is never get munlocked.
> > 
> > It causes crashes like this:
> >  http://lkml.kernel.org/r/5661FBB6.6050307@oracle.com
> 
> I've mentioned it in the original threat, but this patch doesn't fix the
> issue I've reported.

Yes, thanks, noted.

This is a really big problem - I'm sitting on a HUGE number of MM and
DAX patches and I don't know which ones will need to be held out of 4.5
if we can't get this fixed, and holding out some patches will screw up
everything else.

So please, guys - urgency on this one!

> Maybe it fixes a different issue, but the description
> should be different.

Yup, I deleted the third paragraph.
