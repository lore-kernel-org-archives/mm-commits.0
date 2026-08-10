Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F361839AD3B;
	Mon, 10 Aug 2026 22:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786400890; cv=none; b=RGpar9yNEfjbEfY9bykjAYARA6hr3Sq+0/p7y4XhU2aQDoKZ6dkjzQ0QAbLukdFyQMdtMsLgkgb6yXLGaOLYEewevsELvv2/jCFo5P1tupWybDlj0YihzL/oJ8fjcsa1KrztbupOSE4mKk5BbLyzQ5kdvwa6oDYe+wtNAwGNVqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786400890; c=relaxed/simple;
	bh=jz4kdXCOX9Lca5hMecVNLn1qvactiwWo2FjFc45yk7A=;
	h=Date:To:From:Subject:Message-Id; b=enSC+Kta2XDRtAyRuvu/hlbJWmXrCk825hd7N0EJwvLJhMtIMMmZ7vCCEuSlNa5TTCTWM0uky/3mvpVpBjSoTlMyBAdzAmCju8aHmQxgKS/wSG74c4/vlhgcdbfDWIXHGYuhOhJZOSI/WNHiWIH3o9I/N1jEpwRRpQy4wzPMRyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WfGwYwwB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WfGwYwwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBB31F000E9;
	Mon, 10 Aug 2026 22:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786400888;
	bh=kpagiX9DgPtfQIkvA3YX5ltDtveDervQAPfdUG3A6U0=;
	h=Date:To:From:Subject;
	b=WfGwYwwBWzX2AE5HAt4g/xKOhmdpkvIjMmvLuYY9eeOrqPiwsnkc32P8Zz5vH9ZZn
	 ZL24e4de8/IQ1sEHZwJn2Rvt80hqAK/kTSdGYqt9vLreM3OaIYZyTXKBelqSfhrPDR
	 gh+llElDgFscEY4A9mwW0NnzieVDZgvCTolcYwo8=
Date: Mon, 10 Aug 2026 15:28:07 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-account-for-handle-size-in-class-lookup.patch added to mm-new branch
Message-Id: <20260810222808.4FBB31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zsmalloc: account for handle size in class lookup
has been added to the -mm mm-new branch.  Its filename is
     zsmalloc-account-for-handle-size-in-class-lookup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-account-for-handle-size-in-class-lookup.patch

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
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: zsmalloc: account for handle size in class lookup
Date: Sun, 9 Aug 2026 19:55:18 +0800

zs_lookup_class_index() lets zram recompression decide whether a newly
compressed object would use a smaller size class.  It currently classifies
the payload size directly, while zs_malloc() adds ZS_HANDLE_SIZE before
selecting the class.

This makes lookup disagree with allocation near size-class boundaries. 
With 4 KiB pages, CONFIG_ZSMALLOC_CHAIN_SIZE=8, and 64-bit handles, a
1025-to-1024-byte recompression appears to move from class 64 to class 62
although both allocations use class 64.  Conversely, a 1049-to-1025-byte
recompression appears to stay in class 64 although the allocations move
from class 65 to class 64.

As a result, zram can accept replacements with no allocation benefit or
reject ones that would save memory, potentially marking the object
incompressible.

Factor size-class selection into lookup_size_class(), account for the
handle there, and use the helper for both lookup and allocation.

Link: https://lore.kernel.org/20260809115518.3791787-1-xialonglong2025@163.com
Fixes: 7c2af309abd2 ("zram: add size class equals check into recompression")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-account-for-handle-size-in-class-lookup
+++ a/mm/zsmalloc.c
@@ -552,6 +552,11 @@ static int get_size_class_index(int size
 	return min_t(int, ZS_SIZE_CLASSES - 1, idx);
 }
 
+static struct size_class *lookup_size_class(struct zs_pool *pool, size_t size)
+{
+	return pool->size_class[get_size_class_index(size + ZS_HANDLE_SIZE)];
+}
+
 static inline void class_stat_add(struct size_class *class, int type,
 				  unsigned long cnt)
 {
@@ -1117,7 +1122,7 @@ unsigned int zs_lookup_class_index(struc
 {
 	struct size_class *class;
 
-	class = pool->size_class[get_size_class_index(size)];
+	class = lookup_size_class(pool, size);
 
 	return class->index;
 }
@@ -1407,9 +1412,7 @@ unsigned long zs_malloc(struct zs_pool *
 	if (!handle)
 		return (unsigned long)ERR_PTR(-ENOMEM);
 
-	/* extra space in chunk to keep the handle */
-	size += ZS_HANDLE_SIZE;
-	class = pool->size_class[get_size_class_index(size)];
+	class = lookup_size_class(pool, size);
 
 	/* class->lock effectively protects the zpage migration */
 	spin_lock(&class->lock);
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter.patch
zram-fix-out-of-bounds-access-in-writeback_store.patch
zram-fix-out-of-bounds-access-in-read_block_state.patch
zsmalloc-account-for-handle-size-in-class-lookup.patch

