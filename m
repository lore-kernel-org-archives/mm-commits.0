Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33DB7C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 16:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E91C2613CD
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 16:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhEKQcn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 12:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231126AbhEKQcn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 12:32:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8367D6188B;
        Tue, 11 May 2021 16:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620750696;
        bh=uPrfte5KaTPUyCLBFLLIvItx3OL8Fb3NwtKkWVMZC9c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E5r4PJfXra6wz1pNqN0eq+N+mzf1jxX1UOkGkhl0pKd6osm/7wcVsGTYSbAGOBPmC
         vGTthBQV1u8dfWE/Sc+e0wiNsYcF7FEm5e6Ko4uJS+sfFDGVrADbnKHjoa9l5GGBrm
         DOZ5zBUUST5AjSJtwoYmEoehxPwQff/Sgf+700nHoiJFVuIakInc9UiemolnMclJDq
         hriT0fbfOEkNypgPB6Aw1gtRAu0F7KS4klr/zyuX7MZrY5gMLNUgEF3IABwDwCVndw
         t5KQ6pvp6dnFrNCmNeo+LmGU97+Wj/qNTUUb5CK8mQYG3Fjd5AASLY1CY6KYfE96ji
         qj6CojX0DkM6Q==
Date:   Tue, 11 May 2021 19:31:23 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Baoquan He <bhe@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        christian.brauner@ubuntu.com, colin.king@canonical.com,
        corbet@lwn.net, frederic@kernel.org, gpiccoli@canonical.com,
        john.p.donnelly@oracle.com, jpoimboe@redhat.com,
        keescook@chromium.org, linux-mm@kvack.org, masahiroy@kernel.org,
        mchehab+huawei@kernel.org, mike.kravetz@oracle.com,
        mingo@kernel.org, mm-commits@vger.kernel.org, paulmck@kernel.org,
        peterz@infradead.org, rdunlap@infradead.org, rostedt@goodmis.org,
        saeed.mirzamohammadi@oracle.com, samitolvanen@google.com,
        sboyd@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com,
        yifeifz2@illinois.edu, Michal Hocko <mhocko@kernel.org>,
        kasong@redhat.com
Subject: Re: [patch 48/91] kernel/crash_core: add crashkernel=auto for vmcore
 creation
Message-ID: <YJqxWy63cokQZ4jQ@kernel.org>
References: <889c6b90-7335-71ce-c955-3596e6ac7c5a@redhat.com>
 <20210508085133.GA2946@localhost.localdomain>
 <2d0f53d9-51ca-da57-95a3-583dc81f35ef@redhat.com>
 <20210510045338.GB2946@localhost.localdomain>
 <4a544493-0622-ac6d-f14b-fb338e33b25e@redhat.com>
 <20210510104359.GC2946@localhost.localdomain>
 <e9332e4e-57bd-9c7c-b3ba-7e3b29fad7c8@redhat.com>
 <YJkcsswrgAudo2vz@dhcp-128-65.nay.redhat.com>
 <b111806c-9103-3f77-7135-f1f773d23b80@redhat.com>
 <20210511133641.GE2834@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511133641.GE2834@localhost.localdomain>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Baoquan,

On Tue, May 11, 2021 at 09:36:41PM +0800, Baoquan He wrote:
> On 05/10/21 at 01:56pm, David Hildenbrand wrote:
> > On 10.05.21 13:44, Dave Young wrote:
> > > Hi David,
> > 
> > Hi Dave,
> > 
> > > On 05/10/21 at 01:01pm, David Hildenbrand wrote:
> > > [snip]
> > > > It also bugged me for quite a bit that we don't have a sane way to achieve
> > > > what we're doing here upstream. It somewhat feels like "this doesn't belong
> > > > in the kernel and is user policy" but then, the existing kernel support is
> > > > suboptimal.
> > > > 
> > > > Maybe reserving some "maybe too big but okayish to boot the system in a sane
> > > > environment -- e.g., X% of system RAM and at least Y" size first and
> > > > shrinking it later as triggered by user space early (where we do seem to
> > > > have a way to pre-calculate things now) might actually be a good direction
> > > > to look into.
> > > 
> > > Hmm, that is also an option we considered before.  Even for your
> > > suggestion we still need a kernel option to set the default ratio/value.
> > > and the ratio/value should be another patch which expands crashkernel
> > > syntax.
> > 
> > Right.
> > 
> > > 
> > > Actually the kconfig help text in this patch is indeed misleading, it is
> > > not introducing crashkernel=a:b... and no need to explain about the
> > > crashkernel syntax, the config option is actually just some interface we
> > > can add any valid crashkernel settings to be used by default. So current
> > > patch help text describes the default value of crash auto str, instead
> > > of describes what crash auto str is.
> > 
> > Right. And I would much rather prefer either
> > 
> > a) handling "auto" completely in the kernel, not just setting some
> > questionable default at compile time
> 
> Thanks for the suggestions.
> 
> If the way adding default value into kernel config is disliked,
> this a) option looks good. We can get value with x% of system RAM, but
> clamp it with CRASH_KERNEL_MIN/MAX. The CRASH_KERNEL_MIN/MAX may need be
> defined with a default value for different ARCHes. It's very close to
> our current implementation, and handling 'auto' in kernel.
> 
> And kernel config provided so that people can tune the MIN/MAX value,
> but no need to post patch to do the tuning each time if have to?
 
Maybe I'm missing something, but the whole point is to avoid kernel
configuration option at all. If the crashkernel=auto works good for 99% of
the cases, there is no need to provide build time configuration along with
it. There are plenty of ways users can control crashkernel reservations
with the existing 2-4 (depending on architecture) command line options.

Simply hard coding a reasonable defaults (e.g.
"1G-64G:128M,64G-1T:256M,1T-:512M"), and using these defaults when
crashkernel=auto is set would cover the same 99% of users you referred to.

If we can resize the reservation later during boot this will also address
David's concern about the wasted memory.

You mentioned that amount of memory that is required for crash kernel
reservation depends on the devices present on the system. Is is possible to
detect how much memory is required at late stages of boot?

> > b) passing it explicitly in via the cmdline
> > 
> > > 
> > > And crashkernel=auto makes this more flexibly. We can tune the values
> > > easily when upgrading.  But if we pass a fixed value in userspace we
> > > can not know if the value is set by distribution automatically or by user
> > > manually thus we can not blindly update it.
> > 
> > I think there are two different cases:
> > 
> > 
> > 1. kernel space updates the value later during boot. "crashkernel=auto"
> > really does the right thing, meaning
> > 
> > a) allocate something reasonable and safe during early boot
> > b) update the allocation during late boot when we know what kind of system
> > we're running on
> > 
> > Then, we indeed care about "crashkernel=auto" in the kernel and I think it
> > would be a nice thing to have. The only question is on how to make that a
> > little configurable, depending on different thingies we might want to run in
> > the crashkernel (assuming someone doesn't want kdump).
> > 
> > 
> > 2. user space updates the value later during boot
> > 
> > IMHO we don't really car who decided on the value as we do the update from
> > user space. If an admin messes with crashkernel=, the admin can also mess
> > with kdump not doing any overwrites (e.g., make that configurable, or detect
> > the overwrite in kdump somehow).
> > 
> > -- 
> > Thanks,
> > 
> > David / dhildenb
> > 
> 
> 

-- 
Sincerely yours,
Mike.
