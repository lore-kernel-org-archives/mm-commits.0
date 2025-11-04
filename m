Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646F620ADF8
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 01:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762220408; cv=none; b=D7gmG+BSQ9ijpPMxaYXbj+2CC3tvn0e256yS5iD41AXuAwOSfQGvtmIGJgbEdmpO5Rxq0RagpWRC51CKvcY2m1iM4j/h/dEQku7n9ULNoxzajPMarJ9DMK78vHh3elUDa68BdGqxHaTS0zMsPkmB9UlmMzbjGi9tziyMwidokgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762220408; c=relaxed/simple;
	bh=782UnayoxHfeT8QEQNTsK3oU8itC4sukJIQLLfhnC18=;
	h=Date:To:From:Subject:Message-Id; b=sQmiVFsTsKH4JUpCP9vifcC4GuhStKnEwBV+iykm9C0PgobaZ5WXpmAtzXMgrxEiYnyosbzYg1hrhCEoRy/HyUcNhBsyMDVD9PlxuJFa29Hz7HJXAOMjGjEA6444jBI2tAsvJ43w4J1LxT/WD8/d/b/NRfVoXqAi5pXaG38UdHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=al7edB25; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="al7edB25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA050C4CEE7;
	Tue,  4 Nov 2025 01:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762220407;
	bh=782UnayoxHfeT8QEQNTsK3oU8itC4sukJIQLLfhnC18=;
	h=Date:To:From:Subject:From;
	b=al7edB25n67kTsv4AuPewpHVAKxEfuVVyKh7K+HgvKUu42UGfwJ4UZ05keUr+6OJ1
	 2AwHlD4PAQzChj68L8FgMdGiSXjpnH2G91Wj/uPr/Ot32TqYKvNdhwQHVgl6ONWo0c
	 DfI329d64IYw8ErM2DtT1ya6CdUU8m0vly7gkQCk=
Date: Mon, 03 Nov 2025 17:40:07 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,maqianga@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-fix-uninitialized-struct-kimage-image-pointer.patch added to mm-nonmm-unstable branch
Message-Id: <20251104014007.DA050C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: fix uninitialized struct kimage *image pointer
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-fix-uninitialized-struct-kimage-image-pointer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-fix-uninitialized-struct-kimage-image-pointer.patch

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
Subject: kexec: fix uninitialized struct kimage *image pointer
Date: Mon, 3 Nov 2025 14:34:37 +0800

Patch series "kexec: print out debugging message if required for
kexec_load", v2.

