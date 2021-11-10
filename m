Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E65C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 10 Nov 2021 11:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F074610D2
	for <mm-commits@archiver.kernel.org>; Wed, 10 Nov 2021 11:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhKJLOS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 06:14:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231551AbhKJLOF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 06:14:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636542676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R3qv3UKjquasTgi5M7gLk/mkfg3Zumae4Rql3x3eQCE=;
        b=b9i4bsHcLzdeTPNTav+hFYyFrVOp7GTwJX8Fu8vnbI4rarsYIscDfTE/6qY0C7i6el1WNn
        BAbEAQRSh+YLmBI4klA1OCY2KLhCDfYClGo5+6kEq7S4rLuyMgh+fbdZ7pGDh4QlsWRT5W
        YXYMq2C44zeWzv1mcJGRYPcSwe2xDl0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-MW8IFZeDMBa070y0X784MA-1; Wed, 10 Nov 2021 06:11:13 -0500
X-MC-Unique: MW8IFZeDMBa070y0X784MA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 868BD100CCC0;
        Wed, 10 Nov 2021 11:11:11 +0000 (UTC)
Received: from dhcp-128-65.nay.redhat.com (ovpn-13-52.pek2.redhat.com [10.72.13.52])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 69CD060C05;
        Wed, 10 Nov 2021 11:11:04 +0000 (UTC)
Date:   Wed, 10 Nov 2021 19:11:00 +0800
From:   Dave Young <dyoung@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Baoquan He <bhe@redhat.com>, boris.ostrovsky@oracle.com,
        bp@alien8.de, Andrew Morton <akpm@linux-foundation.org>,
        hpa@zytor.com, jasowang@redhat.com, jgross@suse.com,
        linux-mm@kvack.org, mhocko@suse.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        rafael.j.wysocki@intel.com, rppt@kernel.org,
        sstabellini@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com
Subject: Re: [patch 08/87] proc/vmcore: convert oldmem_pfn_is_ram callback to
 more generic vmcore callbacks
Message-ID: <YYuoxJ2BHv8PZi78@dhcp-128-65.nay.redhat.com>
References: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
 <20211109023148.b1OlyuiXG%akpm@linux-foundation.org>
 <20211110072225.GA18768@MiWiFi-R3L-srv>
 <0c68b366-38f4-94fd-da11-57e40a44cb48@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c68b366-38f4-94fd-da11-57e40a44cb48@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi David,
On 11/10/21 at 09:10am, David Hildenbrand wrote:
> On 10.11.21 08:22, Baoquan He wrote:
> > On 11/08/21 at 06:31pm, Andrew Morton wrote:
> >> From: David Hildenbrand <david@redhat.com>
> >> Subject: proc/vmcore: convert oldmem_pfn_is_ram callback to more generic vmcore callbacks
> >>
> >> Let's support multiple registered callbacks, making sure that registering
> >> vmcore callbacks cannot fail.  Make the callback return a bool instead of
> >> an int, handling how to deal with errors internally.  Drop unused
> >> HAVE_OLDMEM_PFN_IS_RAM.
> >>
> >> We soon want to make use of this infrastructure from other drivers:
> >> virtio-mem, registering one callback for each virtio-mem device, to
> >> prevent reading unplugged virtio-mem memory.
> >>
> >> Handle it via a generic vmcore_cb structure, prepared for future
> >> extensions: for example, once we support virtio-mem on s390x where the
> >> vmcore is completely constructed in the second kernel, we want to detect
> >> and add plugged virtio-mem memory ranges to the vmcore in order for them
> >> to get dumped properly.
> >>
> >> Handle corner cases that are unexpected and shouldn't happen in sane
> >> setups: registering a callback after the vmcore has already been opened
> >> (warn only) and unregistering a callback after the vmcore has already been
> >> opened (warn and essentially read only zeroes from that point on).
> >                                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > I am fine with the whole patch except of one concern. As above sentence
> > underscored states, if a callback is unregistered when vmcore has been
> > opened, it will read out zeros from that point on. And it's done by
> > judging global variable 'vmcore_cb_unstable' in pfn_is_ram(). This will
> > cause vmcore dumping in makedumpfile only being able to read out zero
> > page since then, and may cost long extra time to finish.
> > 
> > Please see remap_oldmem_pfn_checked(). In makedumpfile, we default to
> > mmap 4M memory region at one time, then copy out. With this patch, and if
> > vmcore_cb_unstable is true, kernel will mmap page by page. The extra
> > time could be huge, e.g on machine with TBs memory, and we only get a
> > useless vmcore because of loss of core data with high probability.
> 
> Thanks Baoquan for the quick review!
> 
> This code is really just to handle the unlikely case of a driver getting
> unbound from a device that has a callback registered (e.g., a
> virtio-mem-pci device). Something like this will never happen in
> practice in a *sane* environment.
> 
> The only known way I know is if userspace manually unbinds the driver
> from a virtio-mem-pci device -- which is possible but especially in a
> kdump environment something without any sane use case. In that case, we'll
> 
> pr_warn_once("Unexpected vmcore callback unregistration\n");
> 
> to let user space know that something weird/unsupported is going on.
> 
> Long story short: if user space does something nasty, I don't see a
> problem in some action taking a little longer.
> 
> 
> > 
> > I am thinking if we can simply panic in the case, since the left dumping
> > are all zeroed, very likely the vmcore is unavailable any more.
> 
> IMHO panic() is a little bit too much. Instead of returning zeroes, we
> could fail the read/mmap operation -- I considered that as an option
> when I crafted/tested this patch, however, this approach here turned out
> to be the easiest way to handle something that's really not
> supported/advised and won't really happen in a sane environment.

I would still say that the most important task for kdump is to save the
vmcore successfully.  Even the above issue is not a common case it could
cause the vmcore to be useless.  It is understandable if the zeroed part
is only the virtio-mem part, but if all the remaining vmcore is zeroed
that it is bad and not acceptable for kdump. 

Sometimes panic is not always reproducible thus kdump could have only
one time choice to save the vmcore.  So I think we should try the best
to save useful data for later debugging use.

I'm still suggest to acquire the lock when vmcore is opened and block
the driver vmcore_cb updating.  All drivers should be ready before the
vmcore saving in the kdump os/initramfs.  Since the case we talked is
not a common case so this should be better approach.

> 
> -- 
> Thanks,
> 
> David / dhildenb
> 

Thanks
Dave

