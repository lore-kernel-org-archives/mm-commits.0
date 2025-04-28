Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47FF296D21
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 19:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745868045; cv=none; b=BF5z4FeBd9qfmpSeRZsZTvuD9R3hgr8jn8TS89jWHwLV5qite/FF4mcp4U3mAZifW7ivceed97czElPa0pZ+Sv5O8rSJYE6JDVYptPf6cM/tUw5VKCgiyfeEGMgliDKgTWH8J20m3I6a26eRHv2mm74HF4iihMEBDKuJ/FDsYkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745868045; c=relaxed/simple;
	bh=32UT+ixWIIPNSmDdYqLDV0Yf3TEU9UjomZcl9hFNiTo=;
	h=Date:To:From:Subject:Message-Id; b=c+GumIqw+ToW2JKO6ohEuUT5exFH7c7P3uD+bDmNWyX8v0H5ldqoChFEXud6hYsO/K+F2P2WPMNVxkjyzY4ubQQ/0tFA1bNsOW2d5X2yU7+1gWAwSrYMmdTBpwl2pOnxoLcKTrv7jEK6hbdBUCpFx4Egyt3MQFSGFuUycyWV1mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tTwBFQk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tTwBFQk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DB7C4CEE4;
	Mon, 28 Apr 2025 19:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745868044;
	bh=32UT+ixWIIPNSmDdYqLDV0Yf3TEU9UjomZcl9hFNiTo=;
	h=Date:To:From:Subject:From;
	b=tTwBFQk7xe+LHLJGSONw8w9QNFU2L8kXcMfZNvunpGvLIV7eN/UP1dVZqpr0nAeUW
	 7c4Ylb54AJWcUMgdvDAZV1ay+zl2M42ENGw0fv90Hd4UmyMKIXrHGzyJForZzdWIP6
	 G89wNY6ONRvPyqvCwyekfA4kGDgZIVFjxJoMRZZ4=
Date: Mon, 28 Apr 2025 12:20:43 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,ebiggers@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_file-use-sha-256-library-api-instead-of-crypto_shash-api.patch added to mm-nonmm-unstable branch
Message-Id: <20250428192044.15DB7C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec_file: use SHA-256 library API instead of crypto_shash API
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_file-use-sha-256-library-api-instead-of-crypto_shash-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_file-use-sha-256-library-api-instead-of-crypto_shash-api.patch

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
From: Eric Biggers <ebiggers@google.com>
Subject: kexec_file: use SHA-256 library API instead of crypto_shash API
Date: Mon, 28 Apr 2025 11:57:20 -0700

This user of SHA-256 does not support any other algorithm, so the
crypto_shash abstraction provides no value.  Just use the SHA-256 library
API instead, which is much simpler and easier to use.

Tested with '/sbin/kexec --kexec-file-syscall'.

Link: https://lkml.kernel.org/r/20250428185721.844686-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Kconfig.kexec |    3 -
 kernel/kexec_file.c  |   78 +++++++----------------------------------
 2 files changed, 16 insertions(+), 65 deletions(-)

--- a/kernel/Kconfig.kexec~kexec_file-use-sha-256-library-api-instead-of-crypto_shash-api
+++ a/kernel/Kconfig.kexec
@@ -38,8 +38,7 @@ config KEXEC
 config KEXEC_FILE
 	bool "Enable kexec file based system call"
 	depends on ARCH_SUPPORTS_KEXEC_FILE
-	select CRYPTO
-	select CRYPTO_SHA256
+	select CRYPTO_LIB_SHA256
 	select KEXEC_CORE
 	help
 	  This is new version of kexec system call. This system call is
--- a/kernel/kexec_file.c~kexec_file-use-sha-256-library-api-instead-of-crypto_shash-api
+++ a/kernel/kexec_file.c
@@ -19,7 +19,6 @@
 #include <linux/list.h>
 #include <linux/fs.h>
 #include <linux/ima.h>
-#include <crypto/hash.h>
 #include <crypto/sha2.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
