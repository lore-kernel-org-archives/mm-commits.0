Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD772264DC
	for <mm-commits@vger.kernel.org>; Fri, 12 Dec 2025 01:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765504415; cv=none; b=kszcDsguTw/qAQsSZHwsip+92FGeC/FnpIYuUBvnLar4qo374pSduekzpq5WFO3b4omg2DpMruGR+HRB0V2z/E387j/qBQeiDzV0iq9pHA/aXWkGk1PqAhbqe9/O48ob82wckua8SR/Fen8XNWFpAxwx6/axtBnGC2ZX5JtqF0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765504415; c=relaxed/simple;
	bh=b0bhqkFC8bQgVInD7WYdB47R8TrJvVhwcGA3sRzwBGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrDLaFEqJLr0alI5QPCpbyn4P2IDc8xI+03UDOd8J+Qd7tFo3c9uiyUAyCfnhL+pPU/KaNM8Vi7eDC4vGG0ppZe5DUAGkMqOKGBScPfmB3NInvsduLEovd1GjEvRcD1G2TTtw8bh3/6+6EBpD5Wj/H2eKh3wTRU7x64/Hu/OdQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k7mlnGJz; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k7mlnGJz"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-786a822e73aso7690377b3.3
        for <mm-commits@vger.kernel.org>; Thu, 11 Dec 2025 17:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765504413; x=1766109213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fYCbe3d+U5qodPL2pi+jegtHTqz+qNWwtE+Getxtl50=;
        b=k7mlnGJzpaJ7lfQnuRH7tgFCrI4ewqSzNxc4SN/NVDdCA/h7OjOI3Jon/HC3wgjToY
         0qyc2ZN0EDZkNm5vmbQM07kABHQFqaKLqKrntEjWVPNeRUP5bHXCmWfAkOGqCdnFjjY3
         wUgHtXMde91Kjl0Z/mQBbSSzP9Om0T6LVI9CcsE+R2YGzNVq1um6Ay3TdWQZkjgwYuFL
         L4lJgJFArMmwVtzStVJTIB2svZoEY8JVYwLRC0LxXsN6s6xV4BGBxXo0EHzDHSC0aeHp
         3cKKxwCvPd2y0XUabyegJcbfM1UUrGSn7hsVLe2/8F3JTttnuukkgnHtMXSsf/ASGwgX
         uH/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765504413; x=1766109213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fYCbe3d+U5qodPL2pi+jegtHTqz+qNWwtE+Getxtl50=;
        b=SWC8IIKia2YtR9lzNpg/N6myzpMqMtWnrG0j1Re25Y/TSlWjY6oVf9sDd9vWj/Lmf2
         b1UnEqgP0YIl7DfocYdK+GTt8E27g9/HN2nd++rhfmjgbSm2DWe24aD0ZCnF3Z4zQ99P
         wp+S4MNSxvkPOrs4zMS4mmRgBioH91S5sGurdFYkOuPyFPj1pbwRYd+S+PyjRyCtOK6Q
         eVSCqLNODsl/RotO+S9QYVabumMtpeqCgeYjDHomHayQHIUeLvnIUVlBbN6gKf6vtgcf
         7BHNBbKYv5Y5oRFNdvHBONT+slrsjzECP2tL6V3aASxBJDxxhYDVzGYuvuTvq7JZ/TMK
         I4/w==
X-Forwarded-Encrypted: i=1; AJvYcCWSPRccvLOwc7TQlvxU+j0CZF8ouvB405xdwXi5KfpMne7ZDDQsVcYuBxIekXD4jKqi8ZakXSnFRwuu@vger.kernel.org
X-Gm-Message-State: AOJu0YxaRRz/m7UAFBLkHNrzorLVBhuou3wx6GeTj5coo1oEssNZCCiT
	fF1P/Ooc0gycqyfLwn39ndrot3tWtA4rIIMjaDop4ImtsnMSJuqxeyHa
X-Gm-Gg: AY/fxX5oL4IacAsnwTQy0JW88aH9OhYOb44Cz6whaPNstileAdAZVyksWhlrAOUnPnZ
	B43jSpgIgiBvaFM7aDn0SeSJr6A9joZBVBW2KR73mzzbrelCAeIohrCsrizUOOzSwT/rYnbvHqr
	MTUVwbU+GoLQx6fWDMf/1FiYDcoj4LTJ6/03jHBYv8uUY3CXwxgIJXAWwKPccHoNGrU+y2fWuHh
	1B+yC8V+Wh4ErcD4o5Yj61KA6ucF3y44Xrq1VZ5tZgDKoHgvwQp5u5g9iuzVVw9zJTmG2IWugZA
	+vyvnUd2EtKlNGmflTTXqxsvosk52zIGv4ywMivbP5QR0lIjAiRXq5OH7h4pfO7CYrGikgEvGSm
	vzQ14s2M4a+zdlJFnWrieyTqbcVX12FqVZYOD9Pzi/shf88RFnvGGs9X38s5ns9lsBwUJHgzurb
	tyKqA7crN1UL9Z74xlA8l7aw==
X-Google-Smtp-Source: AGHT+IH19dNbm7Wo3cpL1BaNz74wDe5f7qHJ69iLhsgLjotUFLmtyxpNXblzx8Aqo8Np5i0jhQoiAA==
X-Received: by 2002:a05:690e:b8a:b0:644:3a61:eb5f with SMTP id 956f58d0204a3-64555666fdfmr274975d50.74.1765504412637;
        Thu, 11 Dec 2025 17:53:32 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:72::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78e69ffb2c0sm136567b3.23.2025.12.11.17.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 17:53:31 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Daniel Palmer <daniel@0x0f.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	mm-commits@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 6.19-rc1
