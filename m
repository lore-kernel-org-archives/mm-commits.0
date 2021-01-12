Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB97C433E6
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 21:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1BBD208B3
	for <mm-commits@archiver.kernel.org>; Tue, 12 Jan 2021 21:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731546AbhALVvG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Jan 2021 16:51:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbhALVvF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 Jan 2021 16:51:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7415B2078E;
        Tue, 12 Jan 2021 21:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610488225;
        bh=RuQm3XtnZXv3Z0x+r8o0VpLOgkw/jIG772EFCf8H178=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2LhdIXY65Y7ov5Min1zRxxJLH0ZkNyWVzaarhZ/qr4J2nsX+E2y7sZQGXrHQ2MSQI
         J4zgu8QNhEryeEexeHcY0mcdlTsD47WUGaFjfX/mSHDZVeSgRIebzmg75X6nBecM30
         X68D0a95yH7+oN43SUvS8qsYam8FfJtnbypxYQ5c=
Date:   Tue, 12 Jan 2021 13:50:10 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     broonie@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: mmotm 2021-01-12-01-57 uploaded (NR_SWAPCACHE in mm/)
Message-Id: <20210112135010.267508efa85fe98f670ed9e9@linux-foundation.org>
In-Reply-To: <ac517aa0-2396-321c-3396-13aafba46116@infradead.org>
References: <20210112095806.I2Z6as5al%akpm@linux-foundation.org>
        <ac517aa0-2396-321c-3396-13aafba46116@infradead.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 12 Jan 2021 12:38:18 -0800 Randy Dunlap <rdunlap@infradead.org> wrote:

> On 1/12/21 1:58 AM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2021-01-12-01-57 has been uploaded to
> > 
> >    https://www.ozlabs.org/~akpm/mmotm/
> > 
> > mmotm-readme.txt says
> > 
> > README for mm-of-the-moment:
> > 
> > https://www.ozlabs.org/~akpm/mmotm/
> > 
> > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > more than once a week.
> > 
> 
> on i386 and x86_64:
> 
> when CONFIG_SWAP is not set/enabled:
> 
> ../mm/migrate.c: In function ‘migrate_page_move_mapping’:
> ../mm/migrate.c:504:35: error: ‘NR_SWAPCACHE’ undeclared (first use in this function); did you mean ‘QC_SPACE’?
>     __mod_lruvec_state(old_lruvec, NR_SWAPCACHE, -nr);
>                                    ^~~~~~~~~~~~
> 
> ../mm/memcontrol.c:1529:20: error: ‘NR_SWAPCACHE’ undeclared here (not in a function); did you mean ‘SGP_CACHE’?
>   { "swapcached",   NR_SWAPCACHE   },
>                     ^~~~~~~~~~~~

Thanks.  I did the below.

But we're still emitting "Node %d SwapCached: 0 kB" in sysfs when
CONFIG_SWAP=n, which is probably wrong.  Shakeel, can you please have a
think?


--- a/mm/memcontrol.c~mm-memcg-add-swapcache-stat-for-memcg-v2-fix
+++ a/mm/memcontrol.c
@@ -1521,7 +1521,9 @@ static const struct memory_stat memory_s
 	{ "file_mapped",		NR_FILE_MAPPED			},
 	{ "file_dirty",			NR_FILE_DIRTY			},
 	{ "file_writeback",		NR_WRITEBACK			},
+#ifdef CONFIG_SWAP
 	{ "swapcached",			NR_SWAPCACHE			},
+#endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	{ "anon_thp",			NR_ANON_THPS			},
 	{ "file_thp",			NR_FILE_THPS			},
--- a/mm/migrate.c~mm-memcg-add-swapcache-stat-for-memcg-v2-fix
+++ a/mm/migrate.c
@@ -500,10 +500,12 @@ int migrate_page_move_mapping(struct add
 			__mod_lruvec_state(old_lruvec, NR_SHMEM, -nr);
 			__mod_lruvec_state(new_lruvec, NR_SHMEM, nr);
 		}
+#ifdef CONFIG_SWAP
 		if (PageSwapCache(page)) {
 			__mod_lruvec_state(old_lruvec, NR_SWAPCACHE, -nr);
 			__mod_lruvec_state(new_lruvec, NR_SWAPCACHE, nr);
 		}
+#endif
 		if (dirty && mapping_can_writeback(mapping)) {
 			__mod_lruvec_state(old_lruvec, NR_FILE_DIRTY, -nr);
 			__mod_zone_page_state(oldzone, NR_ZONE_WRITE_PENDING, -nr);
_

