Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC08C433ED
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 07:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 112D36193A
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 07:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhELHnm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 03:43:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43286 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229627AbhELHnl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 03:43:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620805353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x4oHpYRnJp/hVA6CvRa19y0TRaFJ61odpzS2k3DfXxc=;
        b=Ktxl7A/vDh8cxqkRwmMxaDW5iJ9ZuXQHhiofFes/nM5IeY8pOq7GM+Cr3QjTZf22aVHojb
        7nCMrpit1FWIwRIHcSmL687I9up9U8INQok4ZphSJk6rtpzuDYrKePjKjbAhXTadmXkdTE
        tZAZXei3cxCCJtn4yyxWoQrETRrbyH8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-XsZol3neOIeQKcmOXyz8DQ-1; Wed, 12 May 2021 03:42:32 -0400
X-MC-Unique: XsZol3neOIeQKcmOXyz8DQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 249CE106BB24;
        Wed, 12 May 2021 07:42:29 +0000 (UTC)
Received: from dhcp-128-65.nay.redhat.com (ovpn-12-207.pek2.redhat.com [10.72.12.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D64A36091A;
        Wed, 12 May 2021 07:42:13 +0000 (UTC)
Date:   Wed, 12 May 2021 15:42:10 +0800
From:   Dave Young <dyoung@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Baoquan He <bhe@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        andreyknvl@google.com, christian.brauner@ubuntu.com,
        colin.king@canonical.com, corbet@lwn.net, frederic@kernel.org,
        gpiccoli@canonical.com, john.p.donnelly@oracle.com,
        jpoimboe@redhat.com, keescook@chromium.org, linux-mm@kvack.org,
        masahiroy@kernel.org, mchehab+huawei@kernel.org,
        mike.kravetz@oracle.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        peterz@infradead.org, rdunlap@infradead.org, rostedt@goodmis.org,
        rppt@kernel.org, saeed.mirzamohammadi@oracle.com,
        samitolvanen@google.com, sboyd@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com,
        yifeifz2@illinois.edu, Michal Hocko <mhocko@kernel.org>,
        kasong@redhat.com
Subject: Re: [patch 48/91] kernel/crash_core: add crashkernel=auto for vmcore
 creation
Message-ID: <20210512074210.GA40612@dhcp-128-65.nay.redhat.com>
References: <20210507010432.IN24PudKT%akpm@linux-foundation.org>
 <889c6b90-7335-71ce-c955-3596e6ac7c5a@redhat.com>
 <20210508085133.GA2946@localhost.localdomain>
 <2d0f53d9-51ca-da57-95a3-583dc81f35ef@redhat.com>
 <20210510045338.GB2946@localhost.localdomain>
 <4a544493-0622-ac6d-f14b-fb338e33b25e@redhat.com>
 <20210510104359.GC2946@localhost.localdomain>
 <e9332e4e-57bd-9c7c-b3ba-7e3b29fad7c8@redhat.com>
 <YJkcsswrgAudo2vz@dhcp-128-65.nay.redhat.com>
 <b111806c-9103-3f77-7135-f1f773d23b80@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b111806c-9103-3f77-7135-f1f773d23b80@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 05/10/21 at 01:56pm, David Hildenbrand wrote:
> On 10.05.21 13:44, Dave Young wrote:
> > Hi David,
> 
> Hi Dave,
> 
> > On 05/10/21 at 01:01pm, David Hildenbrand wrote:
> > [snip]
> > > It also bugged me for quite a bit that we don't have a sane way to achieve
> > > what we're doing here upstream. It somewhat feels like "this doesn't belong
> > > in the kernel and is user policy" but then, the existing kernel support is
> > > suboptimal.
> > > 
> > > Maybe reserving some "maybe too big but okayish to boot the system in a sane
> > > environment -- e.g., X% of system RAM and at least Y" size first and
> > > shrinking it later as triggered by user space early (where we do seem to
> > > have a way to pre-calculate things now) might actually be a good direction
> > > to look into.
> > 
> > Hmm, that is also an option we considered before.  Even for your
> > suggestion we still need a kernel option to set the default ratio/value.
> > and the ratio/value should be another patch which expands crashkernel
> > syntax.
> 
> Right.
> 
> > 
> > Actually the kconfig help text in this patch is indeed misleading, it is
> > not introducing crashkernel=a:b... and no need to explain about the
> > crashkernel syntax, the config option is actually just some interface we
> > can add any valid crashkernel settings to be used by default. So current
> > patch help text describes the default value of crash auto str, instead
> > of describes what crash auto str is.
> 
> Right. And I would much rather prefer either
> 
> a) handling "auto" completely in the kernel, not just setting some
> questionable default at compile time
> b) passing it explicitly in via the cmdline
> 
> > 
> > And crashkernel=auto makes this more flexibly. We can tune the values
> > easily when upgrading.  But if we pass a fixed value in userspace we
> > can not know if the value is set by distribution automatically or by user
> > manually thus we can not blindly update it.
> 
> I think there are two different cases:
> 
> 
> 1. kernel space updates the value later during boot. "crashkernel=auto"
> really does the right thing, meaning
> 
> a) allocate something reasonable and safe during early boot
> b) update the allocation during late boot when we know what kind of system
> we're running on

Sorry for my laggy reply :)

As for kernel late boot action, the other notable issue is most device
drivers are kernel modules, they are loaded with udev. Especially about
some complex storage/network drivers, they often use a lot memory.
Kairui has a tool named "memstrack" which can be used for monitor the
module loading phase peak memory.  But that can only be done in
userspace for now.

And we have some different setups for normal boot and kdump
kernel, eg. some special cmdline eg. nr_cpu=1; and also some in kernel
handling for example some patches merged in networking drivers to use
less memory in kdump kernel via smaller queues etc.

Otherwise about other kernel memory requirement can be done in kernel.

> 
> Then, we indeed care about "crashkernel=auto" in the kernel and I think it
> would be a nice thing to have. The only question is on how to make that a
> little configurable, depending on different thingies we might want to run in
> the crashkernel (assuming someone doesn't want kdump).
> 
> 
> 2. user space updates the value later during boot
> 
> IMHO we don't really car who decided on the value as we do the update from
> user space. If an admin messes with crashkernel=, the admin can also mess
> with kdump not doing any overwrites (e.g., make that configurable, or detect
> the overwrite in kdump somehow).
> 
> -- 
> Thanks,
> 
> David / dhildenb
> 

Thanks
Dave

