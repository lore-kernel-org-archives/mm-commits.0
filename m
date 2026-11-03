Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793668562;
	b=tzcooQAFsdXjRJX2E0skSIS35D27J+WkQ/1H9D91yHqodRQiABexeDPHmIQSwKueB7yd
	 DRS6EtD5nB38Pnru4zOdXkolXJlxA6653ijwa+O/BmL9wNVCRyOLPgaRRre0Rc6QUqk3Z
	 I6FMe5XxAfaE57JZTMRu2AtBHliz30EJm2RfpwM7FOT1YQOIho/2fPbqndIXNQXjO/H8g
	 Sj+GLqI5syU9bPeLRHu0oWtFXFOQbl5ObpIDVTOKC59eUFp6yuCgwCcmBnOdoISqQIZaK
	 EyE19UERi7UyMJ7522Et9HouQGMaXDqWNBvYw6fTtb9iZnlxag/E5VWgLK30ohIlPhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793668562;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=9M+LwfSrewVTsZBz3ZsnghLLf8HXeOf0LIj4JTS98Mo=;
	b=E8PFPLoQ9ISuy/fRyypdTGCAYm1HAZRQuQ/8VJ2GZZnczium03s0q3ueuaVhHGMQBF12
	 F9wYjPUuKWsCOuuh2NraQyxsikElzfOC5T44pXP1J9ezaQoYhewNGpiQyO3ZCKXopMYLg
	 8leNU70J08zVtXfMJ3TWVVNjMSOGLB8Afsa/h7ZM8MLS2lIfK5WWPWy2jZjCZ6pgNMMDy
	 +LWNX0lP7dm60BoHmsNY2gpS/+HeRnXBuhUDZxY7UjgiROQRprcOOW2H6etcSyS8LXLW4
	 ceXLXdKvUyv10KVKgCwsS/zn/R97pDWWUmaCTeJVxNuYK+0keCPY4yHmd3Zi20W5Ieg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fNEjgaC+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CA2606A324
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 01:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fNEjgaC+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993361F000C1;
	Tue,  3 Nov 2026 01:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793668561;
	bh=9M+LwfSrewVTsZBz3ZsnghLLf8HXeOf0LIj4JTS98Mo=;
	h=Date:To:From:Subject;
	b=fNEjgaC+iwUY1OaCs7qtE1wnm2Sc9tP2Mjb5gyM9iZDF7+pMXzACJkT2M0mhVarem
	 31CQTO1tOLkQhdqVnI+RtoC9nHikAItf4qUHqEDR8894Ivju5+ve/U6J/meWH8nsQb
	 obbAtBZpNQ7jCe2jgEQSQbM6Q3xjar4leVzPV7HA=
Date: Mon, 02 Nov 2026 17:16:01 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,
	odys.yuan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-clear-page-cache-marks-once-when-removing-a-folio.patch added to mm-new branch
Message-Id: <20261103011601.993361F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/filemap: clear page cache marks once when removing a folio
has been added to the -mm mm-new branch.  Its filename is
     mm-filemap-clear-page-cache-marks-once-when-removing-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-clear-page-cache-marks-once-when-removing-a-folio.patch

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
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: mm/filemap: clear page cache marks once when removing a folio
Date: Mon, 02 Nov 2026 19:43:37 -0500

xas_store() clears the marks of an entry before it replaces the entry with
NULL.

page_cache_delete() calls xas_init_marks() after xas_store() whether it
stored a shadow entry or NULL, so a folio removed without a shadow, as
POSIX_FADV_DONTNEED and drop_caches do, has its marks cleared twice.  With
4K folios that is about 6% of the time it takes to drop clean page cache.

Call xas_init_marks() only after storing a shadow entry, whose marks
xas_store() leaves alone.  Dropping 8 GiB of 4K folios, median of five
runs, averaged over two boots of each kernel, in a 32 vCPU VM:

                          before    after
  POSIX_FADV_DONTNEED    1517 ms  1423 ms
  drop_caches            1515 ms  1422 ms

Link: https://lore.kernel.org/20261102-bug-mm-filemap-init-marks-once-v2-1-985753b11173@gmail.com
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
---

 mm/filemap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-clear-page-cache-marks-once-when-removing-a-folio
+++ a/mm/filemap.c
@@ -140,7 +140,9 @@ static void page_cache_delete(struct add
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
 	xas_store(&xas, shadow);
-	xas_init_marks(&xas);
+	/* If xas_store() didn't clear marks, do it now */
+	if (shadow)
+		xas_init_marks(&xas);
 
 	folio->mapping = NULL;
 	/* Leave folio->index set: truncation lookup relies upon it */
_

Patches currently in -mm which might be from odys.yuan@gmail.com are

selftests-mm-track-the-modules-run_vmtestssh-loads.patch
selftests-mm-load-xfs-before-checking-for-it-in-run_vmtestssh.patch
word-at-a-time-check-the-first-byte-in-load_unaligned_zeropad.patch
kasan-test-cover-load_unaligned_zeropad.patch
mm-shmem-remove-truncated-folios-from-the-page-cache-in-batches.patch
mm-filemap-clear-page-cache-marks-once-when-removing-a-folio.patch