Date: Thu, 11 Dec 2025 17:53:30 -0800
Message-ID: <20251212015330.1874521-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251211225947.822866-1-joshua.hahnjy@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 11 Dec 2025 14:59:46 -0800 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Thu, 11 Dec 2025 20:12:18 +0900 Daniel Palmer <daniel@0x0f.com> wrote:
> 
> > Hi Andrew,
> > 
> > On Thu, 4 Dec 2025 at 14:29, Andrew Morton <akpm@linux-foundation.org> wrote:
> > >       mm/page_alloc: prevent reporting pcp->batch = 0
> > 
> > I think, maybe, the following part of this patch broke nommu.
> > 
> > -       new_batch = max(1, zone_batchsize(zone));
> > +       new_batch = zone_batchsize(zone);
> > 
> > Before this change on nommu zone_batchsize() returns 0 but the max()
> > changes it to 1. Now it'll stay as 0 and anywhere that depends on it
> > not being 0 won't work?
> 
> Hi Daniel,
> 
> Thank you for taking a look at this and finding that this was the source of
> the deadlock. I took a look, it's definitely an issue. The problem is that
> the patch gets rid of the max(1, zone_batchsize()) and handles the MMU case
> by ensuring zone_batchsize never returns a value less than 1, but the
> NOMMU case always returns 0.
> 
> I think your solution below works. I've also come up with a simler workaround
> which doesn't change drain_pages_zone:
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d0f026ec10b6..9d638697cec8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5919,7 +5919,7 @@ static int zone_batchsize(struct zone *zone)
>          * recycled, this leads to the once large chunks of space being
>          * fragmented and becoming unavailable for high-order allocations.
>          */
> -       return 0;
> +       return 1;
>  #endif
>  }
> 
> Would this be enough? Then we don't have to worry about handling zero values
> from the callsites for NOMMU machines as well. But this has the opposite problem
> that I was initially trying to fix, which is that NOMMU machines will now
> report a batchsize of 1 in zone_pcp_init and print it out to dmesg, which
> may be confusing for NOMMU users who expect there to be no batchsize. So
> it totally makes sense for me to drop my original patch completely as well.
> I'm not a NOMMU user so I am hoping to receive some feedback from folks who do
> who can chime in on which approach is better.
> 
> > I'm seeing a deadlock on nommu:
> > 
> > https://lore.kernel.org/lkml/20251211102607.2538595-1-daniel@thingy.jp/
> 
> I would also like to take this opportunity to ask any NOMMU experts out there
> about the apparent disagreement between the comment in zone_batchsize under the
> NOMMU case, which suggests that NOMMU is harmed by batched freeing:
> 
> 	/* The deferral and batching of frees should be suppressed under NOMMU
> 	 * conditions.
> 
> And returns 0 here which makes sense, only to artificially set it to 1 via
> the max() later on and still do batching anyways by
> << CONFIG_PCP_BATCH_SCALE_MAX.
> 
> Thank you Daniel again for helping root cause this. Hopefully this fix works
> to fix the deadlock you mentioned! Have a great day : -)
> Joshua

On further reflection there's actually an even simpler solution, which is to
just keep the max(1, zone_batchsize(zone)).

For zone_pcp_init, calling zone_batchsize() should:
- For MMU: never return 0
- For NOMMU: always return 0

For zone_set_pageset_high_and_batch:
- For MMU: never return 0
- For NOMMU: always return 1

And I think the solution should ideally not introduce more #ifdefs...
So what if we drop my patch (and the fixlet above) and replace it with the
following patch? Happy to send it as a separate patch if there are any
follow-ups : -)

---

zone_batchsize returns the appropriate value that should be used for
pcp->batch. If it finds a zone with less than 4096 pages or PAGE_SIZE >
1M, however, it leads to some incorrect math.

In the above case, we will get an intermediary value of 1, which is then
rounded down to the nearest power of two, and 1 is subtracted from it.
Since 1 is already a power of two, we will get batch = 1-1 = 0:

        batch = rounddown_pow_of_two(batch + batch/2) - 1;

A pcp->batch value of 0 is nonsensical, for MMU systems. If this were
actually set, then functions like drain_zone_pages would become no-ops,
since they would free 0 pages at a time.

Of the two callers of zone_batchsize, the one that is actually used to
set pcp->batch works around this by setting pcp->batch to the maximum
of 1 and zone_batchsize. However, the other caller, zone_pcp_init,
incorrectly prints out the batch size of the zone to be 0.

This is probably rare in a typical zone, but the DMA zone can often have
less than 4096 pages, which means it will print out "LIFO batch:0".

Before: [    0.001216]   DMA zone: 3998 pages, LIFO batch:0
After:  [    0.001210]   DMA zone: 3998 pages, LIFO batch:1

With all of this said, NOMMU differs in two ways. Semantically, it
should report that pcp->batch is 0. At the same time, it can never
really have a pcp->batch size of 0 since it will reach a deadlock in
pcp freeing functions. For this reason, zone_batchsize should still
report 0 for NOMMU, but zone_set_pageset_high_and_batch should still
interpret it as 1, meaning we cannot get rid of max(1, zone_batchsize())
in zone_set_pageset_high_and_batch.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f928d37eeb6a..95172f4610ff 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5888,7 +5888,7 @@ static int zone_batchsize(struct zone *zone)
         * and zone lock contention.
         */
        batch = min(zone_managed_pages(zone) >> 12, SZ_256K / PAGE_SIZE);
-       if (batch < 1)
+       if (batch <= 1)
                batch = 1;

        /*

base-commit: e0669bdbba170f6c1a7bf5763f72df3f58a4945c
