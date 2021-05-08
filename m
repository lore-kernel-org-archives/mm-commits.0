Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC04CC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 08:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8708D610CD
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 08:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhEHIxC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 04:53:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34435 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229583AbhEHIxB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 May 2021 04:53:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620463919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A41cXRE3iuPJ/eLx+4EYLy1eUH4KkPZCbU20cc8M8uk=;
        b=HMlyfc3ooDDntBDYQWLjhfT7VtUuS7aGu68QSQhduq2u5ocx17iPfGOSh4cHFsCIp3OreO
        5oZbaj6QuPJ7x5MVyzZm6g7GXO9bUqbxWceeO2pUfcyB1MQ4S1CUCXuEAiAve8INHeTucQ
        8imZbjwGdxWKKySZNtsbY6Df9PaR3xc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-NauFr-GHNdy1pm2QxZeKjw-1; Sat, 08 May 2021 04:51:51 -0400
X-MC-Unique: NauFr-GHNdy1pm2QxZeKjw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78F6710066E5;
        Sat,  8 May 2021 08:51:47 +0000 (UTC)
Received: from localhost (ovpn-13-42.pek2.redhat.com [10.72.13.42])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AD2BE6E6F9;
        Sat,  8 May 2021 08:51:36 +0000 (UTC)
Date:   Sat, 8 May 2021 16:51:33 +0800
From:   Baoquan He <bhe@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, andreyknvl@google.com,
        christian.brauner@ubuntu.com, colin.king@canonical.com,
        corbet@lwn.net, dyoung@redhat.com, frederic@kernel.org,
        gpiccoli@canonical.com, john.p.donnelly@oracle.com,
        jpoimboe@redhat.com, keescook@chromium.org, linux-mm@kvack.org,
        masahiroy@kernel.org, mchehab+huawei@kernel.org,
        mike.kravetz@oracle.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        peterz@infradead.org, rdunlap@infradead.org, rostedt@goodmis.org,
        rppt@kernel.org, saeed.mirzamohammadi@oracle.com,
        samitolvanen@google.com, sboyd@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com,
        yifeifz2@illinois.edu
Subject: Re: [patch 48/91] kernel/crash_core: add crashkernel=auto for vmcore
 creation
Message-ID: <20210508085133.GA2946@localhost.localdomain>
References: <20210507010432.IN24PudKT%akpm@linux-foundation.org>
 <889c6b90-7335-71ce-c955-3596e6ac7c5a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <889c6b90-7335-71ce-c955-3596e6ac7c5a@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 05/07/21 at 10:16am, David Hildenbrand wrote:
> On 07.05.21 03:04, Andrew Morton wrote:
......
> > 
> >   Documentation/admin-guide/kdump/kdump.rst       |    3 +-
> >   Documentation/admin-guide/kernel-parameters.txt |    6 ++++
> >   arch/Kconfig                                    |   20 ++++++++++++++
> >   kernel/crash_core.c                             |    7 ++++
> >   4 files changed, 35 insertions(+), 1 deletion(-)
> > 
> > --- a/arch/Kconfig~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
> > +++ a/arch/Kconfig
> > @@ -14,6 +14,26 @@ menu "General architecture-dependent opt
> >   config CRASH_CORE
> >   	bool
> > +config CRASH_AUTO_STR
> > +	string "Memory reserved for crash kernel"
> > +	depends on CRASH_CORE
> > +	default "1G-64G:128M,64G-1T:256M,1T-:512M"
> > +	help
> > +	  This configures the reserved memory dependent
> > +	  on the value of System RAM. The syntax is:
> > +	  crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
> > +	              range=start-[end]
> > +
> > +	  For example:
> > +	      crashkernel=512M-2G:64M,2G-:128M
> > +
> > +	  This would mean:
> > +
> > +	      1) if the RAM is smaller than 512M, then don't reserve anything
> > +	         (this is the "rescue" case)
> > +	      2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
> > +	      3) if the RAM size is larger than 2G, then reserve 128M
> > +
> >   config KEXEC_CORE
> >   	select CRASH_CORE
> >   	bool
> > --- a/Documentation/admin-guide/kdump/kdump.rst~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
> > +++ a/Documentation/admin-guide/kdump/kdump.rst
> > @@ -285,7 +285,8 @@ This would mean:
> >       2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
> >       3) if the RAM size is larger than 2G, then reserve 128M
> > -
> > +Or you can use crashkernel=auto to choose the crash kernel memory size
> > +based on the recommended configuration set for each arch.
> >   Boot into System Kernel
> >   =======================
> > --- a/Documentation/admin-guide/kernel-parameters.txt~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
> > +++ a/Documentation/admin-guide/kernel-parameters.txt
> > @@ -751,6 +751,12 @@
> >   			a memory unit (amount[KMG]). See also
> >   			Documentation/admin-guide/kdump/kdump.rst for an example.
> > +	crashkernel=auto
> > +			[KNL] This parameter will set the reserved memory for
> > +			the crash kernel based on the value of the CRASH_AUTO_STR
> > +			that is the best effort estimation for each arch. See also
> > +			arch/Kconfig for further details.
> > +
> >   	crashkernel=size[KMG],high
> >   			[KNL, X86-64] range could be above 4G. Allow kernel
> >   			to allocate physical memory region from top, so could
> > --- a/kernel/crash_core.c~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
> > +++ a/kernel/crash_core.c
> > @@ -7,6 +7,7 @@
> >   #include <linux/crash_core.h>
> >   #include <linux/utsname.h>
> >   #include <linux/vmalloc.h>
> > +#include <linux/kexec.h>
> >   #include <asm/page.h>
> >   #include <asm/sections.h>
> > @@ -250,6 +251,12 @@ static int __init __parse_crashkernel(ch
> >   	if (suffix)
> >   		return parse_crashkernel_suffix(ck_cmdline, crash_size,
> >   				suffix);
> > +#ifdef CONFIG_CRASH_AUTO_STR
> > +	if (strncmp(ck_cmdline, "auto", 4) == 0) {
> > +		ck_cmdline = CONFIG_CRASH_AUTO_STR;
> > +		pr_info("Using crashkernel=auto, the size chosen is a best effort estimation.\n");
> > +	}
> > +#endif
> I remember that the original "crashkernel=auto" as once proposed by Red Hat
> people did not receive a warm welcome.
> 
> Let me take a look .... oh, there it is from 2009
> 
> https://marc.info/?t=125006512600002&r=1&w=2
> 
> and then we had it in 2018
> 
> https://lkml.org/lkml/2018/5/20/262

Thanks for digging these two out, otherwise I may need do for people to
know the history better.

> 
> 
> The issue I have with this: it's just plain wrong when you take memory
> hotplug into serious account as we see it quite heavily in VMs. You don't
> know what you'll need when building a kernel. Just pass it via the cmdline

Hmm, kdump may have no issue with memory hotplug in crashkernel
reservation aspect. The system RAM size is not correlated to
crashkernel size directly, that's why the default value in this patch is
not linear related to system RAM size. The proportion of crashkernel
size to the total RAM size is thing we take into account. Usually
crashkernel 160M is enough on most of systems. If system RAM size is
larger, extra memory can be added just in case, and not bring much
impact to system.

With our investigation, PCIe devices impact the crashkernel size, and
cpu number. There are always pci devices which driver require tens of KB
meomry, even MB. E.g in below patch, my colleague Coiby found out the
i40e network card even cost 1.5G memory to initialize its ringbuffer on
ppc, and 85M on x86_64.

[PATCH v1 0/3] Reducing memory usage of i40e for kdump
http://lists.infradead.org/pipermail/kexec/2021-March/022117.html

Even though not all pci devices need surprisingly large memory like
i40e, system with hundreds of pci devices can also cost more memory than
expected. This kind of system usually is high end server, specified
crashkernel value need be set manually. 

So system RAM size is the least important part to influence crashkernel
costing. Say my x1 laptop, even though I extended the RAM to 100TB, 160M
crashkernel is still enough. Just we would like to get a tiny extra part
to add to crashkernel if the total RAM is very large, that's the rule
for crashkernel=auto. As for VMs, given their very few devices, virtio
disk, NAT nic, etc, no matter how much memory is deployed and hot
added/removed, crashkernel size won't be influenced very much. My
personal understanding about it.

Thanks
Baoquan

