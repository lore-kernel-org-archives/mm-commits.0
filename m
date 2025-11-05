Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A65A1C84BD
	for <mm-commits@vger.kernel.org>; Wed,  5 Nov 2025 04:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762315634; cv=none; b=IxjsnYJ6r1YqA3qWHG9j63cWfHZJ4frt1mVztFbXlsJOvFnI/90y8TkTYqAhMA2rBrOuiAE5m5b1SGcVipC74B5pHiBstsN+3QFCjUfvZUDWlFqJ+47kfYxpWRAvszMbnOY4gL7JI3xqF8b+BXZydfUSdCw8eXDy1SfIE+toI90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762315634; c=relaxed/simple;
	bh=LVlSuYJq1iACkLDmwZ7Y5y77eUtuapiWHT2YKK2F/LE=;
	h=Date:To:From:Subject:Message-Id; b=VzndifRG655FqtUYA0r2YFbgJFXQNidsgTgUc3/GzRT2/k69NRQnc0hG10fXpJgagBXVhUKD3OeQlNtd6By5gs0ghptro8wZDybUVRe6grAahkswEWNy0TR4HO/5xDZ8BQOwEd7JNLcEkfyBU/gGoENvGY3aHQfA06QiaAmBzYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ULrB0R7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ULrB0R7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACA4C4CEFB;
	Wed,  5 Nov 2025 04:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762315632;
	bh=LVlSuYJq1iACkLDmwZ7Y5y77eUtuapiWHT2YKK2F/LE=;
	h=Date:To:From:Subject:From;
	b=ULrB0R7ONF9TtCzZPnAWKMskatq1u/4+0FTyR+BAAFMDFng0x93o6/mClUWsJJ/Zd
	 /2NlNVbm+0y/TUc3LIj+ac4PEbYBeQnsWDS/G9W2Uxcjg3r23Gp32JWD+yrAaCTIxU
	 ZoInsy1djfTT3AvmoX0GzXMCGqL2yE9KkSr7Ya8k=
Date: Tue, 04 Nov 2025 20:07:12 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,maqianga@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kexec-fix-uninitialized-struct-kimage-image-pointer.patch removed from -mm tree
Message-Id: <20251105040712.BACA4C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: fix uninitialized struct kimage *image pointer
has been removed from the -mm tree.  Its filename was
     kexec-fix-uninitialized-struct-kimage-image-pointer.patch

This patch was dropped because an updated version will be issued

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

kexec-add-kexec_core-flag-to-control-debug-printing.patch
kexec-print-out-debugging-message-if-required-for-kexec_load.patch
kexec_file-fix-the-issue-of-mismatch-between-loop-variable-types.patch

