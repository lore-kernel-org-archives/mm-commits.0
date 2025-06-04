Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC0B1624C5
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 19:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749065532; cv=none; b=tc2K0l2T8AEd3eQ+eZk/Z5QF3abr3+2VUJnfsY89vFyUcpsS9n7i6xR8K+f9108hkBibavPKP5B+lUF9wJR4lzDOOVrx9aOwjO7HzICNT0Ji/mW8IPTTk5dKwTRQFWCcv25dc0kgsD+2bCs9SkmPghLcvxQnTDG1tKOLLavLGYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749065532; c=relaxed/simple;
	bh=KnnSVVWTvbVViIUS82Mk5nlgLvwaSAgOru/+M19CA5U=;
	h=Date:To:From:Subject:Message-Id; b=h/iYN+dyvfJ/omQMyOgoM8aKiGBTn8zEvE/+avCw6IfFESH3MUJ8fbG3TqI1b16ZSE5CXJbyVKlu5I2hjd8vYwVnqbaxY0O1ZeZYJ0jMW5IiUb23jYot2lR4MBlB5vJVxFqXK4VVvdtgQB7s9zHP4J+4uxJI8HkNmOt+AURCT7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EVTfVSsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EVTfVSsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B7FC4CEE4;
	Wed,  4 Jun 2025 19:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749065532;
	bh=KnnSVVWTvbVViIUS82Mk5nlgLvwaSAgOru/+M19CA5U=;
	h=Date:To:From:Subject:From;
	b=EVTfVSsRBZXwwWy5ZNk/JZsnZqiHVh8ZktbvvLa2oWg1v9tzSUO/odqoyHQ2qO632
	 ymtDX21ZruJpGGdfB5g9G5LojdFH+XnMJuaOScNDamJQkOBJm5zgclrrOby30l1O24
	 QsFPX0zOFBM4RNyZPE+Kbi/9AogDs2+vR461J1S4=
Date: Wed, 04 Jun 2025 12:32:11 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-mm-swap-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250604193212.23B7FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add mm swap section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-mm-swap-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-mm-swap-section.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add mm swap section
Date: Wed, 4 Jun 2025 17:31:39 +0100

In furtherance of ongoing efforts to ensure people are aware of who
de-facto maintains/has an interest in specific parts of mm, as well trying
to avoid get_maintainers.pl listing only Andrew and the mailing list for
mm files - establish a swap memory management section and add relevant
maintainers/reviewers.

Link: https://lkml.kernel.org/r/20250604163139.126630-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Kairui Song <kasong@tencent.com>
Acked-by: Kemeng Shi <shikemeng@huaweicloud.com>
Acked-by: Baoquan He <bhe@redhat.com>
Acked-by: Barry Song <baohua@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/MAINTAINERS~maintainers-add-mm-swap-section
+++ a/MAINTAINERS
@@ -15816,6 +15816,25 @@ S:	Maintained
 F:	include/linux/secretmem.h
 F:	mm/secretmem.c
 
+MEMORY MANAGEMENT - SWAP
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Kemeng Shi <shikemeng@huaweicloud.com>
+R:	Kairui Song <kasong@tencent.com>
+R:	Nhat Pham <nphamcs@gmail.com>
+R:	Baoquan He <bhe@redhat.com>
+R:	Barry Song <baohua@kernel.org>
+R:	Chris Li <chrisl@kernel.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	include/linux/swap.h
+F:	include/linux/swapfile.h
+F:	include/linux/swapops.h
+F:	mm/page_io.c
+F:	mm/swap.c
+F:	mm/swap.h
+F:	mm/swap_state.c
+F:	mm/swapfile.c
+
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@redhat.com>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

kvm-s390-rename-prot_none-to-prot_type_dummy.patch
maintainers-add-mm-swap-section.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch

