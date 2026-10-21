Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792543672;
	b=5DcKNZdxeXzrNWHSblUq9vVJhGQPTYKf7gpFFY1FQxcVMPDCPJA7aRqGTXBsMa/WR6pG
	 gndSgGckWXR9nWafC0TPcVQaAw0baLcqXcmAx/4466B4SPla7dpGbPsFrgJ989JwuzQhV
	 snI/PtiIR1fZucanEUXt3KWtfrSO/H6Q7Nq3p3xiHWVQcO7+4QgsaIu6xPUGOuy9t0L39
	 Yxu7P1idWtlrJ2V4VO7XfIDBsbdw7HTMy3MpHUqdqkfQ+CfJT8RA/WX5TU1nhQ1zEnIXK
	 VGa11hMF0bihvf3XSKVfg1KBAj7DNGr/qqs/Px+UCI5YHjkLW/9Zw6spHMTFokMq83w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792543672;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=WxMxk/IFK9PglqRqLUficTjdySaru2yQqpEK2OveuZg=;
	b=G9bMc/CArGF+SM8ufV/RLu2WuMBArakOH9WZRPeauYF+43Kinfd1rxN10eHeiV5dRts3
	 ZEpitLed5BxrZmwMKIrM852aDmOsg5qrlRDCsrWX/IRvIfh3NeZFZKJT1RxI9XmjMAGRw
	 x4mF7/d6vim2k4A2sI8TieK3Slq/huWwIL++FFyHYbT3EQd+ae8AqIJo1QP8E9dmqW0Zn
	 mlGEwLJm/24iw1g4z/VhFFt4WqN3hglkNlbkFIRyWYdNZS+vm7i0LgoOOrGUS1x47a9B9
	 ea+zxp9m4ApN8k55PLPueerqgzYLYzMtv2/hq+qEOHFds5V0r7iYlyBTHTQKk64IY+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2TRxaxY3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD547606A319
	for <mm-commits@vger.kernel.org>; Wed, 21 Oct 2026 00:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2TRxaxY3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BE51F000C9;
	Wed, 21 Oct 2026 00:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792543671;
	bh=WxMxk/IFK9PglqRqLUficTjdySaru2yQqpEK2OveuZg=;
	h=Date:To:From:Subject;
	b=2TRxaxY33MPb3s61mzzngHC2sQ4MIxssrn+I9PaBcSN/kcXmrJtCjyBAcee4cvMKA
	 KV2yWbZdrlvbSKsIfiHlr3WKUruRPldAZY2rKNEG7Is2J0eeKLEIGpfaSrQNpimnzb
	 QExxwNcn2r5us335pucBoZ+jACS1O0W/unReaYHg=
Date: Tue, 20 Oct 2026 17:47:50 -0700
To: mm-commits@vger.kernel.org,thnkslprpt@gmail.com,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + profile-account-for-partial-proc-profile-reads.patch added to mm-nonmm-unstable branch
Message-Id: <20261021004751.29BE51F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: profile: account for partial /proc/profile reads
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     profile-account-for-partial-proc-profile-reads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/profile-account-for-partial-proc-profile-reads.patch

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
Subject: profile: account for partial /proc/profile reads
Date: Tue, 20 Oct 2026 15:28:00 -0700

read_profile() returns -EFAULT without advancing the file position
when a user copy faults, even if earlier header bytes or a prefix of
the counters were successfully copied.  A retry can therefore copy
the same bytes again despite the previous read having delivered data.

Return the number of successfully copied bytes and advance *ppos by
that amount.  Return -EFAULT only if the fault occurs before any bytes
are copied.  Preserve the four-byte sampling-step header, raw counter
representation, and normal successful-read behavior.

Avi Weiss's "profiling: fix sampling step on 64-bit big-endian
systems" is unchanged.  This patch changes only short-read and
fault reporting, not the output format.
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Weiss <thnkslprpt@gmail.com>
Cc: Bradley Morgan <brads@mainlining.org>
---
Tested the combined three-patch series on x86-64 QEMU/KVM with
CONFIG_PROFILING=y, CONFIG_PROC_FS=y and profile=12.
profile-read-test.c: PASS (0 failures). Covered header decoding,
short and boundary reads, EOF, partial user-copy faults, return
values and file-position accounting.
The 64-bit big-endian fix was not runtime tested. There was no
individual-patch or unpatched-versus-patched runtime comparison.

 kernel/profile.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/kernel/profile.c~profile-account-for-partial-proc-profile-reads
+++ a/kernel/profile.c
@@ -157,6 +157,7 @@ read_profile(struct file *file, char __u
 	ssize_t read;
 	char *pnt;
 	unsigned int sample_step = (unsigned int)(1UL << prof_shift);
+	size_t not_copied;
 
 	if (p >= (prof_len+1)*sizeof(unsigned int))
 		return 0;
@@ -166,15 +167,21 @@ read_profile(struct file *file, char __u
 
 	while (p < sizeof(unsigned int) && count > 0) {
 		if (put_user(*((char *)(&sample_step)+p), buf))
-			return -EFAULT;
+			goto out;
 		buf++; p++; count--; read++;
 	}
-	pnt = (char *)prof_buffer + p - sizeof(atomic_t);
-	if (copy_to_user(buf, (void *)pnt, count))
-		return -EFAULT;
-	read += count;
+	if (count) {
+		pnt = (char *)prof_buffer + p - sizeof(atomic_t);
+		not_copied = copy_to_user(buf, pnt, count);
+		read += count - not_copied;
+		if (not_copied)
+			goto out;
+	}
 	*ppos += read;
 	return read;
+out:
+	*ppos += read;
+	return read ? read : -EFAULT;
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

