Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F37C3A9DA1
	for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 22:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773959674; cv=none; b=DOjGimQDTwHtW/QDjZ1CFuDhcV3mhB5hS0xv98VKDycSs7KiISiNKjQfzoTrQxuE4HjHIPhrZRGfhlF4SNIId85idSs7akcrzpEoraU5K7ZV3RU0W3OIhZ+SYqD5AtV6kNtu5Sfg8UQN5pqfndC7CO3yDz2zD+UJzo705mf8+hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773959674; c=relaxed/simple;
	bh=puK43d0eiS+BH/8TnOrMengbNiH09Hfi6X6ewyf/kOo=;
	h=Date:To:From:Subject:Message-Id; b=TWnxBp8O6dDIBj2NCuW8Q8KAMJE6cRR+916gMiP6paAvZCdvpAVhDTjQ3NFuLQE2ASStXM09Q6Bsyi+BDHK58kLNguL7IwP4jve3V26od0lXykrMDx6cI1ZQIK6/hny96vqr63zIEVTC5jeoRTfBPXZSokswOpJE+9sAcblYvrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QT1Ytwdj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QT1Ytwdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08410C19424;
	Thu, 19 Mar 2026 22:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773959674;
	bh=puK43d0eiS+BH/8TnOrMengbNiH09Hfi6X6ewyf/kOo=;
	h=Date:To:From:Subject:From;
	b=QT1YtwdjoBJsTIjy2PgvONjHGxNdonF9Iv/x2AXzIICs5n/jC34iLLiNzdNEaiAZw
	 82t/74gqnUh4um6FXqT3bFQdUZcw0CGw7zKHDhTL0s3Kf4nfeAHpRn/Pd/tfZRCukS
	 06eTlAFcq9DeT0AXM06iMEQKqIFLSx7syBMxmZjo=
Date: Thu, 19 Mar 2026 15:34:33 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-return-ebusy-for-zspage-migration-lock-contention.patch added to mm-new branch
Message-Id: <20260319223434.08410C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zsmalloc: return -EBUSY for zspage migration lock contention
has been added to the -mm mm-new branch.  Its filename is
     zsmalloc-return-ebusy-for-zspage-migration-lock-contention.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-return-ebusy-for-zspage-migration-lock-contention.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: teawater <zhuhui@kylinos.cn>
Subject: zsmalloc: return -EBUSY for zspage migration lock contention
Date: Thu, 19 Mar 2026 14:59:24 +0800

movable_operations::migrate_page() should return an appropriate error code
for temporary migration failures so the migration core can handle them
correctly.

zs_page_migrate() currently returns -EINVAL when zspage_write_trylock()
fails.  That path reflects transient lock contention, not invalid input,
so -EINVAL is clearly wrong.

However, -EAGAIN is also inappropriate here: the zspage's reader-lock
owner may hold the lock for an unbounded duration due to slow
decompression or reader-lock owner preemption.  Since migration retries
are bounded by NR_MAX_MIGRATE_PAGES_RETRY and performed with virtually no
delay between attempts, there is no guarantee the lock will be released in
time for a retry to succeed.  -EAGAIN implies "try again soon", which does
not hold in this case.

Return -EBUSY instead, which more accurately conveys that the resource is
occupied and migration cannot proceed at this time.

Link: https://lkml.kernel.org/r/20260319065924.69337-1-hui.zhu@linux.dev
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: teawater <zhuhui@kylinos.cn>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/zsmalloc.c~zsmalloc-return-ebusy-for-zspage-migration-lock-contention
+++ a/mm/zsmalloc.c
@@ -1727,7 +1727,19 @@ static int zs_page_migrate(struct page *
 	if (!zspage_write_trylock(zspage)) {
 		spin_unlock(&class->lock);
 		write_unlock(&pool->lock);
-		return -EINVAL;
+		/*
+		 * Return -EBUSY but not -EAGAIN: the zspage's reader-lock
+		 * owner may hold the lock for an unbounded duration due to a
+		 * slow decompression or reader-lock owner preemption.
+		 * Since migration retries are bounded by
+		 * NR_MAX_MIGRATE_PAGES_RETRY and performed with virtually no
+		 * delay between attempts, there is no guarantee the lock will
+		 * be released in time for a retry to succeed.
+		 * -EAGAIN implies "try again soon", which does not hold here.
+		 * -EBUSY more accurately conveys "resource is occupied,
+		 * migration cannot proceed".
+		 */
+		return -EBUSY;
 	}
 
 	/* We're committed, tell the world that this is a Zsmalloc page. */
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation.patch
mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v4.patch
mm-swap-strengthen-locking-assertions-and-invariants-in-cluster-allocation-v5.patch
zsmalloc-return-ebusy-for-zspage-migration-lock-contention.patch

