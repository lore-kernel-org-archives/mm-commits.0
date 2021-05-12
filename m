Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A93C433B4
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 14:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 651F46127A
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 14:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhELOP1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 10:15:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231521AbhELOO4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 10:14:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620828828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lLnTRKHFiueIsCjpWoXNZRR9vFshQwADGYOr4gpyT6o=;
        b=XMs202dlBCAcOC2p2rKO1VpDEEyvbCieIm7WJxQ7AHaleoANUvlFw9ka/rKIc9YC2FemJ8
        D2gdfC+YyAZJKzno+U9jslvjqHvT6wh/POSymJk44PDd67LMFnA8TowOVDovGmP7gxA1LW
        9qKFNwV5DQbItDcac4/NBesZnvTL/Yw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-o7SSGj_4NreExNSjiqa6pQ-1; Wed, 12 May 2021 10:13:40 -0400
X-MC-Unique: o7SSGj_4NreExNSjiqa6pQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 677391034B40;
        Wed, 12 May 2021 14:13:36 +0000 (UTC)
Received: from localhost (ovpn-12-39.pek2.redhat.com [10.72.12.39])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A0392B5A8;
        Wed, 12 May 2021 14:13:05 +0000 (UTC)
Date:   Wed, 12 May 2021 22:13:03 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Mike Rapoport <rppt@kernel.org>
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
        kasong@redhat.com, piliu@redhat.com
Subject: Re: [patch 48/91] kernel/crash_core: add crashkernel=auto for vmcore
 creation
Message-ID: <20210512141303.GF2834@localhost.localdomain>
References: <20210508085133.GA2946@localhost.localdomain>
 <2d0f53d9-51ca-da57-95a3-583dc81f35ef@redhat.com>
 <20210510045338.GB2946@localhost.localdomain>
 <4a544493-0622-ac6d-f14b-fb338e33b25e@redhat.com>
 <20210510104359.GC2946@localhost.localdomain>
 <e9332e4e-57bd-9c7c-b3ba-7e3b29fad7c8@redhat.com>
 <YJkcsswrgAudo2vz@dhcp-128-65.nay.redhat.com>
 <b111806c-9103-3f77-7135-f1f773d23b80@redhat.com>
 <20210511133641.GE2834@localhost.localdomain>
 <YJqxWy63cokQZ4jQ@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJqxWy63cokQZ4jQ@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 05/11/21 at 07:31pm, Mike Rapoport wrote:
> Hi Baoquan,
> 
> On Tue, May 11, 2021 at 09:36:41PM +0800, Baoquan He wrote:
> > On 05/10/21 at 01:56pm, David Hildenbrand wrote:
> > > On 10.05.21 13:44, Dave Young wrote:
> > > > Hi David,
> > > 
> > > Hi Dave,
> > > 
> > > > On 05/10/21 at 01:01pm, David Hildenbrand wrote:
> > > > [snip]
> > > > > It also bugged me for quite a bit that we don't have a sane way to achieve
> > > > > what we're doing here upstream. It somewhat feels like "this doesn't belong
> > > > > in the kernel and is user policy" but then, the existing kernel support is
> > > > > suboptimal.
> > > > > 
> > > > > Maybe reserving some "maybe too big but okayish to boot the system in a sane
> > > > > environment -- e.g., X% of system RAM and at least Y" size first and
> > > > > shrinking it later as triggered by user space early (where we do seem to
> > > > > have a way to pre-calculate things now) might actually be a good direction
> > > > > to look into.
> > > > 
> > > > Hmm, that is also an option we considered before.  Even for your
> > > > suggestion we still need a kernel option to set the default ratio/value.
> > > > and the ratio/value should be another patch which expands crashkernel
> > > > syntax.
> > > 
> > > Right.
> > > 
> > > > 
> > > > Actually the kconfig help text in this patch is indeed misleading, it is
> > > > not introducing crashkernel=a:b... and no need to explain about the
> > > > crashkernel syntax, the config option is actually just some interface we
> > > > can add any valid crashkernel settings to be used by default. So current
> > > > patch help text describes the default value of crash auto str, instead
> > > > of describes what crash auto str is.
> > > 
> > > Right. And I would much rather prefer either
> > > 
> > > a) handling "auto" completely in the kernel, not just setting some
> > > questionable default at compile time
> > 
> > Thanks for the suggestions.
> > 
> > If the way adding default value into kernel config is disliked,
> > this a) option looks good. We can get value with x% of system RAM, but
> > clamp it with CRASH_KERNEL_MIN/MAX. The CRASH_KERNEL_MIN/MAX may need be
> > defined with a default value for different ARCHes. It's very close to
> > our current implementation, and handling 'auto' in kernel.
> > 
> > And kernel config provided so that people can tune the MIN/MAX value,
> > but no need to post patch to do the tuning each time if have to?
>  
> Maybe I'm missing something, but the whole point is to avoid kernel
> configuration option at all. If the crashkernel=auto works good for 99% of
> the cases, there is no need to provide build time configuration along with
> it. There are plenty of ways users can control crashkernel reservations
> with the existing 2-4 (depending on architecture) command line options.
> 
> Simply hard coding a reasonable defaults (e.g.
> "1G-64G:128M,64G-1T:256M,1T-:512M"), and using these defaults when
> crashkernel=auto is set would cover the same 99% of users you referred to.

