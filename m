Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E950C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 619AD61054
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347689AbhIBWaO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347658AbhIBWaO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:30:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6571D61041;
        Thu,  2 Sep 2021 22:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630621755;
        bh=ZYUoj8uNbeoGQhvVrrklATONEnS12dpU/powW3BhYJs=;
        h=In-Reply-To:References:Date:From:To:Subject:From;
        b=qZmOlK8nLgVVavDE0Pb4n0BkLdOazut3Iiz1EENpInxQ98+Vuj+Aia0pdGiAqNAcT
         YNaLdpgS0MFpdpb8JLvWlaWM8/Dc3lPFlYX1ymnpympgU3plxCZJ7g5ivTbCdMQDJZ
         oMZVQ9mWjGdMGFbKx2gFO9/FroA8MVgOH+RRcVEUmFpnmVTm5Zoh+E15414lu/J+x0
         MP00K1fJJfV/xh5vE8d2ulrcE2jqfqdNISbelX+l0K9EJvNDI+mTiS1jO1BADig/RH
         CX6m0KO8wmSvlJwuVFV1ZyU2fV0tVTWYB+KRiralLPnuzlh6RlVzX8JM4tz6LF8lio
         AGP60EzFj+iXw==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 774EF27C0054;
        Thu,  2 Sep 2021 18:29:13 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute6.internal (MEProxy); Thu, 02 Sep 2021 18:29:13 -0400
X-ME-Sender: <xms:OFAxYbwiwar1TF1ofa4Y8c09CQedduUnp6_Eg8LBgQ0I84wy8v5WIA>
    <xme:OFAxYTTOto7GScO0nCja0sU3NdJUu3L8sYS6boMF4yBhudQhXsGOGKFqDP5sp1aLr
    E0dK-gZgbyRrwNGJLI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddviedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgfgsehtqhertderreejnecuhfhrohhmpedftehn
    ugihucfnuhhtohhmihhrshhkihdfuceolhhuthhosehkvghrnhgvlhdrohhrgheqnecugg
    ftrfgrthhtvghrnhepuefgueefveekhedvtdffgfekleehgfekheevteegieekgeehiedv
    fffgjeetudfhnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhguhidomhgvshhmthhprghu
    thhhphgvrhhsohhnrghlihhthidqudduiedukeehieefvddqvdeifeduieeitdekqdhluh
    htoheppehkvghrnhgvlhdrohhrgheslhhinhhugidrlhhuthhordhush
X-ME-Proxy: <xmx:OFAxYVXcaCg1y8reSYbbDYmhrbH_LF2SS4aBx9LUsVXPsnHNGzWuzw>
    <xmx:OFAxYVia2YO72vTmyZPiTJ0NB6MCeJahEsSG83eqE9Nc8DL_YOMkqw>
    <xmx:OFAxYdCLtXn6-ZAAU79M_6Ij6KWN3NX5E-mCCa1SN0ApBtrSn7PTUw>
    <xmx:OVAxYf2u7MWfXqzyXa225xtfAscwM4XSHSDKgUCiOACbfRZJFqauZA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 6DA71A002E4; Thu,  2 Sep 2021 18:29:12 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1126-g6962059b07-fm-20210901.001-g6962059b
Mime-Version: 1.0
Message-Id: <18b7e206-9ee6-4afe-b662-9dcbdf55a9db@www.fastmail.com>
In-Reply-To: <20210902215620._WXglfIJy%akpm@linux-foundation.org>
References: <20210902215620._WXglfIJy%akpm@linux-foundation.org>
Date:   Thu, 02 Sep 2021 15:28:52 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Andrew Morton" <akpm@linux-foundation.org>, anton@ozlabs.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        "Nicholas Piggin" <npiggin@gmail.com>, paulus@ozlabs.org,
        "Randy Dunlap" <rdunlap@infradead.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: =?UTF-8?Q?Re:_[patch_119/212]_lazy_tlb:_shoot_lazies,_a_non-refcounting_?=
 =?UTF-8?Q?lazy_tlb_option?=
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On Thu, Sep 2, 2021, at 2:56 PM, Andrew Morton wrote:
> From: Nicholas Piggin <npiggin@gmail.com>
> Subject: lazy tlb: shoot lazies, a non-refcounting lazy tlb option
>=20
> On big systems, the mm refcount can become highly contented when doing=
 a
> lot of context switching with threaded applications (particularly
> switching between the idle thread and an application thread).
>=20
> Abandoning lazy tlb slows switching down quite a bit in the important
> user->idle->user cases, so instead implement a non-refcounted scheme t=
hat
> causes __mmdrop() to IPI all CPUs in the mm_cpumask and shoot down any
> remaining lazy ones.
>=20
> Shootdown IPIs are some concern, but they have not been observed to be=
 a
> big problem with this scheme (the powerpc implementation generated 314
> additional interrupts on a 144 CPU system during a kernel compile).  T=
here
> are a number of strategies that could be employed to reduce IPIs if th=
ey
> turn out to be a problem for some workload.

This pile is:

Nacked-by: Andy Lutomirski <luto@kernel.org>

For reasons that have been discussed previously. My series is still in p=
rogress.  It=E2=80=99s moving slowly for two reasons.  First, I have lim=
ited time to work on it. Second, the existing mm refcounting is a giant =
pile of worms, and that needs fixing one way or another before we add ye=
t more complexity. For example, has anyone noticed that kthread mms are =
refcounted using different rules than everything else?

