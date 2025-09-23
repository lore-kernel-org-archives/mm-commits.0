Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E562472B1
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597505; cv=none; b=YtYPCsONR2yvAV4R0SLtCiIF6gi4Xve4cf4FPehurg5h7wyWaBWcVsrQ/jw0gEBDSj1nEVcql1C+q9k5CI8rfYsCFyPRbkoMO8gs7YKvBaYvHXnaLjfvqYQisJR6n6I471xricFBzSMVXIUvWV3GMYj+UHdKc1CEiw8Cl+90Vbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597505; c=relaxed/simple;
	bh=/U/+wM8K+o+jayBLMDiuC5ycxU/Wb9VuDEzpljUrMB8=;
	h=Date:To:From:Subject:Message-Id; b=Wmz2Emyl6lxKFdAlRVswTHeY9oHi6aA61NlDYNzRGHXKZk3hG9V/jPCgWQ3KlKF3V26ydkkP08Y01UiEVBH8gsZshdaHWNZbQDbaPIJ3CZAgCCzwAfMkl83mKdmEdXzJ8pIuahbR4M7X9dnSP1k6X9QRMqc/+tOdhsJaasYy2LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e6EUqy8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e6EUqy8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FDCC4CEF0;
	Tue, 23 Sep 2025 03:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597504;
	bh=/U/+wM8K+o+jayBLMDiuC5ycxU/Wb9VuDEzpljUrMB8=;
	h=Date:To:From:Subject:From;
	b=e6EUqy8lZ1RDP3JN4xbo+i83mI0c3lUoZjFEYjvK0wzWcmk2sC4vXulo1e+c684LP
	 2EONDLMIolx/fs7BIebssfjZlmaxuwRZV9p1ChzraNV69nmPdIq3ziS4ghM6ArNAcw
	 UYZOTpzUrvFX1wy4Bum6dQK0gHYVRYj8whjEmLKU=
Date: Mon, 22 Sep 2025 20:18:23 -0700
To: mm-commits@vger.kernel.org,clm@meta.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-oom_killc-fix-inverted-check.patch removed from -mm tree
Message-Id: <20250923031824.59FDCC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/oom_kill.c: fix inverted check
has been removed from the -mm tree.  Its filename was
     mm-oom_killc-fix-inverted-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/oom_kill.c: fix inverted check
Date: Wed, 17 Sep 2025 06:16:37 +0100

Fix an incorrect logic conversion in process_mrelease().

Link: https://lkml.kernel.org/r/3b7f0faf-4dbc-4d67-8a71-752fbcdf0906@lucifer.local
Fixes: 12e423ba4eae ("mm: convert core mm to mm_flags_*() accessors")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Chris Mason <clm@meta.com>
  Closes: https://lkml.kernel.org/r/c2e28e27-d84b-4671-8784-de5fe0d14f41@lucifer.local
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/oom_kill.c~mm-oom_killc-fix-inverted-check
+++ a/mm/oom_kill.c
@@ -1257,7 +1257,7 @@ SYSCALL_DEFINE2(process_mrelease, int, p
 	 * Check MMF_OOM_SKIP again under mmap_read_lock protection to ensure
 	 * possible change in exit_mmap is seen
 	 */
-	if (mm_flags_test(MMF_OOM_SKIP, mm) && !__oom_reap_task_mm(mm))
+	if (!mm_flags_test(MMF_OOM_SKIP, mm) && !__oom_reap_task_mm(mm))
 		ret = -EAGAIN;
 	mmap_read_unlock(mm);
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


