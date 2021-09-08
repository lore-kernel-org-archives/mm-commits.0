Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FE4C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 15:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA75D61108
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 15:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348440AbhIHPqM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Sep 2021 11:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239842AbhIHPqL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2021 11:46:11 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B466C061575
        for <mm-commits@vger.kernel.org>; Wed,  8 Sep 2021 08:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qFn1nAQcFnlnYZS+nsEEq8j9vEMeJPJrHiNSe+RMijQ=; b=jMSGR2x1R6Zknu1vUKvOIimn2R
        XqRuB6FqOdmh5XyZLuqOi5+657FcEQmcYUSiexOydVT9vllNR7OmwrcUTuJ5QpzkwNlh29fWpfoXp
        1pE+OPPMJgWqVnfw7carlyodjWXxNVK66QMHtqCrTAkh3HddAf3oJHTKHmbC7+FsbK8SeEk6AhWfo
        HAci00jpgVp+3eoLsjo5hCGm6/NHwHErO0E2OhGu87Z66OvCEFEHCWLEVwIY6LgPKDa8nkX14FeGF
        DIQvs8maVIev6yy4Hod4zVcgU++z8LUrZuKOn/bBjXdP7jCb9ei+pk3S7OI+UaIgnR6gBLsx60adm
        EntyWkbw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mNzkq-0075LZ-Dr; Wed, 08 Sep 2021 15:44:52 +0000
Date:   Wed, 8 Sep 2021 08:44:52 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jessica Yu <jeyu@kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     bgoncalv@redhat.com, egorenar@linux.ibm.com, hkallweit1@gmail.com,
        linux-mm@kvack.org, linux@rasmusvillemoes.dk,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [patch 128/147] init: move usermodehelper_enable() to
 populate_rootfs()
Message-ID: <YTjadLYEhTRbwvRe@bombadil.infradead.org>
References: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
 <20210908030003.WFvhfWzKJ%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908030003.WFvhfWzKJ%akpm@linux-foundation.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Sep 07, 2021 at 08:00:03PM -0700, Andrew Morton wrote:
> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Subject: init: move usermodehelper_enable() to populate_rootfs()
> 
> Currently, usermodehelper is enabled right before PID1 starts going
> through the initcalls. However, any call of a usermodehelper from a
> pure_, core_, postcore_, arch_, subsys_ or fs_ initcall is futile, as
> there is no filesystem contents yet.
> 
> Up until commit e7cb072eb988 ("init/initramfs.c: do unpacking
> asynchronously"), such calls, whether via some request_module(), a
> legacy uevent "/sbin/hotplug" notification or something else, would
> just fail silently with (presumably) -ENOENT from
> kernel_execve(). However, that commit introduced the
> wait_for_initramfs() synchronization hook which must be called from
> the usermodehelper exec path right before the kernel_execve, in order
> that request_module() et al done from *after* rootfs_initcall()
> time (i.e. device_ and late_ initcalls) would continue to find a
> populated initramfs as they used to.
> 
> Any call of wait_for_initramfs() done before the unpacking has been
> scheduled (i.e. before rootfs_initcall time) must just return
> immediately [and let the caller find an empty file system] in order
> not to deadlock the machine. I mistakenly thought, and my limited
> testing confirmed, that there were no such calls, so I added a
> pr_warn_once() in wait_for_initramfs(). It turns out that one can
> indeed hit request_module() as well as kobject_uevent_env() during
> those early init calls, leading to a user-visible warning in the
> kernel log emitted consistently for certain configurations.

Further proof that the semantics for init is still loose. Formalizing
dependencies on init is something we should strive to. Eventualy with a
DAG.  The linker-tables work I had done years ago strived to get us
there which allows us to get a simple explicit DAG through the linker.
Unfortunately that patch set fell through because folks were
more interested in questioning the alternative side benefits of
linker-tables, but the use-case for helping with init is still valid.

If we *do* want to resurrect this folks should let me know.

Since the kobject_uevent_env() interest here is for /sbin/hotplug and
that crap is deprecated, in practice the relevant calls we'd care about
are the request_module() calls.

> We could just remove the pr_warn_once(), but I think it's better to
> postpone enabling the usermodehelper framework until there is at least
> some chance of finding the executable. That is also a little more
> efficient in that a lot of work done in umh.c will be elided.

I *don't* think we were aware that such request_module() calls were
happening before the fs was even ready and failing silently with
-ENOENT. As such, although moving the usermodehelper_enable()
to right after scheduling populating the rootfs is the right thing,
we do loose on the opportunity to learn who were those odd callers
before. We could not care... but this is also a missed opportunity
in finding those. How important that is, is not clear to me as
this was silently failing before...

If we wanted to keep a print for the above purpose though, we'd likely
want the full stack trace to see who the hell made the call.

> However,
> it does change the error seen by those early callers from -ENOENT to
> -EBUSY, so there is a risk of a regression if any caller care about
> the exact error value.

I'd see this as a welcomed evolution as it tells us more: we're saying
"it's coming, try again" or whatever.

A debug option to allow us to get a full warning trace in the -EBUSY
case on early init would be nice to have.

Otherwise:

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

> Link: https://lkml.kernel.org/r/20210728134638.329060-1-linux@rasmusvillemoes.dk
> Fixes: e7cb072eb988 ("init/initramfs.c: do unpacking asynchronously")
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Reported-by: Alexander Egorenkov <egorenar@linux.ibm.com>
> Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
> Reported-by: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  init/initramfs.c   |    2 ++
>  init/main.c        |    1 -
>  init/noinitramfs.c |    2 ++
>  3 files changed, 4 insertions(+), 1 deletion(-)
> 
> --- a/init/initramfs.c~init-move-usermodehelper_enable-to-populate_rootfs
> +++ a/init/initramfs.c
> @@ -15,6 +15,7 @@
>  #include <linux/mm.h>
>  #include <linux/namei.h>
>  #include <linux/init_syscalls.h>
> +#include <linux/umh.h>
>  
>  static ssize_t __init xwrite(struct file *file, const char *p, size_t count,
>  		loff_t *pos)
> @@ -727,6 +728,7 @@ static int __init populate_rootfs(void)
>  {
>  	initramfs_cookie = async_schedule_domain(do_populate_rootfs, NULL,
>  						 &initramfs_domain);
> +	usermodehelper_enable();
>  	if (!initramfs_async)
>  		wait_for_initramfs();
>  	return 0;
> --- a/init/main.c~init-move-usermodehelper_enable-to-populate_rootfs
> +++ a/init/main.c
> @@ -1392,7 +1392,6 @@ static void __init do_basic_setup(void)
>  	driver_init();
>  	init_irq_proc();
>  	do_ctors();
> -	usermodehelper_enable();
>  	do_initcalls();
>  }
>  
> --- a/init/noinitramfs.c~init-move-usermodehelper_enable-to-populate_rootfs
> +++ a/init/noinitramfs.c
> @@ -10,6 +10,7 @@
>  #include <linux/kdev_t.h>
>  #include <linux/syscalls.h>
>  #include <linux/init_syscalls.h>
> +#include <linux/umh.h>
>  
>  /*
>   * Create a simple rootfs that is similar to the default initramfs
> @@ -18,6 +19,7 @@ static int __init default_rootfs(void)
>  {
>  	int err;
>  
> +	usermodehelper_enable();
>  	err = init_mkdir("/dev", 0755);
>  	if (err < 0)
>  		goto out;
> _
