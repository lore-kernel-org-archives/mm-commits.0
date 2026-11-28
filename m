Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795824685;
	b=yGxBhBv/aJZ5cdDQr4QnCJzePzaWYaE90mf2loDqGk2nKNFeWt88HqVOrOlYEbPdvLX6
	 mGz4kCLMWJpSVcpoOV0COmCVtirmkXKRSG606Jtkl7pUJqFNFTBjIozsg5nY0cEzPcnyR
	 H+i9QhwF2utWN5KzcJyMF7T3tYKadg1jpDiAMYd4RiSTPaAd/XI3sXJY9K2xbuBVhhz2K
	 BE6F4JwKuVCIR+1/lUQs4rMGcdeVKsAFZNX5Z7zgnHtRx2xqSzLfwKYNDSeYDCfxdKSY2
	 6704mdpAEuiRlV+DQiOn6Ml+0CWT3YD0wxky2/jCFSZEUH604bIEgC5g29jQlIQ7i2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795824685;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Wx8rKSiyv3SLQnwE5pYDCSmjWlHLodG8vaxumDw+wWI=;
	b=qR+1MgSxlhfMK4Vxg/KKIpJk8nRRbCp+UFv6UXXMvptpld4PWGNCoGHsQCh4AAEeYw2j
	 3d6v8pPxZ+k/TGnX3wn3IsLv5/IwU0z22b1AFxLhlTyp8xocV+NgtGW6dENZXoWV6jgM3
	 ox0yxYInO0GVhlEaWXNntlflR89s/85zyWv9LC8L/6oneVjm3GyIJr2e7SWSa1kQRP7cP
	 ELIEpR9DEwq/+ncK8IiErRN1usayQ7MCRvJPwGMlxW8EPOoJqArHnL0X8TJsDep60C5kZ
	 qvuVn6JccjPlazyr3j//CmUhQiGL1NwnP26QlJKWGwGcrhxVwewp6geeEeGpVboyitA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Xooyti2F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63FE606A31C
	for <mm-commits@vger.kernel.org>; Sat, 28 Nov 2026 00:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Xooyti2F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477FA1F00893;
	Sat, 28 Nov 2026 00:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795824685;
	bh=Wx8rKSiyv3SLQnwE5pYDCSmjWlHLodG8vaxumDw+wWI=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=Xooyti2FokKmGi1j0fM3smTJX/EtCBCNqrxWNhGUzl81bPApmS7Zi8uxu4+052LwY
	 yySuZtJbUXoun33xOiNl93zESeaAG1YzkecLVXKVyPqpOwAuBIKG+mTbjQY+wKJiPy
	 1ldqhKKPOlG6VprFDC3Fv7zdOl34Yy9uuH10eQU4=
Date: Fri, 27 Nov 2026 16:11:24 -0800
To: mm-commits@vger.kernel.org,hughd@google.com,gthelen@google.com,
	david@kernel.org,baolin.wang@linux.alibaba.com,evanfengff@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261127230015.30733-1-evanfengff@gmail.com>
References: <20261127230015.30733-1-evanfengff@gmail.com>
Subject: + tmpfs-reset-the-memory-policy-on-remount-with-mpol=default.patch added to mm-new branch
Message-Id: <20261128001125.477FA1F00893@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: tmpfs: reset the memory policy on remount with mpol=default
has been added to the -mm mm-new branch.  Its filename is
     tmpfs-reset-the-memory-policy-on-remount-with-mpol=default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tmpfs-reset-the-memory-policy-on-remount-with-mpol=default.patch

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
From: Yifan Feng <evanfengff@gmail.com>
Subject: tmpfs: reset the memory policy on remount with mpol=default
Date: Fri, 27 Nov 2026 15:00:15 -0800

mpol_parse_str() returns a NULL policy for "default", and
shmem_reconfigure() takes a NULL ctx->mpol to mean that no mpol option was
given.  So a remount with mpol=default succeeds but keeps the old policy:

  # mount -t tmpfs -o mpol=bind:1 none /mnt
  # mount -o remount,mpol=default /mnt
  # grep /mnt /proc/mounts
  none /mnt tmpfs rw,relatime,mpol=bind:1 0 0

Record that an mpol option was parsed, and replace the policy whenever
one was.

Link: https://patch.msgid.link/20261127230015.30733-1-evanfengff@gmail.com
Fixes: 5f00110f7273 ("tmpfs: fix use-after-free of mempolicy object")
Signed-off-by: Yifan Feng <evanfengff@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Greg Thelen <gthelen@google.com>

 mm/shmem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~tmpfs-reset-the-memory-policy-on-remount-with-mpol=default
+++ a/mm/shmem.c
@@ -134,6 +134,7 @@ struct shmem_options {
 #define SHMEM_SEEN_HUGE 4
 #define SHMEM_SEEN_INUMS 8
 #define SHMEM_SEEN_QUOTA 16
+#define SHMEM_SEEN_MPOL 32
 };
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -4905,6 +4906,7 @@ static int shmem_parse_one(struct fs_con
 			ctx->mpol = NULL;
 			if (mpol_parse_str(param->string, &ctx->mpol))
 				goto bad_value;
+			ctx->seen |= SHMEM_SEEN_MPOL;
 			break;
 		}
 		goto unsupported_parameter;
@@ -5117,7 +5119,7 @@ static int shmem_reconfigure(struct fs_c
 	/*
 	 * Preserve previous mempolicy unless mpol remount option was specified.
 	 */
-	if (ctx->mpol) {
+	if (ctx->seen & SHMEM_SEEN_MPOL) {
 		mpol = sbinfo->mpol;
 		sbinfo->mpol = ctx->mpol;	/* transfers initial ref */
 		ctx->mpol = NULL;
_

Patches currently in -mm which might be from evanfengff@gmail.com are

mm-damon-core-fix-damos_walk-hang-with-zero-watermarks-interval.patch
mm-damon-core-do-not-overwrite-wmarksactivated-in-damos_commit.patch
tools-mm-page_owner_sort-fix-slab-allocator-labelling.patch
tmpfs-reset-the-memory-policy-on-remount-with-mpol=default.patch

