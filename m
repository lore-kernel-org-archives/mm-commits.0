Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4211BE84B
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725057580; cv=none; b=LN/tKdxQJeo1OhLAxhwwKX2ot5Ubx2Wx/0QnQRlLn+ohvJJCRYCbGUVucN0dM/L1oA4ZBuWpICZeMsf7hZxYVhwqLqPVU6ZDTY41Z7fqfdFCN2l0ETQm5RYm6higKeqEz4KezdJjAC6bv+uwQ4KAsIUCcqb1sMwBlrpkDUe9z9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725057580; c=relaxed/simple;
	bh=jPynuPs2DCZfFb/RuFVr0i1E1U9HQ92aouvJCxQ5YQA=;
	h=Date:To:From:Subject:Message-Id; b=Bm3vSk1507Ysghuq95hU1fCXq419PesvLy+KU4St5hUoESP7I8nIu/ahv14sptLajH6rNAjoUWFgKzLdfnO97cw0WS3EWO71CjI/H3Qr+m5qrv/8lTZZyGYFFSnQyjHpjKeGrXsQzSwAsnSlV3Kl6HR4dOFKXdjyJmjEuqgTzUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uVrwlhgv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uVrwlhgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BECC4CEC2;
	Fri, 30 Aug 2024 22:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725057579;
	bh=jPynuPs2DCZfFb/RuFVr0i1E1U9HQ92aouvJCxQ5YQA=;
	h=Date:To:From:Subject:From;
	b=uVrwlhgvWMqZCju87SLxjaLicAreouu0Rz/JZeSZrvXd/lQxIxJlp2IyAJ6uN08gW
	 KbzxDAEDUifaC89IaSxkIKoMO7g+jIldA717M5C+Nx/NJSUQrGT0ZRsZFR0EIWRWjO
	 n8JY53RmrboMIMGTg93o4l3Lrw/yl+foS31dC454=
Date: Fri, 30 Aug 2024 15:39:39 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-percpu-address-space-issues-in-decompressor_multi_percpuc.patch added to mm-nonmm-unstable branch
Message-Id: <20240830223939.C6BECC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: fix percpu address space issues in decompressor_multi_percpu.c
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-fix-percpu-address-space-issues-in-decompressor_multi_percpuc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-percpu-address-space-issues-in-decompressor_multi_percpuc.patch

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

mm-z3fold-add-__percpu-annotation-to-unbuddied-pointer-in-struct-z3fold_pool.patch
errh-add-err_ptr_pcpu-ptr_err_pcpu-and-is_err_pcpu-macros.patch
mm-kmemleak-use-is_err_pcpu-for-pointer-in-the-percpu-address-space.patch
kexec-use-atomic_try_cmpxchg_acquire-in-kexec_trylock.patch
lib-percpu_counter-add-missing-__percpu-qualifier-to-a-cast.patch
squashfs-fix-percpu-address-space-issues-in-decompressor_multi_percpuc.patch

