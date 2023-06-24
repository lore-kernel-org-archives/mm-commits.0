Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABDDAEB64D7
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjFXAHR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjFXAHQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:07:16 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62AC270A
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:07:14 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-988b204ce5fso134794766b.3
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687565233; x=1690157233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vVg2lP8Bz5CEOtrAvg0YIr0FMbVLxE+qyhXw2AXoPh8=;
        b=qLDaTVN2BtF2Ya31tqhsoP5+pymWY4Ora9urat1y/PctOHyJI6VPSJUqW3c3PyycOl
         cE0sLYDpfvsk8xcbP5lqFrHpeh4lIyK8L/ruBjfL+fCj4ACkoX9GrmYu0lM3rO+uPtCy
         nV+uWPJVNIJfP0qx9X72ijm0DO77u7jTyyYjQ+MWeE/pwBJo+cfbrFj6enQLyGQx13VK
         c05O38EC99RS6jcliInjxQiltrEYvjLw36umwCe4BwEdSn17oEGBOkWkiliXFapuW9zo
         B/qFyf/+cZ4f4Dtnpk6pQVI/8r54axvNrdoqHwO8Wd40iNQo/EH4TE+r+38oH7VJjWVj
         UNlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687565233; x=1690157233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vVg2lP8Bz5CEOtrAvg0YIr0FMbVLxE+qyhXw2AXoPh8=;
        b=Z2utMp6DxOGss2D+ab6HNCdke9WMSZSV/jpjOyGicZbh2hwv0hGTqKVVw0EwafvHdz
         nKUvsYVSZN1MKpRxlunCBoT30/ij8cYvS8S/ESCUjQXkLWtpyt/6sdwYYO4X08TwZhuD
         L2GYF2rQJDOhPsf2clw18Mngqad3P8W5Suza6VrPYg3ILaq0hGixD7+BWBaaWr9G3pSX
         3i2cZjORk2MUCS/YXKxin5yHi3bAv7eQAuNtERhw1sqDBJJfEKY6orFSKJLLEsoKrzEC
         hNl/XnSURoSnBJsnur+yleCtNCpdow5D85s8tbX9B2VK/Bu6cxd05LDvJwEmJaSLZhKL
         3Xgw==
X-Gm-Message-State: AC+VfDyeSanwdUAIQvt/Qr7iut7MzyDuorMV8OZ1NeoIya7q3V4bJfyr
        7RWVPajDuPBqzcjjWoGUA8N+cZbOBBQ1mn/aKrtZNg==
X-Google-Smtp-Source: ACHHUZ4mEMSmZh8o2TUQkDzEaxKoEQnVGUUB/JGvx8D1s3R+T2mx8BjCjhvIdcLw+3YkGzgUIsY7LVqUkNYxSXHqaeY=
X-Received: by 2002:a17:906:d965:b0:98d:9d91:a063 with SMTP id
 rp5-20020a170906d96500b0098d9d91a063mr1706666ejb.9.1687565233138; Fri, 23 Jun
 2023 17:07:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230624000034.0E54FC433C9@smtp.kernel.org>
In-Reply-To: <20230624000034.0E54FC433C9@smtp.kernel.org>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Fri, 23 Jun 2023 17:06:36 -0700
Message-ID: <CAJD7tkaVpGuVSQhRcf0VXJx6VGhgVwqOqwhY8pAVDEJGTk5y-Q@mail.gmail.com>
Subject: Re: [merged mm-stable] mm-vmscan-fix-root-proactive-reclaim-unthrottling-unbalanced-node.patch
 removed from -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, yuzhao@google.com,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jun 23, 2023 at 5:00=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The quilt patch titled
>      Subject: mm/vmscan: fix root proactive reclaim unthrottling unbalanc=
ed node
> has been removed from the -mm tree.  Its filename was
>      mm-vmscan-fix-root-proactive-reclaim-unthrottling-unbalanced-node.pa=
tch
>
> This patch was dropped because it was merged into the mm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

I was really hoping someone would take a look at this, ideally
Johannes because he reported the problem initially.

