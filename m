Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A09262FD9
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 23:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486028; cv=none; b=fY0H0kXnmsTm0eJvtRjpR8jN1gZfw3K88NJvk7pYJNpybyz6BKYClogxcjfsFX9DZzrlxCaiJ+A3X60t+lOHom4pmycXeG1jJiQpA9s1B+iKMPU4VN8tSZaQx8G7BYR8Q3uAvmjg1Feum/z9m41whvWVNDJbfTY79dlxKOdrFUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486028; c=relaxed/simple;
	bh=ayvKWHzKa2+tO9Wqgqus6Bms8HAiNPQ/LEN16YWqAAE=;
	h=Date:To:From:Subject:Message-Id; b=tw+yJWaGzPnxJeMm271Y1jwC/wkkhFPxz6zoWGGagArzcqaiT+V10bxoEYB/MGzuZrU9QSJWxXhdXu/E+RYns5bVol8bY8Ls/jQfDh1XhfzLkAsZGtULI0ulMDixA5EgdlqJRXf8iTQYkyuG4i6z8/sfJVu8CmEQHB5HUEb3jFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HAV2/k5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HAV2/k5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405AEC4CEF4;
	Fri, 25 Jul 2025 23:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753486028;
	bh=ayvKWHzKa2+tO9Wqgqus6Bms8HAiNPQ/LEN16YWqAAE=;
	h=Date:To:From:Subject:From;
	b=HAV2/k5iEsoZ6cABkul2HupbKm1vrYGM3gjJJApa4/KUo0SYE1yv89WSV0YzbZtx2
	 SEdnkD/mbBCOe3fFnxYBtXPm10IAffSqrmDsL5EbYios88FNJHY7QO58/lSkudpDZw
	 DjFzVgxgFyXiYB1ZIrPXgaIIfu19F9n46uWZfDO0=
Date: Fri, 25 Jul 2025 16:27:07 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mseal-simplify-and-rename-vma-gap-check-fix.patch added to mm-unstable branch
Message-Id: <20250725232708.405AEC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mseal: add comment explaining why we disallow gaps on mseal()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mseal-simplify-and-rename-vma-gap-check-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mseal-simplify-and-rename-vma-gap-check-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mseal: add comment explaining why we disallow gaps on mseal()
Date: Fri, 25 Jul 2025 19:23:50 +0100

This explains the semantics clearly, the 'why' of the situation.

Link: https://lkml.kernel.org/r/d85b3d55-09dc-43ba-8204-b48267a96751@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mseal.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/mseal.c~mm-mseal-simplify-and-rename-vma-gap-check-fix
+++ a/mm/mseal.c
@@ -38,6 +38,18 @@ out:
 }
 
 /*
+ * mseal() disallows an input range which contain unmapped ranges (VMA holes).
+ *
+ * It disallows unmapped regions from start to end whether they exist at the
+ * start, in the middle, or at the end of the range, or any combination thereof.
+ *
+ * This is because after sealng a range, there's nothing to stop memory mapping
+ * of ranges in the remaining gaps later, meaning that the user might then
+ * wrongly consider the entirety of the mseal()'d range to be sealed when it
+ * in fact isn't.
+ */
+
+/*
  * Does the [start, end) range contain any unmapped memory?
  *
  * We ensure that:
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch
maintainers-add-missing-interval_treec-to-memory-mapping-section.patch
maintainers-add-missing-mm_sloth-file-thp-section.patch
maintainers-add-missing-mm_sloth-file-thp-section-fix.patch
maintainers-move-memremap-to-hotplug-section.patch
maintainers-add-missing-shrinker-files.patch
maintainers-add-missing-files-to-page-alloc-section.patch
maintainers-add-missing-zsmalloc-file.patch
maintainers-add-mm-misc-section-add-missing-files-to-misc-and-core.patch
maintainers-add-missing-file-to-cgroup-section.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-simplify-and-rename-vma-gap-check-fix.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch

