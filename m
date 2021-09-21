Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474D0C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 23:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DCEA61184
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 23:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhIUXrU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Sep 2021 19:47:20 -0400
Received: from smtprelay0174.hostedemail.com ([216.40.44.174]:33010 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229824AbhIUXrU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Sep 2021 19:47:20 -0400
Received: from omf02.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 2CD3030162;
        Tue, 21 Sep 2021 23:45:50 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf02.hostedemail.com (Postfix) with ESMTPA id 243461D42F9;
        Tue, 21 Sep 2021 23:45:46 +0000 (UTC)
Message-ID: <af3c775a1515f97c8dbe6a6651bd6e4b6986e8cd.camel@perches.com>
Subject: Re: [patch 9/9] mm/vmalloc: add __alloc_size attributes for better
 bounds checking
From:   Joe Perches <joe@perches.com>
To:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        Christoph Lameter <cl@linux.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Dennis Zhou <dennis@kernel.org>, dwaipayanray1@gmail.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        mm-commits@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>
Date:   Tue, 21 Sep 2021 16:45:44 -0700
In-Reply-To: <202109211630.2D00627@keescook>
References: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
         <20210910031046.G76dQvPhV%akpm@linux-foundation.org>
         <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
         <202109211630.2D00627@keescook>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 243461D42F9
X-Stat-Signature: nmh4sseds13ojprfziwgjcbwyxpdkcp3
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18siCLeLxc9mFEyyVNoRWQi0ZSA3VAUMs8=
X-HE-Tag: 1632267946-356498
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 2021-09-21 at 16:37 -0700, Kees Cook wrote:
> On Fri, Sep 10, 2021 at 10:23:48AM -0700, Linus Torvalds wrote:
> > On Thu, Sep 9, 2021 at 8:10 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > +__alloc_size(1)
> > >  extern void *vmalloc(unsigned long size);
> > [...]
> > 
> > All of these are added in the wrong place - inconsistent with the very
> > compiler documentation the patches add.
> > 
> > The function attributes are generally added _after_ the function,
> > although admittedly we've been quite confused here before.
> > 
> > But the very compiler documentation you point to in the patch that
> > adds these macros gives that as the examples both for gcc and clang:
> > 
> > + *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-alloc_005fsize-function-attribute
> > + * clang: https://clang.llvm.org/docs/AttributeReference.html#alloc-size
> > 
> > and honestly I think that is the preferred format because this is
> > about the *function*, not about the return type.
> > 
> > Do both placements work? Yes.
> 
> I'm cleaning this up now, and have discovered that the reason for the
> before-function placement is consistency with static inlines. If I do this:
> 
> static __always_inline void * kmalloc(size_t size, gfp_t flags) __alloc_size(1)
> {
> 	...
> }
> 
> GCC is very angry:
> 
> ./include/linux/slab.h:519:1: error: attributes should be specified before the declarator in a function definition
>   519 | static __always_inline void *kmalloc_large(size_t size, gfp_t flags) __alloc_size(1)
>       | ^~~~~~
> 
> It's happy if I treat it as a "return type attribute" in the ordering,
> though:
> 
> static __always_inline void * __alloc_size(1) kmalloc(size_t size, gfp_t flags)
> 
> I'll do that unless you have a preference for somewhere else...

_please_ put it before the return type on a separate line.

[__attributes]
[static inline const] <return type> function(<args...>)




