Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED31C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 09:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7148D61285
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 09:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347253AbhERJZt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 05:25:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25267 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238036AbhERJZq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 05:25:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621329867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FrOQYBS9zkSd8A+za0Y3ZDYccJiOqyYfkPr7lojhvr0=;
        b=Ry1L7uiS4n6aSjrWU0PqYXUcXS5JRpFTBTOYJs3iBQQtqR1mKkB+oji9zrwxGdKf5e8Vai
        yqmlt/1mZ70I59Kt1lisR6izCuEFY6eAsNBvfZQkkbrrQuUrfu53GANq0+c4EjmGnFiJKr
        jdFjv7oB85SDZ+UyPETBDXAxD+hOs3U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-RjJVwtGiMGCZCTJ6__lNUg-1; Tue, 18 May 2021 05:24:25 -0400
X-MC-Unique: RjJVwtGiMGCZCTJ6__lNUg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 118816D4E0;
        Tue, 18 May 2021 09:24:22 +0000 (UTC)
Received: from dhcp-128-65.nay.redhat.com (ovpn-13-91.pek2.redhat.com [10.72.13.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0ED39705B0;
        Tue, 18 May 2021 09:24:07 +0000 (UTC)
Date:   Tue, 18 May 2021 17:24:04 +0800
From:   Dave Young <dyoung@redhat.com>
To:     David Hildenbrand <david@redhat.com>, hbathini@linux.ibm.com
Cc:     Baoquan He <bhe@redhat.com>, Mike Rapoport <rppt@kernel.org>,
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
        kasong@redhat.com, kexec@lists.infradead.org
Subject: Re: [patch 48/91] kernel/crash_core: add crashkernel=auto for vmcore
 creation
Message-ID: <YKOHtMhOZXD/D4ij@dhcp-128-65.nay.redhat.com>
References: <e9332e4e-57bd-9c7c-b3ba-7e3b29fad7c8@redhat.com>
 <YJkcsswrgAudo2vz@dhcp-128-65.nay.redhat.com>
 <b111806c-9103-3f77-7135-f1f773d23b80@redhat.com>
 <20210511133641.GE2834@localhost.localdomain>
 <YJqxWy63cokQZ4jQ@kernel.org>
 <c990270c-30a0-0913-df5a-2c73eb66a436@redhat.com>
 <20210512145150.GG2834@localhost.localdomain>
 <0ef02343-390b-9815-1666-24de4911c0b7@redhat.com>
 <20210518084916.GA12019@MiWiFi-R3L-srv>
 <14966fbd-d852-a240-814a-ab29e2a9b237@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14966fbd-d852-a240-814a-ab29e2a9b237@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

[Add kexec list, for people interested about the old replies, please find in linux-mm archive]
On 05/18/21 at 10:51am, David Hildenbrand wrote:
> On 18.05.21 10:49, Baoquan He wrote:
> > On 05/17/21 at 10:22am, David Hildenbrand wrote:
> > > On 12.05.21 16:51, Baoquan He wrote:
> > > > On 05/11/21 at 07:07pm, David Hildenbrand wrote:
> > > > > > > If the way adding default value into kernel config is disliked,
> > > > > > > this a) option looks good. We can get value with x% of system RAM, but
> > > > > > > clamp it with CRASH_KERNEL_MIN/MAX. The CRASH_KERNEL_MIN/MAX may need be
> > > > > > > defined with a default value for different ARCHes. It's very close to
> > > > > > > our current implementation, and handling 'auto' in kernel.
> > > > > > > 
> > > > > > > And kernel config provided so that people can tune the MIN/MAX value,
> > > > > > > but no need to post patch to do the tuning each time if have to?
> > > > > > Maybe I'm missing something, but the whole point is to avoid kernel
> > > > > > configuration option at all. If the crashkernel=auto works good for 99% of
> > > > > > the cases, there is no need to provide build time configuration along with
> > > > > > it. There are plenty of ways users can control crashkernel reservations
> > > > > > with the existing 2-4 (depending on architecture) command line options.
> > > > > > 
> > > > > > Simply hard coding a reasonable defaults (e.g.
> > > > > > "1G-64G:128M,64G-1T:256M,1T-:512M"), and using these defaults when
> > > > > > crashkernel=auto is set would cover the same 99% of users you referred to.
> > > > > 
> > > > > Right, and we can easily allocate a bit more as a safety net temporarily
> > > > > when we can actually shrink the area later.
> > > > > 
> > > > > > 
> > > > > > If we can resize the reservation later during boot this will also address
> > > > > > David's concern about the wasted memory.
> > > > > > 
> > > > > 
> > > > > Yes.
> > > > > 
> > > > > > You mentioned that amount of memory that is required for crash kernel
> > > > > > reservation depends on the devices present on the system. Is is possible to
> > > > > > detect how much memory is required at late stages of boot?
> > > > > 
> > > > > Here is my thinking:
> > > > > 
> > > > > There seems to be some kind of formula we can roughly use to come up with
> > > > > the final crashkernel size. Baoquan for sure knows all the dirty details, I
> > > > > assume it's roughly "core kernel + drivers + user space".
> > > > > 
> > > > > In the kernel, we can only come up with "core kernel + drivers" expecting
> > > > > that we will run
> > > > > 
> > > > > a) roughly the same kernel
> > > > > b) with roughly the same drivers
> > > > 
> > > > As replied to Mike, kernel size is undecided for different kernel with
> > > > different configs. We can define a default minimal size to cover kernel
> > > > and driver on systems with not many devices, but hardcoding the size
> > > > into upstream is not helpful. If the size is big, users will be asked to
> > > > check and shrink always. If the size is too small, a new value need be
> > > > got and added to cmdline and reboot.
> > > > 
> > > 
> > > Hi Baoquan, Kairui, Dave,
> > > 
> > > so IIUC now, our "old" kernel cannot actually tell us any reliable
> > > "crashkernel area size" because
> > > 
> > > a) it has no idea with which cmdline parameters the crashkernel will be
> > >     started with, and these can have a big impact.
> > > b) it has no idea which driver will be loaded in the crashkernel.
> > > c) It has no idea what will be running in the crashkernel user space.
> > > 
> > > 
> > > AFAIKS, best we can do without further information is, therefore, use some
> > > heuristic to a) allocate some memory early during boot in the kernel and b)
> > > later refine our allocation, triggered by user space (-> shrink the
> > > crashkernel area).
> > > 
> > > I dislike calling a) "auto". It provides a default based on some heuristic
> > > (boot memory size), and that default might be very unfortunate in some
> > > scenarios (-> waste memory).
> > > 
> > > While we could discuss calling the current approach ( a)
> > > )"crashkernel=default", whereby the default is encoded at compile time as
> > > determined by a distributor, I still still quite don't like it because it
> > > feels like this is not necessary. We have a way to pass something like that
> > > via the cmdline, so it's just a matter of properly using that feature from
> > > user space.
> > > 
> > > 
> > > AFAIKS, all you want is most probably a more dynamic way to construct a
> > > kernel cmdline, with some properties specific to a kernel.
> > > 
> > > Let's assume the following:
> > > 
> > > a) When a distributor ships a kernel, he also ships some kind of defaults
> > > file. Let's assume for simplicity
> > > 
> > > /lib/modules/5.11.19-200.fc33.x86_64/defaults.conf
> > > 
> > > The file might contain
> > > 
> > > CRASHKERNEL_DEFAULT=WHATEVER
> > > 
> > > 
> > > b) When generating the cmdline for e.g.,
> > > /boot/loader/entries/XXX-5.11.19-200.fc33.x86_64.conf we run some script
> > > that consult that file in addition to /etc/default/grub. For example, if the
> > > kdump service was installed and /etc/default/grub does not contain
> > > "crashkernel=" (except when we encounter "crashkernel=auto" for compat
> > > handling), we add "crashkernel=WHATEVER". Of course, we might do more
> > > involved stuff based on the current setup, user config, etc.
> > > 
> > > 
> > > c) When we install the kdump service, all we have to do is re-generate the
> > > boot entries AFAIKS. Just like we would when adding "crashkernel=auto" right
> > > now.
> > > 
> > > 
> > > The end result would also allow for having per-kernel defaults and change
> > > them on kernel updates. Would require some thought on how to make it fly in
> > > user space, how to "ship" the defaults etc.
> > 
> > Thanks for looking into this, and really appreciate your insight,
> > comments and patience.
> 
> Thanks for being patient with me :)
> 
> > 
> > We had a sync in team about various viable solutions the other day,
> > and also talked about the similar one as you suggested here since
> > it seems to be able to resolve the concerns we have for a replacement
> > of crashkernel=auto. We will try these in userspace in our side, hope it
> > won't introduce risk and can replace crashkernel=auto perfectly.
> 
> Sure, and as I said, if we want to look into shrinking of the crashkernel
> area triggered by user space, I'm happy to help.
> 

David, Baoquan, thank you both for exploring the issue.  Let's try to do
it like this in downstream.

Kdump initramfs is created for kdump needed only with less memory
requirements, but fadump depends on the normal kernel initramfs thus
fadump needs more memory than kdump.

Hari, with this new no-auto approach, another thing we need to consider is how
fadump will use same value if you do not introduce a new param.  As you
are working in dracut to pack kdump initramfs into 1st kernel initramfs,
it is possible that kdump and fadump can use same value, maybe kdump
crashkernel value plus some static number for powerpc only. Anyway just
a thought.  Please provide your comments if any.

Thanks
Dave

