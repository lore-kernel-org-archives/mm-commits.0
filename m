Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0476C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 22:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343542AbhKXWw0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244982AbhKXWwZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Nov 2021 17:52:25 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BC8C061574
        for <mm-commits@vger.kernel.org>; Wed, 24 Nov 2021 14:49:15 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id 193so5798567qkh.10
        for <mm-commits@vger.kernel.org>; Wed, 24 Nov 2021 14:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zpoUINufJYOEsOKSrKJolz+fTq+VzTbpDq34txotFpQ=;
        b=CrfgoXqVYNR5scZuT+JzqYhXW3UmdUGVa3OoNysN1y/w12XFPJjPfWuGzByUVNZLMD
         3iyPFaENoW+RyTXcodjmTIiQLtwv21ZYxH4nq1NBQGMl6VPK7/Dv5xPRqWJtqEdrYmD3
         5+mwNZpfYQVoJvhVvtkHydQ4zcu5zC+JaNv0wGKM+HTEhNniGZunCEnmFr+PmFVaVbva
         Bv3J/uS50jLCi9JlGmJfOHQAhAHGEngllkQmvATrTev2TumSTrlPf5k4YO19DjyiS8HL
         gxFJ85pXvWQ5iAZj+KacCUbN/mY0jzaV/8tFqS7A++R6KidYYKutqxYuSbXFCbtUEwUy
         Wqfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zpoUINufJYOEsOKSrKJolz+fTq+VzTbpDq34txotFpQ=;
        b=2oUcyCDCi9RBaDoTdxodXPk+dRnl8LfDR0HKZHvdWnBtNbkM9say4f5xBXHtl9qFkc
         oX9dnqySxlyY6hmi2LODUJumUtQKyVVnOQlnk+xf+wOm9lgEdrHMr+Xdov4zu/XlMaqJ
         iaXCU5PQKsc0tZf4vdH0dniBiPsolbFAsbQoYUiIABRBd340JT9K1jcD+KNGk5uEAIKK
         KjDRgJ1oTK6sbL5r2ZKerlnv1OeQ63vXpizYbJTz+JeAISTqTNqptJlU9hI133plBwcD
         ZuK+ori1MI25NDJtR6PI7WrCW5BOoEWbsb0rtu48qeN7iuSAUyFw5uWRpks/7t2YRzj1
         28SQ==
X-Gm-Message-State: AOAM532mljj7PsieChtTkfUCzsZlAJy/dj36BnRT7UX/+IxXb64XuBpv
        7Z8LCGCuVC1Dv+uZyJBmqzwPPyrGS19PHp4WyJu7Fx5gyNs=
X-Google-Smtp-Source: ABdhPJwwcOxlE4TKxW4AinQ7Vbm17Qvr7DHWOT5BtjyOnYP5olV5sq4p/mV6JkPQxJ2DV3L3nCNtjhoZsmLdV4Y3Y4M=
X-Received: by 2002:a25:8411:: with SMTP id u17mr850190ybk.376.1637794153799;
 Wed, 24 Nov 2021 14:49:13 -0800 (PST)
MIME-Version: 1.0
References: <20211124220801.ip01WsWPQ%akpm@linux-foundation.org>
In-Reply-To: <20211124220801.ip01WsWPQ%akpm@linux-foundation.org>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 24 Nov 2021 14:49:02 -0800
Message-ID: <CAJuCfpGbVjT-G3OhrGaf6kLD-cGVHWL3bYvC5_S4=aQxiJr7Aw@mail.gmail.com>
Subject: Re: + sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
 added to -mm tree
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, nixiaoming@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Nov 24, 2021 at 2:08 PM <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix
> has been added to the -mm tree.  Its filename is
>      sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
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
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix
>
> update it for "mm/pagealloc: sysctl: change watermark_scale_factor max
> limit to 30%".

Thanks for resolving the conflicts, Andrew!

>
> Cc: Xiaoming Ni <nixiaoming@huawei.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  fs/proc/proc_sysctl.c  |    2 +-
>  include/linux/sysctl.h |    3 ++-
>  kernel/sysctl.c        |    3 +--
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> --- a/fs/proc/proc_sysctl.c~sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix
> +++ a/fs/proc/proc_sysctl.c
> @@ -26,7 +26,7 @@ static const struct file_operations proc
>  static const struct inode_operations proc_sys_dir_operations;
>
>  /* shared constants to be used in various sysctls */
> -const int sysctl_vals[] = { -1, 0, 1, 2, 4, 100, 200, 1000, INT_MAX };
> +const int sysctl_vals[] = { -1, 0, 1, 2, 4, 100, 200, 1000, 3000, INT_MAX };
>  EXPORT_SYMBOL(sysctl_vals);
>
>  /* Support for permanently empty directories */
> --- a/include/linux/sysctl.h~sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix
> +++ a/include/linux/sysctl.h
> @@ -46,7 +46,8 @@ struct ctl_dir;
>  #define SYSCTL_ONE_HUNDRED             ((void *)&sysctl_vals[5])
>  #define SYSCTL_TWO_HUNDRED             ((void *)&sysctl_vals[6])
>  #define SYSCTL_ONE_THOUSAND            ((void *)&sysctl_vals[7])
> -#define SYSCTL_INT_MAX                 ((void *)&sysctl_vals[8])
> +#define SYSCTL_THREE_THOUSAND          ((void *)&sysctl_vals[8])
> +#define SYSCTL_INT_MAX                 ((void *)&sysctl_vals[9])
>
>  extern const int sysctl_vals[];
>
> --- a/kernel/sysctl.c~sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix
> +++ a/kernel/sysctl.c
> @@ -116,7 +116,6 @@ static int sixty = 60;
>  static unsigned long zero_ul;
>  static unsigned long one_ul = 1;
>  static unsigned long long_max = LONG_MAX;
> -static int three_thousand = 3000;
>  #ifdef CONFIG_PRINTK
>  static int ten_thousand = 10000;
>  #endif
> @@ -2954,7 +2953,7 @@ static struct ctl_table vm_table[] = {
>                 .mode           = 0644,
>                 .proc_handler   = watermark_scale_factor_sysctl_handler,
>                 .extra1         = SYSCTL_ONE,
> -               .extra2         = &three_thousand,
> +               .extra2         = SYSCTL_THREE_THOUSAND,
>         },
>         {
>                 .procname       = "percpu_pagelist_high_fraction",
> _
>
> Patches currently in -mm which might be from akpm@linux-foundation.org are
>
> mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
> kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
> mm.patch
> mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
> mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
> proc-make-the-proc_create-stubs-static-inlines-fix.patch
> panic-use-error_report_end-tracepoint-on-warnings-fix.patch
> linux-next-git-rejects.patch
> sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
> kernel-forkc-export-kernel_thread-to-modules.patch
>
