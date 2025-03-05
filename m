Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18568146588
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 22:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741212992; cv=none; b=sdPcH4WrOQNMR/7iCYn2xUqYjZCxa2HxBAgLvLyFOVA4UFj1mVZ1iDHq9u+Rzo62Ic7Zcl7HC+/VtCXhdcdIU//mG+TVPZixcN2UfFBeK4N41A9HRIQqR0JOYzPeSVqBLFPQmFfo1W7E+cF6o6IEoehL9EnO3eNNEUvk9OTKYH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741212992; c=relaxed/simple;
	bh=GmU1d/PLgnr1uAtwMaUcQ0wA7ZHKg05VS85/1rK95NU=;
	h=Date:To:From:Subject:Message-Id; b=TfxJ1mA1LMUk7QCpVwl5KR8p4sB2Fa7wCl4aNJllQ/cBdeAjXyTkBFggcqX78MThxqcY5IiAl1MoJGnJLMHebdHX0i4tk65k0B9OuO9mXso/Ar2YapVaT8MQty7UabCyZI9Qs/1Puw8vKl7g8RZLdujZK35mwnJBvbzpbtCZiGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cHzIZQCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cHzIZQCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624EEC4CED1;
	Wed,  5 Mar 2025 22:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741212991;
	bh=GmU1d/PLgnr1uAtwMaUcQ0wA7ZHKg05VS85/1rK95NU=;
	h=Date:To:From:Subject:From;
	b=cHzIZQCg1ALlM44OtgoXSDFLu/csnlZcj2htz7dcnp+4lYr+cKgVv2EHycXuBMCy9
	 nGEdL9EDvba1Ppy9Ztt115k7umIR0UCib0JOpCAFCW0/pHD7nCEFNivbEVGBVNZyeP
	 8IBalpzICfwq8N0OX6gjnM+C1ArO7sfVQCNbdrL0=
Date: Wed, 05 Mar 2025 14:16:30 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,jackmanb@google.com,dev.jain@arm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-dont-fail-uffd-stress-if-too-many-cpus-fix.patch added to mm-unstable branch
Message-Id: <20250305221631.624EEC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-dont-fail-uffd-stress-if-too-many-cpus-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-dont-fail-uffd-stress-if-too-many-cpus-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-dont-fail-uffd-stress-if-too-many-cpus-fix.patch

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
Subject: selftests-mm-dont-fail-uffd-stress-if-too-many-cpus-fix
Date: Wed Mar  5 02:15:02 PM PST 2025

fix div-by-zero, per Brendan

Link: https://lkml.kernel.org/r/CA+i-1C2pn90pfB6qhuGV8ecUw3YKfg1b8tSTsXs4n_Rw6US9mA@mail.gmail.com
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-dont-fail-uffd-stress-if-too-many-cpus-fix
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -461,7 +461,7 @@ int main(int argc, char **argv)
 			       nr_cpus);
 		nr_threads = 32;
 	} else {
-		nr_cpus = nr_threads;
+		nr_threads = nr_cpus;
 	}
 
 	nr_pages_per_cpu = bytes / page_size / nr_threads;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch
userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix.patch
mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params-fix.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus-fix.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
mm-mremap-initial-refactor-of-move_vma-fix.patch
mm-mremap-thread-state-through-move-page-table-operation-fix.patch
mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch
resource-fix-resource-leak-in-get_free_mem_region-fix.patch

