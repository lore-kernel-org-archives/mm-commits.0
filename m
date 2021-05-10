Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E63BC43611
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 10:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 097F861C28
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 10:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbhEJKqr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 06:46:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233260AbhEJKpc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 06:45:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620643461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sqVNo9bcDCNHFIpW+78MabhEzociYKL1PMPe5D5F6jk=;
        b=V0jNZ6qfX9olzswoDxXxXOyQyymSSBxba3/u8QglNjk4SEjO66jAhuRJll/CBffh2RBgIO
        y3VWT8rGdEbbzCFyD06inpOEdSu48+Dw1UGLM8+wMVyF7ikGnDRtiCCBLA1HPM38A5FbxZ
        zZJdC9p8Phv8gbrBz3Mt/QJXFg6LX0M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-oXaNHLYJPH29xu6G5-uu-w-1; Mon, 10 May 2021 06:44:19 -0400
X-MC-Unique: oXaNHLYJPH29xu6G5-uu-w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F4CB8015A8;
        Mon, 10 May 2021 10:44:15 +0000 (UTC)
Received: from localhost (ovpn-12-179.pek2.redhat.com [10.72.12.179])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 66F156B8DF;
        Mon, 10 May 2021 10:44:02 +0000 (UTC)
Date:   Mon, 10 May 2021 18:43:59 +0800
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
Message-ID: <20210510104359.GC2946@localhost.localdomain>
References: <20210507010432.IN24PudKT%akpm@linux-foundation.org>
 <889c6b90-7335-71ce-c955-3596e6ac7c5a@redhat.com>
 <20210508085133.GA2946@localhost.localdomain>
 <2d0f53d9-51ca-da57-95a3-583dc81f35ef@redhat.com>
 <20210510045338.GB2946@localhost.localdomain>
 <4a544493-0622-ac6d-f14b-fb338e33b25e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a544493-0622-ac6d-f14b-fb338e33b25e@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 05/10/21 at 10:32am, David Hildenbrand wrote:
> 
> > > "Not correlated directly" ...
> > > 
> > > "1G-64G:128M,64G-1T:256M,1T-:512M"
> > > 
> > > Am I still asleep and dreaming? :)
> > 
> > Well, I said 'Not correlated directly', then gave sentences to explan
> > the reason. I would like to repeat them:
> > 
> > 1) Crashkernel need more memory on some systems mainly because of
> > device driver. You can take a system, no matter how much memory you
> > increse or decrease total system RAM size, the crashkernel size needed
> > is invariable.
> > 
> >    - The extreme case I have give about the i40e.
> >    - And the more devices, narutally the more memory needed.
> > 
> > 2) About "1G-64G:128M,64G-1T:256M,1T-:512M", I also said the different
> > value is because taking very low proprotion of extra memory to avoid
> > potential risk, it's cost effective. Here, add another 90M which is
> > 0.13% of 64G, 0.0085% of 1TB.
> 
> Just let me clarify the problem I am having with all of this:
> 
> We model the crashkernel size as a function of the memory size. Yet, it's
> pretty much independent of the memory size. That screams for "ugly".
> 
> The main problem is that early during boot we don't have a clue how much
> crashkernel memory we may need. So what I see is that we are mostly using a
> heuristic based on the memory size to come up with the right answer how much
> devices we might have. That just feels very wrong.
> 
> I can understand the reasoning of "using a fraction of the memory size" when
> booting up just to be on the safe side as we don't know", and that
> motivation is much better than what I read so far. But then I wonder if we
> cannot handle that any better? Because this feels very suboptimal to me and
> I feel like there can be cases where the heuristic is just wrong.

Yes, I understand what you said. Our headache is mainly from bare metal
system worrying the reservation is not enough becuase of many devices.

On VM, it is truly different. With much less devices, it does waste some
memory. Usually a fixed minimal size can cover 99.9% of system unless
too many devices attached/added to VM, I am not sure what's the
probability it could happen. While, by the help of /sys/kernel/kexec_crash_size,
you can shrink it to an small enough but available size. Just you may
need to reload kdump kernel because the loaded kernel should have been
erazed and out of control. The shrinking should be done at early stage of
kernel running, I would say, lest crash may happen during that period.

We ever tried several different ways to enlarge the crashkernel size
dynamically, but didn't think of a good way.

> 
> As one example, can I add a whole bunch of devices to a 32GB VM and break
> "crashkernel=auto"?
> 
> As another example, when I boot a 64G VM, the crashkernel size will be
> 512MB, although I really only might need 128MB. That's an effective overhead
> of 0.5%. And especially when we take memory ballooning etc. into account it
> can effectively be more than that.
> 
> Let's do a more detailed look. PPC64 in kernel-ark:
> 
> "2G-4G:384M,4G-16G:512M,16G-64G:1G,64G-128G:2G,128G-:4G";

Yes, the wasting mainly happens on ppc. Its 64K page size, caused the
difference with other ARCHes. On x86_64, s390, it's much better, assuming
most of VM won't own memory bigger than 64G, their crashkernel size will
be 160M most of time.

> 
> Assume I would only need 385M on a simple 16GB VM. We would have an overhead
> of ~4%. But maybe on ppc64 we do have to take the memory size into account
> (my assumption and, thus, my comment regarding memory hotplug)?
> 
> 
> I wonder if we could always try allocating larger granularity (falling back
> to smaller if it fails), and once the kernel is able to come up with a
> better answer how many devices there are and, thus, how big the crashkernel
> area really should be, shrink the preallocated crashkernel (either from the
> kernel or from user space)? Not completely trivial but possible I think.
> It's trivial when we allocate a memmap for the crashkernel (I think we
> mostly do but I might be wrong).
> 
> The "crashkernel=auto" would really do something magical good instead of
> implement some heuristic base don the memory size.
> 
> [...]
> > > So, all the rules we have are essentially broken because they rely
> > > completely on the system RAM during boot.
> > 
> > How do you get this?
> > 
> > Crashkernel=auto is a default value. PC, VMs, normal workstation and server
> > which are the overall majority can work well with it. I can say the number
> > is 99%. Only very few high end workstation, servers which contain
> > many PCI devices need investigation to decide crashkernel size. A possible
> > manual setting and rebooting is needed for them. You call this
> > 'essentially broken'? So you later suggestd constructing crashkernel value
> > in user space and rebooting is not broken? Even though it's the similar
> > thing? what is your logic behind your conclusion?
> 
> A kernel early during boot can only guess. A kernel late during boot knows.
> Please correct me if I'm wrong.

Well, I would not say it's guess, and would like to call them experical
values from statistical data. With a priori vlaue given by 'auto',
basically normal users of kdump don't need to care about the setting.
E.g on Fedora, 'auto' can cover all systems, assume nobody would deploy
it on a high end server. Everything we do is to make thing simple enough.
If you don't know how to set, just add 'crashkernel=auto' to cmdline,
then everything is done. I believe you agree that not everybody would
like to dig into kexec/kdump just for getting how big crashkernel size
need be set when they want to use kdump functionality.

> 
> > 
> > Crashkernel=auto is mainly targetting most of systems, help people
> > w/o much knowledge of kdump implementation to use it for debugging.
> > 
> > I can say more about the benefit of crashkernel=auto. On Fedora, the
> > community distros sponsord by Redhat, the kexec/kdump is also maintained
> > by us. Fedora kernel is mainline kernel, so no crashkernel=auto
> > provided. We almost never get bug report from users, means almost nobody
> > use  it. We hope Fedora users' usage can help test functionality of
> > component.
> 
> I know how helpful "crashkernel=auto" was so far, but I am also aware that
> there was strong pushback in the past, and I remember for the reasons I
> gave. IMHO we should refine that approach instead of trying to push the same
> thing upstream every couple of years.
> 
> I ran into the "512MB crashkernel" on a 64G VM with memory ballooning issue
> already but didn't report a BZ, because so far, I was under the impression
> that more memory means more crashkernel. But you explained to me that I was
> just running into a (for my use case) bad heuristic.

I re-read the old posts, didn't see strong push-back. People just gave
some different ideas instead. When we were silent, we tried different
way, e.g the enlarging crashkernel at run time as told at above, but
failed. Reusing free pages and user space pages of 1st kernel in kdump
kernel, also failed. We also talked with people to consult if it's
doable to remove 'auto' support, nobody would like to give an affirmative
answer. I know SUSE is using the way you mentioned to get a recommended
size for long time, but it needs severeal more steps and need reboot. We
prefer to take that way too as an improvement. The simpler, the better.

Besides, 'auto' doesn't introduce tons of complicated code, and we don't
think of it with a pat on the head, then try to push to pollute kernel.

> 
> > > > So system RAM size is the least important part to influence crashkernel
> > > 
> > > Aehm, not with fadump, no?
> > 
> > Fadump makes use of crashkernel reservation, but has different mechanism
> > to dumping. It needs a kernel config too if this patch is accepted, or
> > it can add it to command line from a user space program, I will talk
> > about that later. This depends on IBM's decision, I have added Hari to CC,
> > they will make the best choice after consideration.
> > 
> 
> I was looking at RHEL8, and there we have
> 
> fadump_cmdline = get_last_crashkernel(cmdline, "fadump=", NULL);
> ...
> if (!fadump_cmdline || (strncmp(fadump_cmdline, "off", 3) == 0))
> 	ck_cmdline = ...
> else
> 	ck_cmdline = ...
> 
> which was a runtime check for fadump.
> 
> Something that cannot be modeled properly at least with this patch here.

Yes, I believe it won't be done like that. A static detection or a
global switch variable can solve it.

