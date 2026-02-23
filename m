Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E038933C18B
	for <mm-commits@vger.kernel.org>; Mon, 23 Feb 2026 18:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771870832; cv=none; b=bZv8p325nyPl2QVDcA6m8joqMMQMJzWZi4xSWVLwojhURjjQa/DPqKXtcAFsQ+WDxzqVGloHpcCuq+X/1JwKz7NwxMxRlBPE4iL+ZsIsmcpjYHAAk8JteWAqDLJ/ULpNrlZo+QC7n6T3SYXV0E1U6iFSwx4b+hekzJxHk/ezZT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771870832; c=relaxed/simple;
	bh=AcPJ9n3Im+MHJBw/Sn/DZQXcvRv+JgR+6Ds0SSan76I=;
	h=Date:To:From:Subject:Message-Id; b=ipUo8VHQWALnOm1tL5XxSOpysC6gVQ7hudbzkK1Gg3SNEVok50ah7wH5yd4NmHWyo0eGLAEAuV56CikoL3Oa0gMyny+LRbXgmVOTFQ3F7TdqKNEH0zh+1HG7GS0VqBXpX25I7pZ3EB3B5h3IV6nwuXwGY23VLPqUCKnGbLYTVjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=clZk24jr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="clZk24jr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4C5C116C6;
	Mon, 23 Feb 2026 18:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771870832;
	bh=AcPJ9n3Im+MHJBw/Sn/DZQXcvRv+JgR+6Ds0SSan76I=;
	h=Date:To:From:Subject:From;
	b=clZk24jrE/So0wWtjO/NgKaf+9dluAeDwgLiPeqf08fcGAUbGJisqHRBLEegOplrF
	 q8NYSnyYNTGISvWSkzHLBZK+64E8n7KZ3nUW9ui+O88mEQE07PIrTo88mj5S+yhIfY
	 FjBOUXn9SJcg5xXIXKCo/dSulUDb/zkWOyHi54ec=
Date: Mon, 23 Feb 2026 10:20:31 -0800
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,pmladek@suse.com,joel.granados@kernel.org,rioo.tsukatsukii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-panic-mark-init_taint_buf-as-__initdata-and-panic-instead-of-warning-in-alloc_taint_buf.patch added to mm-nonmm-unstable branch
Message-Id: <20260223182032.6B4C5C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/panic: mark init_taint_buf as __initdata and panic instead of warning in alloc_taint_buf()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-panic-mark-init_taint_buf-as-__initdata-and-panic-instead-of-warning-in-alloc_taint_buf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-panic-mark-init_taint_buf-as-__initdata-and-panic-instead-of-warning-in-alloc_taint_buf.patch

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
From: Rio <rioo.tsukatsukii@gmail.com>
Subject: kernel/panic: mark init_taint_buf as __initdata and panic instead of warning in alloc_taint_buf()
Date: Mon, 23 Feb 2026 09:29:14 +0530

However there's a convention of assuming that __init-time allocations
cannot fail.  Because if a kmalloc() were to fail at this time, the kernel
is hopelessly messed up anyway.  So simply panic() if that kmalloc failed,
then make that 350-byte buffer __initdata.

Link: https://lkml.kernel.org/r/20260223035914.4033-1-rioo.tsukatsukii@gmail.com
Signed-off-by: Rio <rioo.tsukatsukii@gmail.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/kernel/panic.c~kernel-panic-mark-init_taint_buf-as-__initdata-and-panic-instead-of-warning-in-alloc_taint_buf
+++ a/kernel/panic.c
@@ -865,8 +865,8 @@ static void print_tainted_seq(struct seq
  */
 #define INIT_TAINT_BUF_MAX 350
 
-static char init_taint_buf[INIT_TAINT_BUF_MAX];
-static char *taint_buf = init_taint_buf;
+static char init_taint_buf[INIT_TAINT_BUF_MAX] __initdata;
+static char *taint_buf __refdata = init_taint_buf;
 static size_t taint_buf_size = INIT_TAINT_BUF_MAX;
 
 static __init int alloc_taint_buf(void)
@@ -887,11 +887,7 @@ static __init int alloc_taint_buf(void)
 	buf = kmalloc(size, GFP_KERNEL);
 
 	if (!buf) {
-		/* Allocation may fail; this warning explains possibly
-		 * truncated taint strings
-		 */
-		pr_warn_once("taint string buffer allocation failed, using fallback buffer\n");
-		return 0;
+		panic("Failed to allocate taint string buffer");
 	}
 
 	taint_buf = buf;
_

Patches currently in -mm which might be from rioo.tsukatsukii@gmail.com are

kernel-panic-increase-buffer-size-for-verbose-taint-logging.patch
kernel-panic-allocate-taint-string-buffer-dynamically.patch
kernel-panic-mark-init_taint_buf-as-__initdata-and-panic-instead-of-warning-in-alloc_taint_buf.patch

