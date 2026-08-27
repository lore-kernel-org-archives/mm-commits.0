Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5D4242D6B
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 04:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787804784; cv=none; b=rqXVhZMN/wAFczxWLntRV1tDVgrY2quVqb6fT78Nq+P9iATXinbQdkMnVO2iGroay8sJPchAcyPlXm0nPf6cVF3FenZ6KauSFS+SyyNjY0gGVZhUeqMcWEI25MFJb3vE7QRqjilcRwvGpakWYru1JzdAOxwzaZYC1o0NhxgBd3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787804784; c=relaxed/simple;
	bh=XLg1LOaL8oZpbPrCFOqJ/2AOqqF3Kwd6PsZ83vDXydY=;
	h=Date:To:From:Subject:Message-Id; b=jRd3SAn0E77P3LzKjltPjv46M8mkYKMzLHrNSqpYJ6I/fK+N4bRvwaucoUxio1CAM5QNvvwE9kA8ege2/hpkzMsR991sG1HW3L1nyqB54lV2yNQs38wFo+A36TBQan58Kd6FdBJfwxpv0JeQcjifKTLborcWa1bPCxsBxjmDXm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n2l7TkMG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n2l7TkMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793341F000E9;
	Thu, 27 Aug 2026 04:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787804783;
	bh=k2B95W7VgyUtraLr3hdHLoO85gbsz/IeW/yl2q2ZVek=;
	h=Date:To:From:Subject;
	b=n2l7TkMGt1VFveoT5Kn9v1n97mFtuoWBfje4L1hFWFfSc0r+sirQt5Z0f1imGtL/2
	 MFtZNlVnkzeeRNtX9RfJogYNIEHSDsLdhbyTzyNGlyVn4etAdEGpVpTaQIeRV8kuKN
	 3q5o4WXuA3F4+xC4Xhpck3jnd5Sh1ihE3qMgQAts=
Date: Wed, 26 Aug 2026 21:26:23 -0700
To: mm-commits@vger.kernel.org,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] module-fix-lost-error-code-from-codetag_load_module.patch removed from -mm tree
Message-Id: <20260827042623.793341F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: module: fix lost error code from codetag_load_module()
has been removed from the -mm tree.  Its filename was
     module-fix-lost-error-code-from-codetag_load_module.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hao Ge <hao.ge@linux.dev>
Subject: module: fix lost error code from codetag_load_module()
Date: Mon, 24 Aug 2026 09:47:36 +0800

If codetag_load_module() fails, err is not set to reflect the failure and
load_module() returns 0 after the module has been torn down.

Link: https://lore.kernel.org/20260824014736.35026-1-hao.ge@linux.dev
Fixes: 044d2aee6c57 ("alloc_tag: handle module codetag load errors as module load failures")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/module/main.c~module-fix-lost-error-code-from-codetag_load_module
+++ a/kernel/module/main.c
@@ -3568,7 +3568,8 @@ static int load_module(struct load_info
 			goto sysfs_cleanup;
 	}
 
-	if (codetag_load_module(mod))
+	err = codetag_load_module(mod);
+	if (err)
 		goto sysfs_cleanup;
 
 	/* Get rid of temporary copy. */
_

Patches currently in -mm which might be from hao.ge@linux.dev are

alloc_tag-skip-percpu-counter-allocation-when-profiling-is-disabled.patch
alloc_tag-remove-proc-allocinfo-outside-of-mod_lock.patch

