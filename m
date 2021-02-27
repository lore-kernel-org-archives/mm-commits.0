Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C35C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 19:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FBDE64E2F
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 19:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhB0TTi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Feb 2021 14:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbhB0TTY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Feb 2021 14:19:24 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED437C06174A
        for <mm-commits@vger.kernel.org>; Sat, 27 Feb 2021 11:18:43 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id s3so12468046otg.5
        for <mm-commits@vger.kernel.org>; Sat, 27 Feb 2021 11:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=VqdS6xACzBzd6KDD/RGmhLHONKmrDLV8J0nAE4zwfn0=;
        b=WSeVSUA8r21Qb00WlkjxDaS4INz8XJ/cV9jOJpjuwzaa+CgGdJEpzgx1Pu4UTKkXr6
         gkorfqaGRD+sLSdk3GnfAEgI6tiQc5GOL0LcBXUkqHZesECtRUF+N8I6k/SMG8n/T4yt
         98cRTRGABzkod+mZsbotPqJnRy41pM20UuLTdAbYNxzCVKfbE9X+J8nWqs3K5ys+5dYs
         M7i99GmjVLfxMUlPYn8JTnIMHHlsdvNIoFd12hv1EeUOyrd7p9P/uZOn+e7hKe+7X8Tr
         pLBQe4BY0bCruvFurxv/HSnC84+ZspT+M8/pYdwpDEIP6jioU7JvRiZmAA67jwByckSQ
         Gvjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=VqdS6xACzBzd6KDD/RGmhLHONKmrDLV8J0nAE4zwfn0=;
        b=X7vRG7oFkf7/PoT0ImWSlaO4hS+I5Waek/DWuDjhMq0efEkvVVp5i5NK37+AoGUXla
         tO931ax7eM4jRw9XXVyh1qye/4D/AiHHQhIuScER5U8Ida+pEFgBI/Uh3LLSV6lfi24K
         50MV37jcFcqDDGiLkEOe9CQAQxYEJmzivLNW36d8qnIp7JwOBetfsBt5fV62ylNoO34Z
         nbM74C2Qvge8Vr+mBE4iogdZFdLpgCRHk3wXWouwE/HCqiIByOjiPjdVACC9kwtifYWk
         yvY13B7hDqyk9GwAm2RMb4Sp3ZxjvfrCBi5ep5SFGi3qNOugu4x57K3PYS7u81571Hh7
         3lMw==
X-Gm-Message-State: AOAM533m98DZWbXOVtBtUl+Z92+GD2eDFtZ0CZJbFJQThCiQzSBNqU7b
        qfOeozr1tHUD6xMNjzpYZ7JT3YFZRJ86eW/Ikw8=
X-Google-Smtp-Source: ABdhPJyaiGgD7EBEhTc6khgRRxmdyh1i+qJZWpeqo90PVhaNHF3bozuUnZ8ZqlKWs4TG2iWidfdARHTF3Oo1pZGtEpM=
X-Received: by 2002:a9d:7587:: with SMTP id s7mr7809988otk.114.1614453523399;
 Sat, 27 Feb 2021 11:18:43 -0800 (PST)
MIME-Version: 1.0
References: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org> <20210226012114.nmlpmyIrt%akpm@linux-foundation.org>
In-Reply-To: <20210226012114.nmlpmyIrt%akpm@linux-foundation.org>
From:   "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date:   Sat, 27 Feb 2021 20:18:32 +0100
Message-ID: <CAKgNAkiVWvzQOwRGOdSoh8JY-DpxcF6pWdLWNK4RHFdN-d6=+w@mail.gmail.com>
Subject: Re: [patch 091/118] MAINTAINERS: add uapi directories to API/ABI section
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hello,

On Fri, 26 Feb 2021 at 02:21, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Vlastimil Babka <vbabka@suse.cz>
> Subject: MAINTAINERS: add uapi directories to API/ABI section
>
> Let's add include/uapi/ and arch/*/include/uapi/ to API/ABI section, so
> that for patches modifying them, get_maintainers.pl suggests CCing
> linux-api@ so people don't forget.
>
> Link: https://lkml.kernel.org/r/20210217174745.13591-1-vbabka@suse.cz
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reported-by: David Hildenbrand <david@redhat.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  MAINTAINERS |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- a/MAINTAINERS~maintainers-add-uapi-directories-to-api-abi-section
> +++ a/MAINTAINERS
> @@ -261,6 +261,8 @@ ABI/API
>  L:     linux-api@vger.kernel.org
>  F:     include/linux/syscalls.h
>  F:     kernel/sys_ni.c
> +F:     include/uapi/
> +F:     arch/*/include/uapi/
>
>  ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
>  M:     Hans de Goede <hdegoede@redhat.com>

Can we please NOT do this.

Please see commit b14fd334ff3dc47b31c3592c166af5ea42b204d3.

In the past, include/uapi/ was listed as a file trigger, and the
consequence was a lot of low signal noise on linux-api@, until finally
I removed the trigger.

Thanks,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
