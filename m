Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0314C433ED
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 21:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F33A61184
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 21:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhELVNP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 17:13:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240664AbhELTFX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 15:05:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620846236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6BzFZv78Cof8iNVZQwNlWAb90V2wLUHV6tDyeXR0eoQ=;
        b=ZeKGn6FXo/9tGosa9ZOXCPHWnxW4iKWzkZlC8cYXI3O+OJsbnMi8k531kLhbrHQDYntGdg
        YsCym5yTS1m8JSyuoVnCE1Tpv4wy0tGrxTFfktltfOfAbo7dRNJbPOQkSA10dtE3XOScvE
        vDPqKJWpZbnugq2rPiP2x30yCcmuvHA=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-ishyoHZzOMysf6MHIS_ewg-1; Wed, 12 May 2021 15:03:52 -0400
X-MC-Unique: ishyoHZzOMysf6MHIS_ewg-1
Received: by mail-yb1-f197.google.com with SMTP id d89-20020a25a3620000b02904dc8d0450c6so28932142ybi.2
        for <mm-commits@vger.kernel.org>; Wed, 12 May 2021 12:03:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6BzFZv78Cof8iNVZQwNlWAb90V2wLUHV6tDyeXR0eoQ=;
        b=PXqSdWOXe4QrH4oVmvynF+6hgWBA4WjvpG4D0nMLLmoyXmoM4Vzm0ono/h1z9H07wY
         uwPSv3pt2d9DlfgrZYGJOi5dfSalN8Hg9UxK2kDL3/trZY44v+x0NAZP1oIoPWrmL2ny
         CG4mJxofdEq2g1E4yZetogsuvUEhx96Aa45KJ1N/alXu651dHlBP9Wydgig6ycZHmriv
         AIxwmHDf356Y0WPxtUwu0Spr/S367eeh9XEjNRZUiwtg2eTET6xRP7f5rPtS8u5sc0Pp
         lQqUNy7YbIQE1667lXn8hiEl7Z1K6Y1MDDessI/fOx1SWRaSLMolGpwEHlE3f3Bj2gtE
         UBCQ==
X-Gm-Message-State: AOAM5318ijrIW8Tg8+rlI/IrCMMyHs1Vc/fsX2FGXIGYjTov1AHJJsid
        yQHJmTpNAsMKvOFWrgDumVX+nGOcQxoihiEgndO1lhQ6EvbhxxTOp/OvKZJ1uC+TZAokck7dTQu
        /JG8Vhc6h09ENheKQvuTCRezIh18EVyssMccDLA==
X-Received: by 2002:a25:880f:: with SMTP id c15mr47990782ybl.247.1620846231866;
        Wed, 12 May 2021 12:03:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzX6S4nsLKJX94McEl3Ujz7R+tMvD6NUSTE8iPEz/xc7T6wOdmRKlzUcd51nJCOaHEg4GRnJwXDuyNlWj6p1LY=
X-Received: by 2002:a25:880f:: with SMTP id c15mr47990740ybl.247.1620846231664;
 Wed, 12 May 2021 12:03:51 -0700 (PDT)
MIME-Version: 1.0
References: <2d0f53d9-51ca-da57-95a3-583dc81f35ef@redhat.com>
 <20210510045338.GB2946@localhost.localdomain> <4a544493-0622-ac6d-f14b-fb338e33b25e@redhat.com>
 <20210510104359.GC2946@localhost.localdomain> <e9332e4e-57bd-9c7c-b3ba-7e3b29fad7c8@redhat.com>
 <YJkcsswrgAudo2vz@dhcp-128-65.nay.redhat.com> <b111806c-9103-3f77-7135-f1f773d23b80@redhat.com>
 <20210511133641.GE2834@localhost.localdomain> <YJqxWy63cokQZ4jQ@kernel.org>
 <c990270c-30a0-0913-df5a-2c73eb66a436@redhat.com> <20210512145150.GG2834@localhost.localdomain>
In-Reply-To: <20210512145150.GG2834@localhost.localdomain>
From:   Kairui Song <kasong@redhat.com>
Date:   Thu, 13 May 2021 03:03:40 +0800
Message-ID: <CACPcB9ez26pi3iEa__1wucB3KWWrwJYG=XYfiGfbHJ4EzCcV=g@mail.gmail.com>
Subject: Re: [patch 48/91] kernel/crash_core: add crashkernel=auto for vmcore creation
To:     David Hildenbrand <david@redhat.com>, Baoquan He <bhe@redhat.com>
Cc:     Mike Rapoport <rppt@kernel.org>, Dave Young <dyoung@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        John Donnelly <john.p.donnelly@oracle.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kees Cook <keescook@chromium.org>, linux-mm@kvack.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Ingo Molnar <mingo@kernel.org>, mm-commits@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        torvalds@linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>,
        YiFei Zhu <yifeifz2@illinois.edu>,
        Michal Hocko <mhocko@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, May 12, 2021 at 10:52 PM Baoquan He <bhe@redhat.com> wrote:
