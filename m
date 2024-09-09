Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201CF18DF76
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925693; cv=none; b=VSquWRMCcbL5DsI37ucutkVGQdaW2w73EbbD4TzX4rQGhsIH/dnhSxxdpRDOb8/t4JvFFhUpZZx6RFI+UIKOWeyXZtq1XQrJPuHhynv08e0of51pM5TepmjIRoiEZnUYyZN8Zw+aeSq9tnwUv4dmrGyTtz3wjGKgkUGkEDhggeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925693; c=relaxed/simple;
	bh=yS5d89hxLk+aKqQVfee49pMCc14hpctBfS4yPzT2HK8=;
	h=Date:To:From:Subject:Message-Id; b=CoaPU3KRcKcQjbiQPBqbNSiHMLXwo9CFM3qGnfrjWXfBSWqn0Rsjp6exk5QtTo7iVs/WjxTSzBGrh0Z6RgD1GTcW0onT4g1zfcyfbVujGt082Hbd9bbj8AuVUZND8iu08sb9miE7yS2DttIFxC6jKuVM5zRQdUBWF6ZakiNH89I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AfxIJCSK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AfxIJCSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0D4C4CECA;
	Mon,  9 Sep 2024 23:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925692;
	bh=yS5d89hxLk+aKqQVfee49pMCc14hpctBfS4yPzT2HK8=;
	h=Date:To:From:Subject:From;
	b=AfxIJCSKz3Qzhteyr2HIG6TnOtGQmr+e9Rznltvp3bcYxHMKlpanTyIR7iWlDvZnj
	 YAyj0W6g39/yJ1zgYfEKKBm/EI9koGjog7FtSxk1oQ1IfbrTJUlfkDenpnEh7iv8W3
	 kxVBCrleuyVuQVH36ngbmvAjeL/EMlRcQqVYLqPY=
Date: Mon, 09 Sep 2024 16:48:12 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-fix-percpu-address-space-issues-in-decompressor_multi_percpuc.patch removed from -mm tree
Message-Id: <20240909234812.8B0D4C4CECA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: fix percpu address space issues in decompressor_multi_percpu.c
has been removed from the -mm tree.  Its filename was
     squashfs-fix-percpu-address-space-issues-in-decompressor_multi_percpuc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: squashfs: fix percpu address space issues in decompressor_multi_percpu.c
Date: Fri, 30 Aug 2024 11:10:50 +0200

When strict percpu address space checks are enabled, then current direct
casts between the percpu address space and the generic address space fail
the compilation on x86_64 with:

decompressor_multi_percpu.c: In function `squashfs_decompressor_create':
decompressor_multi_percpu.c:49:16: error: cast to generic address space pointer from disjoint `__seg_gs' address space pointer

decompressor_multi_percpu.c: In function `squashfs_decompressor_destroy':
decompressor_multi_percpu.c:64:25: error: cast to `__seg_gs' address space pointer from disjoint generic address space pointer

decompressor_multi_percpu.c: In function `squashfs_decompress':
decompressor_multi_percpu.c:82:25: error: cast to `__seg_gs' address space pointer from disjoint generic address space pointer

Add intermediate casts to unsigned long, as advised in [1] and [2].

Side note: sparse still requires __force when casting from the percpu
address space, although the documentation [2] allows casts to unsigned
long without __force attribute.

Found by GCC's named address space checks.

There were no changes in the resulting object file.

[1] https://gcc.gnu.org/onlinedocs/gcc/Named-Address-Spaces.html#x86-Named-Address-Spaces
[2] https://sparse.docs.kernel.org/en/latest/annotations.html#address-space-name

Link: https://lkml.kernel.org/r/20240830091104.13049-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/decompressor_multi_percpu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/squashfs/decompressor_multi_percpu.c~squashfs-fix-percpu-address-space-issues-in-decompressor_multi_percpuc
+++ a/fs/squashfs/decompressor_multi_percpu.c
@@ -46,7 +46,7 @@ static void *squashfs_decompressor_creat
 	}
 
 	kfree(comp_opts);
-	return (__force void *) percpu;
+	return (void *)(__force unsigned long) percpu;
 
 out:
 	for_each_possible_cpu(cpu) {
@@ -61,7 +61,7 @@ out:
 static void squashfs_decompressor_destroy(struct squashfs_sb_info *msblk)
 {
 	struct squashfs_stream __percpu *percpu =
-			(struct squashfs_stream __percpu *) msblk->stream;
+			(void __percpu *)(unsigned long) msblk->stream;
 	struct squashfs_stream *stream;
 	int cpu;
 
@@ -79,7 +79,7 @@ static int squashfs_decompress(struct sq
 {
 	struct squashfs_stream *stream;
 	struct squashfs_stream __percpu *percpu =
-			(struct squashfs_stream __percpu *) msblk->stream;
+			(void __percpu *)(unsigned long) msblk->stream;
 	int res;
 
 	local_lock(&percpu->lock);
_

Patches currently in -mm which might be from ubizjak@gmail.com are


