Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4342080C8
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 01:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762220416; cv=none; b=aB4ZbcSYD0G/+B2oTgey6QzsAIlAJ3CMtMEbQ8YKZ5Jn+SFbMn8EZ6ILMatekST/jEJsQ/ClaK3m8TYtHp7ksZsuxyeQcGm6CDsZo57mxgRlo9ukPgpyuNKm1IvuTHDgXDP33xSwkegMjwhz1jdil1qbpo3bBJ52aCFVLOgG878=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762220416; c=relaxed/simple;
	bh=NiSk5VFaxHl1mjVIXDwStSOc663Q3Aww953sZrnXsDo=;
	h=Date:To:From:Subject:Message-Id; b=pWtCT+QmHLZVqD9rfiM2pI6dgdusun2lVGzJczVsguX0LxKH4iHatbsYgqSor0o0ekXAvBcOUeIaD+zatdyJxFwZYrcWnXuL0I8rqHw2E8wJ9O5ZkbrNzhkJlymw01IsNsjsio1ecsvV42wRNqN5bx2Ha+pQtGbX2sBAM+YIibU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TVFBZ4fl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TVFBZ4fl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFE3C4CEE7;
	Tue,  4 Nov 2025 01:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762220415;
	bh=NiSk5VFaxHl1mjVIXDwStSOc663Q3Aww953sZrnXsDo=;
	h=Date:To:From:Subject:From;
	b=TVFBZ4flpKKZa1YU/BgNf884APKufSLgZX1SwSHY7qqzcoo+6NhE6vE0zww+4EDx1
	 o5J867YCU+F1BJEcaW4DVzDfeHnf2B1HWN4IKX/QJ3ZjXErzKMYkL+PDvsefb5v2Yh
	 9s08d+NnUo8eelnthY6Cy7jmxVMdGYHYYlYt+gAw=
Date: Mon, 03 Nov 2025 17:40:15 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,maqianga@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_file-fix-the-issue-of-mismatch-between-loop-variable-types.patch added to mm-nonmm-unstable branch
Message-Id: <20251104014015.8CFE3C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec_file: fix the issue of mismatch between loop variable types
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_file-fix-the-issue-of-mismatch-between-loop-variable-types.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_file-fix-the-issue-of-mismatch-between-loop-variable-types.patch

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
From: Qiang Ma <maqianga@uniontech.com>
Subject: kexec_file: fix the issue of mismatch between loop variable types
Date: Mon, 3 Nov 2025 14:34:40 +0800

The type of the struct kimage member variable nr_segments is unsigned
long.  Correct the loop variable i and the print format specifier type.

Link: https://lkml.kernel.org/r/20251103063440.1681657-5-maqianga@uniontech.com
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/kexec_file.c~kexec_file-fix-the-issue-of-mismatch-between-loop-variable-types
+++ a/kernel/kexec_file.c
@@ -366,7 +366,8 @@ SYSCALL_DEFINE5(kexec_file_load, int, ke
 	int image_type = (flags & KEXEC_FILE_ON_CRASH) ?
 			 KEXEC_TYPE_CRASH : KEXEC_TYPE_DEFAULT;
 	struct kimage **dest_image, *image;
-	int ret = 0, i;
+	int ret = 0;
+	unsigned long i;
 
 	/* We only trust the superuser with rebooting the system. */
 	if (!kexec_load_permitted(image_type))
@@ -432,7 +433,7 @@ SYSCALL_DEFINE5(kexec_file_load, int, ke
 		struct kexec_segment *ksegment;
 
 		ksegment = &image->segment[i];
-		kexec_dprintk("segment[%d]: buf=0x%p bufsz=0x%zx mem=0x%lx memsz=0x%zx\n",
+		kexec_dprintk("segment[%lu]: buf=0x%p bufsz=0x%zx mem=0x%lx memsz=0x%zx\n",
 			      i, ksegment->buf, ksegment->bufsz, ksegment->mem,
 			      ksegment->memsz);
 
_

Patches currently in -mm which might be from maqianga@uniontech.com are

kexec-fix-uninitialized-struct-kimage-image-pointer.patch
kexec-add-kexec_core-flag-to-control-debug-printing.patch
kexec-print-out-debugging-message-if-required-for-kexec_load.patch
kexec_file-fix-the-issue-of-mismatch-between-loop-variable-types.patch

