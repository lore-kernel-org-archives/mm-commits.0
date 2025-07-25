Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24BE25DAFC
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 23:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753485460; cv=none; b=kO/x5KZoKF7wD9CQ4UMyaqdZ+acaQeMXBuxvvINYeqZ2J5G7xOAH2767fN+el9mU67jSvTceafedYiku6COgoRecXlJ/r3opWxu2R6qnvOstcaBXcnnpiESkNDYsB7t78u2v0ubc5rdjgmmXhg76knlk+ct2HAPjRnH6loR/xKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753485460; c=relaxed/simple;
	bh=1S0lDnJ7cZjwqcJWcXlFNt/YovD+xes0UYPrIGNuaQQ=;
	h=Date:To:From:Subject:Message-Id; b=sAyp1q87axIagGv9JWzXHNQdoTCTI6jjioeJEM72POTSfh94coqytoXoYyfw/U4gHtiPmkcqh+5V74Q/tu0S2rHLCyeHaIAeCttQrZpgQbi9sxpkN0tKSIOf6P6aeE6cWOJ8jNAiFgJ23UzO0SBBVFnAYhEdIHHA2dXRJZTWeK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gimxk1jO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gimxk1jO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E63FC4CEE7;
	Fri, 25 Jul 2025 23:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753485458;
	bh=1S0lDnJ7cZjwqcJWcXlFNt/YovD+xes0UYPrIGNuaQQ=;
	h=Date:To:From:Subject:From;
	b=Gimxk1jO2vuewxpUao3PweYld4GDh2KKsRqrYrTVu63CYwYslOQI/+Nuzf34fSQpM
	 uAbKOrGbBOEaagY3g0Pp0gU8+e3mkfyGxminyKZoia7DVF/asM6c90I74V38cpefUZ
	 7XNmeOH1wZjDhIvpwNgqSLGB0Pbfz5j4AJaeMt2E=
Date: Fri, 25 Jul 2025 16:17:37 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-mm-io-mappingc-fix.patch added to mm-new branch
Message-Id: <20250725231738.2E63FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-remove-mm-io-mappingc-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-mm-io-mappingc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-mm-io-mappingc-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm-remove-mm-io-mappingc-fix
Date: Fri Jul 25 04:14:00 PM PDT 2025

update Documentation/core-api/mm-api.rst, per Vlastimil

Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/core-api/mm-api.rst~mm-remove-mm-io-mappingc-fix
+++ a/Documentation/core-api/mm-api.rst
@@ -139,4 +139,3 @@ More Memory Management Functions
 .. kernel-doc:: mm/mmu_notifier.c
 .. kernel-doc:: mm/balloon_compaction.c
 .. kernel-doc:: mm/huge_memory.c
-.. kernel-doc:: mm/io-mapping.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix-fix.patch
mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin-fix.patch
selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation-checkpatch-fixes.patch
mm-rmap-add-anon_vma-lifetime-debug-check-fix.patch
mm-remove-mm-io-mappingc-fix.patch
init-kconfig-restore-config_broken-help-text.patch

