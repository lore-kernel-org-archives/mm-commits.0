Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252A4EEC6
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600535; cv=none; b=JocX/rvT4juQmjAsQQ89Q0ANndTeJ+DqK66xzG4FGvhGUSlVw6FSJy16N0MxKOI3TD0r85dbuGl1PThgbLcvgRykleB4YsOp4AwwHJYIeH99EPTAQg5/iEme0I/3284HXJhceezfAnMKB2CbJfLHqwJoyl342hPkB0S94GwxfpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600535; c=relaxed/simple;
	bh=Xf7y02qTftVzMSGdnEUUCx8+GJTmsOgbIcLYh+7fOEc=;
	h=Date:To:From:Subject:Message-Id; b=pqNYcSqsVL2zASQ0RpEPTkuI8YgcC324vHDBlngDrBr6A3qqzCq+8Z9pxgEjCetEgoIE8ZS5G4pPrmnDZ26s9gUqMAT7DA8/mH+Ef8jUeex2/EAk8LSVO7m3NYmAJkyX4F9kJfvwvfopeRWrVPztoBkDj2OaldUpNfVfiDP2SQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l6j6Eunk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l6j6Eunk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01D5C433A6;
	Tue,  5 Mar 2024 01:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600534;
	bh=Xf7y02qTftVzMSGdnEUUCx8+GJTmsOgbIcLYh+7fOEc=;
	h=Date:To:From:Subject:From;
	b=l6j6EunkWcpC8NfX1/JVIRZ/BjZpb539Mxy2vsr61S7j1P1F/QYBbSkxRhE8Nt5Ta
	 ZcyZPzxMzcG+ANC2QbeEZX9D8bl6K18iGPaLlFNGPN6PiW/IlwnnDDCjF3M91JpxCD
	 IpLYUjyRbF6l840jLTLBOQ4mNzLSVRaf4shcO1zA=
Date: Mon, 04 Mar 2024 17:02:14 -0800
To: mm-commits@vger.kernel.org,glider@google.com,andreyknvl@gmail.com,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-stackdepot-off-by-one-in-depot_fetch_stack.patch removed from -mm tree
Message-Id: <20240305010214.A01D5C433A6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/stackdepot: off by one in depot_fetch_stack()
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-off-by-one-in-depot_fetch_stack.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


