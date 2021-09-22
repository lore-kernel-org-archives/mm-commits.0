Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F38C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 22 Sep 2021 11:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1D646112F
	for <mm-commits@archiver.kernel.org>; Wed, 22 Sep 2021 11:19:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235151AbhIVLVR convert rfc822-to-8bit (ORCPT
        <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Sep 2021 07:21:17 -0400
Received: from mga12.intel.com ([192.55.52.136]:55531 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230171AbhIVLVQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 22 Sep 2021 07:21:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="203065012"
X-IronPort-AV: E=Sophos;i="5.85,313,1624345200"; 
   d="scan'208";a="203065012"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 04:19:46 -0700
X-IronPort-AV: E=Sophos;i="5.85,313,1624345200"; 
   d="scan'208";a="557422965"
Received: from vidyaram-mobl1.gar.corp.intel.com (HELO localhost) ([10.251.218.73])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 04:19:39 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
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
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        linux-doc@vger.kernel.org
Subject: Re: function prototype element ordering
In-Reply-To: <YUraGKetS+Tgc7y9@localhost.localdomain>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org> <20210910031046.G76dQvPhV%akpm@linux-foundation.org> <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com> <202109211630.2D00627@keescook> <af3c775a1515f97c8dbe6a6651bd6e4b6986e8cd.camel@perches.com> <202109211757.F38DF644@keescook> <YUraGKetS+Tgc7y9@localhost.localdomain>
Date:   Wed, 22 Sep 2021 14:19:28 +0300
Message-ID: <874kacn9hb.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 22 Sep 2021, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Tue, Sep 21, 2021 at 07:25:53PM -0700, Kees Cook wrote:
>> On Tue, Sep 21, 2021 at 04:45:44PM -0700, Joe Perches wrote:
>> > On Tue, 2021-09-21 at 16:37 -0700, Kees Cook wrote:
>> > > On Fri, Sep 10, 2021 at 10:23:48AM -0700, Linus Torvalds wrote:
>> > > > On Thu, Sep 9, 2021 at 8:10 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>> > > > > 
>> > > > > +__alloc_size(1)
>> > > > >  extern void *vmalloc(unsigned long size);
>> > > > [...]
>> > > > 
>> > > > All of these are added in the wrong place - inconsistent with the very
>> > > > compiler documentation the patches add.
>> > > > 
>> > > > The function attributes are generally added _after_ the function,
>> > > > although admittedly we've been quite confused here before.
>> > > > 
>> > > > But the very compiler documentation you point to in the patch that
>> > > > adds these macros gives that as the examples both for gcc and clang:
>> > > > 
>> > > > + *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-alloc_005fsize-function-attribute
>> > > > + * clang: https://clang.llvm.org/docs/AttributeReference.html#alloc-size
>> > > > 
>> > > > and honestly I think that is the preferred format because this is
>> > > > about the *function*, not about the return type.
>> > > > 
>> > > > Do both placements work? Yes.
>> > > 
>> > > I'm cleaning this up now, and have discovered that the reason for the
>> > > before-function placement is consistency with static inlines. If I do this:
>> > > 
>> > > static __always_inline void * kmalloc(size_t size, gfp_t flags) __alloc_size(1)
>> > > {
>> > > 	...
>> > > }
>> > > 
>> > > GCC is very angry:
>> > > 
>> > > ./include/linux/slab.h:519:1: error: attributes should be specified before the declarator in a function definition
>> > >   519 | static __always_inline void *kmalloc_large(size_t size, gfp_t flags) __alloc_size(1)
>> > >       | ^~~~~~
>> > > 
>> > > It's happy if I treat it as a "return type attribute" in the ordering,
>> > > though:
>> > > 
>> > > static __always_inline void * __alloc_size(1) kmalloc(size_t size, gfp_t flags)
>> > > 
>> > > I'll do that unless you have a preference for somewhere else...
>> > 
>> > _please_ put it before the return type on a separate line.
>> > 
>> > [__attributes]
>> > [static inline const] <return type> function(<args...>)
>> 
>> Somehow Linus wasn't in CC. :P
>> 
>> Linus, what do you want here? I keep getting conflicting (or
>> uncompilable) advice. I'm also trying to prepare a patch for
>> Documentation/process/coding-style.rst ...
>> 
>> Looking through what was written before[1] and through examples in the
>> source tree, I find the following categories:
>> 
>> 1- storage class: static extern inline __always_inline
>> 2- storage class attributes/hints/???: __init __cold
>> 3- return type: void *
>> 4- return type attributes: __must_check __noreturn __assume_aligned(n)
>> 5- function attributes: __attribute_const__ __malloc
>> 6- function argument attributes: __printf(n, m) __alloc_size(n)
>> 
>> Everyone seems to basically agree on:
>> 
>> [storage class] [return type] [return type attributes] [name]([arg1type] [arg1name], ...)
>> 
>> There is a lot of disagreement over where 5 and 6 should fit in above. And
>> there is a lot of confusion over 4 (mixed between before and after the
>> function name) and 2 (see below).
>> 
>> What's currently blocking me is that 6 cannot go after the function
>> (for definitions) because it angers GCC (see quoted bit above), but 5
>> can (e.g. __attribute_const__).
>> 
>> Another inconsistency seems to be 2 (mainly section markings like
>> __init). Sometimes it's after the storage class and sometimes after the
>> return type, but it certainly feels more like a storage class than a
>> return type attribute:
>> 
>> $ git grep 'static __init int' | wc -l
>> 349
>> $ git grep 'static int __init' | wc -l
>> 8402
>> 
>> But it's clearly positioned like a return type attribute in most of the
>> tree. What's correct?
>> 
>> Regardless, given the constraints above, it seems like what Linus may
>> want is (on "one line", though it will get wrapped in pathological cases
>> like kmem_cache_alloc_node_trace):
>> 
>> [storage class] [storage class attributes] [return type] [return type attributes] [function argument attributes] [name]([arg1type] [arg1name], ...) [function attributes]
>> 
>> Joe appears to want (on two lines):
>> 
>> [storage class attributes] [function attributes] [function argument attributes]
>> [storage class] [return type] [return type attributes] [name]([arg1type] [arg1name], ...)
>> 
>> I would just like to have an arrangement that won't get NAKed by
>> someone. ;) And I'm willing to document it. :)
>
> Attributes should be on their own line, they can be quite lengthy.
>
> 	__attribute__((...))
> 	[static] [inline] T f(A1 arg1, ...)
> 	{
> 		...
> 	}
>
> There will be even more attributes in the future, both added by
> compilers and developers (const, pure, WUR), so let's make "prototype lane"
> for them.
>
> Same for structures:
>
> 	__attribute__((packed))
> 	struct S {
> 	};
>
> Kernel practice of hiding attributes under defines (__ro_after_init)
> breaks ctags which parses the last identifier before semicolon as object
> name. Naturally, it is ctags bug, but placing attributes before
> declaration will autmatically unbreak such cases.

git grep seems to suggest __packed is preferred over
__attribute__((packed)), and at the end of the struct declaration
instead of at front:

	struct S {
		/* ... */
        } __packed;

And GNU Global handles this just fine. ;)


BR,
Jani.

-- 
Jani Nikula, Intel Open Source Graphics Center
