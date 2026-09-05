Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02271E98EF;
	Sat,  5 Sep 2026 23:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788651276; cv=none; b=jKS5bUfsZXms8iBZoAiO1iuZREG7vb44uPMQIcNyJBK1VBJHAuKlv45b9oZqtSnbxiT7kPz5gOSnqor8NJ9cocn7klroOIh1UgnaSH+i/7Fz36Hnrwrvb+ediYQEfTmeZ7959zgWqW6bNKvi0lmIaoC6ggWBO8Gbj5I4zWktoys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788651276; c=relaxed/simple;
	bh=x6KsGoXGAcRC9r1HopZE3TtDAUPZWn9mXTBPwg83POY=;
	h=Date:To:From:Subject:Message-Id; b=smG6DosO60VxbiW/LyhFbp3A/bwMLShor/XQD/I4q0KI5DQjfN5C9TxrZcBKI3+exXvjD0zs+wiYzrrlsjCYWeWh99Jx2a/IwxpGE0c8R436LlPHrFVwxe/cwG52yaLUQhi2GRzc+m1Yn2woNZW1/4Z6hhROkcJADshXsSjQHWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CzEoP77C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CzEoP77C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D661F00A3A;
	Sat,  5 Sep 2026 23:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788651274;
	bh=LnbvGp6RobYtcFbe9PRXNBHYRHIjFbMYhgP9jHVddwQ=;
	h=Date:To:From:Subject;
	b=CzEoP77CfPiZxQgfdm84I4j0BbqzJyyCAqpdcjZgWgL3OfGZrqIfy+Tv1/t6e8r/l
	 KtM22iignzOgi6q6ggFkhfxQympfQXxMr8+JGIM3ueR3aV/AaYGeBjOwo+V9oxBd2q
	 m1IgIKksjJ+SsQA5+9TPIQYlKJhY/IWxnKZRJ3+Q=
Date: Sat, 05 Sep 2026 16:34:33 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-enable-static-key-after-runtime-pool-recovery.patch added to mm-new branch
Message-Id: <20260905233434.62D661F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: enable static key after runtime pool recovery
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-enable-static-key-after-runtime-pool-recovery.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-enable-static-key-after-runtime-pool-recovery.patch

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
Subject: mm/zswap: enable static key after runtime pool recovery
Date: Sat, 5 Sep 2026 20:50:28 +0800

When CONFIG_ZSWAP_DEFAULT_ON is disabled, zswap_setup() can complete
without a pool after a failed initial pool creation.  A later compressor
parameter update can create and publish a pool, but does not enable
zswap_ever_enabled.

If users then enable zswap, zswap_store() intercepts swapout while
zswap_load() still returns -ENOENT without consulting the xarray.  The
swapin path therefore reads a stale backing swap slot because the store
skipped writing it.

Enable the static key after a successful compressor and pool update.  Do
this outside zswap_pools_lock because static key updates may sleep.

Verified with fault injection on a stock kernel (compressor builtin,
CONFIG_ZSWAP_DEFAULT_ON=n):

  1. Boot with zswap.enabled=1; pool creation fails, init completes
     pool-less (static key off).
  2. Echo an available compressor name to zswap.compressor; a pool is
     recovered but the key stays off.
  3. Enable zswap.
  4. madvise(MADV_PAGEOUT) a pattern-verified 512 MiB region, then
     fault it back in and verify.

Step 4 reads back 131072/131072 zeroed pages (zswpin=0, zswpout=131072)
without this patch; all pages intact (zswpin=131072) with it.

Link: https://lore.kernel.org/20260905125101.2970456-1-xialonglong2025@163.com
Fixes: 2d4d2b1cfb85 ("mm: zswap: add zswap_never_enabled()")
Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Longlong Xia <xialonglong@kylinos.cn>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/zswap.c~mm-zswap-enable-static-key-after-runtime-pool-recovery
+++ a/mm/zswap.c
@@ -586,6 +586,9 @@ static int zswap_compressor_param_set(co
 	else
 		ret = -EINVAL;
 
+	if (!ret)
+		static_branch_enable(&zswap_ever_enabled);
+
 	spin_lock_bh(&zswap_pools_lock);
 
 	if (!ret) {
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

mm-hugetlb-do-not-dissolve-gigantic-pages-without-runtime-support.patch
mm-hugetlb-warn-instead-of-silently-bailing-gigantic-pages-without-runtime-support.patch
mm-hugetlb-preserve-source-surplus-accounting-during-demotion.patch
mm-hugetlb-cap-demotion-at-currently-available-free-pages.patch
mm-zswap-enable-static-key-after-runtime-pool-recovery.patch

