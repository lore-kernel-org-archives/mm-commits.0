Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792828032;
	b=UF31fQHw8EdSb2d0Z1Z+bMABdiTJgNtYI5lVeoBsjCIVbWLiA0hCt+m5iKki8nqcDVGE
	 uLg+odVTdsJaNWEaSv6N7Khl9SO5Y8kXAWYthPpK8/MxZI3ueq1GqQUtJkr2KvqQnPjOD
	 /GxkywYXRZQk0+HmhAGuNvDjEbcRtAPIXlzVbQyUEzR/hW06sS8r+V8VlPd/tB23eMb5T
	 DMijweGhfA6agz+1YEUWVCw/M+YGHnz2zlD/9QMQC4FMpC+vrXnSkdgMs6growz2xUbES
	 O3rGmvPx5bFGLbUew3POrCqTxOZH6NzuXuatHZt8H72gCTDbEwUHAhxXHUXzOyWiexQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792828032;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=UnJTXBMdWR2ykWjXI+/WgOd6Cw95Kb7h8wRZVIjCtlE=;
	b=4LLDyIUvatW12lOvMKruDJUj0n+tY1+d23H5aYtQjMluvREvWKFpyoyce/iHp4dwNPRV
	 Y3rRyolm/FrQMn5HexIbx2VaJgd0etEDFLc2H7rBIMFOOiMZMOl3H2vBLF6QDLZtkWUzZ
	 +SH433u/DWfe1MiIF/fyIe/44rf5dKVvov9yFj3Fr1/5MZzU8Ngc8f9OoSxbqLzbCrhnQ
	 m2Z4jDSdoAkCQno0SYdaWUcOk0gmEkeRosc1rM8CBXc5i23Ar0M1Hzxx7DSyoUUoLI6hT
	 oQm4rK3VOCsFjtt4y00sx6oizBQxHBH9pk8CR1yaC1D3SaIe0P3xenzk8xbjA3iMrfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AikOlzku;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3206606A31E
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 07:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AikOlzku
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A78B1F01825;
	Sat, 24 Oct 2026 07:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792828031;
	bh=UnJTXBMdWR2ykWjXI+/WgOd6Cw95Kb7h8wRZVIjCtlE=;
	h=Date:To:From:Subject;
	b=AikOlzkuw/hynoFZbCljuVmE3ZO7ST1ZY4lddS1mK/76nti7iuR2hZ90xBZd9lwqO
	 N9fGCmBiY0TGbEpkBK1G/A5k2PkQ043NppvU0IX4/eQ6MUBVEH4XnBxS6QMGhz58uh
	 rASgNPyf2Xtu+VHh++ilFczAbmpiZCzgmhf6n/eo=
Date: Sat, 24 Oct 2026 00:47:11 -0700
To: mm-commits@vger.kernel.org,brads@mainlining.org,thnkslprpt@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] profiling-fix-sampling-step-on-64-bit-big-endian-systems.patch removed from -mm tree
Message-Id: <20261024074711.6A78B1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: profiling: fix sampling step on 64-bit big-endian systems
has been removed from the -mm tree.  Its filename was
     profiling-fix-sampling-step-on-64-bit-big-endian-systems.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Avi Weiss <thnkslprpt@gmail.com>
Subject: profiling: fix sampling step on 64-bit big-endian systems
Date: Tue, 20 Oct 2026 13:12:24 +0300

read_profile() stores the sampling step in an unsigned long but copies
only four bytes to userspace.  On 64-bit big-endian systems (not common
obviously), this copies the upper 32 bits and discards the rest, causing
/proc/profile to report zero for normal shift values.

Cast to unsigned int so we get the correct 4 bytes, while keeping the
shift calculation in unsigned long.

A small C reproducer under qemu-s390x reproduced this and proved the fix
works for prof_shift=2.

Link: https://lore.kernel.org/20261020101225.917959-1-thnkslprpt@gmail.com
Fixes: 2d186afd04d6 ("profiling: fix shift-out-of-bounds bugs")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
---

 kernel/profile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/profile.c~profiling-fix-sampling-step-on-64-bit-big-endian-systems
+++ a/kernel/profile.c
@@ -156,7 +156,7 @@ read_profile(struct file *file, char __u
 	unsigned long p = *ppos;
 	ssize_t read;
 	char *pnt;
-	unsigned long sample_step = 1UL << prof_shift;
+	unsigned int sample_step = (unsigned int)(1UL << prof_shift);
 
 	if (p >= (prof_len+1)*sizeof(unsigned int))
 		return 0;
_

Patches currently in -mm which might be from thnkslprpt@gmail.com are


