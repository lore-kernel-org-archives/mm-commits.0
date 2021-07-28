Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 665F9C4338F
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jul 2021 06:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4675460FA0
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jul 2021 06:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbhG1GIu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Jul 2021 02:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231199AbhG1GIu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Jul 2021 02:08:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93C5460F9E;
        Wed, 28 Jul 2021 06:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627452528;
        bh=zDcZ1gQhXqUEsZ1uAAg77drWIrnJcFlK88PY+jFKOi8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jO+2/7gN9cbmQXEXEgK6YULFEQ3jqPJj8kdtMJ910SL2ocT+EYX1X4BubqWbjxJy2
         Ys5xAlVITZKKhcI7BVEU8/j56Pb0Uqs8LFo579LTfB90tyQxPtBKsqrhxgL1WH0p1B
         pWFmDiwFkwcHLIJLkExS32MGw79GGGctXInQ5tqs=
Date:   Wed, 28 Jul 2021 08:08:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        vdavydov.dev@gmail.com, tj@kernel.org, tglx@linutronix.de,
        shakeelb@google.com, serge@hallyn.com, oleg@redhat.com,
        nglaive@gmail.com, mingo@redhat.com, mhocko@kernel.org,
        lizefan.x@bytedance.com, ktkhai@virtuozzo.com, jlayton@kernel.org,
        jirislaby@kernel.org, hpa@zytor.com, hannes@cmpxchg.org,
        guro@fb.com, ebiederm@xmission.com, christian.brauner@ubuntu.com,
        bp@suse.de, bp@alien8.de, bfields@fieldses.org, axboe@kernel.dk,
        avagin@gmail.com, adobriyan@gmail.com, 0x7f454c46@gmail.com,
        vvs@virtuozzo.com
Subject: Re: + memcg-enable-accounting-for-tty-related-objects.patch added to
 -mm tree
Message-ID: <YQD0brY0x/uGTT15@kroah.com>
References: <20210727210827.rn4v1%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727210827.rn4v1%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Jul 27, 2021 at 02:08:27PM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: memcg: enable accounting for tty-related objects
> has been added to the -mm tree.  Its filename is
>      memcg-enable-accounting-for-tty-related-objects.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/memcg-enable-accounting-for-tty-related-objects.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/memcg-enable-accounting-for-tty-related-objects.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Vasily Averin <vvs@virtuozzo.com>
> Subject: memcg: enable accounting for tty-related objects
> 
> At each login the user forces the kernel to create a new terminal and
> allocate up to ~1Kb memory for the tty-related structures.
> 
> By default it's allowed to create up to 4096 ptys with 1024 reserve for
> initial mount namespace only and the settings are controlled by host
> admin.
> 
> Though this default is not enough for hosters with thousands of containers
> per node.  Host admin can be forced to increase it up to NR_UNIX98_PTY_MAX
> = 1<<20.
> 
> By default container is restricted by pty mount_opt.max = 1024, but admin
> inside container can change it via remount.  As a result, one container
> can consume almost all allowed ptys and allocate up to 1Gb of unaccounted
> memory.
> 
> It is not enough per-se to trigger OOM on host, however anyway, it allows
> to significantly exceed the assigned memcg limit and leads to troubles on
> the over-committed node.
> 
> It makes sense to account for them to restrict the host's memory
> consumption from inside the memcg-limited container.
> 
> Link: https://lkml.kernel.org/r/b8baa04f-e789-0321-b39d-07c5696ff755@virtuozzo.com
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Andrei Vagin <avagin@gmail.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Dmitry Safonov <0x7f454c46@gmail.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "J. Bruce Fields" <bfields@fieldses.org>
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Jiri Slaby <jirislaby@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Serge Hallyn <serge@hallyn.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Yutian Yang <nglaive@gmail.com>
> Cc: Zefan Li <lizefan.x@bytedance.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/tty/tty_io.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/drivers/tty/tty_io.c~memcg-enable-accounting-for-tty-related-objects
> +++ a/drivers/tty/tty_io.c
> @@ -1493,7 +1493,7 @@ void tty_save_termios(struct tty_struct
>  	/* Stash the termios data */
>  	tp = tty->driver->termios[idx];
>  	if (tp == NULL) {
> -		tp = kmalloc(sizeof(*tp), GFP_KERNEL);
> +		tp = kmalloc(sizeof(*tp), GFP_KERNEL_ACCOUNT);
>  		if (tp == NULL)
>  			return;
>  		tty->driver->termios[idx] = tp;
> @@ -3119,7 +3119,7 @@ struct tty_struct *alloc_tty_struct(stru
>  {
>  	struct tty_struct *tty;
>  
> -	tty = kzalloc(sizeof(*tty), GFP_KERNEL);
> +	tty = kzalloc(sizeof(*tty), GFP_KERNEL_ACCOUNT);
>  	if (!tty)
>  		return NULL;
>  
> _
> 
> Patches currently in -mm which might be from vvs@virtuozzo.com are
> 
> memcg-enable-accounting-for-pids-in-nested-pid-namespaces.patch
> memcg-enable-accounting-for-mnt_cache-entries.patch
> memcg-enable-accounting-for-pollfd-and-select-bits-arrays.patch
> memcg-enable-accounting-for-file-lock-caches.patch
> memcg-enable-accounting-for-fasync_cache.patch
> memcg-enable-accounting-for-new-namesapces-and-struct-nsproxy.patch
> memcg-enable-accounting-of-ipc-resources.patch
> memcg-enable-accounting-for-signals.patch
> memcg-enable-accounting-for-posix_timers_cache-slab.patch
> memcg-enable-accounting-for-tty-related-objects.patch
> memcg-enable-accounting-for-ldt_struct-objects.patch
> 

This patch should be dropped, as per review it was rejected as being
incorrect.

thanks,

greg k-h
