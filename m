Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B23AC433EF
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 04:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 404F561037
	for <mm-commits@archiver.kernel.org>; Sat,  6 Nov 2021 04:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhKFEcX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 6 Nov 2021 00:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229485AbhKFEcX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 6 Nov 2021 00:32:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA90860F45;
        Sat,  6 Nov 2021 04:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636172982;
        bh=SZOqknOSxndty+fdHmYk0uPYK4z1kPondQiSs8sKHhw=;
        h=In-Reply-To:References:Date:From:To:Subject:From;
        b=XjjYFalEGlXrLqtclLzs6SQzO58iHcnoFhONf7VonxG23xxw4QNmoYQIqUEPoN+R9
         On0uzsep9K5yi6Fbodx2dNvHzlfEHYl45scc3aKpotvxD27MsC3FedhXReH5J9dgBl
         0vjHlyidBPnxzxBZl3p8qIuPsotIcoNAePbqvx52sI3XJcfLzHBebLxLzF5xypRNbT
         ZYaMkcOMbZE33yKkMFZqvsJZkZ1MKGqPDCY7fr48hOJ/ACZw9LjS1nUtkTpW8cayn5
         +ZH3vOYFlS1cU4g4iDXnE+CNwTwIzYTGBaOa2DQcJ67B2ubO6TY+R7cHeIbH5TaxTB
         DXGmiRHRoNMMA==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 89EEE27C0054;
        Sat,  6 Nov 2021 00:29:40 -0400 (EDT)
Received: from imap48 ([10.202.2.98])
  by compute6.internal (MEProxy); Sat, 06 Nov 2021 00:29:40 -0400
X-ME-Sender: <xms:swSGYbmB71N43NdyDAPTmfry3WmeBtXHr2xgJOqg9g1w0Y1Q34hVbQ>
    <xme:swSGYe2NCDiW7OxB4OyDW9p9SMDgWqK7LmeLJP2-OB7lkUey2EkLPH2iJli0dHsiD
    sEN-4BQ97mDSJwxsAo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrtdejgdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedftehnugih
    ucfnuhhtohhmihhrshhkihdfuceolhhuthhosehkvghrnhgvlhdrohhrgheqnecuggftrf
    grthhtvghrnheptdfhheettddvtedvtedugfeuuefhtddugedvleevleefvdetleffgfef
    vdekgeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnugihodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduudeiudekheei
    fedvqddvieefudeiiedtkedqlhhuthhopeepkhgvrhhnvghlrdhorhhgsehlihhnuhigrd
    hluhhtohdruhhs
X-ME-Proxy: <xmx:swSGYRq0A99PK_fDPr39WUIQgGC2BwSQqcvrlEBhb3CM7da21mo8zg>
    <xmx:swSGYTl3PiEoBp42d4bVV6YrABZcEswHg4btovHfjSI4FUTlZC88kw>
    <xmx:swSGYZ29hdlzTdFqSqBEDKfJfZVMrkEuWpaacQT_JzteTAb80hpXOA>
    <xmx:tASGYWltFW044scB4a60vmNWXVt3oZRUIEO9VEHBYXayzExtrrE0Mw>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id C40C621E006E; Sat,  6 Nov 2021 00:29:39 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1369-gd055fb5e7c-fm-20211018.002-gd055fb5e
Mime-Version: 1.0
Message-Id: <9f241d37-5db8-4cd2-95c5-ef35844d8b08@www.fastmail.com>
In-Reply-To: <20211105203851.Ise-VKP1_%akpm@linux-foundation.org>
References: <20211105203851.Ise-VKP1_%akpm@linux-foundation.org>
Date:   Fri, 05 Nov 2021 21:29:19 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Andrew Morton" <akpm@linux-foundation.org>, anton@ozlabs.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        "Nicholas Piggin" <npiggin@gmail.com>, paulus@ozlabs.org,
        "Randy Dunlap" <rdunlap@infradead.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: Re: [patch 080/262] lazy tlb: allow lazy tlb mm refcounting to be configurable
Content-Type: text/plain
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Nov 5, 2021, at 1:38 PM, Andrew Morton wrote:
> From: Nicholas Piggin <npiggin@gmail.com>
> Subject: lazy tlb: allow lazy tlb mm refcounting to be configurable
>
> Add CONFIG_MMU_TLB_REFCOUNT which enables refcounting of the lazy tlb mm
> when it is context switched.  This can be disabled by architectures that
> don't require this refcounting if they clean up lazy tlb mms when the last
> refcount is dropped.  Currently this is always enabled, which is what
> existing code does, so the patch is effectively a no-op.
>
> Rename rq->prev_mm to rq->prev_lazy_mm, because that's what it is.

Still nacked by me.  Since I seem to have been doing a poor job of explaining my issues with this patch, I'll explain with code:

commit 54b675d9b28d9a56289d06a813250472bc621f40
Author: Andy Lutomirski <luto@kernel.org>
Date:   Fri Nov 5 21:20:47 2021 -0700

    [HACK] demonstrate lazy tlb issues

diff --git a/arch/Kconfig b/arch/Kconfig
index cca27f1b5d0e..19f273642d8f 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -442,6 +442,7 @@ config ARCH_WANT_IRQS_OFF_ACTIVATE_MM
 config MMU_LAZY_TLB_REFCOUNT
 	def_bool y
 	depends on !MMU_LAZY_TLB_SHOOTDOWN
+	depends on !X86
 
 # This option allows MMU_LAZY_TLB_REFCOUNT=n. It ensures no CPUs are using an
 # mm as a lazy tlb beyond its last reference count, by shooting down these
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 25dd795497e8..c5a0c1e92524 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4902,6 +4902,13 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 */
 	arch_start_context_switch(prev);
 
+	/*
+	 * Sanity check: if something went wrong and the previous mm was
+	 * freed while we were still using it, KASAN might not notice
+	 * without help.
+	 */
+	kasan_check_byte(prev->active_mm);
+
 	/*
 	 * kernel -> kernel   lazy + transfer active
 	 *   user -> kernel   lazy + mmgrab_lazy_tlb() active

Build this with KASAN for x86 and try to boot it.  It splats left and right.  The issue is that the !MMU_LAZY_TLB_REFCOUNT mode, while safe under certain select circumstances (maybe -- still not quite convinced) cheats and ignores the fact that the scheduler itself maintains a pointer to the old mm.  On x86, on bare metal, we *already* don't access lazy mms after the process is gone because the pagetable freeing process shoots down the lazy mm, so we are compliant with all the supposed preconditions of this new mode.  But the scheduler itself still has this nonsense active_mm pointer, and, if anyone ever tries to do anything with it (e.g. the above hack to force kasan to validate it), it all blows up.

On top of this, the whole refcount-me-maybe mode seems incredibly fragile, and I don't think the kernel really benefits from having a set of refcount helpers that may or may not keep the supposedly refcounted object alive depending on config.  And the mere fact that my patch appears to work as long as kasan isn't in play should be a pretty good indicator that this whole thing is not terribly robust.

So I think there are a few credible choices:

1. Find an alternative solution that gets the performance we want without dangling references.

2. Make the MMU_LAZY_TLB_REFCOUNT mode genuinely safe.  This means literally ifdeffing out active_mm so it can't dangle.  Doing that cleanly will be a lot of nasty arch work.

I again apologize that my series is taking so long, although I think it's finally getting into decent shape.  I still need to deal with the scs mess (that's new), finish tidying up kthread, and make sure hotplug is good.  But all this is because this is really hairy code and I'm trying to do it right.

If anyone wants to help, help is welcome.  Otherwise, I really do intend to get it all the way done soon.

--Andy
