Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4BEC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 08:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E264E611C0
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 08:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhIJINT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Sep 2021 04:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhIJINQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Sep 2021 04:13:16 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76167C061574
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 01:12:05 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id t19so2548381ejr.8
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 01:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1dOOAVGFLJeQKROF8vyV5jECkXk5ICn4TwJOOAS4vBs=;
        b=J4qvXwnPbHsqQnF+fhCUWknnywseXtxqkxxAdk2U4qN3YUsc7SkXgW3m9QTeqjLMjv
         g8uThbo6FjIfDFcLPyYHKkpFHHVx7QL5X6cap6NNADoqLU7cAkD1yGvADHXEsttoX9ZA
         vJoiW9ZKjrZJczXL78D1mvqNhQmdYa26R2IUQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1dOOAVGFLJeQKROF8vyV5jECkXk5ICn4TwJOOAS4vBs=;
        b=ixO70AgRxr/kpCYuDFmP3PnJpoX3fquOrMk+zEsOQ4BnNMgs1Fkc1R8MAIsYofnRe4
         3srSCJszBGsdfabIplOeAzQu+DkAVB4dAiCT5NGMcJgfz3no6Lj8jba9Ny/r+8QVM1/U
         IrpGpOK8kY0UWoHcK6wa/+J3lzRYpi/ltjkR58eLoBIWNKTFHzAbAJc3KQPDOLSRWzys
         /pMp8mUNjD9yNkQ5qoThUwlxm2CjCFhkth4qplIhEryAvsJ5fAk9HR37gL1zrDGj+onu
         nhJKs7YBbcqNJX5umCSC2lsWLb4tcQsMcmNEQtugB+twXlyd96tYbPVuf1/59GpwTTqH
         s24Q==
X-Gm-Message-State: AOAM531GbYBs38CzJrNPYqxAh21rYVAHS2JVhHA1mLGDuhZ21BawUtJg
        e3LvhBGsZO5ygNHu6LvTjGLB+Q==
X-Google-Smtp-Source: ABdhPJye7b/IYmGDEgsgJMNR7ubOWe4W3LCkdtEDzHEBk88UrMYVXbNmn2dQWb+KQm1Pe8t+SU+vGw==
X-Received: by 2002:a17:906:3146:: with SMTP id e6mr8049909eje.296.1631261523837;
        Fri, 10 Sep 2021 01:12:03 -0700 (PDT)
Received: from [192.168.20.191] ([89.221.169.166])
        by smtp.gmail.com with ESMTPSA id q6sm1979323ejm.106.2021.09.10.01.12.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 01:12:03 -0700 (PDT)
Subject: Re: [patch 128/147] init: move usermodehelper_enable() to
 populate_rootfs()
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jessica Yu <jeyu@kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     bgoncalv@redhat.com, egorenar@linux.ibm.com, hkallweit1@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
 <20210908030003.WFvhfWzKJ%akpm@linux-foundation.org>
 <YTjadLYEhTRbwvRe@bombadil.infradead.org>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <04d237ff-9a52-a6ce-d184-ea5874c104dc@rasmusvillemoes.dk>
Date:   Fri, 10 Sep 2021 10:12:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YTjadLYEhTRbwvRe@bombadil.infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 08/09/2021 17.44, Luis Chamberlain wrote:
> On Tue, Sep 07, 2021 at 08:00:03PM -0700, Andrew Morton wrote:
>> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> Any call of wait_for_initramfs() done before the unpacking has been
>> scheduled (i.e. before rootfs_initcall time) must just return
>> immediately [and let the caller find an empty file system] in order
>> not to deadlock the machine. I mistakenly thought, and my limited
>> testing confirmed, that there were no such calls, so I added a
>> pr_warn_once() in wait_for_initramfs(). It turns out that one can
>> indeed hit request_module() as well as kobject_uevent_env() during
>> those early init calls, leading to a user-visible warning in the
>> kernel log emitted consistently for certain configurations.
> 
> Further proof that the semantics for init is still loose. Formalizing
> dependencies on init is something we should strive to. Eventualy with a
> DAG.  The linker-tables work I had done years ago strived to get us
> there which allows us to get a simple explicit DAG through the linker.
> Unfortunately that patch set fell through because folks were
> more interested in questioning the alternative side benefits of
> linker-tables, but the use-case for helping with init is still valid.
> 
> If we *do* want to resurrect this folks should let me know.

Heh, a while back I actually had some completely unrelated thing where
I'd want to make use of the linker tables infrastructure - I remembered
reading about it on LWN, and was quite surprised when I learnt that that
work had never made it in. I don't quite remember the use case (I think
it was for some test module infrastructure). But if you do have time to
resurrect those patches, I'd certainly be interested.

> Since the kobject_uevent_env() interest here is for /sbin/hotplug and
> that crap is deprecated, in practice the relevant calls we'd care about
> are the request_module() calls.

Yes - the first report I got about that pr_warn_once was indeed fixed by
the reporter simply disabling CONFIG_UEVENT_HELPER
(https://lore.kernel.org/lkml/9849be80-cfe5-b33e-8224-590a4c451415@gmail.com/).

>> We could just remove the pr_warn_once(), but I think it's better to
>> postpone enabling the usermodehelper framework until there is at least
>> some chance of finding the executable. That is also a little more
>> efficient in that a lot of work done in umh.c will be elided.
> 
> I *don't* think we were aware that such request_module() calls were
> happening before the fs was even ready and failing silently with
> -ENOENT. 

Probably not, no, otherwise somebody would have noticed.

As such, although moving the usermodehelper_enable()
> to right after scheduling populating the rootfs is the right thing,
> we do loose on the opportunity to learn who were those odd callers
> before. We could not care... but this is also a missed opportunity
> in finding those. How important that is, is not clear to me as
> this was silently failing before...
> 
> If we wanted to keep a print for the above purpose though, we'd likely
> want the full stack trace to see who the hell made the call.

Well, yes, I have myself fallen into that trap not just once, but at
least twice. The first time when I discovered this behaviour on one of
the ppc targets I did this work for in the first place (before I came up
with the CONFIG_MODPROBE_PATH patch). The second when I asked a reporter
to replace the pr_warn_once by WARN_ONCE:

https://lore.kernel.org/lkml/4434f245-db3b-c02a-36c4-0111a0dfb78d@rasmusvillemoes.dk/


The problem is that request_module() just fires off some worker thread
and then the original calling thread sits back and waits for that worker
to return a result.


>> However,
>> it does change the error seen by those early callers from -ENOENT to
>> -EBUSY, so there is a risk of a regression if any caller care about
>> the exact error value.
> 
> I'd see this as a welcomed evolution as it tells us more: we're saying
> "it's coming, try again" or whatever.

Indeed, and I don't think it's the end of the world if somebody notices
some change due to that, because we'd learn more about where those early
request_module() calls come from.

> A debug option to allow us to get a full warning trace in the -EBUSY
> case on early init would be nice to have.

As noted above, that's difficult. We'd need a way to know which other
task is waiting for us, then print the trace of that guy.

I don't think anybody is gonna hear this tree falling, so let's not try
to solve a problem before we know there is one.

Rasmus
