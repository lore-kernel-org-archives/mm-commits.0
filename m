Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220CB218821
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 03:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740542061; cv=none; b=g8UoKVo5XoNs9M2IGvLN35zf6jzJuxfmSRPML7uh2aDL2hGinWvzPmmaD4OpIbffhrNzBXHGdqtf5Lx83iY9wAwWbqV7bc1jTwnrqi1GMAQ6ZaAmzwiJH0BkZkNIHYYldZAAxTxoBiYYbErVOr2byrkLY4OQr+o+PsfIxk7ZiZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740542061; c=relaxed/simple;
	bh=63pH/E1VExADrzglpxbiwPAKHqnYaWQZ52/rY7ZbrzI=;
	h=Date:To:From:Subject:Message-Id; b=W4Z4LPStpjBeVQpEbiGNvFnHFJudldFjVZTKIjmDFB6rfZ7jltwiUcoWX4uSfD/uZuCTKxDuuOYAgD1Do/9hemOTaXvt+n0VDecHc4stlYrGuAHLhSGpK8QiO43/8rdJXdIc/pbpmtI8oIfn78ct20EFl4DShSPrzK+WM072jv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vu3JZct8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vu3JZct8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C86C4CED6;
	Wed, 26 Feb 2025 03:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740542059;
	bh=63pH/E1VExADrzglpxbiwPAKHqnYaWQZ52/rY7ZbrzI=;
	h=Date:To:From:Subject:From;
	b=Vu3JZct8Ev48qX+WhRvOJ9Zr8JwRb56l91ggISqNUZVQH5PZ3k36LleBdRDXfLBcx
	 nmIOgiOTjWsDaopkY5aPX199D5ZTxLz04+htTL2NJT1skkOgz5nnch92oXGU37XBvo
	 1efanvLx9RbpFCRoQTk+Q9C50/pz1+HrjrsEx5Ew=
Date: Tue, 25 Feb 2025 19:54:18 -0800
To: mm-commits@vger.kernel.org,james.bottomley@HansenPartnership.com,eahariha@linux.microsoft.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250226035419.66C86C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix
Date: Tue Feb 25 07:32:03 PM PST 2025

fix build

Cc: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_sli.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_sli.c~scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix
+++ a/drivers/scsi/lpfc/lpfc_sli.c
@@ -3954,7 +3954,7 @@ void lpfc_poll_eratt(struct timer_list *
 	else
 		/* Restart the timer for next eratt poll */
 		mod_timer(&phba->eratt_poll,
-			  jiffies + secs_to_jiffies(phba->eratt_poll_interval);
+			  jiffies + secs_to_jiffies(phba->eratt_poll_interval));
 	return;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch
mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch

