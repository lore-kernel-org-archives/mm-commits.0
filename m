Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF93347126B
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 03:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791863999; cv=none; b=bvrwGLoxH5IAXZQ2H3WwdhdHmze8Q/u+Q7f3WNNtbw1Kxie1Hv355tqC2XfPp43aGjWXorPpFEPrw6UKDVN7M+AUKSChqp9AAdr3lmKroNNpvOIp6VDIQ4DvaCxbK30MjNOeU8I5sWBezXBtIFYHnLJV34TFSrr0G0gQ5SLrAJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791863999; c=relaxed/simple;
	bh=ZvVqDWMsMdeVEmF42mMbKjO4nOehjIQSbcPmPY1MfBE=;
	h=Date:To:From:Subject:Message-Id; b=QnLyzEA7S3g9c59cDD6TQRXEJErq/zvDtV1RxVWudXipk5V+7asqBZiWU7IjocPliezHBQ8UQdUf4rVM/quu66APBE/OG1hIy0BqhDvfWPcNCH9CjiPn3r7ZhYrBf0kvkMnwFD6gcd0Xc9RpQrkCYSoedxP3cryNYbZQ1DLavZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ypI9HIUi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ypI9HIUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561031F00893;
	Tue, 13 Oct 2026 03:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791863998;
	bh=nIUOczJSkcVH/iGtW5Vh0owM1N6Vaa1l/aMj6ZmnQnQ=;
	h=Date:To:From:Subject;
	b=ypI9HIUi5JBb/5HtdP+7SExEXYVtzJN9aLHjnbAaNiswd6JC2GzREqlREeS8TZeUE
	 URmDD+wrl/Cc/ncHKa575zH6Un+xZktEquByi6XKoveD3ouBnfmCl/cQl1thoCGl+U
	 GLMyDp2lPFCPpb3pnbHVlDKD6O/bc6Y/PQ7VrUas=
Date: Mon, 12 Oct 2026 20:59:57 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch removed from -mm tree
Message-Id: <20261013035958.561031F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
has been removed from the -mm tree.  Its filename was
     proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch

This patch was dropped because it was folded into proc-task_mmu-remove-unnecessary-inlines-in-function-definitions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
Date: Sun Sep 27 10:59:53 AM PDT 2026

fix CONFIG_NUMA=y && CONFIG_PROC_PAGE_MONITOR=n build

show_numa_map() uses drop_rcu() and reacquire_rcu(), but those helpers are
currently built only when CONFIG_PROC_PAGE_MONITOR is enabled.  A kernel
with CONFIG_NUMA=y and CONFIG_PROC_PAGE_MONITOR=n therefore fails to build
with implicit declarations for both helpers.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
+++ a/fs/proc/task_mmu.c
@@ -196,7 +196,7 @@ static bool fallback_to_mmap_lock(struct
 	return true;
 }
 
-#ifdef CONFIG_PROC_PAGE_MONITOR
+#if defined(CONFIG_PROC_PAGE_MONITOR) || defined(CONFIG_NUMA)
 static void drop_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

proc-task_mmu-remove-unnecessary-inlines-in-function-definitions.patch
mm-damon-core-introduce-damos_quota_goal-complement-fix.patch
lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

