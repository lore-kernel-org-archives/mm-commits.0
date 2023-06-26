Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC285EB64D7
	for <mm-commits@archiver.kernel.org>; Mon, 26 Jun 2023 06:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjFZGli (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Jun 2023 02:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjFZGlg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jun 2023 02:41:36 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2936A8
        for <mm-commits@vger.kernel.org>; Sun, 25 Jun 2023 23:41:35 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b7e6512973so4503645ad.3
        for <mm-commits@vger.kernel.org>; Sun, 25 Jun 2023 23:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687761695; x=1690353695;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2/kHYdlKwbLOuDBb42QrwtD0lEVbSEPsnikfBuAu5dU=;
        b=TjWkYH4uKU9IY5CvfmqUxobAIH6gzsap0+1lXIOjWfskQwwwnzZEp55YEZyYOxqS/5
         4JyN5m5WnA2Cq+1UuazxFfCFrPSn2uI8KjUwTtbL4zAhDNbwMQRNCUWxKJKapMPrjPuX
         MnRlRJAi1i/+PJN6HQaq8Qr12Z5if/PIJiU4g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687761695; x=1690353695;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2/kHYdlKwbLOuDBb42QrwtD0lEVbSEPsnikfBuAu5dU=;
        b=B2HiqS+0n+cddDJVM+Y49T/Ym9kx1QITln4Ep6pRithHyN7qv1KbvIau1XIwB+w6Cl
         7HKJOw9RfMQJR4uB3oTwtNe9m5rmiZdfpQFtptqq4tVJa0UIGQoAMOvkslHXyTgtMtZs
         UlN/ZHE7eBT5+OAACYDBqtqS0PU/9mXKmiz3f8CC4aleAsAukqvQx8MuCElmlc9il0ZC
         6ypyVG0ZFFyP8N+qhyaT3SXYnMIXOF4LUUvu4WjgsBTfDXETjQnW03FlDq9Iwu/w7b+9
         U23VbIUewug0pb47lX10hPHvo7+mkeJFTZgAm+sl/OJjDHL3akv6k5IFsX8fd+syg8JE
         57fA==
X-Gm-Message-State: AC+VfDykHNguHYauEZf9Nlytn1iklRdMrkcjTBGx1wDapIx18Xpwid5h
        4WcjaLtwNr7LO9oL1MZvRzWYZg==
X-Google-Smtp-Source: ACHHUZ43dTdIUNW3Vfq50K9Nb0ysPn9wncq4lsHcutuZptCSghyABsQetjuLXWIj/VVZYFmIuaHTqA==
X-Received: by 2002:a17:902:8c84:b0:1b6:702b:11a with SMTP id t4-20020a1709028c8400b001b6702b011amr2664240plo.47.1687761695148;
        Sun, 25 Jun 2023 23:41:35 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id y6-20020a1709029b8600b001b682336f66sm3390484plp.55.2023.06.25.23.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 23:41:34 -0700 (PDT)
Date:   Mon, 26 Jun 2023 15:41:29 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     mm-commits@vger.kernel.org, zwp10758@gmail.com,
        senozhatsky@chromium.org, pc@cjr.nz, mcgrof@kernel.org,
        keescook@chromium.org, joe@perches.com, gregkh@linuxfoundation.org,
        tiozhang@didiglobal.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + cred-convert-printks-to-pr_level.patch added to
 mm-nonmm-unstable branch
Message-ID: <20230626064129.GJ2934656@google.com>
References: <20230625035813.A23CAC433C8@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230625035813.A23CAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Cc-ing Petr on this for visibility.
Message-id: 20230625035813.A23CAC433C8@smtp.kernel.org

On (23/06/24 20:58), Andrew Morton wrote:
> The patch titled
>      Subject: cred: convert printks to pr_<level>
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      cred-convert-printks-to-pr_level.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cred-convert-printks-to-pr_level.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
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
> From: tiozhang <tiozhang@didiglobal.com>
> Subject: cred: convert printks to pr_<level>
> Date: Sun, 25 Jun 2023 11:34:52 +0800
> 
> Use current logging style.
> 
> Link: https://lkml.kernel.org/r/20230625033452.GA22858@didi-ThinkCentre-M930t-N000
> Signed-off-by: tiozhang <tiozhang@didiglobal.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Joe Perches <joe@perches.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Paulo Alcantara <pc@cjr.nz>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Weiping Zhang <zwp10758@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/cred.c |   27 +++++++++++++++------------
>  1 file changed, 15 insertions(+), 12 deletions(-)
> 
> --- a/kernel/cred.c~cred-convert-printks-to-pr_level
> +++ a/kernel/cred.c
> @@ -4,6 +4,9 @@
>   * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
>   * Written by David Howells (dhowells@redhat.com)
>   */
> +
> +#define pr_fmt(fmt) "CRED: " fmt
> +
>  #include <linux/export.h>
>  #include <linux/cred.h>
>  #include <linux/slab.h>
> @@ -835,32 +838,32 @@ EXPORT_SYMBOL(creds_are_invalid);
>  static void dump_invalid_creds(const struct cred *cred, const char *label,
>  			       const struct task_struct *tsk)
>  {
> -	printk(KERN_ERR "CRED: %s credentials: %p %s%s%s\n",
> +	pr_err("%s credentials: %p %s%s%s\n",
>  	       label, cred,
>  	       cred == &init_cred ? "[init]" : "",
>  	       cred == tsk->real_cred ? "[real]" : "",
>  	       cred == tsk->cred ? "[eff]" : "");
> -	printk(KERN_ERR "CRED: ->magic=%x, put_addr=%p\n",
> +	pr_err("->magic=%x, put_addr=%p\n",
>  	       cred->magic, cred->put_addr);
> -	printk(KERN_ERR "CRED: ->usage=%d, subscr=%d\n",
> +	pr_err("->usage=%d, subscr=%d\n",
>  	       atomic_read(&cred->usage),
>  	       read_cred_subscribers(cred));
> -	printk(KERN_ERR "CRED: ->*uid = { %d,%d,%d,%d }\n",
> +	pr_err("->*uid = { %d,%d,%d,%d }\n",
>  		from_kuid_munged(&init_user_ns, cred->uid),
>  		from_kuid_munged(&init_user_ns, cred->euid),
>  		from_kuid_munged(&init_user_ns, cred->suid),
>  		from_kuid_munged(&init_user_ns, cred->fsuid));
> -	printk(KERN_ERR "CRED: ->*gid = { %d,%d,%d,%d }\n",
> +	pr_err("->*gid = { %d,%d,%d,%d }\n",
>  		from_kgid_munged(&init_user_ns, cred->gid),
>  		from_kgid_munged(&init_user_ns, cred->egid),
>  		from_kgid_munged(&init_user_ns, cred->sgid),
>  		from_kgid_munged(&init_user_ns, cred->fsgid));
>  #ifdef CONFIG_SECURITY
> -	printk(KERN_ERR "CRED: ->security is %p\n", cred->security);
> +	pr_err("->security is %p\n", cred->security);
>  	if ((unsigned long) cred->security >= PAGE_SIZE &&
>  	    (((unsigned long) cred->security & 0xffffff00) !=
>  	     (POISON_FREE << 24 | POISON_FREE << 16 | POISON_FREE << 8)))
> -		printk(KERN_ERR "CRED: ->security {%x, %x}\n",
> +		pr_err("->security {%x, %x}\n",
>  		       ((u32*)cred->security)[0],
>  		       ((u32*)cred->security)[1]);
>  #endif
> @@ -871,8 +874,8 @@ static void dump_invalid_creds(const str
>   */
>  void __noreturn __invalid_creds(const struct cred *cred, const char *file, unsigned line)
>  {
> -	printk(KERN_ERR "CRED: Invalid credentials\n");
> -	printk(KERN_ERR "CRED: At %s:%u\n", file, line);
> +	pr_err("Invalid credentials\n");
> +	pr_err("At %s:%u\n", file, line);
>  	dump_invalid_creds(cred, "Specified", current);
>  	BUG();
>  }
> @@ -898,14 +901,14 @@ void __validate_process_creds(struct tas
>  	return;
>  
>  invalid_creds:
> -	printk(KERN_ERR "CRED: Invalid process credentials\n");
> -	printk(KERN_ERR "CRED: At %s:%u\n", file, line);
> +	pr_err("Invalid process credentials\n");
> +	pr_err("At %s:%u\n", file, line);
>  
>  	dump_invalid_creds(tsk->real_cred, "Real", tsk);
>  	if (tsk->cred != tsk->real_cred)
>  		dump_invalid_creds(tsk->cred, "Effective", tsk);
>  	else
> -		printk(KERN_ERR "CRED: Effective creds == Real creds\n");
> +		pr_err("Effective creds == Real creds\n");
>  	BUG();
>  }
>  EXPORT_SYMBOL(__validate_process_creds);
> _
> 
> Patches currently in -mm which might be from tiozhang@didiglobal.com are
> 
> cred-convert-printks-to-pr_level.patch
> 
