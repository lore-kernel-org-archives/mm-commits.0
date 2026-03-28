Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322CE2D1913
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671882; cv=none; b=JOsLMK8bpYgTjbPjXDD93QPYr1oCmWxXICFQV9/rLqU99+Glw4nVUI4Ze8f/5/B5TsHXrTs+wgm7nl6VqyIKdd21+AdUBR1rPFMVfLWwwY+Nd8eyxo5Af7MFzbKkuoeBGyimqgVU++CZniXS2ynDjhIRfJbqYORbWRPNIMMSjAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671882; c=relaxed/simple;
	bh=9mjYNa97JsflablAhmzo1p+p/WY6J4p36JEBGk+G2JI=;
	h=Date:To:From:Subject:Message-Id; b=FoDPECNmMXs7NGEVZXVWt2L5EKqo9SOaeyObOawPZduaGU5i9TbjwDVOM10tkvPLjJsmvNy3dWXjbJkkkcNlLQUOwfDrCbs4ArfayzIw23kPqkqmmEJ3X3Xg4QQntgceTiPwEKIyri9yp+l+njaKJpTs/AmzSM9B2/y87kNg6VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1M85R+Z/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1M85R+Z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC13FC4CEF7;
	Sat, 28 Mar 2026 04:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671881;
	bh=9mjYNa97JsflablAhmzo1p+p/WY6J4p36JEBGk+G2JI=;
	h=Date:To:From:Subject:From;
	b=1M85R+Z/tDNkRR6DP2ijzOzKaqCLTDT6O20yI6oaocv/Vfsg8aYXb3vMrPsx5Qk4/
	 9dXZ2xFfZ8UjAtIMBdWMVu0CcwpN3Rbcu4gSX3Snqix6NvJSOvVsPpu5VoeCGi45fe
	 H40MgcpIsULSIbxjTtuCMSg5hJ2gxKH9bfOd5y/U=
Date: Fri, 27 Mar 2026 21:24:41 -0700
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,pmladek@suse.com,joel.granados@kernel.org,rioo.tsukatsukii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-panic-increase-buffer-size-for-verbose-taint-logging.patch removed from -mm tree
Message-Id: <20260328042441.BC13FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/panic: increase buffer size for verbose taint logging
has been removed from the -mm tree.  Its filename was
     kernel-panic-increase-buffer-size-for-verbose-taint-logging.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rio <rioo.tsukatsukii@gmail.com>
Subject: kernel/panic: increase buffer size for verbose taint logging
Date: Fri, 20 Feb 2026 20:45:00 +0530

The verbose 'Tainted: ...' string in print_tainted_seq can total to 327
characters while the buffer defined in _print_tainted is 320 bytes. 
Increase its size to 350 characters to hold all flags, along with some
headroom.

[akpm@linux-foundation.org: fix spello, add comment]
Link: https://lkml.kernel.org/r/20260220151500.13585-1-rioo.tsukatsukii@gmail.com
Signed-off-by: Rio <rioo.tsukatsukii@gmail.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/panic.c~kernel-panic-increase-buffer-size-for-verbose-taint-logging
+++ a/kernel/panic.c
@@ -801,6 +801,8 @@ EXPORT_SYMBOL(panic);
  * Documentation/admin-guide/tainted-kernels.rst, including its
  * small shell script that prints the TAINT_FLAGS_COUNT bits of
  * /proc/sys/kernel/tainted.
+ *
+ * Also, update TAINT_BUF_MAX below.
  */
 const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
 	TAINT_FLAG(PROPRIETARY_MODULE,		'P', 'G'),
@@ -854,10 +856,12 @@ static void print_tainted_seq(struct seq
 	}
 }
 
+/* 350 can accommodate all taint flags in verbose mode, with some headroom */
+#define TAINT_BUF_MAX 350
+
 static const char *_print_tainted(bool verbose)
 {
-	/* FIXME: what should the size be? */
-	static char buf[sizeof(taint_flags)];
+	static char buf[TAINT_BUF_MAX];
 	struct seq_buf s;
 
 	BUILD_BUG_ON(ARRAY_SIZE(taint_flags) != TAINT_FLAGS_COUNT);
_

Patches currently in -mm which might be from rioo.tsukatsukii@gmail.com are


