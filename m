Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B24326D44
	for <mm-commits@vger.kernel.org>; Tue, 21 Jul 2026 17:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655821; cv=none; b=lw8Y+phPLPCv5IBcHLHwJq3V9DNX7TXCz6ILiOzGc9C15LArV62Yj8iSI1WDSsK92jyjVn4+xHpvKkfiibuPIDPZZtVh99MBJvcjI01FH8NQmPeJl0XcbK5xOEVySVBA0NDb+2Zo0bZxbrWGrKZFNpwoKVIPK+5usfHidlwggjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655821; c=relaxed/simple;
	bh=WZG1p2Rxj2ewDzH3uKRcplHkrta+1iSJmtoaVQYNQas=;
	h=Date:To:From:Subject:Message-Id; b=TnhFB+9ZXBAgruEdkm+lIs34NG4CzsdBWARRZ1lqE/7L/EDFsaO9IeQT8GyDqMzYt8BLbT+t5M00yzFh9hDwZEk5F5l1Bak71/M+FXyx/D2R9xN3b+Gviuc+XfqlsHsrr5TLbEBHV2nGF/TwAnG4Bd3y1DElAFOgHPkjGs6D8ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xKp4k1eF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xKp4k1eF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BF21F000E9;
	Tue, 21 Jul 2026 17:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784655820;
	bh=B88y6/W6rxgnQ4X08kJ52wgs94IJgc5LL7zUMWWlYjo=;
	h=Date:To:From:Subject;
	b=xKp4k1eF0NEgpjVjTfSl+hOVGsCG0MZttpY1p/3vANbDY8UX2HK78I05XWH75mEVC
	 vi5Q83IkvjB8BYd2oQj4QVrh7i5ymt53wuz+cwahnnkVkqv4ndn8X9Vqpzf4vBzThG
	 5ujByQkTi/YbGbg6x/AwT7Uel3/BeEtG+RhTTL8k=
Date: Tue, 21 Jul 2026 10:43:39 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,david@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-physical-memory-remove-deferred_split_queue.patch added to mm-unstable branch
Message-Id: <20260721174340.09BF21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs/mm: Physical Memory: remove deferred_split_queue
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-physical-memory-remove-deferred_split_queue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-physical-memory-remove-deferred_split_queue.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: docs/mm: Physical Memory: remove deferred_split_queue
Date: Tue, 21 Jul 2026 19:19:19 +0800

deferred_split_queue was removed from struct pglist_data {} in commit
fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru").  Remove
its description in doc as well.

Link: https://lore.kernel.org/20260721111919.22923-1-zenghui.yu@linux.dev
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/physical_memory.rst |    3 ---
 1 file changed, 3 deletions(-)

--- a/Documentation/mm/physical_memory.rst~docs-mm-physical-memory-remove-deferred_split_queue
+++ a/Documentation/mm/physical_memory.rst
@@ -262,9 +262,6 @@ General
   PFN that needs to be initialized. Defined only when
   ``CONFIG_DEFERRED_STRUCT_PAGE_INIT`` is enabled
 
-``deferred_split_queue``
-  Per-node queue of huge pages that their split was deferred. Defined only when ``CONFIG_TRANSPARENT_HUGEPAGE`` is enabled.
-
 ``__lruvec``
   Per-node lruvec holding LRU lists and related parameters. Used only when
   memory cgroups are disabled. It should not be accessed directly, use
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

tools-mm-add-thp_swap_allocator_test-binary-to-gitignore.patch
maintainers-add-abi-docs-and-selftests-to-zram-entry.patch
docs-mm-physical-memory-remove-deferred_split_queue.patch

