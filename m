From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: incoming
Date: Sat, 9 Sep 2017 11:09:35 -0700
Message-ID: <20170909110935.a78edd14f8ace0d070882c87@linux-foundation.org>
References: <20170908161001.e84271585208bb6f898a321d@linux-foundation.org>
        <CA+55aFwRXB5_kSuN7o+tqN6Eft6w5oZuLG3B8Rns=0ZZa2ihgA@mail.gmail.com>
        <CA+55aFw+z3HDT4s1C41j=d5_0QTSu8NLSSpnk_jxZ39w34xgnA@mail.gmail.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54838 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbdIISJh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 9 Sep 2017 14:09:37 -0400
In-Reply-To: <CA+55aFw+z3HDT4s1C41j=d5_0QTSu8NLSSpnk_jxZ39w34xgnA@mail.gmail.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, mm-commits@vger.kernel.org

On Sat, 9 Sep 2017 10:40:21 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Sep 8, 2017 at 6:27 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Git does all of this right. Your quilt scripts are garbage. Please
> > please start fixing this.
> >
> > I've worked around it by just editing the patch, but..
> 
> .. and I just realized that your patches must obviously be ok in your
> tree, since you can apply them, and apparently Stephen can apply them
> in linux-next.
> 
> I'm assuming Stephen applies them from your quilt series directly, and
> thus never saw the problem with bad locale conversion.
> 
> Maybe we should just change the workflow, with you sending me a raw
> tar-ball of the quilt series (or whatever the equivalent quilt
> "bundle" is) as an attachment and we forego the traditional
> patch-bombing model?
> 
> That would avoid the locale issues with email.
> 

Leave it with me - I need to sit down and have fiddle for a while.  For
some reason I can't recall I had LOCALE=C set, and using en_US.UTF-8
changes things quite a lot.

And I need to figure out why the heck I did this:

iconv -f latin1 | mailx -s "$subject" "$all"

!
