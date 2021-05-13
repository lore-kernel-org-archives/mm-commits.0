Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D60DC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 05:04:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C6C16142D
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 05:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhEMFFo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 01:05:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48138 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230176AbhEMFFn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 01:05:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620882272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f9XavPqVJ1HUu4pTWzQFntsmkDviMhwg08pcvaFhsys=;
        b=ioOcHRTeuQU5U3BbrYdWDNgayKmR24qJhz/PcN2xpHeNv27ku6R8uX6a0a85J9j/WxVWsf
        spdtk1GUOOToAx3u7m9z6DMgU3Rfvi5atj72faHwXXGi3i7uLFsQH5YZvlkLH7vWy0PTuI
        xwNwdo0x67LvlBoBEQD7K7GjMp+ReDs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-wGWmSbG_OiefN2YAxnx1qA-1; Thu, 13 May 2021 01:04:31 -0400
X-MC-Unique: wGWmSbG_OiefN2YAxnx1qA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57121801ADA;
        Thu, 13 May 2021 05:04:27 +0000 (UTC)
Received: from localhost (ovpn-12-82.pek2.redhat.com [10.72.12.82])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A787478622;
        Thu, 13 May 2021 05:04:19 +0000 (UTC)
Date:   Thu, 13 May 2021 13:04:16 +0800
From:   Baoquan He <bhe@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Mike Rapoport <rppt@kernel.org>, Dave Young <dyoung@redhat.com>,
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
Message-ID: <20210513050416.GH2834@localhost.localdomain>
References: <4a544493-0622-ac6d-f14b-fb338e33b25e@redhat.com>
 <20210510104359.GC2946@localhost.localdomain>
 <e9332e4e-57bd-9c7c-b3ba-7e3b29fad7c8@redhat.com>
 <YJkcsswrgAudo2vz@dhcp-128-65.nay.redhat.com>
 <b111806c-9103-3f77-7135-f1f773d23b80@redhat.com>
 <20210511133641.GE2834@localhost.localdomain>
 <YJqxWy63cokQZ4jQ@kernel.org>
 <c990270c-30a0-0913-df5a-2c73eb66a436@redhat.com>
 <20210512145150.GG2834@localhost.localdomain>
 <3897d7a7-1120-4445-c297-e1cb7ac99f43@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3897d7a7-1120-4445-c297-e1cb7ac99f43@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 05/12/21 at 05:07pm, David Hildenbrand wrote:
> On 12.05.21 16:51, Baoquan He wrote:
> > On 05/11/21 at 07:07pm, David Hildenbrand wrote:
> > > > > If the way adding default value into kernel config is disliked,
> > > > > this a) option looks good. We can get value with x% of system RAM, but
> > > > > clamp it with CRASH_KERNEL_MIN/MAX. The CRASH_KERNEL_MIN/MAX may need be
> > > > > defined with a default value for different ARCHes. It's very close to
> > > > > our current implementation, and handling 'auto' in kernel.
> > > > > 
> > > > > And kernel config provided so that people can tune the MIN/MAX value,
> > > > > but no need to post patch to do the tuning each time if have to?
> > > > Maybe I'm missing something, but the whole point is to avoid kernel
> > > > configuration option at all. If the crashkernel=auto works good for 99% of
> > > > the cases, there is no need to provide build time configuration along with
> > > > it. There are plenty of ways users can control crashkernel reservations
> > > > with the existing 2-4 (depending on architecture) command line options.
> > > > 
> > > > Simply hard coding a reasonable defaults (e.g.
> > > > "1G-64G:128M,64G-1T:256M,1T-:512M"), and using these defaults when
> > > > crashkernel=auto is set would cover the same 99% of users you referred to.
> > > 
> > > Right, and we can easily allocate a bit more as a safety net temporarily
> > > when we can actually shrink the area later.
> > > 
> > > > 
> > > > If we can resize the reservation later during boot this will also address
> > > > David's concern about the wasted memory.
> > > > 
> > > 
> > > Yes.
> > > 
> > > > You mentioned that amount of memory that is required for crash kernel
> > > > reservation depends on the devices present on the system. Is is possible to
> > > > detect how much memory is required at late stages of boot?
> > > 
> > > Here is my thinking:
> > > 
> > > There seems to be some kind of formula we can roughly use to come up with
> > > the final crashkernel size. Baoquan for sure knows all the dirty details, I
> > > assume it's roughly "core kernel + drivers + user space".
> > > 
> > > In the kernel, we can only come up with "core kernel + drivers" expecting
> > > that we will run
> > > 
> > > a) roughly the same kernel
> > > b) with roughly the same drivers
> > 
> > As replied to Mike, kernel size is undecided for different kernel with
> > different configs. We can define a default minimal size to cover kernel
> > and driver on systems with not many devices, but hardcoding the size
> 
> I never talked about hardcoding, did I?

Sorry, I didn't make it clear. I said hardcoding, meaning a hardcoding
min value. No matter what formula we take, it needs a default MIN value
to restrict the lowest size, right? That MIN value is the hardcoding I
meant. With it properly chosen, most of systems have no need to shrink
or adjust the crashkernel, given most of systems own memory less than
64G. Let alone the later estimation is done in 1st kernel, very likely
it will get a bigger value as really needed.

> 
> > into upstream is not helpful. If the size is big, users will be asked to
> > check and shrink always. If the size is too small, a new value need be
> > got and added to cmdline and reboot.
> 
> 
> -- 
> Thanks,
> 
> David / dhildenb
> 

