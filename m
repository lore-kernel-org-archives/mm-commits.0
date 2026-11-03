Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675990;
	b=vy0AjKRDCTnUnRQaoIGilwzBUIuiYadE63Nd+2PvyimUZ5VPAyYymL9eT2Tisx7vVNb4
	 0N5hhSVCiTxhHI3J/sp3eQQFNZ0FYOOWnTTqBO9bAPa4BDU4ieAZyYXH01A6SaRKUGFPJ
	 1/oIISJH3ub7TOydVdt1wguyRu0ycsUnS5T/HPvkc0r+twyrrmbAbW7laixoirkvrKQnw
	 8/PWRX04TDS+RJtsL3qu+fJZP+89/KErm1rrdgSlI6LYDQTKH7LW+G6fvUIZlAeRxNmrK
	 B8wnxEdKkiGgx50s1/epsRpPv/3c/jGzNxMw/DpNAyxtgDzKPqiDgu/lALihhrO+KwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675990;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=B9Ech+fsg+hlX8YEu83qJWfUQXYamGpxjlYwLlrPOIQ=;
	b=P3v9XJFybENHj4ZOlKURMSE3X5ZL9dZjLk/ytuYMyG5NptVVmYkYIhrfWJ2kQffOSre9
	 gBbu/SaKfg8pmMW+m2lHAAb7UFTwLqws3fr5/hEM8+cXyynhyL9lcQNEcOoqI/gxYwWX2
	 WvOzVaN+7Sdk3S3i9COb1aP9+GeAPAyQ2JhAAU7CpHaPVXN2gfPLBNta+aa4V7NWvZrOR
	 xIue/bFjC9u7tFmGHlUxLlXWrdRc/klU9yIfFldrMyAfH3NS9diccPRMUZ4J9h3QTdXRp
	 cBbm0idCKaFd934Y9rzEXCR/D8nXsxfDNUeqnTrXEhwdCMnYrYtGtKKWbBp1t4a8FoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="j/mMxU3c";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486F2606A335;
	Tue,  3 Nov 2026 03:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=j/mMxU3c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96AB1F00A16;
	Tue,  3 Nov 2026 03:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793675990;
	bh=B9Ech+fsg+hlX8YEu83qJWfUQXYamGpxjlYwLlrPOIQ=;
	h=Date:To:From:Subject;
	b=j/mMxU3cr0rJWJvvdroqIEX24uNudjK/RtSSZURjKMmFk3LMeZVqMZTUyMcWHwGqE
	 wrCn/W8br3mC6Q8FYmR2NSVCCIt8u/C3w4AOpJuao19ldc/C59wzPEo5Qw/OpRQvTq
	 gcPQMiUHQwbjmAMvPeEhj5Tak8rAFdbRBlVaaTtM=
Date: Mon, 02 Nov 2026 19:19:49 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,
	rioo.tsukatsukii@gmail.com,pmladek@suse.com,brads@mainlining.org,
	nickolai@csail.mit.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] panic-zero-the-dynamically-allocated-taint-buffer.patch removed from -mm tree
Message-Id: <20261103031949.D96AB1F00A16@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: panic: zero the dynamically allocated taint buffer
has been removed from the -mm tree.  Its filename was
     panic-zero-the-dynamically-allocated-taint-buffer.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: panic: zero the dynamically allocated taint buffer
Date: Fri, 23 Oct 2026 22:01:52 -0400

A %s read of print_tainted()'s string can run past the end of the taint
buffer while another CPU rebuilds a longer string in it, reading slab
memory out of bounds into the kernel log (a KASAN slab-out-of-bounds
report at taint_buf + size).  A warning or an unhandled-signal dump on
another CPU reaches print_tainted() through dump_stack_print_info().

alloc_taint_buf() sizes the buffer for the longest taint string and
allocates it with kmalloc(), so the bytes past that string are never
written and the object holds no permanent NUL terminator. 
_print_tainted() rebuilds the string in place without locking and writes
the terminator last, so a reader that overtakes a writer extending the
string past the previous high-water mark finds no terminator inside the
object and walks off its end.  print_tainted()'s kernel-doc promises the
string is "always NULL terminated", a guarantee the previous zero-filled
static buffer kept.

Allocate the buffer with kzalloc() so its trailing bytes stay NUL and
every reader stops inside the object.

Reproduced on QEMU riscv64 under KASAN by growing the taint set while
processes took unhandled-signal dumps on several CPUs: the unpatched
kernel reports a slab-out-of-bounds read at taint_buf + size, the patched
one is clean.

Link: https://lore.kernel.org/20261024020153.830459-1-nickolai@csail.mit.edu
Fixes: a9dff0d0d11c ("kernel/panic: allocate taint string buffer dynamically")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Rio <rioo.tsukatsukii@gmail.com>
Cc: <stable@vger.kernel.org>
---

 kernel/panic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/panic.c~panic-zero-the-dynamically-allocated-taint-buffer
+++ a/kernel/panic.c
@@ -884,7 +884,7 @@ static __init int alloc_taint_buf(void)
 
 	size += 1; /* For NULL terminator */
 
-	buf = kmalloc(size, GFP_KERNEL);
+	buf = kzalloc(size, GFP_KERNEL);
 
 	if (!buf) {
 		panic("Failed to allocate taint string buffer");
_

Patches currently in -mm which might be from nickolai@csail.mit.edu are

xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch
lib-plist-add-a-plist_test-case-for-plist_requeue-on-the-last-priority-bucket.patch

