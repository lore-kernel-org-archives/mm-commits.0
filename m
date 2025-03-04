Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095F61F92A
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 04:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741062377; cv=none; b=bG/Qa65CS2ReN8aIeMklOojUi/jM9+ZFo2V4Ph4FKzsoxXvvplvSYwnMeBbUCjG8n781rygF0gr/Ts71OUc0BjqxH9FojYcWZDyhJ9h08UyKCtyV2z+8DKMvwxCUezFd/UTeqBXq04QYLC4tewPo3bZxVZPPhp3l4U1O5lox2IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741062377; c=relaxed/simple;
	bh=9xfN5ahjJaKkIZNjS98NgU+u/eOOELCuUUEHEvFVHrA=;
	h=Date:To:From:Subject:Message-Id; b=LBIt64qMYt3PxcEr2S7KnHRToXXdllmTnX1LkZXT2z5HBZUjyoc1WU+N1Zv3u1YLw6XSJkALt5as+Z99jkSsxIJ1APtX1wm9dKfkQDz9JuM2GJ6SXHivFoBhyf3jGxC7IqGdjTvfAYHiRS9Q91oCP5ujLAgizns7vkh4bvkBfmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r+etCRkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r+etCRkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63649C4CEE5;
	Tue,  4 Mar 2025 04:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741062375;
	bh=9xfN5ahjJaKkIZNjS98NgU+u/eOOELCuUUEHEvFVHrA=;
	h=Date:To:From:Subject:From;
	b=r+etCRkqxFAjULT8bKM4Gpfo4AiUsHxJGPStQ0jRWD6TmbReOftyFL9RtABExKiHb
	 Ey1iHw9IaNaxNQ0uDswNkQ0QcLe28X3Lbe/29MxMOYx76AxiOFP2ZxjTSohnfFCY/c
	 g0K8OwZQ7ttF4KT4ErjX2itXUTx3J+jJiUgnBYqA=
Date: Mon, 03 Mar 2025 20:26:14 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,jackmanb@google.com,dev.jain@arm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-print-some-details-when-uffd-stress-gets-bad-params-fix.patch added to mm-unstable branch
Message-Id: <20250304042615.63649C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-print-some-details-when-uffd-stress-gets-bad-params-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-print-some-details-when-uffd-stress-gets-bad-params-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-print-some-details-when-uffd-stress-gets-bad-params-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-print-some-details-when-uffd-stress-gets-bad-params-fix
Date: Mon Mar  3 08:25:32 PM PST 2025

fix _err() args

Link: https://lkml.kernel.org/r/CA+i-1C2RFVZovrxjYGA3i6+vuizkMkr-OXr0bEOQrBqRoAqQ1Q@mail.gmail.com
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-print-some-details-when-uffd-stress-gets-bad-params-fix
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -458,7 +458,7 @@ int main(int argc, char **argv)
 	nr_pages_per_cpu = bytes / page_size / nr_threads;
 	if (!nr_pages_per_cpu) {
 		_err("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)",
-			nr_pages_per_cpu, bytes, page_size, nr_threads);
+			bytes, page_size, nr_threads);
 		usage();
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch
userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix.patch
mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry-fix.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params-fix.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
mm-mremap-thread-state-through-move-page-table-operation-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch

