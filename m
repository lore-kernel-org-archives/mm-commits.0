Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57561C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 09:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 402E66138E
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 09:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245088AbhI2JmT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Sep 2021 05:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245177AbhI2JmB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Sep 2021 05:42:01 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229CFC061755
        for <mm-commits@vger.kernel.org>; Wed, 29 Sep 2021 02:40:20 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 205-20020a1c01d6000000b0030cd17ffcf8so4688142wmb.3
        for <mm-commits@vger.kernel.org>; Wed, 29 Sep 2021 02:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=AfZs3p/U/8pbk2EdanpaDTOtkOIqOvr2YmG20byTnZI=;
        b=Eb2cEBciYg9UHgXEgtdjlO4Qx4maVqiWRH5Aq0w6TgWPWfK/AJldwRLjJesozHAMhJ
         lnDqkhFpOCYwhWvcLXsygkwWBJRUiB7qwo4IwlRPqClRTdbTvVatpJhwv4NRKYA14nmA
         fbLkt1K9nsSxDOfe1Mdr8qKfa1oTMQxtPnCYNFuYZ/EfDldzUd2Qz/Ecs9EuzAElUtmS
         JgLQN5ZKZVesxuzDqZYkIIU2zs7KQPBC3PDVR/CRq0irX3xpq0rZ283V8zqsqQ2xSZYb
         48M2+kybMVLQtdL4ynz0kk6o1Xnb/Fu0OcAzSrRXHwNgrUru39HuoX+1FK1J2/HHztPC
         tCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=AfZs3p/U/8pbk2EdanpaDTOtkOIqOvr2YmG20byTnZI=;
        b=sGMgiZTcAKu5RoKZyrk1F09SBcCsNsDNNyW9e59zaSCXwCp2e4DCidRsQBTLNIpk5w
         6qn429TSJMoLXC7sU2QUCrvooLokQbyEO7ulDf50SAu7VWa6I7T6n6LWlYr+dlhZbWlI
         I42Is+ktnY9KhGqL5vOyYxaqxAep4cP40W2a3vAEhPdGGiMfWXB2O28JPqwRV9zJqNsV
         OeDicdGJ19GWJPv4iDh+ztBV0CzJrzF4Q+U1nc9H/h6UazCEDk01Zh5a1VZEv7hv73P7
         k6aTJz2VXYZYHzuGlKq8RgObWal6/+LAm7YnALVnAaw2MzAui5fqe2e6OuY9ulMWrn6M
         IwsQ==
X-Gm-Message-State: AOAM533xVLCi9mN4SatQfx9YKAvJF95b4mpGgCrHADUvhK2hHByEI/7a
        ZS7mdviii7/FiTQySq0qy8nKYQ==
X-Google-Smtp-Source: ABdhPJwwcpXvVN3bB+WVCtNEDw2Nd3DdmqP3j+tsVhUWTks4W0fazuqNE3mhXJY3mUJal/+r5L4vcA==
X-Received: by 2002:a05:600c:321a:: with SMTP id r26mr8455296wmp.43.1632908418524;
        Wed, 29 Sep 2021 02:40:18 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:15:13:c9be:b970:304:6a4d])
        by smtp.gmail.com with ESMTPSA id d7sm1692546wrh.13.2021.09.29.02.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 02:40:17 -0700 (PDT)
Date:   Wed, 29 Sep 2021 11:40:12 +0200
From:   Marco Elver <elver@google.com>
To:     akpm@linux-foundation.org
Cc:     dvyukov@google.com, glider@google.com, jannh@google.com,
        mm-commits@vger.kernel.org, nogikh@google.com,
        sfr@canb.auug.org.au, tarasmadan@google.com
Subject: Re: +
 kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix-fix.patch
 added to -mm tree
Message-ID: <YVQ0fE4Yil2EX8FI@elver.google.com>
References: <20210929032540.vi1QD7Ofp%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210929032540.vi1QD7Ofp%akpm@linux-foundation.org>
User-Agent: Mutt/2.0.5 (2021-01-21)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Sep 28, 2021 at 08:25PM -0700, akpm@linux-foundation.org wrote:
[...]
> --- a/mm/kfence/core.c~kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix-fix
> +++ a/mm/kfence/core.c
> @@ -172,7 +172,7 @@ static inline bool should_skip_covered(v
>  	return atomic_long_read(&counters[KFENCE_COUNTER_ALLOCATED]) > thresh;
>  }
>  
> -static u32 get_alloc_stack_hash(unsigned long *stack_entries, size_t num_entries)
> +static u32 get_alloc_stack_hash(unsigned long *stack_entries, unsigned long num_entries)
>  {
>  	num_entries = min(num_entries, UNIQUE_ALLOC_STACK_DEPTH);
>  	num_entries = filter_irq_stacks(stack_entries, num_entries);
> @@ -839,7 +839,7 @@ void kfence_shutdown_cache(struct kmem_c
>  void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
>  {
>  	unsigned long stack_entries[KFENCE_STACK_DEPTH];
> -	size_t num_stack_entries;
> +	unsigned long num_stack_entries;
>  	u32 alloc_stack_hash;

Thanks, Andrew!

Apologies for missing this. UNIQUE_ALLOC_STACK_DEPTH was turned into an
UL after seeing the same warning on 64-bit builds... :-/

The below would be simpler and more consistent, because we use size_t
for num_stack_entries elsewhere, too. Whichever you think is more
appropriate.

Thanks,
-- Marco

------ >8 ------

From: Marco Elver <elver@google.com>
Date: Wed, 29 Sep 2021 11:20:44 +0200
Subject: [PATCH] fixup! kfence: limit currently covered allocations when pool
 nearly full
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fix 32 bit. size_t is UL on 64-bit only; just cast it to size_t

mm/kfence/core.c: In function ‘get_alloc_stack_hash’:
./include/linux/minmax.h:20:28: warning: comparison of distinct pointer types lacks a cast
   20 |  (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
      |                            ^~
./include/linux/minmax.h:26:4: note: in expansion of macro ‘__typecheck’
   26 |   (__typecheck(x, y) && __no_side_effects(x, y))
      |    ^~~~~~~~~~~
./include/linux/minmax.h:36:24: note: in expansion of macro ‘__safe_cmp’
   36 |  __builtin_choose_expr(__safe_cmp(x, y), \
      |                        ^~~~~~~~~~
./include/linux/minmax.h:45:19: note: in expansion of macro ‘__careful_cmp’
   45 | #define min(x, y) __careful_cmp(x, y, <)
      |                   ^~~~~~~~~~~~~
mm/kfence/core.c:177:16: note: in expansion of macro ‘min’
  177 |  num_entries = min(num_entries, UNIQUE_ALLOC_STACK_DEPTH);
      |                ^~~

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Marco Elver <elver@google.com>
---
 mm/kfence/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 1f1fc5be1d4d..802905b1c89b 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -130,7 +130,7 @@ atomic_t kfence_allocation_gate = ATOMIC_INIT(1);
 static atomic_t alloc_covered[ALLOC_COVERED_SIZE];
 
 /* Stack depth used to determine uniqueness of an allocation. */
-#define UNIQUE_ALLOC_STACK_DEPTH 8UL
+#define UNIQUE_ALLOC_STACK_DEPTH ((size_t)8)
 
 /*
  * Randomness for stack hashes, making the same collisions across reboots and
-- 
2.33.0.685.g46640cef36-goog

