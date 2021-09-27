Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F30C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 27 Sep 2021 09:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1461861157
	for <mm-commits@archiver.kernel.org>; Mon, 27 Sep 2021 09:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhI0JYp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Sep 2021 05:24:45 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:43035 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233638AbhI0JYo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Sep 2021 05:24:44 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 18R9Mama021544;
        Mon, 27 Sep 2021 11:22:36 +0200
Date:   Mon, 27 Sep 2021 11:22:36 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "apw@canonical.com" <apw@canonical.com>,
        Christoph Lameter <cl@linux.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Dennis Zhou <dennis@kernel.org>,
        "dwaipayanray1@gmail.com" <dwaipayanray1@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Subject: Re: function prototype element ordering
Message-ID: <20210927092236.GC20117@1wt.eu>
References: <20210910031046.G76dQvPhV%akpm@linux-foundation.org>
 <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
 <202109211630.2D00627@keescook>
 <af3c775a1515f97c8dbe6a6651bd6e4b6986e8cd.camel@perches.com>
 <202109211757.F38DF644@keescook>
 <YUraGKetS+Tgc7y9@localhost.localdomain>
 <CAHk-=wjS-Jg7sGMwUPpDsjv392nDOOs0CtUtVkp=S6Q7JzFJRw@mail.gmail.com>
 <6a85bbbf952949118cc5f93b57d48265@AcuMS.aculab.com>
 <CAHk-=wjoLAYG446ZNHfg=GhjSY6nFmuB_wA8fYd5iLBNXjo9Bw@mail.gmail.com>
 <6a84e8b3fa07483092ae79aeded81797@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a84e8b3fa07483092ae79aeded81797@AcuMS.aculab.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Sep 27, 2021 at 08:21:24AM +0000, David Laight wrote:
> Putting '} else {' on one line is important when reading code.

I used not to like that due to "else if ()" being less readable and less
easy to spot, but the arguments you gave regarding the end of screen are
valid and are similar to my hate of GNU's broken "while ()" on its own
line especially after a "do { }" block where it immediately looks like
an accidental infinite loop.

However:

> But none of this is related to the location of attributes unless
> you need to split long lines and put the attribute before the
> function name where you may need.
> 
> static struct frobulate *
> __inline ....
> find_frobulate(....)

This is exactly the case where I hate to dig into code looking like
that: you build, it fails to find symbol "find_frobulate()", you run
"git grep -w find_frobulate" to figure what file provides it, or even
"grep ^find_frobulate" if you want. And you find it in frobulate.c. You
double-check, you find that frobulate.o was built and linked into your
executable. Despite this it fails to find the symbol. Finally you open
the file to discover this painful "static" two lines above, which made
you waste 3 minutes of your time digging at the wrong place.

*Just* for this reason I'm much more careful to always put the type and
name on the same line nowadays.

> Especially if you need #if around the attributes.

This is the only exception I still have to the rule above. But #if by
definition require multi-line processing anyway and they're not welcome
in the middle of control flows.

Willy
