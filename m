Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E0E26A0C7
	for <mm-commits@vger.kernel.org>; Wed, 25 Mar 2026 04:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774413199; cv=none; b=a+pULRUvcfcxYIk2nhUebug6x1Q29aIh18cCSl/gRifIA2zNbGBl/yEp7ROkrHig/5LjL9wm9b43bAZ7zLD+x0bg/GHOvganmFI4fbQpx/Oc8HDK9TUuGqq3N4codV18Wy85BvIfpQ2dh81Ocu4UwGqmvoQCv59WQGauVCP2tus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774413199; c=relaxed/simple;
	bh=FsuZf2CLO1T8y9/3BPG26zAM87rcCVUEF6I03rJ4d1o=;
	h=Date:To:From:Subject:Message-Id; b=tqbXml45NRevy86qJi281lLLlCq1b5aJd/wFUyjwcV3isnlW7qxEGjOAT0AnubMfXtcSUB1KtNATa4JBYRFpfIiSL7IqoVAPmNhRJmk2Otm6aSRUknDJT1JDFwyBjNAvnjD18PCcAyFjX+VCqF7wQ+qXoRwqCOUR9tNh+BbZ2B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x6jMDGdY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x6jMDGdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DD6C4CEF7;
	Wed, 25 Mar 2026 04:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774413198;
	bh=FsuZf2CLO1T8y9/3BPG26zAM87rcCVUEF6I03rJ4d1o=;
	h=Date:To:From:Subject:From;
	b=x6jMDGdYVInNd5vJVbINO+zGAQJBbrjAmwyxfbTBHv2A/3XBI5mYFfjHR42pM7qZo
	 9MiXpemdGwJhl1C+/oEq2TTLpbjBK8jEZbV/pZjwwMHqO7mjnwh6j65ounJ/tdT+yZ
	 tZqprUSDUM3EA2JQsyCX7MN6UKMLy9NtGkdkRBIw=
Date: Tue, 24 Mar 2026 21:33:17 -0700
To: mm-commits@vger.kernel.org,wangjinchao600@gmail.com,rioo.tsukatsukii@gmail.com,pmladek@suse.com,joel.granados@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch removed from -mm tree
Message-Id: <20260325043318.72DD6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix
has been removed from the -mm tree.  Its filename was
     kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch

This patch was dropped because it was folded into kernel-panic-increase-buffer-size-for-verbose-taint-logging.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix
Date: Fri Feb 20 01:05:15 PM PST 2026

fix spello, add comment

Cc: Joel Granados <joel.granados@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rio <rioo.tsukatsukii@gmail.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/panic.c~kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix
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
@@ -854,7 +856,7 @@ static void print_tainted_seq(struct seq
 	}
 }
 
-/* 350 can accomadate all taint flags in verbose mode, with some headroom */
+/* 350 can accommodate all taint flags in verbose mode, with some headroom */
 #define TAINT_BUF_MAX 350
 
 static const char *_print_tainted(bool verbose)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix.patch
mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging.patch
decode_stacktrace-decode-caller-address-checkpatch-fixes.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

