Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C74C43460
	for <mm-commits@archiver.kernel.org>; Sun,  2 May 2021 03:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C715613B0
	for <mm-commits@archiver.kernel.org>; Sun,  2 May 2021 03:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhEBDL7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 1 May 2021 23:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhEBDL7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 1 May 2021 23:11:59 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25215C06174A
        for <mm-commits@vger.kernel.org>; Sat,  1 May 2021 20:11:07 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id j13so1275544vsf.2
        for <mm-commits@vger.kernel.org>; Sat, 01 May 2021 20:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EaSudPlR2rmEoAsm+oIDcns/1yXi9M5M7SrU4T5qiNY=;
        b=hLBjZKOibHs8RLGqHK5kdfXVVEPyLUeYBTL1gWhdW0ulfL0mxFUqERBfFrUwlrso8k
         7Rp8hC6KBhMapSG9EVsG+O4wndbB/YljtJtQQOJtOH0jUOs7wbGbk3bEnwVQZC7H6mO6
         RueWI5TdGkd2q5WXmB1lYwqQmifAqhsTxmKv7CXRbD9GHOJU3R+5BlHyshV/ccZOx6A+
         3t4a7XiAKLUr1ylEH9m6s5YtzFoDv8QKn6rVWmY8Hf7E9TdwfktH54Wkxn10UcjXAbDN
         8z+/aGBv4R0OV5VqzfLpPBoa9R2kpSp13CbrW/pWYAItM5z25vgyHjTS/Kmf46jyOfC7
         333g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EaSudPlR2rmEoAsm+oIDcns/1yXi9M5M7SrU4T5qiNY=;
        b=KDh+cyssRDidEpbJbbb3+wamDv2RCD2njF/MfGNy9IPjFChdBVeCcj4xp8Y6x2Wz2G
         3Uh74JoZRgKIvBE3srFPs9vdYBqm2fHgLnb1ccw98AEKaStI3fQ/LHADW/x8ruymkFoU
         zwdWf+ytoIQ2ivrAw8o8kD2wP6KPRtIyetmXpNkIy6nHomXPiSoLXflUXniHbSgGNfoR
         SLn+c7LMp4LDvJgoi65DltM1IWzJ3Au86cG3ZTlucXr/Yv69da2QZC+10seAMV5pkGkm
         B7ZiPKeXMu7PSHQ7prfCs7jS84dW26rmwTxnxhPdQgMSWqKd2bAfcd6m52Y8wOmIL/ul
         Y4AQ==
X-Gm-Message-State: AOAM5314hhSTPoPQf99noHojxPPkfbE/KzyOKkmG42wjjlY075HYvjmu
        zvOka5TFwI1FTGpvh/DpSBYyoaqEHeQfrHOZP9Y=
X-Google-Smtp-Source: ABdhPJwzwSBTuGA8aelbGzEGFEePuhBpaa3ybnu0pqTz4UizVK6ATPUwRrvS64taqyOZgVd1A3XV3wN2DBOVL5GlKVo=
X-Received: by 2002:a67:f988:: with SMTP id b8mr11972701vsq.14.1619925066177;
 Sat, 01 May 2021 20:11:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org> <20210430060130.NUadzonOe%akpm@linux-foundation.org>
In-Reply-To: <20210430060130.NUadzonOe%akpm@linux-foundation.org>
From:   jim.cromie@gmail.com
Date:   Sat, 1 May 2021 21:10:40 -0600
Message-ID: <CAJfuBxwdHTJrDpcedT_aaMeneTPhb0Wu-bENh+eRpYx4QLQg0A@mail.gmail.com>
Subject: Re: [patch 162/178] mm: page_alloc: dump migrate-failed pages
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     david@redhat.com, Jason Baron <jbaron@akamai.com>,
        joaodias@google.com, linux-mm@kvack.org, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Apr 30, 2021 at 12:01 AM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> From: Minchan Kim <minchan@kernel.org>
> Subject: mm: page_alloc: dump migrate-failed pages
>
> Currently, debugging CMA allocation failures is quite limited.  The most
> common source of these failures seems to be page migration which doesn't
> provide any useful information on the reason of the failure by itself.
> alloc_contig_range can report those failures as it holds a list of
> migrate-failed pages.
>
> The information logged by dump_page() has already proven helpful for
> debugging allocation issues, like identifying long-term pinnings on
> ZONE_MOVABLE or MIGRATE_CMA.
>
> Let's use the dynamic debugging infrastructure, such that we avoid
> flooding the logs and creating a lot of noise on frequent
> alloc_contig_range() calls.  This information is helpful for debugging
> only.
>
> There are two ifdefery conditions to support common dyndbg options:
>
> - CONFIG_DYNAMIC_DEBUG_CORE && DYNAMIC_DEBUG_MODULE
>   It aims for supporting the feature with only specific file with
>   adding ccflags.
>
> - CONFIG_DYNAMIC_DEBUG
>   It aims for supporting the feature with system wide globally.
>
> A simple example to enable the feature:
>
> Admin could enable the dump like this(by default, disabled)
>
>         echo "func alloc_contig_dump_pages +p" > control
>
> Admin could disable it.
>
>         echo "func alloc_contig_dump_pages =_" > control
>
> Detail goes Documentation/admin-guide/dynamic-debug-howto.rst
>
> A concern is utility functions in dump_page use inconsistent
> loglevels. In the future, we might want to make the loglevels
> used inside dump_page() consistent and eventually rework the way
> we log the information here. See [1].
>

FWIW, the  "format ^$prefix" specifier allows selection of "classes"
of pr_debugs
examples:
"^drm:kms:" etc
"^drm:" too, for example to set +fmlt across entire subsystem
"gvt:"
"^Lo", "^MID", "^HI"
"^1:", "^2:", "^3:"

all hierarchy / set-creation is applied by authors