The commit a85ee18c7900 ("kexec_file: print out debugging message if
required") has added general code printing in kexec_file_load(), but not
in kexec_load().

Since kexec_load and kexec_file_load are not triggered simultaneously, we
can unify the debug flag of kexec and kexec_file as kexec_core_dbg_print.

Next, we need to do some things in this patchset:

1. rename kexec_file_dbg_print to kexec_core_dbg_print
2. Add KEXEC_DEBUG
3. Initialize kexec_core_dbg_print for kexec
4. Fix uninitialized struct kimage *image pointer 
5. Set the reset of kexec_file_dbg_print to kimage_free

Testing:
=========
I did testing on x86_64, arm64 and loongarch. On x86_64, the printed messages
look like below:

unset CONFIG_KEXEC_FILE:
[   81.476959] kexec: nr_segments = 7
[   81.477565] kexec: segment[0]: buf=0x00000000c22469d2 bufsz=0x70 mem=0x100000 memsz=0x1000
[   81.478797] kexec: segment[1]: buf=0x00000000dedbb3b1 bufsz=0x140 mem=0x101000 memsz=0x1000
[   81.480075] kexec: segment[2]: buf=0x00000000d7657a33 bufsz=0x30 mem=0x102000 memsz=0x1000
[   81.481288] kexec: segment[3]: buf=0x00000000c7eb60a6 bufsz=0x16f40a8 mem=0x23bd0b000 memsz=0x16f5000
[   81.489018] kexec: segment[4]: buf=0x00000000d1ca53c8 bufsz=0xd73400 mem=0x23d400000 memsz=0x2ab7000
[   81.499697] kexec: segment[5]: buf=0x00000000697bac5a bufsz=0x50dc mem=0x23fff1000 memsz=0x6000
[   81.501084] kexec: segment[6]: buf=0x000000001f743a68 bufsz=0x70e0 mem=0x23fff7000 memsz=0x9000
[   81.502374] kexec: kexec_load: type:0, start:0x23fff7700 head:0x10a4b9002 flags:0x3e0010

set CONFIG_KEXEC_FILE
[   36.774228] kexec_file: kernel: 0000000066c386c8 kernel_size: 0xd78400
[   36.821814] kexec-bzImage64: Loaded purgatory at 0x23fffb000
[   36.821826] kexec-bzImage64: Loaded boot_param, command line and misc at 0x23fff9000 bufsz=0x12d0 memsz=0x2000
[   36.821829] kexec-bzImage64: Loaded 64bit kernel at 0x23d400000 bufsz=0xd73400 memsz=0x2ab7000
[   36.821918] kexec-bzImage64: Loaded initrd at 0x23bd0b000 bufsz=0x16f40a8 memsz=0x16f40a8
[   36.821920] kexec-bzImage64: Final command line is: root=/dev/mapper/test-root crashkernel=auto rd.lvm.lv=test/root
[   36.821925] kexec-bzImage64: E820 memmap:
[   36.821926] kexec-bzImage64: 0000000000000000-000000000009ffff (1)
[   36.821928] kexec-bzImage64: 0000000000100000-0000000000811fff (1)
[   36.821930] kexec-bzImage64: 0000000000812000-0000000000812fff (2)
[   36.821931] kexec-bzImage64: 0000000000813000-00000000bee38fff (1)
[   36.821933] kexec-bzImage64: 00000000bee39000-00000000beec2fff (2)
[   36.821934] kexec-bzImage64: 00000000beec3000-00000000bf8ecfff (1)
[   36.821935] kexec-bzImage64: 00000000bf8ed000-00000000bfb6cfff (2)
[   36.821936] kexec-bzImage64: 00000000bfb6d000-00000000bfb7efff (3)
[   36.821937] kexec-bzImage64: 00000000bfb7f000-00000000bfbfefff (4)
[   36.821938] kexec-bzImage64: 00000000bfbff000-00000000bff7bfff (1)
[   36.821939] kexec-bzImage64: 00000000bff7c000-00000000bfffffff (2)
[   36.821940] kexec-bzImage64: 00000000feffc000-00000000feffffff (2)
[   36.821941] kexec-bzImage64: 00000000ffc00000-00000000ffffffff (2)
[   36.821942] kexec-bzImage64: 0000000100000000-000000023fffffff (1)
[   36.872348] kexec_file: nr_segments = 4
[   36.872356] kexec_file: segment[0]: buf=0x000000005314ece7 bufsz=0x4000 mem=0x23fffb000 memsz=0x5000
[   36.872370] kexec_file: segment[1]: buf=0x000000006e59b143 bufsz=0x12d0 mem=0x23fff9000 memsz=0x2000
[   36.872374] kexec_file: segment[2]: buf=0x00000000eb7b1fc3 bufsz=0xd73400 mem=0x23d400000 memsz=0x2ab7000
[   36.882172] kexec_file: segment[3]: buf=0x000000006af76441 bufsz=0x16f40a8 mem=0x23bd0b000 memsz=0x16f5000
[   36.889113] kexec_file: kexec_file_load: type:0, start:0x23fffb150 head:0x101a2e002 flags:0x8


This patch (of 4):

The image is initialized to NULL.  Then, after calling kimage_alloc_init,
we can directly goto 'out' because at this time, the kimage_free will
determine whether image is a NULL pointer.

This can also prepare for the subsequent patch's kexec_core_dbg_print to
be reset to zero in kimage_free.

Link: https://lkml.kernel.org/r/20251103063440.1681657-1-maqianga@uniontech.com
Link: https://lkml.kernel.org/r/20251103063440.1681657-2-maqianga@uniontech.com
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/kexec.c~kexec-fix-uninitialized-struct-kimage-image-pointer
+++ a/kernel/kexec.c
@@ -95,6 +95,8 @@ static int do_kexec_load(unsigned long e
 	unsigned long i;
 	int ret;
 
+	image = NULL;
+
 	/*
 	 * Because we write directly to the reserved memory region when loading
 	 * crash kernels we need a serialization here to prevent multiple crash
@@ -129,7 +131,7 @@ static int do_kexec_load(unsigned long e
 
 	ret = kimage_alloc_init(&image, entry, nr_segments, segments, flags);
 	if (ret)
-		goto out_unlock;
+		goto out;
 
 	if (flags & KEXEC_PRESERVE_CONTEXT)
 		image->preserve_context = 1;
_

Patches currently in -mm which might be from maqianga@uniontech.com are

kexec-fix-uninitialized-struct-kimage-image-pointer.patch
kexec-add-kexec_core-flag-to-control-debug-printing.patch
kexec-print-out-debugging-message-if-required-for-kexec_load.patch
kexec_file-fix-the-issue-of-mismatch-between-loop-variable-types.patch