> 
> > }
> > > 
> > > > costing. Say my x1 laptop, even though I extended the RAM to 100TB, 160M
> > > > crashkernel is still enough. Just we would like to get a tiny extra part
> > > > to add to crashkernel if the total RAM is very large, that's the rule
> > > > for crashkernel=auto. As for VMs, given their very few devices, virtio
> > > > disk, NAT nic, etc, no matter how much memory is deployed and hot
> > > > added/removed, crashkernel size won't be influenced very much. My
> > > > personal understanding about it.
> > > 
> > > That's an interesting observation. But you're telling me that we end up
> > > wasting memory for the crashkernel because "crashkernel=auto" which is
> > > supposed to do something magical good automatically does something very
> > > suboptimal? Oh my ... this is broken.
> > > 
> > > Long story short: crashkernel=auto is pure ugliness.
> > 
> > Very interesting. Your long story is clear to me, but your short story
> > confuses me a lot.
> > 
> > Let me try to sort out and understand. In your first reply, you asserted
> > "it's plain wrong when taking memory hotplug serious account as
> > we see it quite heavily in VMs", means you plain don't know if it's
> > wrong, but you say it's plain wrong. I answered you 'no, not at all'
> > with detailed explanation, means it's plain opposite to your assertion.
> 
> Yep, I might be partially wrong about memory hotplug thingy, mostly because
> I had the RHEL8 rule for ppc64 (including fadump) in mind. For dynamic
> resizing of VMs, the current rules for VMs can be very sub-optimal.
> 
> Let's relax "plain wrong" to "the heuristic can be very suboptimal because
> it uses something mostly unrelated to come up with an answer". And it's
> simply not plain wrong because in practice it gets the job done. Mostly.
> 
> 
> > So then you quickly came to 'crashkernel=auto is pure ugliness'. If a
> > simple crashkernel=auto is added to cover 99% systems, and advanced
> > operation only need be done for the rest which is tiny proportion,
> > this is called pure ugliness, what's pure beauty? Here I say 99%, I
> > could be very conservative.
> 
> I don't like wasting memory just because we cannot come up with a better
> heuristic. Yes, it somewhat gets the job done, but I call that ugly. My
> humble opinion.
> 
> [...]
> 
> > 
> > Yes, if you haven't seen our patch in fedora kexec-tools maining list,
> > your suggested approach is the exactly same thing we are doing, please
> > check below patch.
> > 
> > [PATCH v2] kdumpctl: Add kdumpctl estimate
> > https://lists.fedoraproject.org/archives/list/kexec@lists.fedoraproject.org/thread/YCEOJHQXKVEIVNB23M2TDAJGYVNP5MJZ/
> > 
> > We will provide a new feature in user space script, to let user check if
> > their current crashkernel size is good or not. If not, they can adjust
> > accordingly.
> 
> That's good, thanks for the pointer -- wasn't aware of that.
> 
> > 
> > But, where's the current crashkernel size coming from? Surely
> > crashkernel=auto. You wouldn't add a random crashkernel size then
> > compared with the recommended crashkernel size, then reboot, will you?
> > If crashkernel=auto get the expected size, no need to reboot. Means 99%
> > of systems has no need to reboot. Only very few of systems, need reboot
> > after checking the recommended size.
> > 
> > Long story short. crashkernel=auto will give a default value, trying to
> > cover most of systems. (Very few high end server need check if it's
> > enough and adjust with the help of user space tools. Then reboot.)
> 
> Then we might really want to investigate into shrinking a possibly larger
> allocation dynamically during boot.
> 
> > > 
> > > Also: this approach here doesn't make any sense when you want to do
> > > something dependent on other cmdline parameters. Take "fadump=on" vs
> > > "fadump=off" as an example. You just cannot handle it properly as proposed
> > > in this patch. To me the approach in this patch makes least sense TBH.
> > 
> > Why? We don't have this kind of judgement in kernel? Crashkernel=auto is
> > a generic mechanism, and has been added much earlier. Fadump was added
> > later by IBM for their need on ppc only, it relies on crashkernel
> > reservation but different mechanism of dumping. If it has different value
> > than kdump, a special hanlding is certainly needed. Who tell it has to be
> > 'fadump=on'? They can check the value in user space program and add into
> > cmdline as you suggested, they can also make it into auto. The most suitable
> > is the best.
> 
> Take a look at the RHEL8 handling to see where my comment is coming from.
> 
> > 
> > And I have several questions to ask, hope you can help answer:
> > 
> > 1) Have you ever met crashkernel=auto broken on virt platform?
> 
> I have encountered it being very suboptimal. I call wasting hundreds of MB
> problematic, especially when dynamically resizing of VMs (for example, using
> memory ballooning)
> 
> > 
> > Asking this because you are from Virt team, and crashkernel=auto has been
> > there in RHEL for many years, and we have been working with Virt team to
> > support dumping. We haven't seen any bug report or complaint about
> > crashkernel=auto from Virt.
> 
> I've had plenty of bug reports where people try inflating the balloon fairly
> heavily but don't take the crashkernel size into account. The bigger the
> crashkernel size, the bigger the issue when people try squeezing the last
> couple of MB out of their VMs. I keep repeating to them "with
> crashkernel=auto, you have to be careful about how much memory might get set
> aside for the crashkernel and, therefore, reduces your effective guest OS
> RAM size and reduces the maximum balloon size".
> 
> > 
> > 2) Adding crashkernel=auto, and the kdumpctl estimate as user space
> > program to get a recommended size, then reboot. Removing crashkernel=auto,
> > only the kdumpctl estimate to get a recommended size, always reboot.
> > In RHEL we will take the 1st option. Are you willing to take the 2nd one
> > for Virt platform since you think crashkernel=auto is plain wrong, pure
> > ugliness, essentially broken, least sense?
> 
> We are talking about upstreaming stuff here and I am wearing my upstream hat
> here. I'm stating (just like people decades ago) that this might not be the
> right approach for upstream, at least not as it stands.
> 
> And no, I don't have time to solve problems/implement solutions/upstream
> patches to tackle fundamental issues that have been there for decades.
> 
> I'll be happy to help looking into dynamic shrinking of the crashkernel size
> if that approach makes sense. We could even let user space trigger that
> resizing -- without a reboot.

Don't reply each inline comment since I believe they have been covered
by the earlier reply. Thanks for looking to this and telling your
thought, to let us know that in fact you really care about the extra
memory on VMs which we have realized, but didn't realized it really cause
issue. 

Thanks
Baoquan