@@ -725,11 +724,10 @@ int kexec_add_buffer(struct kexec_buf *k
 /* Calculate and store the digest of segments */
 static int kexec_calculate_store_digests(struct kimage *image)
 {
-	struct crypto_shash *tfm;
-	struct shash_desc *desc;
+	struct sha256_state state;
 	int ret = 0, i, j, zero_buf_sz, sha_region_sz;
-	size_t desc_size, nullsz;
-	char *digest;
+	size_t nullsz;
+	u8 digest[SHA256_DIGEST_SIZE];
 	void *zero_buf;
 	struct kexec_sha_region *sha_regions;
 	struct purgatory_info *pi = &image->purgatory_info;
@@ -740,37 +738,12 @@ static int kexec_calculate_store_digests
 	zero_buf = __va(page_to_pfn(ZERO_PAGE(0)) << PAGE_SHIFT);
 	zero_buf_sz = PAGE_SIZE;
 
-	tfm = crypto_alloc_shash("sha256", 0, 0);
-	if (IS_ERR(tfm)) {
-		ret = PTR_ERR(tfm);
-		goto out;
-	}
-
-	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
-	desc = kzalloc(desc_size, GFP_KERNEL);
-	if (!desc) {
-		ret = -ENOMEM;
-		goto out_free_tfm;
-	}
-
 	sha_region_sz = KEXEC_SEGMENT_MAX * sizeof(struct kexec_sha_region);
 	sha_regions = vzalloc(sha_region_sz);
-	if (!sha_regions) {
-		ret = -ENOMEM;
-		goto out_free_desc;
-	}
-
-	desc->tfm   = tfm;
-
-	ret = crypto_shash_init(desc);
-	if (ret < 0)
-		goto out_free_sha_regions;
+	if (!sha_regions)
+		return -ENOMEM;
 
-	digest = kzalloc(SHA256_DIGEST_SIZE, GFP_KERNEL);
-	if (!digest) {
-		ret = -ENOMEM;
-		goto out_free_sha_regions;
-	}
+	sha256_init(&state);
 
 	for (j = i = 0; i < image->nr_segments; i++) {
 		struct kexec_segment *ksegment;
@@ -789,10 +762,7 @@ static int kexec_calculate_store_digests
 		if (ksegment->kbuf == pi->purgatory_buf)
 			continue;
 
-		ret = crypto_shash_update(desc, ksegment->kbuf,
-					  ksegment->bufsz);
-		if (ret)
-			break;
+		sha256_update(&state, ksegment->kbuf, ksegment->bufsz);
 
 		/*
 		 * Assume rest of the buffer is filled with zero and
@@ -804,44 +774,26 @@ static int kexec_calculate_store_digests
 
 			if (bytes > zero_buf_sz)
 				bytes = zero_buf_sz;
-			ret = crypto_shash_update(desc, zero_buf, bytes);
-			if (ret)
-				break;
+			sha256_update(&state, zero_buf, bytes);
 			nullsz -= bytes;
 		}
 
-		if (ret)
-			break;
-
 		sha_regions[j].start = ksegment->mem;
 		sha_regions[j].len = ksegment->memsz;
 		j++;
 	}
 
-	if (!ret) {
-		ret = crypto_shash_final(desc, digest);
-		if (ret)
-			goto out_free_digest;
-		ret = kexec_purgatory_get_set_symbol(image, "purgatory_sha_regions",
-						     sha_regions, sha_region_sz, 0);
-		if (ret)
-			goto out_free_digest;
+	sha256_final(&state, digest);
 
-		ret = kexec_purgatory_get_set_symbol(image, "purgatory_sha256_digest",
-						     digest, SHA256_DIGEST_SIZE, 0);
-		if (ret)
-			goto out_free_digest;
-	}
+	ret = kexec_purgatory_get_set_symbol(image, "purgatory_sha_regions",
+					     sha_regions, sha_region_sz, 0);
+	if (ret)
+		goto out_free_sha_regions;
 
-out_free_digest:
-	kfree(digest);
+	ret = kexec_purgatory_get_set_symbol(image, "purgatory_sha256_digest",
+					     digest, SHA256_DIGEST_SIZE, 0);
 out_free_sha_regions:
 	vfree(sha_regions);
-out_free_desc:
-	kfree(desc);
-out_free_tfm:
-	kfree(tfm);
-out:
 	return ret;
 }
 
_

Patches currently in -mm which might be from ebiggers@google.com are

kexec_file-use-sha-256-library-api-instead-of-crypto_shash-api.patch

