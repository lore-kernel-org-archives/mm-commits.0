Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40EB2F3C1C
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 22:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892166; cv=none; b=op/KFKuOTtJRcx9CedVey1w1BvtTSrJq1Vy3AWNn2F1N/okqVZ3rBnGzYN+Vb2DBBxNpxj8dNAnpkfo2v3PtowM9TcymSMFZWarijITE2j3UukD3HT8Y6nwrGrKTBflooaUN6gnFOONQ98ddezRFm11shHPgikjXfZyO9OrJlXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892166; c=relaxed/simple;
	bh=jlvXq+9+udpNJWynFgWT7hJCaL8STLyCBUf2kD+RrlU=;
	h=Date:To:From:Subject:Message-Id; b=F5GAAviatQY/1omq8Ix/96f4TO5sKZSZht1X8AuNVkyXRclcRYwmzBULNJ1cBP4HNkEKVhDM3r7jGfvqYB2u6QhnlpFaSgIX/ou8umtP3/aJV+GPoxEwSOI3lXdO8KWLE5ywK94s5ebgI1sXihFonjxfLiH5UXipIzTE1XDduOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aFg21SzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aFg21SzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0D6C4CEEA;
	Wed, 25 Jun 2025 22:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750892165;
	bh=jlvXq+9+udpNJWynFgWT7hJCaL8STLyCBUf2kD+RrlU=;
	h=Date:To:From:Subject:From;
	b=aFg21SzLHq/j2dos5v4xygs2ch0t3wq96EVcQybp9zkuyRtGAqZvFE62NRggHjQWO
	 sQTjCoDZ6bSYCjq0ZD/DZ5CMt0UMDq9fCHdup0A5oZC8L0F/mIsk3ZWh2T0dZgPHpj
	 7oFcHjYnbloEO3sQ4B9KJhDGNxqeAPexLilNizTw=
Date: Wed, 25 Jun 2025 15:56:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,osalvador@suse.de,npache@redhat.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-myself-as-thp-co-maintainer.patch removed from -mm tree
Message-Id: <20250625225605.CD0D6C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Lorenzo as THP co-maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-thp-co-maintainer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add Lorenzo as THP co-maintainer
Date: Wed, 25 Jun 2025 10:52:31 +0100

I am doing a great deal of review and getting ever more involved in THP
with intent to do more so in future also, so add myself as co-maintainer
to help David with workload.

Link: https://lkml.kernel.org/r/20250625095231.42874-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Dev Jain <dev.jain@arm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-add-myself-as-thp-co-maintainer
+++ a/MAINTAINERS
@@ -15945,9 +15945,9 @@ F:	mm/swapfile.c
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@redhat.com>
+M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
-R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Nico Pache <npache@redhat.com>
 R:	Ryan Roberts <ryan.roberts@arm.com>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas-fix.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-use-per_vma-lock-for-madv_dontneed-fix.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch
mm-update-core-kernel-code-to-use-vm_flags_t-consistently.patch
mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch
mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch
mm-maps-read-proc-pid-maps-under-per-vma-lock-fix.patch

