Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D182CC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 27 Dec 2022 13:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiL0NpN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Dec 2022 08:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiL0NpN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Dec 2022 08:45:13 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50554DD4
        for <mm-commits@vger.kernel.org>; Tue, 27 Dec 2022 05:45:12 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id s7so13276352plk.5
        for <mm-commits@vger.kernel.org>; Tue, 27 Dec 2022 05:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LLOaP6oZQVFqrGvrn6qUtbOqvisbvz7LL3tUHhmBYAA=;
        b=OHZZbpc/rNe+pPC8/wUGJqEOtcL45H9OZMtRqrw6BkkCxOKcZ1ssg+GD+3/ojZpu7g
         4us86mXUHST/c8fP4GSabkc9WlCrRrM6l725dRXEWkdY7BuUN7zgn/YMIN7kZ6IAkBuX
         a9WlVvtPpvSbvKMI647KF8E7H82DoYR3m5oZ8BlnD8iXwyEnJm7Gv6HAgtYiAylRJ+eS
         0YLFstgYnC8tZ4woz+dXsWsdGvoLKd0xgplRucg0c+S7QaiIzPNcI49FS13R+LywV7h9
         TepjHhsdrhu0eKqo+WMea3nz/0q0IQsXrTs6rZQKKa029puxieq4fTkWIpE/sRFmGF0j
         o68w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LLOaP6oZQVFqrGvrn6qUtbOqvisbvz7LL3tUHhmBYAA=;
        b=IpSj23Zrpk0S+f2zfQZscbbFbRliEcp2jQwO9GoVlB4MtUSWJ8UuIYLym/JTWUz9/j
         xCnnaVOfOVmk1G/gx3qgxRipiFoC+q7jpSCUDpfufve0fVmUVRGL4VZhj2jj2/yXHj+0
         bQLaw5MIKJN7eZz1YSHSgrSQobytawh2qcTaKGBD+AqywuZIIEC6YoTPL8RGgvSLVdZN
         MDeh9XugQqv4s4asL1343cuF3rc7j8iI+g5707g8hsWjFIp3q+3A3/2JcLIMGIL9BoSu
         meZw8an1VTNgItEJ2X4U4RHRV18muF050XCttM1iUaOXMeN8fuOhCE4pys+TqW2+VEAe
         w4gw==
X-Gm-Message-State: AFqh2krgOSEdaTYXCEn2SAe6yY3djFPzP2+lmneE+FeIIcuACe5y2u1/
        ixGisiymP+AhgmT9OoAJJMOpY6TghxdImB+6u02AGDHmfTOywg==
X-Google-Smtp-Source: AMrXdXtmkTchj0JicKIG9lRGF4mrHLoMlFGAPkh7XOY9GRBY4lVMnoQoFYsHYMYQDM+2fribMIL72sg+chAinVCwAFY=
X-Received: by 2002:a17:902:f2ca:b0:189:894c:6b58 with SMTP id
 h10-20020a170902f2ca00b00189894c6b58mr1026804plc.172.1672148711493; Tue, 27
 Dec 2022 05:45:11 -0800 (PST)
MIME-Version: 1.0
References: <20221220220816.BC003C433D2@smtp.kernel.org>
In-Reply-To: <20221220220816.BC003C433D2@smtp.kernel.org>
From:   Jeff Xu <jeffxu@google.com>
Date:   Tue, 27 Dec 2022 05:44:34 -0800
Message-ID: <CALmYWFtXNW50tAJhPg6YoN13Xjd4npwK+9kxziX=kxNSVYXLRw@mail.gmail.com>
Subject: Re: + mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch added
 to mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, lkp@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Thanks!

On Tue, Dec 20, 2022 at 2:08 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch
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
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix
> Date: Tue Dec 20 02:06:58 PM PST 2022
>
> fix CONFIG_SYSCTL=n warning
>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Jeff Xu <jeffxu@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/memfd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/mm/memfd.c~mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix
> +++ a/mm/memfd.c
> @@ -271,7 +271,6 @@ SYSCALL_DEFINE2(memfd_create,
>                 unsigned int, flags)
>  {
>         char comm[TASK_COMM_LEN];
> -       struct pid_namespace *ns;
>         unsigned int *file_seals;
>         struct file *file;
>         int fd, error;
> @@ -295,6 +294,7 @@ SYSCALL_DEFINE2(memfd_create,
>         if (!(flags & (MFD_EXEC | MFD_NOEXEC_SEAL))) {
>  #ifdef CONFIG_SYSCTL
>                 int sysctl = MEMFD_NOEXEC_SCOPE_EXEC;
> +               struct pid_namespace *ns;
>
>                 ns = task_active_pid_ns(current);
>                 if (ns)
> _
>
> Patches currently in -mm which might be from akpm@linux-foundation.org are
>
> mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch
> mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix.patch
> mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch
> mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch
> mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch
> mm-memcontrol-deprecate-charge-moving-fix.patch
> error-injection-remove-ei_etype_none-fix.patch
>
