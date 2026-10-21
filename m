Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792543679;
	b=s0a270bD7NzjLgsY6b7O3b1I6iW0cLonaxHHcx23cXimqSyqrXY3mV0N0s0hak7wZ4S/
	 b41pqXPcFD6Wj1oLOhCXcyZQS2HuFuiRq6ZTjUSPutFEiPBZl7yL0KM5d6lmdD9PWIdq1
	 P2U6X1k5V5G743mR/bgwhz1Hep7czLUu6E3gS3sIuneSt0OKwiz5yRFhgYyeWxUC9RgUq
	 24Bup8qy8V3A98S8jh6W4u8dzLTCJw5qUR1/QvVYs++Tseyly0P5LO4r8NDDAkOSox0ms
	 waif7Cc1n3MZy5OIsnURQP/rwl6hvuLJUlHJEEqGqNlofMyy4Bhavd/lTnfUau3Ht+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792543679;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=nxDTFurcrqMz3fEcsclIhXohiRZ80WiOyVW6r6/9dcc=;
	b=3JvB101mNcxqgERIrtGXRxewUTlvQX63kw1fYEoh14Ae1dx3WMRvHSDR3lBi6woWkTFp
	 VCExHT9t2c+80UroJbTx3Yp5V7KCMCCFmP760IqapTdxdLHV/8rUnzAWkPaJu/5s4YSjv
	 wd2rnhRrLVGxifR9PPssh7/TpKhUyvUiVayy8Pg5LEHXRxigvxGBHRqBtkaj6OgQilLKO
	 2lO3cnemcfN0JcajLEtDBrAQtUbWwVqGbW5F9aUxAxDY59ej0YDGBSuiAXE5SgcL5ZQwA
	 q+zbZWtZu/kkHqpgxK6lfRVDSE0o+Quyy5zidWCrNvvve+cdqgs2huPg2Qf8d/V0RiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nER3mWvB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12373606A319
	for <mm-commits@vger.kernel.org>; Wed, 21 Oct 2026 00:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nER3mWvB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5201F000C9;
	Wed, 21 Oct 2026 00:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792543678;
	bh=nxDTFurcrqMz3fEcsclIhXohiRZ80WiOyVW6r6/9dcc=;
	h=Date:To:From:Subject;
	b=nER3mWvBRsXWI8ShQdy5lOneUG7KIMkiuiuy/LQFl1puCDAFoJTGcKxmR9JG6xuGV
	 4skRWqoSPOOsVim3fcKvH02I9X4bomTanz1zXkoeeH8jTyW/M/iOVHgWuSRpfXZBMJ
	 yf8OKSI89Hx9KtT9Lxb0u5XQ3rie8pfLVqWF1FJE=
Date: Tue, 20 Oct 2026 17:47:58 -0700
To: mm-commits@vger.kernel.org,thnkslprpt@gmail.com,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + profile-simplify-proc-profile-read-layout.patch added to mm-nonmm-unstable branch
Message-Id: <20261021004758.9C5201F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: profile: simplify /proc/profile read layout
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     profile-simplify-proc-profile-read-layout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/profile-simplify-proc-profile-read-layout.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: profile: simplify /proc/profile read layout
Date: Tue, 20 Oct 2026 23:58:33 +0000

read_profile() is needlessly difficult to understand.  It copies the
four-byte sampling-step header one byte at a time, then manufactures
a pointer before prof_buffer so a file offset can be used as a
counter-array offset.  Its signed byte counter, unsigned long file
offset and repeated size calculations further obscure where each
read starts and how many bytes it transfers.

Treat the file as two consecutive regions: a four-byte header and
the profiling counters.  Use size_t for byte positions and lengths,
copy the bounded header in one operation, and address the counters
relative to the start of prof_buffer.  Brief comments explain each
region.

Keep the word-sized shift and explicit narrowing required by Avi
Weiss's "profiling: fix sampling step on 64-bit big-endian systems".
Assign the header value separately and explain why the 32-bit ABI
requires a narrowing conversion.

Preserve the partial-read and fault semantics established by [1/2],
including short copies within either region.  No userspace-visible
behavior change is intended.
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Weiss <thnkslprpt@gmail.com>
Cc: Bradley Morgan <brads@mainlining.org>
---
Tested the combined three-patch series on x86-64 QEMU/KVM, with
CONFIG_PROFILING=y, CONFIG_PROC_FS=y and profile=12.
profile-read-test.c: PASS (0 failures). Covered header decoding,
short/unaligned and boundary reads, EOF, partial copy faults,
return values and file-position updates.
The 64-bit big-endian case was not tested. No per-patch or
unpatched-versus-patched runtime comparison was reported.

 kernel/profile.c |   57 +++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 22 deletions(-)

--- a/kernel/profile.c~profile-simplify-proc-profile-read-layout
+++ a/kernel/profile.c
@@ -153,35 +153,48 @@ void profile_tick(int type)
 static ssize_t
 read_profile(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
-	unsigned long p = *ppos;
-	ssize_t read;
-	char *pnt;
-	unsigned int sample_step = (unsigned int)(1UL << prof_shift);
-	size_t not_copied;
+	const size_t header_size = sizeof(unsigned int);
+	const size_t file_size = (prof_len + 1) * sizeof(unsigned int);
+	unsigned int sample_step;
+	size_t pos = *ppos;
+	size_t done = 0;
+	size_t n, not_copied;
 
-	if (p >= (prof_len+1)*sizeof(unsigned int))
+	/* Keep the shift word-sized before narrowing to the 32-bit ABI. */
+	sample_step = (unsigned int)(1UL << prof_shift);
+
+	if (pos >= file_size)
 		return 0;
-	if (count > (prof_len+1)*sizeof(unsigned int) - p)
-		count = (prof_len+1)*sizeof(unsigned int) - p;
-	read = 0;
+	count = min(count, file_size - pos);
 
-	while (p < sizeof(unsigned int) && count > 0) {
-		if (put_user(*((char *)(&sample_step)+p), buf))
-			goto out;
-		buf++; p++; count--; read++;
+	/* Copy the four-byte sampling resolution. */
+	if (pos < header_size) {
+		n = min(count, header_size - pos);
+		not_copied = copy_to_user(buf, (u8 *)&sample_step + pos, n);
+		done += n - not_copied;
+		if (not_copied)
+			goto fault;
+		buf += n;
+		pos += n;
+		count -= n;
 	}
+
+	/* Copy raw counters using offsets relative to the counter array. */
 	if (count) {
-		pnt = (char *)prof_buffer + p - sizeof(atomic_t);
-		not_copied = copy_to_user(buf, pnt, count);
-		read += count - not_copied;
+		not_copied = copy_to_user(buf,
+					(u8 *)prof_buffer + pos - header_size,
+					count);
+		done += count - not_copied;
 		if (not_copied)
-			goto out;
+			goto fault;
 	}
-	*ppos += read;
-	return read;
-out:
-	*ppos += read;
-	return read ? read : -EFAULT;
+	*ppos += done;
+	return done;
+fault:
+	*ppos += done;
+	if (!done)
+		return -EFAULT;
+	return done;
 }
 
 /* default is to not implement this call */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-damon-core-introduce-damos_quota_goal-complement-fix.patch
fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan-fix.patch
lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch
fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch

