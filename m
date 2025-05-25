Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C59FC1D;
	Sun, 25 May 2025 07:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748159666; cv=none; b=Z7GTqvqo+pBHJ6OFFzl0Cexr20iUXUWkoaCXx89+j29d7VuJTY4o9Ifr/7SbahK4KRnoBMdH8trRY8PFVZ/e2GaWwrnGuUQjkJK7+LVj8EgZ6odUe48EYtM0eU5VxdoHHgM6d57EqQF+MZuSBxNm3XrH+9pBWVsVSW3gRwYpffs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748159666; c=relaxed/simple;
	bh=AmJIs25MeWz2xHMYCvcc+c8kgbflbn02b0xan91zq44=;
	h=Date:To:From:Subject:Message-Id; b=IH9oh8NZbINvWrYtauq6fzt+tx7JcC4X3W60EoIrwHfV+FQlEiMc1t8s4aaF+gxcpPdX9zwf1QRoiOOs5oLYtr0dp1xO1aUf/hszn9FUmoOKVln1ha3Bvj5tXeB39+/PSfgP1i4wwV5v9KW2T3wtyh8sLEI8jnPc82/+JP5FgAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eCcU6ukQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eCcU6ukQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996C2C4CEEF;
	Sun, 25 May 2025 07:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748159665;
	bh=AmJIs25MeWz2xHMYCvcc+c8kgbflbn02b0xan91zq44=;
	h=Date:To:From:Subject:From;
	b=eCcU6ukQTdu566zsg7hjrd8NATtz2FkGzKVMYt4zB2BSZyTjAp9arJnMXe10pmER5
	 b0xjTL85W98JnscU5guu8tS2wdsI10Da2O81pInZFU9L8zr3FA1zD9+q5aitd8njji
	 ml/vQq/Wv2XSe7liHqiyPxLaZz15xd+grUSYOc6Y=
Date: Sun, 25 May 2025 00:54:25 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,stable@vger.kernel.org,shung-hsi.yu@suse.com,pawan.kumar.gupta@linux.intel.com,erhard_f@mailbox.org,eddyz87@gmail.com,dakr@kernel.org,kees@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmalloc-only-zero-init-on-vrealloc-shrink.patch removed from -mm tree
Message-Id: <20250525075425.996C2C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: only zero-init on vrealloc shrink
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-only-zero-init-on-vrealloc-shrink.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kees Cook <kees@kernel.org>
Subject: mm: vmalloc: only zero-init on vrealloc shrink
Date: Thu, 15 May 2025 14:42:16 -0700

The common case is to grow reallocations, and since init_on_alloc will
have already zeroed the whole allocation, we only need to zero when
shrinking the allocation.

Link: https://lkml.kernel.org/r/20250515214217.619685-2-kees@kernel.org
Fixes: a0309faf1cb0 ("mm: vmalloc: support more granular vrealloc() sizing")
Signed-off-by: Kees Cook <kees@kernel.org>
Tested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: "Erhard F." <erhard_f@mailbox.org>
Cc: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-only-zero-init-on-vrealloc-shrink
+++ a/mm/vmalloc.c
@@ -4093,8 +4093,8 @@ void *vrealloc_noprof(const void *p, siz
 	 * would be a good heuristic for when to shrink the vm_area?
 	 */
 	if (size <= old_size) {
-		/* Zero out "freed" memory. */
-		if (want_init_on_free())
+		/* Zero out "freed" memory, potentially for future realloc. */
+		if (want_init_on_free() || want_init_on_alloc(flags))
 			memset((void *)p + size, 0, old_size - size);
 		vm->requested_size = size;
 		kasan_poison_vmalloc(p + size, old_size - size);
@@ -4107,9 +4107,11 @@ void *vrealloc_noprof(const void *p, siz
 	if (size <= alloced_size) {
 		kasan_unpoison_vmalloc(p + old_size, size - old_size,
 				       KASAN_VMALLOC_PROT_NORMAL);
-		/* Zero out "alloced" memory. */
-		if (want_init_on_alloc(flags))
-			memset((void *)p + old_size, 0, size - old_size);
+		/*
+		 * No need to zero memory here, as unused memory will have
+		 * already been zeroed at initial allocation time or during
+		 * realloc shrink time.
+		 */
 		vm->requested_size = size;
 		return (void *)p;
 	}
_

Patches currently in -mm which might be from kees@kernel.org are


