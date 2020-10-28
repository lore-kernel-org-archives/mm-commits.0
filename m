Return-Path: <SRS0=6wtZ=ED=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3D6C4363A
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 23:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6CAF207BC
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 23:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603927585;
	bh=3KPUgzIkkF0W2XRKkBY1XXDs2/GUZmif85ZAlleYYxI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Reply-To:List-ID:
	 From;
	b=TrqmLYuJc5OA+Rwr2wiRt1ItOB+poPgxR1oZoVMXYOK9SjFlR6hMkncq3Sc596VYI
	 3qSHypO9dR36kfi3x7lOGabY9mgRngowU/Jp4jLJqxs4bYjYqxwIfWGIVO3w6UCQUT
	 LwdwQzPhw6DFZRXKMZ5/VziO7jIox4R8mh+xj6HE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390420AbgJ1X0Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Oct 2020 19:26:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389588AbgJ1XYz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Oct 2020 19:24:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8354520796;
        Wed, 28 Oct 2020 23:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603927494;
        bh=3KPUgzIkkF0W2XRKkBY1XXDs2/GUZmif85ZAlleYYxI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LXAZb1ANPXyGeaXMGJw5t+bRpesvXgcbXqmwgeMS0exG5msOuTAL45HkoMjlYXpNz
         wAh6aI7zDEpVALdBqWs2lHvEZFySGXOUzgGS4ZkNMKZPxvSZ0bp2qfxuWPw1oAHrPZ
         DNk+kqRps+Wb2izmK3xpWqer6MoeTQYPseKkOEVY=
Date:   Wed, 28 Oct 2020 16:24:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Michal Hocko <mhocko@suse.com>
Cc:     linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        mm-commits@vger.kernel.org, zhongjiang-ali@linux.alibaba.com
Subject: Re: +
 mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix.patch
 added to -mm tree
Message-Id: <20201028162453.530ab33e20b3722a367b8b9a@linux-foundation.org>
In-Reply-To: <20201027072157.GO20500@dhcp22.suse.cz>
References: <20201026210801.n9JtTzchy%akpm@linux-foundation.org>
        <20201027072157.GO20500@dhcp22.suse.cz>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 27 Oct 2020 08:21:57 +0100 Michal Hocko <mhocko@suse.com> wrote:

> > --- a/mm/memcontrol.c~mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix
> > +++ a/mm/memcontrol.c
> > @@ -4107,7 +4107,7 @@ static int memcg_stat_show(struct seq_fi
> >  		if (memcg1_stats[i] == NR_ANON_THPS)
> >  			nr *= HPAGE_PMD_NR;
> >  #endif
> > -		seq_printf(m, "total_%s %llu\n", memcg1_stat_names[i],
> > +		seq_printf(m, "total_%s %lu\n", memcg1_stat_names[i],
> >  						nr * PAGE_SIZE);
> 
> Shouldn't we cast to u64 instead? 32b systems with a lot of memory are
> quite rare but going over 4G here is not something unimaginable. The
> similar is true for other counters.

Sure..

--- a/mm/memcontrol.c~mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix-fix
+++ a/mm/memcontrol.c
@@ -4119,8 +4119,8 @@ static int memcg_stat_show(struct seq_fi
 		if (memcg1_stats[i] == NR_ANON_THPS)
 			nr *= HPAGE_PMD_NR;
 #endif
-		seq_printf(m, "total_%s %lu\n", memcg1_stat_names[i],
-						nr * PAGE_SIZE);
+		seq_printf(m, "total_%s %llu\n", memcg1_stat_names[i],
+						(u64)nr * PAGE_SIZE);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
_

