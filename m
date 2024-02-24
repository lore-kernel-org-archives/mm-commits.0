Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9010D19A
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 00:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708734276; cv=none; b=Hpv1P6xI7GuHRSrn9SrPaDLqEA5xN0Q5T6e9Ud3s9DjC41lv7rdhdIOqW6kINHbi1hnoQW5D2W1jNiiLtU+X2Ych9YbNz2OvI6FB4pSxs8DEkqy8npL3pMbVZ4+2bO/MWMg0xJh8OGxz29GycnsuPJfKzhhh1Kmp3lEAE3p0UVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708734276; c=relaxed/simple;
	bh=8MfxBYaUJf/EbodDvrZ6cxIEJ9GIjOd82gC0x4zq9wE=;
	h=Date:To:From:Subject:Message-Id; b=P00P8IAKKXzyOJ25AcSDSwCtLnpsIDUPnDexpVn+jSBxnyHVf7k39vWk70InXec5g32GL116eYHZSDBc7aroiJeHEo5imzDOy7aw1hvFOS9MZuqJh05mRMKwPYIJ4rdA2bb6tOBWru+npudU0pB3bfvtSVSepnZ4Adv1uZyUSVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KfAbyfFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KfAbyfFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D43C433C7;
	Sat, 24 Feb 2024 00:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708734276;
	bh=8MfxBYaUJf/EbodDvrZ6cxIEJ9GIjOd82gC0x4zq9wE=;
	h=Date:To:From:Subject:From;
	b=KfAbyfFKvKXAiLjHLo6WF5jHxoJGtRmcs6gpqSGqrnLl3zLRzQmIyXeHUUCNFRhl5
	 R0QRYCSfvTZe6yAf7SSK99RirWw9nOWKqQs6XdSyvq1t2sJ+rjyKIkoYK0sl0KJpV7
	 fSGIQdZPaHX81bWH4AjgvBGNmnGGkT6w1E154zHY=
Date: Fri, 23 Feb 2024 16:24:35 -0800
To: mm-commits@vger.kernel.org,glider@google.com,andreyknvl@gmail.com,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-off-by-one-in-depot_fetch_stack.patch added to mm-nonmm-unstable branch
Message-Id: <20240224002435.E7D43C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/stackdepot: off by one in depot_fetch_stack()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-off-by-one-in-depot_fetch_stack.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-off-by-one-in-depot_fetch_stack.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: lib/stackdepot: off by one in depot_fetch_stack()
Date: Fri, 23 Feb 2024 17:20:13 +0300

The stack_pools[] array has DEPOT_MAX_POOLS.  The "pools_num" tracks the
number of pools which are initialized.  See depot_init_pool() for more
details.

If pool_index == pools_num_cached, this will read one element beyond what
we want.  If not all the pools are initialized, then the pool will be
NULL, triggering a WARN(), and if they are all initialized it will read
one element beyond the end of the array.

Link: https://lkml.kernel.org/r/361ac881-60b7-471f-91e5-5bf8fe8042b2@moroto.mountain
Fixes: b29d31885814 ("lib/stackdepot: store free stack records in a freelist")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/stackdepot.c~lib-stackdepot-off-by-one-in-depot_fetch_stack
+++ a/lib/stackdepot.c
@@ -447,7 +447,7 @@ static struct stack_record *depot_fetch_
 
 	lockdep_assert_not_held(&pool_lock);
 
-	if (pool_index > pools_num_cached) {
+	if (pool_index >= pools_num_cached) {
 		WARN(1, "pool index %d out of bounds (%d) for stack id %08x\n",
 		     pool_index, pools_num_cached, handle);
 		return NULL;
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

lib-stackdepot-off-by-one-in-depot_fetch_stack.patch

