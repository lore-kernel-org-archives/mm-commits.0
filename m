Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077C3747F
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 06:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686450; cv=none; b=OPDx7JWhP/U/To8eZVGFz927mhoQtP5Lo7Xsi4fy+1DCGpcT2L2qNoBmbb4N4OOCItOi3pPMiRQCCH0fgb0ZGuHBH7iNv/qkTnolMKFUvaJ5rWJN50jDuzMxknRfUrtVdUxHDQq6jWhEangKOiQcoBPtLLcd73ZYJ9huIE0eE7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686450; c=relaxed/simple;
	bh=1d+w4c3oQYmoGxc+OtKlAn8iJCuQR8bDooksPVgHd6U=;
	h=Date:To:From:Subject:Message-Id; b=ndWi8VO4viR3XRVm64aHU5T2w9lQWfgjnH7LWUXV5EnGc3oxCF0N5N87A+e8rMf4yL0Ey8trII2nol000YTirRIp/pH00ZP9wADIHmuhQjF5OBTPBTLxg4iWxqTvQaVfpipSbDabcam0B3eef4Xe7+DriPFF9HYBv8uQ9AOQhVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JyaRmoNh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JyaRmoNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CD4C4CEEB;
	Thu,  8 May 2025 06:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746686449;
	bh=1d+w4c3oQYmoGxc+OtKlAn8iJCuQR8bDooksPVgHd6U=;
	h=Date:To:From:Subject:From;
	b=JyaRmoNhvjZbU+aeQCc3Z2oCKjr2REaApX0V4HnXVsBz6KKJsp4p+nUAyEA3cFlSP
	 WxZzSuIFvS9ePAF+fy9+RKlWcGUJB50DTtNZ3GUxfNJeasGWPpRkYz4tQwn1I9LZ7A
	 6ZwxQ9e/eEQo6uZryGpkXojq8HZ2JmH7CIvb2qUg=
Date: Wed, 07 May 2025 23:40:49 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,Liam.Howlett@oracle.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-core-mm-section.patch removed from -mm tree
Message-Id: <20250508064049.B1CD4C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add core mm section
has been removed from the -mm tree.  Its filename was
     maintainers-add-core-mm-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add core mm section
Date: Wed, 23 Apr 2025 13:30:42 +0100

In furtherance of ongoing efforts to ensure people are aware of who
de-facto maintains/has an interest in specific parts of mm, as well trying
to avoid get_maintainers.pl listing only Andrew and the mailing list for
mm files - establish a 'core' memory management section establishing David
as co-maintainer alongside Andrew (thanks David for volunteering!) along
with a number of relevant reviewers.

We try to keep things as fine-grained as possible, so we place only
obviously 'general' mm things here.  For files which are specific to a
particular part of mm, we prefer new entries.

Link: https://lkml.kernel.org/r/20250423123042.59082-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/MAINTAINERS~maintainers-add-core-mm-section
+++ a/MAINTAINERS
@@ -15494,14 +15494,11 @@ F:	Documentation/mm/
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
 F:	include/linux/memfd.h
-F:	include/linux/memory.h
 F:	include/linux/memory_hotplug.h
 F:	include/linux/memory-tiers.h
 F:	include/linux/mempolicy.h
 F:	include/linux/mempool.h
 F:	include/linux/memremap.h
-F:	include/linux/mm.h
-F:	include/linux/mm_*.h
 F:	include/linux/mmzone.h
 F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
@@ -15511,6 +15508,31 @@ F:	tools/mm/
 F:	tools/testing/selftests/mm/
 N:	include/linux/page[-_]*
 
+MEMORY MANAGEMENT - CORE
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@redhat.com>
+R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Mike Rapoport <rppt@kernel.org>
+R:	Suren Baghdasaryan <surenb@google.com>
+R:	Michal Hocko <mhocko@suse.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/memory.h
+F:	include/linux/mm.h
+F:	include/linux/mm_*.h
+F:	include/linux/mmdebug.h
+F:	include/linux/pagewalk.h
+F:	mm/Kconfig
+F:	mm/debug.c
+F:	mm/init-mm.c
+F:	mm/memory.c
+F:	mm/pagewalk.c
+F:	mm/util.c
+
 MEMORY MANAGEMENT - EXECMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-mm-gup-section.patch
mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch
mm-move-mmap-vma-locking-logic-into-specific-files.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality.patch
mm-abstract-initial-stack-setup-to-mm-subsystem.patch
mm-move-dup_mmap-to-mm.patch
mm-perform-vma-allocation-freeing-duplication-in-mm.patch
mm-introduce-new-mmap_prepare-file-callback.patch
mm-secretmem-convert-to-mmap_prepare-hook.patch
mm-vma-remove-mmap-retry-merge.patch

