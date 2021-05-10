Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4131C433ED
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5D6A613CE
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhEJEzQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 00:55:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42940 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229934AbhEJEzP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 00:55:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620622440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L7RbkXeHJnVJMcXqreDKznJPlMT6ENwxTSb81biIxzo=;
        b=HZbmY8dEJxuM2JnvT/mAPEBKQQheIJU32goTAh6tfsqCFrMYKUTIv295+Ub3ypsI07oRyw
        u0s1F6LZ3iBrYghwjJxd1DIlOKz42aBqVJNi1mq6JHB0GHJd8b4x89XAnwFEQwKO71zXC6
        XPGMy/zpukJdITwJ7vTQnlWxI+HVSKk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-IvmrsY62MqGZnwmjjW52UA-1; Mon, 10 May 2021 00:53:53 -0400
X-MC-Unique: IvmrsY62MqGZnwmjjW52UA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 876DF107ACC7;
        Mon, 10 May 2021 04:53:49 +0000 (UTC)
Received: from localhost (ovpn-12-179.pek2.redhat.com [10.72.12.179])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 99398610D0;
        Mon, 10 May 2021 04:53:41 +0000 (UTC)
Date:   Mon, 10 May 2021 12:53:38 +0800
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
Message-ID: <20210510045338.GB2946@localhost.localdomain>
References: <20210507010432.IN24PudKT%akpm@linux-foundation.org>
 <889c6b90-7335-71ce-c955-3596e6ac7c5a@redhat.com>
 <20210508085133.GA2946@localhost.localdomain>
 <2d0f53d9-51ca-da57-95a3-583dc81f35ef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d0f53d9-51ca-da57-95a3-583dc81f35ef@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 05/08/21 at 11:22am, David Hildenbrand wrote:
> > > Let me take a look .... oh, there it is from 2009
> > > 
> > > https://marc.info/?t=125006512600002&r=1&w=2
> > > 
> > > and then we had it in 2018
> > > 
> > > https://lkml.org/lkml/2018/5/20/262
> > 
> > Thanks for digging these two out, otherwise I may need do for people to
> > know the history better.
> 
> Sure, I stumbled over this myself recently when wondering about what fadump
> is.
> 
> 
> > > The issue I have with this: it's just plain wrong when you take memory
> > > hotplug into serious account as we see it quite heavily in VMs. You don't
> > > know what you'll need when building a kernel. Just pass it via the cmdline
> > 
> > Hmm, kdump may have no issue with memory hotplug in crashkernel
> > reservation aspect. The system RAM size is not correlated to
> > crashkernel size directly, that's why the default value in this patch is
> 
> "Not correlated directly" ...
> 
> "1G-64G:128M,64G-1T:256M,1T-:512M"
> 
> Am I still asleep and dreaming? :)

Well, I said 'Not correlated directly', then gave sentences to explan
the reason. I would like to repeat them:

1) Crashkernel need more memory on some systems mainly because of
device driver. You can take a system, no matter how much memory you
increse or decrease total system RAM size, the crashkernel size needed
is invariable.

  - The extreme case I have give about the i40e.
  - And the more devices, narutally the more memory needed.

2) About "1G-64G:128M,64G-1T:256M,1T-:512M", I also said the different
value is because taking very low proprotion of extra memory to avoid
potential risk, it's cost effective. Here, add another 90M which is
0.13% of 64G, 0.0085% of 1TB.

Hope it can help people sober up.

> 
> 
> > not linear related to system RAM size. The proportion of crashkernel
> > size to the total RAM size is thing we take into account. Usually
> > crashkernel 160M is enough on most of systems. If system RAM size is
> > larger, extra memory can be added just in case, and not bring much
> > impact to system.
> 
> So, all the rules we have are essentially broken because they rely
> completely on the system RAM during boot.

How do you get this?

Crashkernel=auto is a default value. PC, VMs, normal workstation and server
which are the overall majority can work well with it. I can say the number
is 99%. Only very few high end workstation, servers which contain
many PCI devices need investigation to decide crashkernel size. A possible
manual setting and rebooting is needed for them. You call this
'essentially broken'? So you later suggestd constructing crashkernel value
in user space and rebooting is not broken? Even though it's the similar
thing? what is your logic behind your conclusion?

Crashkernel=auto is mainly targetting most of systems, help people
w/o much knowledge of kdump implementation to use it for debugging.

I can say more about the benefit of crashkernel=auto. On Fedora, the
community distros sponsord by Redhat, the kexec/kdump is also maintained
by us. Fedora kernel is mainline kernel, so no crashkernel=auto
provided. We almost never get bug report from users, means almost nobody
use  it. We hope Fedora users' usage can help test functionality of
component. 
> 
> > 
> > With our investigation, PCIe devices impact the crashkernel size, and
> > cpu number. There are always pci devices which driver require tens of KB
> > meomry, even MB. E.g in below patch, my colleague Coiby found out the
> > i40e network card even cost 1.5G memory to initialize its ringbuffer on
> > ppc, and 85M on x86_64.
> > 
> > [PATCH v1 0/3] Reducing memory usage of i40e for kdump
> > http://lists.infradead.org/pipermail/kexec/2021-March/022117.html
> > 
> > Even though not all pci devices need surprisingly large memory like
> > i40e, system with hundreds of pci devices can also cost more memory than
> > expected. This kind of system usually is high end server, specified
> > crashkernel value need be set manually.
> > 
> > So system RAM size is the least important part to influence crashkernel
> 
> Aehm, not with fadump, no?

Fadump makes use of crashkernel reservation, but has different mechanism
to dumping. It needs a kernel config too if this patch is accepted, or
it can add it to command line from a user space program, I will talk
about that later. This depends on IBM's decision, I have added Hari to CC,
they will make the best choice after consideration.

}
> 
> > costing. Say my x1 laptop, even though I extended the RAM to 100TB, 160M
> > crashkernel is still enough. Just we would like to get a tiny extra part
> > to add to crashkernel if the total RAM is very large, that's the rule
> > for crashkernel=auto. As for VMs, given their very few devices, virtio
> > disk, NAT nic, etc, no matter how much memory is deployed and hot
> > added/removed, crashkernel size won't be influenced very much. My
> > personal understanding about it.
> 
> That's an interesting observation. But you're telling me that we end up
> wasting memory for the crashkernel because "crashkernel=auto" which is
> supposed to do something magical good automatically does something very
> suboptimal? Oh my ... this is broken.
> 
> Long story short: crashkernel=auto is pure ugliness.

Very interesting. Your long story is clear to me, but your short story
confuses me a lot.

Let me try to sort out and understand. In your first reply, you asserted
"it's plain wrong when taking memory hotplug serious account as
we see it quite heavily in VMs", means you plain don't know if it's
wrong, but you say it's plain wrong. I answered you 'no, not at all'
with detailed explanation, means it's plain opposite to your assertion.
So then you quickly came to 'crashkernel=auto is pure ugliness'. If a
simple crashkernel=auto is added to cover 99% systems, and advanced
operation only need be done for the rest which is tiny proportion,
this is called pure ugliness, what's pure beauty? Here I say 99%, I
could be very conservative.

> 
> Why can't we construct a crashkernel in user space when
> installing/activating kdump and requiring a reboot for kdump to be active as
> long as that crashkernel setting is not properly respected?
> 
> Just have a look at the system properties (is_qemu(), #PCI, ...) and propose
> a value for "crashkernel=". Check that that value is at least active when
> activating kdump. Otherwise don't enable kdump and fail.
> 
> Yes, it can be difficult with some newer/older kernels having some different
> demands, but things should change drastically, and a distro can always
> update its advises along with the kernel, no?
> 
> You could even have a kernel interface that gives you the current
> crashkernel size (maybe already there) vs. the recommended crashkernel size.
> Make kdump or *whoever* activate that in the cmdline and let kdump check if
> both values are satisfied when booting up.

Now, let's go to your long story.

Yes, if you haven't seen our patch in fedora kexec-tools maining list,
your suggested approach is the exactly same thing we are doing, please
check below patch.

[PATCH v2] kdumpctl: Add kdumpctl estimate
https://lists.fedoraproject.org/archives/list/kexec@lists.fedoraproject.org/thread/YCEOJHQXKVEIVNB23M2TDAJGYVNP5MJZ/

We will provide a new feature in user space script, to let user check if
their current crashkernel size is good or not. If not, they can adjust
accordingly.

But, where's the current crashkernel size coming from? Surely
crashkernel=auto. You wouldn't add a random crashkernel size then
compared with the recommended crashkernel size, then reboot, will you?
If crashkernel=auto get the expected size, no need to reboot. Means 99%
of systems has no need to reboot. Only very few of systems, need reboot
after checking the recommended size.

Long story short. crashkernel=auto will give a default value, trying to
cover most of systems. (Very few high end server need check if it's
enough and adjust with the help of user space tools. Then reboot.)


> 
> Also: this approach here doesn't make any sense when you want to do
> something dependent on other cmdline parameters. Take "fadump=on" vs
> "fadump=off" as an example. You just cannot handle it properly as proposed
> in this patch. To me the approach in this patch makes least sense TBH.

Why? We don't have this kind of judgement in kernel? Crashkernel=auto is
a generic mechanism, and has been added much earlier. Fadump was added
later by IBM for their need on ppc only, it relies on crashkernel
reservation but different mechanism of dumping. If it has different value
than kdump, a special hanlding is certainly needed. Who tell it has to be
'fadump=on'? They can check the value in user space program and add into
cmdline as you suggested, they can also make it into auto. The most suitable
is the best.

And I have several questions to ask, hope you can help answer:

1) Have you ever met crashkernel=auto broken on virt platform?

Asking this because you are from Virt team, and crashkernel=auto has been
there in RHEL for many years, and we have been working with Virt team to
support dumping. We haven't seen any bug report or complaint about
crashkernel=auto from Virt. 

2) Adding crashkernel=auto, and the kdumpctl estimate as user space
program to get a recommended size, then reboot. Removing crashkernel=auto,
only the kdumpctl estimate to get a recommended size, always reboot.
In RHEL we will take the 1st option. Are you willing to take the 2nd one
for Virt platform since you think crashkernel=auto is plain wrong, pure
ugliness, essentially broken, least sense?

Thanks
Baoquan

