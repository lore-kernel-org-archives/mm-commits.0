Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F6B3C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 11 Sep 2021 05:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16DB1611C3
	for <mm-commits@archiver.kernel.org>; Sat, 11 Sep 2021 05:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhIKFhZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Sep 2021 01:37:25 -0400
Received: from smtprelay0116.hostedemail.com ([216.40.44.116]:54288 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230392AbhIKFhZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Sat, 11 Sep 2021 01:37:25 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Sep 2021 01:37:25 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave04.hostedemail.com (Postfix) with ESMTP id 880D3180E36C5
        for <mm-commits@vger.kernel.org>; Sat, 11 Sep 2021 05:29:30 +0000 (UTC)
Received: from omf19.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id EB7B829DF1;
        Sat, 11 Sep 2021 05:29:28 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf19.hostedemail.com (Postfix) with ESMTPA id D2EB520D758;
        Sat, 11 Sep 2021 05:29:24 +0000 (UTC)
Message-ID: <4028a9be304ae79d55d2ad099651c640f583df5d.camel@perches.com>
Subject: Re: [patch 9/9] mm/vmalloc: add __alloc_size attributes for better
 bounds checking
From:   Joe Perches <joe@perches.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     apw@canonical.com, Christoph Lameter <cl@linux.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Dennis Zhou <dennis@kernel.org>, dwaipayanray1@gmail.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kees Cook <keescook@chromium.org>,
        Linux-MM <linux-mm@kvack.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        mm-commits@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>
Date:   Fri, 10 Sep 2021 22:29:23 -0700
In-Reply-To: <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
References: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
         <20210910031046.G76dQvPhV%akpm@linux-foundation.org>
         <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: D2EB520D758
X-Stat-Signature: i91pz8j5jei8bzz71za3ieogfgs7zec9
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+9w6GlThcpvVJijJed+sZKczcsjABR48o=
X-HE-Tag: 1631338164-2999
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 2021-09-10 at 10:23 -0700, Linus Torvalds wrote:
> On Thu, Sep 9, 2021 at 8:10 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > +__alloc_size(1)
> >  extern void *vmalloc(unsigned long size);
[]
> So wouldn't this all have looked much more natural as
> 
>      void *vmalloc(unsigned long size) __malloc(1);
> 
> instead? Hmm?

I think not as the __malloc attribute and in fact all the other function
attributes are effectively uninteresting when it comes to grepping for
function declarations.

Putting the attribute lists after the function arguments in many
cases would just be visual noise.

My preference would be for declarations to be mostly like:

[optional attribute list[
<return type> function(arguments);

Frequently there are multiline function declarations with many
arguments similar to either of

[optional attribute list]
<return type> function(type arg1,
		       type arg2,
		       etc...);

or

[optional attribute list]
<return type>
function(type arg1,
	 type arg2,
	 etc...);

which always makes grep rather difficult.

And given the expansion is naming lengths there are more and more
of these multiline argument lists.  It doesn't matter if the line
length is increased above 80 columns or not.



