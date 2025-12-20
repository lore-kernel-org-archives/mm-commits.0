Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC0823EA99
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766271269; cv=none; b=coftwB6i4HJ7sbCDOIzpqopt3caomYFEoN+ldaRShDlWJHOuzeXxh99+xlG4GYCbOAqxbCkgBzR2Z+zNvp3o5o7rsXMG2jWtn2pNxsHrS5k72tlHnMRotDlZA5HG7UEdqMA8DllGMmFwZBy4wwwyLJdlKLBw2Z7CPLgQ3PCvl1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766271269; c=relaxed/simple;
	bh=8u/dUYrTCSVIUrZEJ18h7SjrtjYFzdwNnrRp9KJCkR4=;
	h=Date:To:From:Subject:Message-Id; b=TPq9XT/inrsT5dUs2K188hniJUUpO9371jsalwoQfqmHYtmZE3w88Kh65nVP0vo+YrzyH5JmUecSR0Qnz5EVL2/TD+1OUoJDY5wsug+hlhi9Nt6FzrU+QKq5konLv/SL1I4sEqg6opoMugmWNyb3NmbSN3F97IxWVMdfyM3RJAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u1qfv3ef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u1qfv3ef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14299C4CEF5;
	Sat, 20 Dec 2025 22:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766271269;
	bh=8u/dUYrTCSVIUrZEJ18h7SjrtjYFzdwNnrRp9KJCkR4=;
	h=Date:To:From:Subject:From;
	b=u1qfv3efjzdmU+cn2QgF6mDBhKQoWo0cbjDdpy2fAQGboNcrBAMTKcV+Jq3VuarBf
	 /jSTPdqcz3QAk9hlC/gEwyhBmVZuQcRpWWiFQ/003dwpQJdCAc+7JnUU0EsByFdf0c
	 oR1hSIzY8bGouqGVAg7NmNVbpZmBreu64QBD2QnI=
Date: Sat, 20 Dec 2025 14:54:28 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,catalin.marinas@arm.com,bhe@redhat.com,maqianga@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-replace-the-goto-out_unlock-with-out.patch added to mm-nonmm-unstable branch
Message-Id: <20251220225429.14299C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: replace the goto out_unlock with out
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-replace-the-goto-out_unlock-with-out.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-replace-the-goto-out_unlock-with-out.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Qiang Ma <maqianga@uniontech.com>
Subject: kexec: replace the goto out_unlock with out
Date: Fri, 19 Dec 2025 17:31:31 +0800

Patch series "kexec: add kexec flag to control debug printing", v2.

Overview:
=========
The commit cbc2fe9d9cb2 ("kexec_file: add kexec_file flag to control debug
printing") added the kexec_file flag to control debug printing.  However,
for arm64, after commit 6f8c1da071a4 ("kexec_file, arm64: print out
debugging message if required"), when using the kexec_load interface, the
kexec_image_info function is called to print debug message, but it uses
kexec_dprintk, which is only available under kexec_file, then when
specifying 'kexec -d', kexec_load interface will print nothing.

For riscv, commit eb7622d908a09 ("kexec_file, riscv: print out debugging
message if required") remove kexec_image_info(), because the content has
been printed out in generic code in kexec_file_load, but not in
kexec_load.

Therefore, in order to solve the two problems mentioned above, for this
patchset, several things need to be done:

1. Enabling kexec_dprintk is available for kexec_load.
2. Add some debugging message of the deleted kexec_image_info
   to generic code.
3. Remove duplicate debugging prints for arm64.

Since kexec_load and kexec_file_load are not triggered simultaneously, we
can unify the debug flag of kexec and kexec_file as kexec_dbg_print.

In this way, kexec_dprintk is available for kexec_load and
kexec_file_load.

Then when specifying 'kexec -d', the debugging message using kexec_dprintk
in kexec_image_info can be printed normally.

The following are the key points of the specific changes:

1. rename kexec_file_dbg_print to kexec_dbg_print
2. Add KEXEC_DEBUG
3. Initialize kexec_dbg_print for kexec
4. Set the reset of kexec_dbg_print to kimage_free

Testing:
=========
I did testing on x86_64, arm64 and loongarch. On x86_64, the printed
messages look like below:

Unset CONFIG_KEXEC_FILE:
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

On aarch64, the printed messages look like below:

Set CONFIG_KEXEC_FILE
[   39.033203] kexec_file: kernel: 0000000073414684 kernel_size: 0x3123a00
[   39.047010] kexec_file: Loaded initrd at 0x43cf0000 bufsz=0x17e0e19 memsz=0x17e1000
[   39.047054] kexec_file: Loaded dtb at 0x23ec00000 bufsz=0x386 memsz=0x1000
[   39.047056] kexec_file(Image): Loaded kernel at 0x40000000 bufsz=0x3123a00 memsz=0x3cf0000
[   39.047063] kexec_file: nr_segments = 3
[   39.047064] kexec_file: segment[0]: buf=0x0000000073414684 bufsz=0x3123a00 mem=0x40000000 memsz=0x3cf0000
[   39.073612] kexec_file: segment[1]: buf=0x000000005cd5746b bufsz=0x17e0e19 mem=0x43cf0000 memsz=0x17e1000
[   39.085309] kexec_file: segment[2]: buf=0x0000000084c4a0f1 bufsz=0x386 mem=0x23ec00000 memsz=0x1000
[   39.085459] machine_kexec_post_load:155:
[   39.085463]   kexec kimage info:
[   39.085467]     kern_reloc: 0x00000001620e2000
[   39.085468]     el2_vectors: 0x0000000000000000
[   39.085470] kexec_file: kexec_file_load: type:0, start:0x40000000 head:0x1620e4002 flags:0x8

Unset CONFIG_KEXEC_FILE:

With this patch:
[   35.156088] machine_kexec_post_load:155:
[   35.156097]   kexec kimage info:
[   35.156101]     kern_reloc: 0x000000011c134000
[   35.156102]     el2_vectors: 0x0000000000000000
[   35.156104] kexec: kexec_load: type:0, start:0x454d26b0 head:0x105c14002 flags:0xb70010

Without this patch:
There is no kexec print in dmesg.


This patch (of 4):

The image is initialized to NULL.  Then, after calling kimage_alloc_init,
we can directly goto 'out' because at this time, the kimage_free will
determine whether image is a NULL pointer.

This will prepare for the subsequent patch to reset the variable in
kimage_free.

Link: https://lkml.kernel.org/r/20251219093134.2268620-1-maqianga@uniontech.com
Link: https://lkml.kernel.org/r/20251219093134.2268620-2-maqianga@uniontech.com
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/kexec.c~kexec-replace-the-goto-out_unlock-with-out
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

kexec-replace-the-goto-out_unlock-with-out.patch
kexec-add-kexec-flag-to-control-debug-printing.patch
kexec-print-out-debugging-message-if-required-for-kexec_load.patch
arm64-kexec-adjust-the-debug-print-of-kexec_image_info.patch

