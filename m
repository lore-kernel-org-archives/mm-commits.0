Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3909C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiKOW6j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238529AbiKOW6i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:58:38 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0A0617E
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:58:36 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso611457pjc.0
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kq4Y6rQhdXOoiJ3ApzoaQ4iWRuNKguAJvH7fFiA5+lM=;
        b=BaJKP/ZS2tHAcjTUXqz3a6j2RfJYf363C+N2oshVYmO/U1tJEXTxXhQZGAZhi0rlCu
         C5TQh4yiPabbWWPWALVZV2clCiTNjG8N5sQmPBmGwAZ5gEp4kXMebCg8CfZ3Temkcyl+
         zpVl0KYW+sMECgu84u7wyEp1xBEUuRbwF7LksHLeL1HrfrXx61ItAfCbWmZ+VWN3IQ4c
         nTki297fzgf5YN83nAxiJgJyVkRG+Nn+ST4d7OFDe2ixKKAy/r5pT630jKVJOzfcvpx+
         8tUygCTI5WxgsfACmwEjif22Hn0lc+ZAk65hhwb0ajm8dyGYIfQzoHrdNwwmFLPTQf+Z
         NfcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kq4Y6rQhdXOoiJ3ApzoaQ4iWRuNKguAJvH7fFiA5+lM=;
        b=aPdfZ7y5BsvBTnPOwLZv41p9aY1pTWc0TRVASOv3AKpSsX3B4VO6GO9CQyqpqxjcN4
         s1t81Mi+mORPrWU5XmRWv93Rpat868L/Sq0FDx4egal/y97tdWd92LuODY9OmKO6hH4S
         J4JlHV9AGszjKzeJItI0g7t9hqO5n2hAvY6Xd7I4HS8QJV0jYMXpiMMIEo2oLRCao8Uj
         aBfJ0kbnsKQ2hHJG/IAfE5bTJ+cdL6cAc63sNRBA7gu2laLuR5jvpwLlt2WXR/we7jZd
         x46vtuF7m+pj+eU45RTifu38COS0Z70qetrZk0i8Lvd4YnYburVWkq4JijGCFfVe7WT3
         oxCg==
X-Gm-Message-State: ANoB5pmiV6L0Fsjd9a42hk3tJjU3aGwtgxNHGCjAZChTlzYsh1ZSztCQ
        I2y4t1lY+9fNH+cCZH8CXoU=
X-Google-Smtp-Source: AA0mqf7dFFUXl1zLLNV8FGTEYby7Lxfm8TM/+QXzLrc2VxfWkD8V/ashED8J6Pr+wkC5ClC52XEYNg==
X-Received: by 2002:a17:90b:4d0b:b0:20a:d78d:ed20 with SMTP id mw11-20020a17090b4d0b00b0020ad78ded20mr653781pjb.65.1668553115940;
        Tue, 15 Nov 2022 14:58:35 -0800 (PST)
Received: from google.com ([2620:15c:211:201:6ff2:4caf:5d97:1932])
        by smtp.gmail.com with ESMTPSA id i65-20020a628744000000b0056b6c7a17c6sm9696352pfe.12.2022.11.15.14.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 14:58:35 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Tue, 15 Nov 2022 14:58:33 -0800
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, suleiman@google.com, ngupta@vflare.org,
        keescook+coverity-bot@chromium.org, keescook@chromium.org,
        senozhatsky@chromium.org
Subject: Re: + zram-introduce-recompress-sysfs-knob-fix-2.patch added to
 mm-unstable branch
Message-ID: <Y3QZmY9KyJWEDv5v@google.com>
References: <20221115004212.CD9B7C433C1@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115004212.CD9B7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Nov 14, 2022 at 04:42:12PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: zram: explicitly limit prio_max for static analyzers
> has been added to the -mm mm-unstable branch.  Its filename is
>      zram-introduce-recompress-sysfs-knob-fix-2.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-introduce-recompress-sysfs-knob-fix-2.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Sergey Senozhatsky <senozhatsky@chromium.org>
> Subject: zram: explicitly limit prio_max for static analyzers
> Date: Mon, 14 Nov 2022 11:14:20 +0900
> 
> Link: https://lkml.kernel.org/r/20221114021420.4060601-1-senozhatsky@chromium.org
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Suleiman Souhlal <suleiman@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/block/zram/zram_drv.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/drivers/block/zram/zram_drv.c~zram-introduce-recompress-sysfs-knob-fix-2
> +++ a/drivers/block/zram/zram_drv.c
> @@ -1689,6 +1689,7 @@ static int zram_recompress(struct zram *
>  	 * Iterate the secondary comp algorithms list (in order of priority)
>  	 * and try to recompress the page.
>  	 */
> +	prio_max = min(prio_max, ZRAM_MAX_COMPS);
>  	for (; prio < prio_max; prio++) {
>  		if (!zram->comps[prio])
>  			continue;
> _

Hi Andrew,

Please drop this patch. It makes reviewer think "oh, zram_recompress
pass the higher prio_max value than the one zram allowed by somehow
so we need to get the min value here", which is not true once review
read code again/again and scratch head and then post patch to remove
the unncessary line. I prefer reviewer happier.