Thanks for looking into this, Mike.

The crashkernel=auto works well for 99% of systems with a prerequisite
that values of 'auto' corresponds to a certain kernel, e.g distros kernel.
Say so because the kernel configs of a distros kernel decides the kernel
size, and also the initrd size. A generic default value for
crashkernel=auto doesn't make much sense when we make it into distros.
That's why we want to add the default value into kernel config originally.
Then asking for a minimal size with a kernel config tunable as the second
best when handle 'auto' in kernel as David's option a) suggested.

Here it's a little not clear to me about why kernel config has to be
avoided. We have this kind of tunable, e.g CONFIG_CMA_SIZE_SEL_MBYTES.

> 
> If we can resize the reservation later during boot this will also address
> David's concern about the wasted memory.

We can't resize the reservation, we can only shrink currently.

> 
> You mentioned that amount of memory that is required for crash kernel
> reservation depends on the devices present on the system. Is is possible to
> detect how much memory is required at late stages of boot?

It may be doable to detect at late stage of boot, need investigation, now we
are working to do after system bootup. The thing is the detection is
very coarse-grained. We count all loaded kernel modules in. But in kdump
kernel, only very necessary modules is added in our distros. e.g if we
dump through network, NIC modules are collected. otherwise we filter it out
to reduce memory usage in kdump kernel. For most of normal systems with
dozens of devices, memory required by device driver in kdump kernel is
limited. On VM guests, it's even much less since only very necessary
devices are added, e.g disk/NIC/serial.

So, I said 99% of systems can be covered by default value, it's based on
a certain kernel with fixed kernel configs, mainly related to distros.
Adding a permanent default value in upstream kernel doesn't make much
sense, if no tunable provided for distros to adjust.

> 
> > > b) passing it explicitly in via the cmdline
> > > 
> > > > 
> > > > And crashkernel=auto makes this more flexibly. We can tune the values
> > > > easily when upgrading.  But if we pass a fixed value in userspace we
> > > > can not know if the value is set by distribution automatically or by user
> > > > manually thus we can not blindly update it.
> > > 
> > > I think there are two different cases:
> > > 
> > > 
> > > 1. kernel space updates the value later during boot. "crashkernel=auto"
> > > really does the right thing, meaning
> > > 
> > > a) allocate something reasonable and safe during early boot
> > > b) update the allocation during late boot when we know what kind of system
> > > we're running on
> > > 
> > > Then, we indeed care about "crashkernel=auto" in the kernel and I think it
> > > would be a nice thing to have. The only question is on how to make that a
> > > little configurable, depending on different thingies we might want to run in
> > > the crashkernel (assuming someone doesn't want kdump).
> > > 
> > > 
> > > 2. user space updates the value later during boot
> > > 
> > > IMHO we don't really car who decided on the value as we do the update from
> > > user space. If an admin messes with crashkernel=, the admin can also mess
> > > with kdump not doing any overwrites (e.g., make that configurable, or detect
> > > the overwrite in kdump somehow).
> > > 
> > > -- 
> > > Thanks,
> > > 
> > > David / dhildenb
> > > 
> > 
> > 
> 
> -- 
> Sincerely yours,
> Mike.
> 