> On 05/11/21 at 07:07pm, David Hildenbrand wrote:
> > > > If the way adding default value into kernel config is disliked,
> > > > this a) option looks good. We can get value with x% of system RAM, but
> > > > clamp it with CRASH_KERNEL_MIN/MAX. The CRASH_KERNEL_MIN/MAX may need be
> > > > defined with a default value for different ARCHes. It's very close to
> > > > our current implementation, and handling 'auto' in kernel.
> > > >
> > > > And kernel config provided so that people can tune the MIN/MAX value,
> > > > but no need to post patch to do the tuning each time if have to?
> > > Maybe I'm missing something, but the whole point is to avoid kernel
> > > configuration option at all. If the crashkernel=auto works good for 99% of
> > > the cases, there is no need to provide build time configuration along with
> > > it. There are plenty of ways users can control crashkernel reservations
> > > with the existing 2-4 (depending on architecture) command line options.
> > >
> > > Simply hard coding a reasonable defaults (e.g.
> > > "1G-64G:128M,64G-1T:256M,1T-:512M"), and using these defaults when
> > > crashkernel=auto is set would cover the same 99% of users you referred to.
> >
> > Right, and we can easily allocate a bit more as a safety net temporarily
> > when we can actually shrink the area later.
> >
> > >
> > > If we can resize the reservation later during boot this will also address
> > > David's concern about the wasted memory.
> > >
> >
> > Yes.
> >
> > > You mentioned that amount of memory that is required for crash kernel
> > > reservation depends on the devices present on the system. Is is possible to
> > > detect how much memory is required at late stages of boot?
> >
> > Here is my thinking:
> >
> > There seems to be some kind of formula we can roughly use to come up with
> > the final crashkernel size. Baoquan for sure knows all the dirty details, I
> > assume it's roughly "core kernel + drivers + user space".
> >
> > In the kernel, we can only come up with "core kernel + drivers" expecting
> > that we will run
> >
> > a) roughly the same kernel
> > b) with roughly the same drivers
>
> As replied to Mike, kernel size is undecided for different kernel with
> different configs. We can define a default minimal size to cover kernel
> and driver on systems with not many devices, but hardcoding the size
> into upstream is not helpful. If the size is big, users will be asked to
> check and shrink always. If the size is too small, a new value need be
> got and added to cmdline and reboot.
>
> >
> > The "user space" part is completely under user space control, depending on
> > what application will be run after kexec.
> >
> > So I wonder if something like
> >
> > crashkernel=auto,100M
> >
> > whereby "100M" corresponds to user space demands in addition to the variable
> > part depend on the current kernel + drivers.
> >
> > would already be somewhat sufficient for main use cases I guess.
> >
> > Of course, that approach will get more complicated if the user space portion
> > heavily depends on the drivers etc. Then we need more tunables.
> >

I actually like this idea of "crashkernel=auto,100M" at first look, it
gives some tunable space for userspace, and kernel can just take care
of its own memory usage. Userspace is completely undeterminable.

But unfortunately estimating kernel usage for kdump is also very hard.
It's heavily related to the kdump kernel's cmdline, and kernel has
many kdump specified behavior/workaround that affects mem usage, and
kernel kconfig also affects it.

Just for example, `nr_cpus=1`, `noefi` are commonly used for kdump
kernel cmdline to reduce memory usage, but it's also completely
acceptable to not use such kernel params for kdump kernel. Even a
rough estimation most likely won't work, those moving parts can change
the memory usage by a lot.

So basically the kdump's memory usage (userspace or kernel) is not
estimable from kernel side in a generic way. It's strictly bonded to
distro implementation and config.

And also that's why this patch started with adding a kconfig, so
distros can set a value that corresponds to their default setup.

Baoquan has added reasons why passing the `crashkernel=` config via
cmdline also mess things up. So at the time this patch is sent, having
a tunable (via kconfig) `crashkernel=auto` seemed the most helpful
way. I'm not sure if there is a better way to make it distro tunable
if not through kconfig.

--
Best Regards,
Kairui Song

