Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD9927180A
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 23:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739318004; cv=none; b=Nme6CIhyy0DtTi2Fwngdp6OWeJv/m5lKIHQQHs0DFUOvpRagPV0yxT0LcxA1y08N1goWQ3OSONclKjllirZT9zKaUhVH3Egz9k1K3dWbhKgqGr6Vj/CZ23VveO5c8gourxIc6/E1CgBiK0ByZI6OSimA6wB5dpZBGTFDPCMrO3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739318004; c=relaxed/simple;
	bh=yg/7HKAuwCg2WiRusD02UzJqW0ZVtEWdMXZQYKj2cSA=;
	h=Date:To:From:Subject:Message-Id; b=unaM523mQQTuGmJnTyC/iOjSvdp+kD4+9aEYll//BvkWiaz3uoQraoTNns8WWTmpVEgRG9gdERSzEQz7eKJze4LSVHDr27Gd6NAPhFN3mH6w58tHF1l2/Q+MsSIldyq1V+1nAYE+Lz0s0zWXsy3BPKHbJ8N/g8czC3/Sbl7gj4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=frv3kFQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="frv3kFQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BA4C4CEDD;
	Tue, 11 Feb 2025 23:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739318003;
	bh=yg/7HKAuwCg2WiRusD02UzJqW0ZVtEWdMXZQYKj2cSA=;
	h=Date:To:From:Subject:From;
	b=frv3kFQPJGQjDLV5S5IyckMZIy7wxs5+ZKLf2LmzW7gwdHbsbJ1lK68l65kPlRt+u
	 CFf0pRgnwdy+vNLiGbHPgK3IsHvEJr80JURa0s6fhTLq+J+VLcoICoEWr+E44ysETf
	 yLmbqANeT59lxZ3/1casneYKAW9HK/R61dqY7SDY=
Date: Tue, 11 Feb 2025 15:53:22 -0800
To: mm-commits@vger.kernel.org,yi1.lai@linux.intel.com,sj@kernel.org,shakeel.butt@linux.dev,naresh.kamboju@linaro.org,howlett@gmail.com,dave@stgolabs.net,arnd@arndb.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-split-out-mmap-locking-operations-for-madvise-fix.patch added to mm-unstable branch
Message-Id: <20250211235323.50BA4C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: fix madvise_[un]lock() issue
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-split-out-mmap-locking-operations-for-madvise-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-split-out-mmap-locking-operations-for-madvise-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/madvise: fix madvise_[un]lock() issue
Date: Tue, 11 Feb 2025 10:44:26 +0000

We are asymmetric in our locking/unlocking in the case of memory failure
madvise() behaviour options, correct this and abstract the memory failure
check.

Link: https://lkml.kernel.org/r/2f448f7b-1da7-4099-aa9e-0179d47fde40@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
Closes: https://lore.kernel.org/Z6rgiVp7221r4JZ5@ly-workstation
Reviewed-by: SeongJae Park <sj@kernel.org>
Tested-by: SeongJae Park <sj@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Liam R. Howlett <howlett@gmail.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/mm/madvise.c~mm-madvise-split-out-mmap-locking-operations-for-madvise-fix
+++ a/mm/madvise.c
@@ -1575,14 +1575,29 @@ int madvise_set_anon_name(struct mm_stru
 }
 #endif /* CONFIG_ANON_VMA_NAME */
 
-static int madvise_lock(struct mm_struct *mm, int behavior)
-{
-
 #ifdef CONFIG_MEMORY_FAILURE
-	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
-		return 0;
+static bool is_memory_failure(int behavior)
+{
+	switch (behavior) {
+	case MADV_HWPOISON:
+	case MADV_SOFT_OFFLINE:
+		return true;
+	default:
+		return false;
+	}
+}
+#else
+static bool is_memory_failure(int behavior)
+{
+	return false;
+}
 #endif
 
+static int madvise_lock(struct mm_struct *mm, int behavior)
+{
+	if (is_memory_failure(behavior))
+	    return 0;
+
 	if (madvise_need_mmap_write(behavior)) {
 		if (mmap_write_lock_killable(mm))
 			return -EINTR;
@@ -1590,11 +1605,13 @@ static int madvise_lock(struct mm_struct
 		mmap_read_lock(mm);
 	}
 	return 0;
-
 }
 
 static void madvise_unlock(struct mm_struct *mm, int behavior)
 {
+	if (is_memory_failure(behavior))
+	    return;
+
 	if (madvise_need_mmap_write(behavior))
 		mmap_write_unlock(mm);
 	else
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix.patch
mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect.patch
mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch
mm-provide-mapping_wrprotect_range-function.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch
mm-madvise-handle-madv_hwpoisonsoft_offline-from-madvise_unlock.patch