Even if my modified refcounting scheme isn=E2=80=99t the eventual winner=
, the prerequisite cleanups are still prerequisites. I absolutely nack a=
nything that adds yet more nonsensical complexity to the existing scheme=
, makes it substantially more fragile, and does not fix the underlying c=
rap that makes speeding up responsibly such a mess.

Nick or anyone else, you=E2=80=99re welcome to finish up my series (and =
I can give pointers) or you can wait.

>=20
> [npiggin@gmail.com: update comments]
>   Link: https://lkml.kernel.org/r/1623121901.mszkmmum0n.astroid@bobo.n=
one
> Link: https://lkml.kernel.org/r/20210605014216.446867-4-npiggin@gmail.=
com
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> Cc: Anton Blanchard <anton@ozlabs.org>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@ozlabs.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  arch/Kconfig  |   14 +++++++++++++
>  kernel/fork.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 65 insertions(+)
>=20
> --- a/arch/Kconfig~lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-op=
tion
> +++ a/arch/Kconfig
> @@ -438,6 +438,20 @@ config ARCH_WANT_IRQS_OFF_ACTIVATE_MM
>  # to a kthread ->active_mm (non-arch code has been converted already).
>  config MMU_LAZY_TLB_REFCOUNT
>  	def_bool y
> +	depends on !MMU_LAZY_TLB_SHOOTDOWN
> +
> +# This option allows MMU_LAZY_TLB_REFCOUNT=3Dn. It ensures no CPUs ar=
e using an
> +# mm as a lazy tlb beyond its last reference count, by shooting down =
these
> +# users before the mm is deallocated. __mmdrop() first IPIs all CPUs =
that may
> +# be using the mm as a lazy tlb, so that they may switch themselves t=
o using
> +# init_mm for their active mm. mm_cpumask(mm) is used to determine wh=
ich CPUs
> +# may be using mm as a lazy tlb mm.
> +#
> +# To implement this, an arch must ensure mm_cpumask(mm) contains at l=
east all
> +# possible CPUs in which the mm is lazy, and it must meet the require=
ments for
> +# MMU_LAZY_TLB_REFCOUNT=3Dn (see above).
> +config MMU_LAZY_TLB_SHOOTDOWN
> +	bool
> =20
>  config ARCH_HAVE_NMI_SAFE_CMPXCHG
>  	bool
> --- a/kernel/fork.c~lazy-tlb-shoot-lazies-a-non-refcounting-lazy-tlb-o=
ption
> +++ a/kernel/fork.c
> @@ -674,6 +674,53 @@ static void check_mm(struct mm_struct *m
>  #define allocate_mm()	(kmem_cache_alloc(mm_cachep, GFP_KERNEL))
>  #define free_mm(mm)	(kmem_cache_free(mm_cachep, (mm)))
> =20
> +static void do_shoot_lazy_tlb(void *arg)
> +{
> +	struct mm_struct *mm =3D arg;
> +
> +	if (current->active_mm =3D=3D mm) {
> +		WARN_ON_ONCE(current->mm);
> +		current->active_mm =3D &init_mm;
> +		switch_mm(mm, &init_mm, current);
> +	}
> +}
> +
> +static void do_check_lazy_tlb(void *arg)
> +{
> +	struct mm_struct *mm =3D arg;
> +
> +	WARN_ON_ONCE(current->active_mm =3D=3D mm);
> +}
> +
> +static void shoot_lazy_tlbs(struct mm_struct *mm)
> +{
> +	if (IS_ENABLED(CONFIG_MMU_LAZY_TLB_SHOOTDOWN)) {
> +		/*
> +		 * IPI overheads have not found to be expensive, but they could
> +		 * be reduced in a number of possible ways, for example (in
> +		 * roughly increasing order of complexity):
> +		 * - A batch of mms requiring IPIs could be gathered and freed
> +		 *   at once.
> +		 * - CPUs could store their active mm somewhere that can be
> +		 *   remotely checked without a lock, to filter out
> +		 *   false-positives in the cpumask.
> +		 * - After mm_users or mm_count reaches zero, switching away
> +		 *   from the mm could clear mm_cpumask to reduce some IPIs
> +		 *   (some batching or delaying would help).
> +		 * - A delayed freeing and RCU-like quiescing sequence based on
> +		 *   mm switching to avoid IPIs completely.
> +		 */
> +		on_each_cpu_mask(mm_cpumask(mm), do_shoot_lazy_tlb, (void *)mm, 1);
> +		if (IS_ENABLED(CONFIG_DEBUG_VM))
> +			on_each_cpu(do_check_lazy_tlb, (void *)mm, 1);
> +	} else {
> +		/*
> +		 * In this case, lazy tlb mms are refounted and would not reach
> +		 * __mmdrop until all CPUs have switched away and mmdrop()ed.
> +		 */
> +	}
> +}
> +
>  /*
>   * Called when the last reference to the mm
>   * is dropped: either by a lazy thread or by
> @@ -683,6 +730,10 @@ void __mmdrop(struct mm_struct *mm)
>  {
>  	BUG_ON(mm =3D=3D &init_mm);
>  	WARN_ON_ONCE(mm =3D=3D current->mm);
> +
> +	/* Ensure no CPUs are using this as their lazy tlb mm */
> +	shoot_lazy_tlbs(mm);
> +
>  	WARN_ON_ONCE(mm =3D=3D current->active_mm);
>  	mm_free_pgd(mm);
>  	destroy_context(mm);
> _
>=20
