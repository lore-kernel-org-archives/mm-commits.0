Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F7CBC43334
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 22:14:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiFAWOI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 18:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbiFAWOH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 18:14:07 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527252528B
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 15:14:06 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id g4so5250045ybf.12
        for <mm-commits@vger.kernel.org>; Wed, 01 Jun 2022 15:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3lchSwxpgxXWZoqJIR3k86lWN6hQqrE2YEa3/+RhP14=;
        b=sQ2cs8vx+GBc662i3r5L0m6/SWBfaJv3wEJXDAR3qJTPaKo14l1FuSzHgh7hO5l/wv
         lfWOPmlncTu9+GXwFfQ4s74DwdAPEhEWRb6E9I/V0jazEHaaUifxyY4QV9Tfj4fXhOSd
         koSIlCQ/pEVHZFjqgQ+4fCY9Xeia0hHL4xSkHuXbqpVYdO1ITL8J516nZcY9gf5oi4Vj
         RsP7BdA7lK3XiHX1zBGPE+XevvwznjTH52pp7SUf/XmpQot+C4qCcVgh/vd25ckSU1Sa
         pPA1NieGKUjn5BLSTjvAKVt6a2KADoQGQsTJQiozsq4kOv5rSz15p1sShr34CckjIOn+
         rWuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3lchSwxpgxXWZoqJIR3k86lWN6hQqrE2YEa3/+RhP14=;
        b=F+lIdDb1Ws+/aBIz+RCnYLfVZuNXcASe5G12TVbNAxNIr/XnkqnouuAn5X6LDXp5vy
         a20ysQdSvDB7hITF01XrjWGskvEOPtX0wgIGKDGKEh9tWtuYK5//xPvstXr63GoI/WhC
         s1v8vsKhLZtjcm4lpjtebZqXOcoxeFlOb8xmgD0qy9o0nWDwAOD9g/YFCAovX+Z7Iznv
         3rflI4g9nqr75VunMbURdj42oAnKfNFxb3S30z/XXzoGhJpfgVcdcpGH7yvUKfQUrvNV
         9KvC3erv0aCB2Xp7ctxNZhA9BBRzD9bGgwuDCAoHd5bt/IX5cYW7emCQYC5KRJFoGA+3
         QRGA==
X-Gm-Message-State: AOAM530La+JhBJLFRQamoFmr7OOKXF+m7dAJuuDPULP+uz3u7o5RAzXp
        RUswwjt8yTHESeymZBtpvVlFYOQ3+xE1vxxL9qpNWyyVDrw=
X-Google-Smtp-Source: ABdhPJzKWgMOiukWsPBeQu/eSjKUGR8TJIeje6Ci0ItoAoqaSK+t9icQVcTmIozIguX1xz1F3CIxyfFj5QMQPxqa6tw=
X-Received: by 2002:a05:6902:13c2:b0:641:b6d:a151 with SMTP id
 y2-20020a05690213c200b006410b6da151mr2142341ybu.348.1654121645366; Wed, 01
 Jun 2022 15:14:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220601220859.B1F0EC385A5@smtp.kernel.org>
In-Reply-To: <20220601220859.B1F0EC385A5@smtp.kernel.org>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 1 Jun 2022 15:13:54 -0700
Message-ID: <CAJuCfpFvH0EnyNnc8bdFnMVE3tHWQX2zwN7L29Yz+PT_xsZq5A@mail.gmail.com>
Subject: Re: + mm-drop-oom-code-from-exit_mmap-fix.patch added to mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jun 1, 2022 at 3:09 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: mm-drop-oom-code-from-exit_mmap-fix
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-drop-oom-code-from-exit_mmap-fix.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-oom-code-from-exit_mmap-fix.patch
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
> Subject: mm-drop-oom-code-from-exit_mmap-fix
> Date: Wed Jun  1 03:07:59 PM PDT 2022
>
> fix it for presense of mapletree patchset, per Suren

Andrew, could we also restore the mmap_lock_read/write retaking? It
does make a difference for parallel memory reaping.
If you want I can post a v3 with more explanation about that and also
a separate patchset applied over maple-tree branch (if you have it
separately). Should I?

>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/mmap.c |    1 -
>  1 file changed, 1 deletion(-)
>
> --- a/mm/mmap.c~mm-drop-oom-code-from-exit_mmap-fix
> +++ a/mm/mmap.c
> @@ -3215,7 +3215,6 @@ void exit_mmap(struct mm_struct *mm)
>
>         trace_exit_mmap(mm);
>         __mt_destroy(&mm->mm_mt);
> -       mm->mmap = NULL;
>         mmap_write_unlock(mm);
>         vm_unacct_memory(nr_accounted);
>  }
> _
>
> Patches currently in -mm which might be from akpm@linux-foundation.org are
>
> mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
> mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
> mm-start-tracking-vmas-with-maple-tree-fix.patch
> damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
> mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch
> mm-remove-the-vma-linked-list-fix-fix.patch
> mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
> mm-introduce-clear_highpage_tagged-fix.patch
> kasan-fix-zeroing-vmalloc-memory-with-hw_tags-fix.patch
> mm-drop-oom-code-from-exit_mmap-fix.patch
> squashfs-implement-readahead-checkpatch-fixes.patch
>