>
> ------------------------------------------------------
> From: Yosry Ahmed <yosryahmed@google.com>
> Subject: mm/vmscan: fix root proactive reclaim unthrottling unbalanced no=
de
> Date: Wed, 21 Jun 2023 02:31:01 +0000
>
> When memory.reclaim was introduced, it became the first case where
> cgroup_reclaim() is true for the root cgroup.  Johannes concluded [1] tha=
t
> for most cases this is okay, except for one case.  Historically, kswapd
> would throttle reclaim on a node if a lot of pages marked for reclaim are
> under writeback (aka the node is congested).  This occurred by setting
> LRUVEC_CONGESTED bit in lruvec->flags.  The bit would be cleared when the
> node is balanced.
>
> Similarly, cgroup reclaim would set the same bit when an lruvec is
> congested, and clear it on the way out of reclaim (to throttle local
> reclaimers).
>
> Before the introduction of memory.reclaim, the root memcg was the only
> target of kswapd reclaim, and non-root memcgs were the only targets of
> cgroup reclaim, so they would never interfere.  Using the same bit for
> both was fine.  After memory.reclaim, it is possible for cgroup reclaim o=
n
> the root cgroup to clear the bit set by kswapd.  This would result in
> reclaim on the node to be unthrottled before the node is balanced.
>
> Fix this by introducing separate bits for cgroup-level and node-level
> congestion.  kswapd can unthrottle an lruvec that is marked as congested
> by cgroup reclaim (as the entire node should no longer be congested), but
> not vice versa (to prevent premature unthrottling before the entire node
> is balanced).
>
> [1]https://lore.kernel.org/lkml/20230405200150.GA35884@cmpxchg.org/
>
> Link: https://lkml.kernel.org/r/20230621023101.432780-1-yosryahmed@google=
.com
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
> Closes: https://lore.kernel.org/lkml/20230405200150.GA35884@cmpxchg.org/
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Cc: Yu Zhao <yuzhao@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/linux/mmzone.h |   18 +++++++++++++++---
>  mm/vmscan.c            |   19 ++++++++++++-------
>  2 files changed, 27 insertions(+), 10 deletions(-)
>
> --- a/include/linux/mmzone.h~mm-vmscan-fix-root-proactive-reclaim-unthrot=
tling-unbalanced-node
> +++ a/include/linux/mmzone.h
> @@ -293,9 +293,21 @@ static inline bool is_active_lru(enum lr
>  #define ANON_AND_FILE 2
>
>  enum lruvec_flags {
> -       LRUVEC_CONGESTED,               /* lruvec has many dirty pages
> -                                        * backed by a congested BDI
> -                                        */
> +       /*
> +        * An lruvec has many dirty pages backed by a congested BDI:
> +        * 1. LRUVEC_CGROUP_CONGESTED is set by cgroup-level reclaim.
> +        *    It can be cleared by cgroup reclaim or kswapd.
> +        * 2. LRUVEC_NODE_CONGESTED is set by kswapd node-level reclaim.
> +        *    It can only be cleared by kswapd.
> +        *
> +        * Essentially, kswapd can unthrottle an lruvec throttled by cgro=
up
> +        * reclaim, but not vice versa. This only applies to the root cgr=
oup.
> +        * The goal is to prevent cgroup reclaim on the root cgroup (e.g.
> +        * memory.reclaim) to unthrottle an unbalanced node (that was thr=
ottled
> +        * by kswapd).
> +        */
> +       LRUVEC_CGROUP_CONGESTED,
> +       LRUVEC_NODE_CONGESTED,
>  };
>
>  #endif /* !__GENERATING_BOUNDS_H */
> --- a/mm/vmscan.c~mm-vmscan-fix-root-proactive-reclaim-unthrottling-unbal=
anced-node
> +++ a/mm/vmscan.c
> @@ -6578,10 +6578,13 @@ again:
>          * Legacy memcg will stall in page writeback so avoid forcibly
>          * stalling in reclaim_throttle().
>          */
> -       if ((current_is_kswapd() ||
> -            (cgroup_reclaim(sc) && writeback_throttling_sane(sc))) &&
> -           sc->nr.dirty && sc->nr.dirty =3D=3D sc->nr.congested)
> -               set_bit(LRUVEC_CONGESTED, &target_lruvec->flags);
> +       if (sc->nr.dirty && sc->nr.dirty =3D=3D sc->nr.congested) {
> +               if (cgroup_reclaim(sc) && writeback_throttling_sane(sc))
> +                       set_bit(LRUVEC_CGROUP_CONGESTED, &target_lruvec->=
flags);
> +
> +               if (current_is_kswapd())
> +                       set_bit(LRUVEC_NODE_CONGESTED, &target_lruvec->fl=
ags);
> +       }
>
>         /*
>          * Stall direct reclaim for IO completions if the lruvec is
> @@ -6591,7 +6594,8 @@ again:
>          */
>         if (!current_is_kswapd() && current_may_throttle() &&
>             !sc->hibernation_mode &&
> -           test_bit(LRUVEC_CONGESTED, &target_lruvec->flags))
> +           (test_bit(LRUVEC_CGROUP_CONGESTED, &target_lruvec->flags) ||
> +            test_bit(LRUVEC_NODE_CONGESTED, &target_lruvec->flags)))
>                 reclaim_throttle(pgdat, VMSCAN_THROTTLE_CONGESTED);
>
>         if (should_continue_reclaim(pgdat, nr_node_reclaimed, sc))
> @@ -6848,7 +6852,7 @@ retry:
>
>                         lruvec =3D mem_cgroup_lruvec(sc->target_mem_cgrou=
p,
>                                                    zone->zone_pgdat);
> -                       clear_bit(LRUVEC_CONGESTED, &lruvec->flags);
> +                       clear_bit(LRUVEC_CGROUP_CONGESTED, &lruvec->flags=
);
>                 }
>         }
>
> @@ -7237,7 +7241,8 @@ static void clear_pgdat_congested(pg_dat
>  {
>         struct lruvec *lruvec =3D mem_cgroup_lruvec(NULL, pgdat);
>
> -       clear_bit(LRUVEC_CONGESTED, &lruvec->flags);
> +       clear_bit(LRUVEC_NODE_CONGESTED, &lruvec->flags);
> +       clear_bit(LRUVEC_CGROUP_CONGESTED, &lruvec->flags);
>         clear_bit(PGDAT_DIRTY, &pgdat->flags);
>         clear_bit(PGDAT_WRITEBACK, &pgdat->flags);
>  }
> _
>
> Patches currently in -mm which might be from yosryahmed@google.com are
>
>
