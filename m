Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E445E4D114
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 18:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SjvnawKb"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-5e76948cda7so41998677b3.3
        for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 10:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704910564; x=1705515364; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IDswIqNBA9cNBN9+Xd9yeyxsi2SwNIMvpXkhjISYVDY=;
        b=SjvnawKbr3ldka7cfUQqP5XyW6R3yOoIrVtYsEZe/n9UcvkCCfPFnJ255I/Bvtrt1l
         AgEEmc8NtTtu3d/sougVj9YOpz0XuKZH67C+yd3G/JyIVndecGIJJ+R72p+YtmMgXrtY
         fZy/GbJgYdoSQeeDL7UBmYl7k0R5W3x5h1gDXDM44aYWWh3HAVtjSPpUKhNjTRiEverV
         bqznHl3o05+jXmmJiA+e7YJ6YzhDG3NUgsR+yf9JoWXFZsRVT53e6tiapklZ6UBX55cG
         PQx9M2AXCAw5NqWcRkydExlCjZ8GzJbj0NFv/50oJhAm+DDwA94Qa62WRTKeUonx7KnX
         sGhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704910564; x=1705515364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IDswIqNBA9cNBN9+Xd9yeyxsi2SwNIMvpXkhjISYVDY=;
        b=UuxbL5+uXbRuPjpLno+RuwK7HV6if0rLE4Lg7+nm22cP9f47nXTT2BoPuvhYCjURbm
         pV0O+rQcqVSHC+ISMGqR8TbVaGTusbwDYR339Y5jRDaWiIC0r/sIxf5p8BiafYH/uM2M
         /XQiskAUu+8Hdj/wLUiPGWILwKMilVl1W0GSXyYD+ST17kPDsDt4yaDfBO7l92qLFIH7
         ddx9+gAx2YzJ3t4XmdxqGHSFgv4R1X8eSfdaC/7+0F7vuPfqJq8cnYJPAdsrKLdRlt6X
         jIV8adPSHZW2zA3j2Grwq2PwnQ+byv8ek1jXWKrHJPecsWBj/oqq9NnrJWQhf5XpoX6M
         1qmw==
X-Gm-Message-State: AOJu0YzNfGuhhJHV6cc1vPh0MLpkuzKTTGldkBJEV/joCOlqgoTzm3UJ
	Trgm3m9ejAgWRq0H3+hLlGc=
X-Google-Smtp-Source: AGHT+IFLXS+4Piks54WwUCv7x2raKsdQ6FdLikR932ZQU8XCjN98xg4qSRhV5slRtZyiruhYviBoDQ==
X-Received: by 2002:a81:ad45:0:b0:5f8:d50a:e6c7 with SMTP id l5-20020a81ad45000000b005f8d50ae6c7mr27864ywk.46.1704910562284;
        Wed, 10 Jan 2024 10:16:02 -0800 (PST)
Received: from localhost ([2601:344:8301:57f0:1c7f:c069:2cd3:449a])
        by smtp.gmail.com with ESMTPSA id q131-20020a815c89000000b005e6e0361d87sm1762553ywb.16.2024.01.10.10.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 10:16:01 -0800 (PST)
Date: Wed, 10 Jan 2024 10:15:59 -0800
From: Yury Norov <yury.norov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, tglx@linutronix.de, ming.lei@redhat.com,
	linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com
Subject: Re: + lib-group_cpus-rework-group_cpus_evenly.patch added to
 mm-nonmm-unstable branch
Message-ID: <ZZ7e3xbIKfVa3yqd@yury-ThinkPad>
References: <20240110160755.3E20BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110160755.3E20BC433C7@smtp.kernel.org>

On Wed, Jan 10, 2024 at 08:07:54AM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: lib/group_cpus: rework group_cpus_evenly()
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      lib-group_cpus-rework-group_cpus_evenly.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-group_cpus-rework-group_cpus_evenly.patch
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
> From: Yury Norov <yury.norov@gmail.com>
> Subject: lib/group_cpus: rework group_cpus_evenly()
> Date: Thu, 28 Dec 2023 12:09:35 -0800
> 
> Leverage cleanup machinery and drop most of housekeeping code. 
> Particularly, drop unneeded and erroneously initialized with -ENOMEM
> variable ret.
> 
> Link: https://lkml.kernel.org/r/20231228200936.2475595-9-yury.norov@gmail.com
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Hi Andrew,

Thanks for taking this series.

I received a couple of 0-day reports on initialization section of 
the new group_cpus_evenly(), and wanted to send v5 shortly. Below
is the patch fixing them.

I think it should be fixed at the early stage. So, at your discretion,
can you either meld the fix into this patch, apply it on top of the
series, or I can send v5 with everything fixed.

Thanks,
Yury


From 5349b044f0a9e6a1816b786271c9c632a71edc38 Mon Sep 17 00:00:00 2001
From: Yury Norov <yury.norov@gmail.com>
Date: Wed, 10 Jan 2024 09:46:39 -0800
Subject: [PATCH] lib/group_cpus: fix initialization section in
 group_cpus_evenly()

_free() parameters have to be initialized at declaration to avoid
passing uninitialized pointer to the destructor (unless such a
parameter is initialized before any possibility of return).

nr_present and nr_others are assigned by __group_cpus_evenly(),
which may return negative value in case of error. So make it signed.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312310941.FXBRzn8C-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202401050452.IcgrcQON-lkp@intel.com/
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 lib/group_cpus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/group_cpus.c b/lib/group_cpus.c
index 3a0db0f51f09..c9c95b21e6c6 100644
--- a/lib/group_cpus.c
+++ b/lib/group_cpus.c
@@ -353,8 +353,8 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps)
 {
 	cpumask_var_t *node_to_cpumask __free(free_node_to_cpumask) = alloc_node_to_cpumask();
 	struct cpumask *masks __free(kfree) = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
-	cpumask_var_t npresmsk __free(free_cpumask_var);
-	unsigned int curgrp, nr_present, nr_others;
+	cpumask_var_t npresmsk __free(free_cpumask_var) = NULL;
+	int curgrp, nr_present, nr_others;
 
 	if (!masks || !node_to_cpumask || !alloc_cpumask_var(&npresmsk, GFP_KERNEL))
 		return NULL;
-- 
2.40.1

