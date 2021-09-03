Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E51BC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 00:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E32CF60FD7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 00:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243566AbhICAhH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 20:37:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233254AbhICAhH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 20:37:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C784760F21;
        Fri,  3 Sep 2021 00:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630629368;
        bh=QETTcInGWtnFuY/QWZkuxAZhfdn2vMAbAZD94rFsBpI=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=BkKouhu2G0xALwe0/eyofyMpbVQo3tuyBIEPcVugxIm6L0bCHM3Od1+A7v4NsIO5J
         Foog9eXLB1d6J21kwWiUEJY1oeO5/7Rc45gsSOiAsQlxJfsH7156RFgAarLAtle7Jt
         53zXUnaJP8+C1i/3F4RjNoW/EzYxs7Pe+CORlw9wYUuRjr3Il2/1JmppKwdY7FGFF/
         Zsbm90goBpm7LFNqrVL1XyUCwYGd4QipDR1miktZkCfsx+ed2xu3aW/lQrVJHV1OMf
         /l0pp2zroJU2Gu6M3I9qeETitHiZGEeL/QQeK/EuYMZO25KNDc+vXhm8hp/fzzqZJG
         oPb7DGmoF5VMg==
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id E71C327C0054;
        Thu,  2 Sep 2021 20:36:06 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute6.internal (MEProxy); Thu, 02 Sep 2021 20:36:06 -0400
X-ME-Sender: <xms:9W0xYcsovpv0Sk1vIcZFLNchAwFZQytF5VggmMOS9KFpkEIipxwZKg>
    <xme:9W0xYZfctxXbWqBxoKR0idIK5Nsc2yUxQJDjQWnK0GfO9u0qnTuj4hNL7nGsJrLig
    z-8k__VMsV4ajvBMvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddviedgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreerjeenucfhrhhomhepfdetnhgu
    hicunfhuthhomhhirhhskhhifdcuoehluhhtoheskhgvrhhnvghlrdhorhhgqeenucggtf
    frrghtthgvrhhnpeeufedtffejtdeuieevgedtfeeffedttedukeeiffekgfejffdtvdff
    ffekjeejudenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghnugihodhmvghsmhhtphgruhht
    hhhpvghrshhonhgrlhhithihqdduudeiudekheeifedvqddvieefudeiiedtkedqlhhuth
    hopeepkhgvrhhnvghlrdhorhhgsehlihhnuhigrdhluhhtohdruhhs
X-ME-Proxy: <xmx:9W0xYXzuDLSFRnlqk4m55ETnpEXD0tn62AC5nGsm3DuEkI1IWTv0Ag>
    <xmx:9W0xYfNe-O7aFtERLwXye7mFATa1jqluplbXloymjJuH5fCEynbRKw>
    <xmx:9W0xYc-DVmOsq1ug961HQj7T4MqiFB2S18Pb1NchHCuvIxJMMtmxzw>
    <xmx:9m0xYcxWA0_E7N9spGF38f5RC6cREt0V0DxS5dTCxxlGt-aQbnQV6g>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id CE273A002E4; Thu,  2 Sep 2021 20:36:05 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-1126-g6962059b07-fm-20210901.001-g6962059b
Mime-Version: 1.0
Message-Id: <19f558f1-3a31-428f-9b3c-d8dd0783f5d4@www.fastmail.com>
In-Reply-To: <20210902155330.a643b03dc6991cde53133edf@linux-foundation.org>
References: <20210902215620._WXglfIJy%akpm@linux-foundation.org>
 <18b7e206-9ee6-4afe-b662-9dcbdf55a9db@www.fastmail.com>
 <CAHk-=wjC05YZycowZkmvjZACNEm3rUhLTneN+Vaz9Ebp1+++Gw@mail.gmail.com>
 <20210902155330.a643b03dc6991cde53133edf@linux-foundation.org>
Date:   Thu, 02 Sep 2021 17:35:44 -0700
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Cc:     "Anton Blanchard" <anton@ozlabs.org>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        "Nicholas Piggin" <npiggin@gmail.com>,
        "Paul Mackerras" <paulus@ozlabs.org>,
        "Randy Dunlap" <rdunlap@infradead.org>
Subject: =?UTF-8?Q?Re:_[patch_119/212]_lazy_tlb:_shoot_lazies,_a_non-refcounting_?=
 =?UTF-8?Q?lazy_tlb_option?=
Content-Type: text/plain
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Sep 2, 2021, at 3:53 PM, Andrew Morton wrote:
> On Thu, 2 Sep 2021 15:50:03 -0700 Linus Torvalds 
> <torvalds@linux-foundation.org> wrote:
> 
> > On Thu, Sep 2, 2021 at 3:29 PM Andy Lutomirski <luto@kernel.org> wrote:
> > >
> > > This pile is:
> > >
> > > Nacked-by: Andy Lutomirski <luto@kernel.org>
> > 
> > Can you specify exactly the range you want me to drop?
> > 
> > I assume it's the four patches 117-120, ie
> > 
> >   lazy tlb: introduce lazy mm refcount helper functions
> >   lazy tlb: allow lazy tlb mm refcounting to be configurable
> >   lazy tlb: shoot lazies, a non-refcounting lazy tlb option
> >   powerpc/64s: enable MMU_LAZY_TLB_SHOOTDOWN
> > 
> > but I just want to double-check before I do surgery on that series.
> 
> Yes, those 4.
> 
> Sorry, I missed that email thread...
> 

Indeed.

If anyone cares, my WIP series is here:

https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/log/?h=sched/lazymm

It has known bugs and is definitely not ready.  The major known problem is that the kthread and execve paths are still not cleaned up.  (We have several different code paths that change current->mm, and they're not all quite consistent with each other.)  kthread_use_mm() follows its own little set of refcounting rules that is not consistent with the scheduler's expectations, but I think it's just close enough that current kernels will not erroneously free an in-use mm or permanently leak a reference.  I have half-written code to consolidate all the ->mm assignments into a single function, but it's not done.

The CPU offline issue fixed in that series seems to me like it should also affect Nick's series, but I haven't dug in.  I don't immediately see why Nick's series would be able to get away without the same rearrangement I needed.  (You can't *shoot* a lazy TLB entry out from under an offlined CPU -- you need to actually get rid of the reference and account for it correctly.  Perhaps it's all okay in Nick's series because mmdrop() becomes a no-op and the stale logical reference doesn't actually exist.)

--Andy
