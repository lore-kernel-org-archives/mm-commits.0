Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4371A83F7
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011381; cv=none; b=m/UYweIb9uBQmEoA+aqXchn2FrnA0PLnwl26127aQmiJ8TbENKsqrv0DBg4T5WDAA2ld8L3NxEb1VPVjhEFPXDhhYM8ukDM0pJe/zDD7f5guG6vTnYVhon/LVgPRbSg/HqeTpsH2C7cItzWb3Qbl/ne1sf0GuE2dU64+0/9XSvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011381; c=relaxed/simple;
	bh=R3u9Ftp6CxH1LvZpgOtlp4MOO798blwU3txOvLhQiR0=;
	h=Date:To:From:Subject:Message-Id; b=rB/yrCKg+EqpCkNFIbltnUWWjUvA2Vagldp0V7XgdCjkIqSkYlye5uImbpRef3Gk0FQepUGWUeS7bDYsyFyYsT3Ke6IdUR2d8WsMQTFgqUv6bRmhforTJqwHoZ6zCPTeI0lperlul/JxSX4i54XvzwW0N6Nn7AtJsPE0ynVlSkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ke+7u7ix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ke+7u7ix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D35C4CEE4;
	Mon, 12 May 2025 00:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011381;
	bh=R3u9Ftp6CxH1LvZpgOtlp4MOO798blwU3txOvLhQiR0=;
	h=Date:To:From:Subject:From;
	b=ke+7u7ixbvs1o+6Oa5qo7imeX+H9lRKwuWzXoHnKrPBCa8+Rat7RM8p757AcAiH/g
	 zL8NMmqQBgLj4L7Z9vQUxNFpCpoAsbLuyi0P7hx5j2rSi3gObmdK3WcIhQC9pWB06e
	 5QYg7gQWP1Y1Oo7u2+hdMM44N3fygJQ//HZVOW18=
Date: Sun, 11 May 2025 17:56:20 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,ebiggers@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec_file-use-sha-256-library-api-instead-of-crypto_shash-api.patch removed from -mm tree
Message-Id: <20250512005621.33D35C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec_file: use SHA-256 library API instead of crypto_shash API
has been removed from the -mm tree.  Its filename was
     kexec_file-use-sha-256-library-api-instead-of-crypto_shash-api.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -712,11 +711,10 @@ int kexec_add_buffer(struct kexec_buf *k
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
@@ -727,37 +725,12 @@ static int kexec_calculate_store_digests
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
@@ -776,10 +749,7 @@ static int kexec_calculate_store_digests
 		if (ksegment->kbuf == pi->purgatory_buf)
 			continue;
 
-		ret = crypto_shash_update(desc, ksegment->kbuf,
-					  ksegment->bufsz);
-		if (ret)
-			break;
+		sha256_update(&state, ksegment->kbuf, ksegment->bufsz);
 
 		/*
 		 * Assume rest of the buffer is filled with zero and
@@ -791,44 +761,26 @@ static int kexec_calculate_store_digests
 
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


