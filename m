Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5146342A95
	for <mm-commits@vger.kernel.org>; Fri, 21 Feb 2025 23:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740181384; cv=none; b=PlNiTmi3WCNdLj3e2ObgECTLZjFlhhkyBxsmn8kl9D+WrBtZnjIyAtz4WM8OSd6jkFWtefN8XtSq/QKE8BQV4GQO30G62xL3LFeBcQf++vAwQ52RwppH3EBSgmjrsVHhpqpw31qYLrBST3JCzZECpLiYYMaZRD03IDGjWWh/6z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740181384; c=relaxed/simple;
	bh=wgqCOj2kO9XZBtYot+Xf8iXsmTYstW0z1uiZNFM3JLs=;
	h=Date:To:From:Subject:Message-Id; b=htXl+6x4Xm013kdtOyD7WGSP/VtEu1qjFbK5BbOC/b1coIsO6DRS3lNDRyIMYdNmY5WassFX4MdEodIRjA51gOPit+gZKP9t42iS3Hfc18lZdLZWewN9cSWFUU64cFQEkzc3EJVRO+9G9zmLsPJu3aJ1EPHuL8Tu4+B7VteRRlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Q5m1rKz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Q5m1rKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CEF6C4CED6;
	Fri, 21 Feb 2025 23:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740181384;
	bh=wgqCOj2kO9XZBtYot+Xf8iXsmTYstW0z1uiZNFM3JLs=;
	h=Date:To:From:Subject:From;
	b=1Q5m1rKzKfHBTWk6jr8C/ovtJnWrEeyHcDz8CxYKdrWqQslr9ccgEDyYd3BonoOfF
	 yK5SlxhB5cvzdpFbt/ijA2ygBeXPokb024VEKoBFMhnxvw1YZwYwGNpT3MMt1xqSMw
	 V4213rzlEd0YVGbhtDYOB5U9U4uqp/qi6oz9bsPM=
Date: Fri, 21 Feb 2025 15:43:03 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-might_sleep-to-zcomp-api.patch added to mm-unstable branch
Message-Id: <20250221234304.1CEF6C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: add might_sleep to zcomp API
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-might_sleep-to-zcomp-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-might_sleep-to-zcomp-api.patch

This patch will later appear in the mm-unstable branch at
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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: add might_sleep to zcomp API
Date: Sat, 22 Feb 2025 07:25:48 +0900

Explicitly state that zcomp compress/decompress must be called from
non-atomic context.

Link: https://lkml.kernel.org/r/20250221222958.2225035-18-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/block/zram/zcomp.c~zram-add-might_sleep-to-zcomp-api
+++ a/drivers/block/zram/zcomp.c
@@ -146,6 +146,7 @@ int zcomp_compress(struct zcomp *comp, s
 	};
 	int ret;
 
+	might_sleep();
 	ret = comp->ops->compress(comp->params, &zstrm->ctx, &req);
 	if (!ret)
 		*dst_len = req.dst_len;
@@ -162,6 +163,7 @@ int zcomp_decompress(struct zcomp *comp,
 		.dst_len = PAGE_SIZE,
 	};
 
+	might_sleep();
 	return comp->ops->decompress(comp->params, &zstrm->ctx, &req);
 }
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-sleepable-entry-locking.patch
zram-permit-preemption-with-active-compression-stream.patch
zram-remove-unused-crypto-include.patch
zram-remove-max_comp_streams-device-attr.patch
zram-remove-second-stage-of-handle-allocation.patch
zram-remove-writestall-zram_stats-member.patch
zram-limit-max-recompress-prio-to-num_active_comps.patch
zram-filter-out-recomp-targets-based-on-priority.patch
zram-rework-recompression-loop.patch
zsmalloc-rename-pool-lock.patch
zsmalloc-make-zspage-lock-preemptible.patch
zsmalloc-introduce-new-object-mapping-api.patch
zram-switch-to-new-zsmalloc-object-mapping-api.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-do-not-leak-page-on-recompress_store-error-path.patch
zram-do-not-leak-page-on-writeback_store-error-path.patch
zram-add-might_sleep-to-zcomp-api.patch
zsmalloc-zram-there-be-preemption.patch

