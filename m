Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B9520458A
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 01:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762220414; cv=none; b=ooKJS4So3d+gV0bd9OpODmsdmYRn2SKCgg+zQc8YHwOCGPkCRVLdSNnOv+ge/kxMSWGhbvXkmxpRjXSGPw7FTNHThF/q1OUsJmR6H3BP99X3RQRFFlJCpsWDP0Ql6NcKH0/RoBTd9cnsdrBFzZpPjOTANHzKxG2Gd4kH0x+mh6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762220414; c=relaxed/simple;
	bh=v+TY2/Om37fP3IJ//vNC29+yXrqEc8qzku5hH2j+2SQ=;
	h=Date:To:From:Subject:Message-Id; b=m9HJXkJet+lAtQu9QdnT9N23Rfpdcdz4Wrq7fAS0zOUKmZ5TM3bEUsv8AMXUThfbRETDHVbHlSe2YRGvJFz0KF1CVpR85WLVzclP0jtTBfGQi5gZ/D9Ct9AmmonF7YdHdbSIu4yQCeGIFuFKzPe2Y6IUFxHuswM2cdl8m6tQ210=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sNS4yx0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sNS4yx0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8846BC4CEE7;
	Tue,  4 Nov 2025 01:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762220413;
	bh=v+TY2/Om37fP3IJ//vNC29+yXrqEc8qzku5hH2j+2SQ=;
	h=Date:To:From:Subject:From;
	b=sNS4yx0YVHBvnodqPdpgmh71eiS3WxrX6yoqgB/FDkzzbq2m0kMG9nWDBZpclls7j
	 FYNFlx0laZQA1zfp2drwV+5xQACAeYd22S6LOAT2mYh5AeCcOJloZMfLgrudRymjNV
	 X+o03TCBDslDFJlb+0sZPw+OKh17gjWZN9VwG8ZM=
Date: Mon, 03 Nov 2025 17:40:13 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,lkp@intel.com,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,maqianga@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-print-out-debugging-message-if-required-for-kexec_load.patch added to mm-nonmm-unstable branch
Message-Id: <20251104014013.8846BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: print out debugging message if required for kexec_load
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-print-out-debugging-message-if-required-for-kexec_load.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-print-out-debugging-message-if-required-for-kexec_load.patch

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
Subject: kexec: print out debugging message if required for kexec_load
Date: Mon, 3 Nov 2025 14:34:39 +0800

The commit a85ee18c7900 ("kexec_file: print out debugging message if
required") has added general code printing in kexec_file_load(), but not
in kexec_load().

Especially in the RISC-V architecture, kexec_image_info() has been
removed(commit eb7622d908a0 ("kexec_file, riscv: print out debugging
message if required")).  As a result, when using '-d' for the kexec_load
interface, print nothing in the kernel space.  This might be helpful for
verifying the accuracy of the data passed to the kernel.  Therefore, refer
to this commit a85ee18c7900 ("kexec_file: print out debugging message if
required"), debug print information has been added.

Link: https://lkml.kernel.org/r/20251103063440.1681657-4-maqianga@uniontech.com
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202510310332.6XrLe70K-lkp@intel.com/
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/kernel/kexec.c~kexec-print-out-debugging-message-if-required-for-kexec_load
+++ a/kernel/kexec.c
@@ -154,7 +154,15 @@ static int do_kexec_load(unsigned long e
 	if (ret)
 		goto out;
 
+	kexec_dprintk("nr_segments = %lu\n", nr_segments);
 	for (i = 0; i < nr_segments; i++) {
+		struct kexec_segment *ksegment;
+
+		ksegment = &image->segment[i];
+		kexec_dprintk("segment[%lu]: buf=0x%p bufsz=0x%zx mem=0x%lx memsz=0x%zx\n",
+			      i, ksegment->buf, ksegment->bufsz, ksegment->mem,
+			      ksegment->memsz);
+
 		ret = kimage_load_segment(image, i);
 		if (ret)
 			goto out;
@@ -166,6 +174,9 @@ static int do_kexec_load(unsigned long e
 	if (ret)
 		goto out;
 
+	kexec_dprintk("kexec_load: type:%u, start:0x%lx head:0x%lx flags:0x%lx\n",
+		      image->type, image->start, image->head, flags);
+
 	/* Install the new kernel and uninstall the old */
 	image = xchg(dest_image, image);
 
_

Patches currently in -mm which might be from maqianga@uniontech.com are

kexec-fix-uninitialized-struct-kimage-image-pointer.patch
kexec-add-kexec_core-flag-to-control-debug-printing.patch
kexec-print-out-debugging-message-if-required-for-kexec_load.patch
kexec_file-fix-the-issue-of-mismatch-between-loop-variable-types.patch

