Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0475D257AC1
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 06:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740466495; cv=none; b=Oy7+4zyNDPxEbE37SCExOuf6ejEf4EApIjS/ex8+3NnQLM3IzP6mLiRqd1wS9oQPBt253dCBGYbKUxP4j80+7oGAA/QjFxuDrXbO2/jq2E3Vx6H6cY9wL6otrXAUELBBAs2H7wQO/BptIdibwT+zufO+ezFRSACRVRRiDZfidh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740466495; c=relaxed/simple;
	bh=JqhipE3IG8hEG0b9AocaE4eY8g+Z/TuDcGyXyYXIjP0=;
	h=Date:To:From:Subject:Message-Id; b=hIOkMaMrnOPxGYObLsrnN2gfzqtR6a199ZnvNnon5f8aF4xe8WEgknk7hskgZdaqy0vhpyHBZ16D+B2gN20W6hWSvm9oz+G2jENGPKPGU5u9hL/LHpOKwXlVDmCS2/Ng8nB3vv2yXQHW8rMD+LkHRgPhy8c5aaX8PGz8gqY0If4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A+/ESP7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A+/ESP7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722B4C4CEE7;
	Tue, 25 Feb 2025 06:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740466494;
	bh=JqhipE3IG8hEG0b9AocaE4eY8g+Z/TuDcGyXyYXIjP0=;
	h=Date:To:From:Subject:From;
	b=A+/ESP7wXZ7+4QRfSDLRtbkPxVKFHR+BI5xl+j/J3NMJ1nyiwPyRixfWtEvEEX4rQ
	 X4hRn+HUSGLQ69LLPutmu7u83b35n7kqcf+KWTom3qvSAOvo3UoFRSijLqE/tGO+WB
	 20wi712VUqh6z5Vf4/0khROWWXmTNNbslHumsezU=
Date: Mon, 24 Feb 2025 22:54:53 -0800
To: mm-commits@vger.kernel.org,trond.myklebust@hammerspace.com,snitzer@kernel.org,anna.schumaker@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250225065454.722B4C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch

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
Subject: nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix
Date: Mon Feb 24 10:53:31 PM PST 2025

fix build

Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix
+++ a/mm/compaction.c
@@ -3181,7 +3181,7 @@ static int kcompactd(void *p)
 	long default_timeout = msecs_to_jiffies(HPAGE_FRAG_CHECK_INTERVAL_MSEC);
 	long timeout = default_timeout;
 
-	tsk->flags |= PF_KCOMPACTD;
+	current->flags |= PF_KCOMPACTD;
 	set_freezable();
 
 	pgdat->kcompactd_max_order = 0;
@@ -3238,7 +3238,7 @@ static int kcompactd(void *p)
 			pgdat->proactive_compact_trigger = false;
 	}
 
-	tsk->flags &= ~PF_KCOMPACTD;
+	current->flags &= ~PF_KCOMPACTD;
 
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch
mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch

