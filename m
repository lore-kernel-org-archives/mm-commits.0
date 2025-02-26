Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2212253FD
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 21:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740606697; cv=none; b=IULynw7J2RXB68CW6bgTIaGtHgoJf9GckKZ3x4l0KUcO+JxDuaOAmJD6gHRPUQSrsB7g++827QDZe3FMOc883qRGVgVKkEpk3NBCW17A/0unlW4qNZwJg6DaHa3Odf9BYjJVRjWwiq+jRrbSaMCMezLMMxyEa9Ar8emYN6u7B7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740606697; c=relaxed/simple;
	bh=QkTT9oXUdUo2WtL7b0+CgaKY627fpwXJPuI2XVAppJU=;
	h=Date:To:From:Subject:Message-Id; b=i5PUu5r9IN/QC0ayvI2IgjBy2QywvC0HTKWbLVTaeMSdCNUw33+C6EiZGqvQ7OWoriW/nNYe6L0fbP0A7kBx6utpIS7AA8lIlEluwprIpejcQhX6dA6CZz5q6cp5i68eHPhQE57Fs2Y9t31xVY9dbXfLo0fuLLCYWsIrFcDktCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m6F/Fi1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m6F/Fi1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638A7C4CED6;
	Wed, 26 Feb 2025 21:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740606696;
	bh=QkTT9oXUdUo2WtL7b0+CgaKY627fpwXJPuI2XVAppJU=;
	h=Date:To:From:Subject:From;
	b=m6F/Fi1Kb7cvV4Av3U0nZCfM/vvqVhaqEnDYgffoepWdCKWWF1gSiV5x/XzK40VaZ
	 zFAvH559IYSXhQlZhQtiny7htEED81SsUYjwd5YnyDTpylP4LsZD4qR9vNwcXw8aFL
	 LfXU5XvWeZDNyNYjfA1Dw84HaCOnk9P6+VXwiMMU=
Date: Wed, 26 Feb 2025 13:51:35 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250226215136.638A7C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix
Date: Wed Feb 26 01:50:26 PM PST 2025

reflow comment to 80 cols, s/end/end up/

Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix
+++ a/mm/userfaultfd.c
@@ -1272,11 +1272,11 @@ retry:
 
 			locked = folio_trylock(folio);
 			/*
-			 * We avoid waiting for folio lock with a raised refcount
-			 * for large folios because extra refcounts will result in
-			 * split_folio() failing later and retrying. If multiple
-			 * tasks are trying to move a large folio we can end
-			 * livelocking.
+			 * We avoid waiting for folio lock with a raised
+			 * refcount for large folios because extra refcounts
+			 * will result in split_folio() failing later and
+			 * retrying.  If multiple tasks are trying to move a
+			 * large folio we can end up livelocking.
 			 */
 			if (!locked && folio_test_large(folio)) {
 				spin_unlock(src_ptl);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch
userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix.patch
mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch

