Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F232D1913
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671884; cv=none; b=I/UmlF/TeVrCsk/bs0rfZa8WqGtWyUWLeYd2z7TCQQ191YQCMWYHvjy+lxgNPvCkmvWY8/XYnolwuot48WDK3OfkE2uAMKyzDXglsdKLgewDMd7g2jD4rBi4dddv4pM9GtHwVHu5PeGiXGJiX1nESrwMSftmxuSTBKn9FgeCIxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671884; c=relaxed/simple;
	bh=yjy+fZAT/r6WB7/qxy94VpbsjlFGoGhoPGLy7kC1dqQ=;
	h=Date:To:From:Subject:Message-Id; b=UdytAfzy77goctVFxpBQ9CbV/IcRtxt6pFRbU2t7NZiUnTQTxfm0D3t3fV/69fv2cipXykxJsiGnoNyrfQIhxYYrcDjVkPOXyuPVqNrMhPTx9QQsXwP3lFd+GXwwzjX9ZevT3B1n9AMz2tmPoqArJNleVA+U0XoqgFA/qVsLF0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IhxiULha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IhxiULha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501BDC4CEF7;
	Sat, 28 Mar 2026 04:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671884;
	bh=yjy+fZAT/r6WB7/qxy94VpbsjlFGoGhoPGLy7kC1dqQ=;
	h=Date:To:From:Subject:From;
	b=IhxiULhayTIzh/Zzmkbw++KwyQDkOVKaOaEtY/A9aqZilPP0mhMmOOt0VWur61Je3
	 M03L4SAxSoivyra0Lu/z4wRkN6WRoXnD8cWkOhOfYL17rq0CaPwn7eMKsmWifvMVxy
	 z9IUANVAPRBhcE5HVFLteLSvFyWiNmyGa0bZMkVs=
Date: Fri, 27 Mar 2026 21:24:43 -0700
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,pmladek@suse.com,joel.granados@kernel.org,rioo.tsukatsukii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-panic-mark-init_taint_buf-as-__initdata-and-panic-instead-of-warning-in-alloc_taint_buf.patch removed from -mm tree
Message-Id: <20260328042444.501BDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/panic: mark init_taint_buf as __initdata and panic instead of warning in alloc_taint_buf()
has been removed from the -mm tree.  Its filename was
     kernel-panic-mark-init_taint_buf-as-__initdata-and-panic-instead-of-warning-in-alloc_taint_buf.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


