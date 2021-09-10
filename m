Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D7B0C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 18:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36B0C6124E
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 18:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbhIJStT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Sep 2021 14:49:19 -0400
Received: from terminus.zytor.com ([198.137.202.136]:43893 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232347AbhIJStM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Sep 2021 14:49:12 -0400
X-Greylist: delayed 3622 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Sep 2021 14:49:12 EDT
Received: from [IPv6:::1] ([IPv6:2601:646:8600:3c71:7167:9908:f516:fd1e])
        (authenticated bits=0)
        by mail.zytor.com (8.16.1/8.15.2) with ESMTPSA id 18AHlLEC492080
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 10 Sep 2021 10:47:22 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 18AHlLEC492080
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2021083001; t=1631296043;
        bh=MpGGLjb/ptKT8DnQ1zzPUTON7aybYk1GwKrqi1M7XVM=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=gye2EPlTn4+vVaFA48NJNDZ7GLyirNPU2SAIKeBKDE3SKsy9HVJCJnwURN6+zEP15
         fEZXkOYr/2bMnDMOQV8wHM0tzdiyFjPRl4XK/SA2RHBEpmkf9OOzjukeJlEjg0w3dU
         tU5gMTTjOXq1LReALPYB6EZ0crvOsON4smMZUPqi3QfUjSCY+h0saQ41O11FEXSP7l
         mXHmoh5Qu/rqitKtRjYfNgK33lAeGcPrkbnaJRr+aA/KI8C5WkSk/yItxw/SSNEM/C
         F22OKyg58ncvReSmDeN3FbF6rqIjLym7C2RWgwOu8WT83U34ApULX69n9Ae8omiqO6
         cmhNYcVFL3AtA==
Date:   Fri, 10 Sep 2021 10:47:13 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jessica Yu <jeyu@kernel.org>, Borislav Petkov <bp@suse.de>
CC:     bgoncalv@redhat.com, egorenar@linux.ibm.com, hkallweit1@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: =?US-ASCII?Q?Re=3A_=5Bpatch_128/147=5D_init=3A_move_usermo?= =?US-ASCII?Q?dehelper=5Fenable=28=29_to_populate=5Frootfs=28=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <04d237ff-9a52-a6ce-d184-ea5874c104dc@rasmusvillemoes.dk>
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org> <20210908030003.WFvhfWzKJ%akpm@linux-foundation.org> <YTjadLYEhTRbwvRe@bombadil.infradead.org> <04d237ff-9a52-a6ce-d184-ea5874c104dc@rasmusvillemoes.dk>
Message-ID: <3BCD005A-B983-48FF-B30F-486387853245@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

I feel there is a general problem with the way infrastructure improvements =
are dealt with in the kernel =E2=80=93 basically it feels like the submitte=
r of new infrastructure is expected to convert existing users or "what we h=
ave now works=2E" This is a classic way of building tech debt=2E

Maybe this might be a topic to discuss?

On September 10, 2021 1:12:01 AM PDT, Rasmus Villemoes <linux@rasmusvillem=
oes=2Edk> wrote:
>On 08/09/2021 17=2E44, Luis Chamberlain wrote:
>> On Tue, Sep 07, 2021 at 08:00:03PM -0700, Andrew Morton wrote:
>>> From: Rasmus Villemoes <linux@rasmusvillemoes=2Edk>
>>> Any call of wait_for_initramfs() done before the unpacking has been
>>> scheduled (i=2Ee=2E before rootfs_initcall time) must just return
>>> immediately [and let the caller find an empty file system] in order
>>> not to deadlock the machine=2E I mistakenly thought, and my limited
>>> testing confirmed, that there were no such calls, so I added a
>>> pr_warn_once() in wait_for_initramfs()=2E It turns out that one can
>>> indeed hit request_module() as well as kobject_uevent_env() during
>>> those early init calls, leading to a user-visible warning in the
>>> kernel log emitted consistently for certain configurations=2E
>>=20
>> Further proof that the semantics for init is still loose=2E Formalizing
>> dependencies on init is something we should strive to=2E Eventualy with=
 a
>> DAG=2E  The linker-tables work I had done years ago strived to get us
>> there which allows us to get a simple explicit DAG through the linker=
=2E
>> Unfortunately that patch set fell through because folks were
>> more interested in questioning the alternative side benefits of
>> linker-tables, but the use-case for helping with init is still valid=2E
>>=20
>> If we *do* want to resurrect this folks should let me know=2E
>
>Heh, a while back I actually had some completely unrelated thing where
>I'd want to make use of the linker tables infrastructure - I remembered
>reading about it on LWN, and was quite surprised when I learnt that that
>work had never made it in=2E I don't quite remember the use case (I think
>it was for some test module infrastructure)=2E But if you do have time to
>resurrect those patches, I'd certainly be interested=2E
>
>> Since the kobject_uevent_env() interest here is for /sbin/hotplug and
>> that crap is deprecated, in practice the relevant calls we'd care about
>> are the request_module() calls=2E
>
>Yes - the first report I got about that pr_warn_once was indeed fixed by
>the reporter simply disabling CONFIG_UEVENT_HELPER
>(https://lore=2Ekernel=2Eorg/lkml/9849be80-cfe5-b33e-8224-590a4c451415@gm=
ail=2Ecom/)=2E
>
>>> We could just remove the pr_warn_once(), but I think it's better to
>>> postpone enabling the usermodehelper framework until there is at least
>>> some chance of finding the executable=2E That is also a little more
>>> efficient in that a lot of work done in umh=2Ec will be elided=2E
>>=20
>> I *don't* think we were aware that such request_module() calls were
>> happening before the fs was even ready and failing silently with
>> -ENOENT=2E=20
>
>Probably not, no, otherwise somebody would have noticed=2E
>
>As such, although moving the usermodehelper_enable()
>> to right after scheduling populating the rootfs is the right thing,
>> we do loose on the opportunity to learn who were those odd callers
>> before=2E We could not care=2E=2E=2E but this is also a missed opportun=
ity
>> in finding those=2E How important that is, is not clear to me as
>> this was silently failing before=2E=2E=2E
>>=20
>> If we wanted to keep a print for the above purpose though, we'd likely
>> want the full stack trace to see who the hell made the call=2E
>
>Well, yes, I have myself fallen into that trap not just once, but at
>least twice=2E The first time when I discovered this behaviour on one of
>the ppc targets I did this work for in the first place (before I came up
>with the CONFIG_MODPROBE_PATH patch)=2E The second when I asked a reporte=
r
>to replace the pr_warn_once by WARN_ONCE:
>
>https://lore=2Ekernel=2Eorg/lkml/4434f245-db3b-c02a-36c4-0111a0dfb78d@ras=
musvillemoes=2Edk/
>
>
>The problem is that request_module() just fires off some worker thread
>and then the original calling thread sits back and waits for that worker
>to return a result=2E
>
>
>>> However,
>>> it does change the error seen by those early callers from -ENOENT to
>>> -EBUSY, so there is a risk of a regression if any caller care about
>>> the exact error value=2E
>>=20
>> I'd see this as a welcomed evolution as it tells us more: we're saying
>> "it's coming, try again" or whatever=2E
>
>Indeed, and I don't think it's the end of the world if somebody notices
>some change due to that, because we'd learn more about where those early
>request_module() calls come from=2E
>
>> A debug option to allow us to get a full warning trace in the -EBUSY
>> case on early init would be nice to have=2E
>
>As noted above, that's difficult=2E We'd need a way to know which other
>task is waiting for us, then print the trace of that guy=2E
>
>I don't think anybody is gonna hear this tree falling, so let's not try
>to solve a problem before we know there is one=2E
>
>Rasmus

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
