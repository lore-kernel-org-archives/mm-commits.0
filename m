Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A1F23F27B
	for <mm-commits@vger.kernel.org>; Sun, 14 Dec 2025 23:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765754763; cv=none; b=AiWDZjCJ/dey/VRgG+Pe1veZBc902kMU00ktjLzsIT1IPL/2Ds9l3IamLAPSwpUYL+bCTukOKEWFysfDJFKWzuy4n91Ei3MtTRcUyxI4rCRa1ZTO8FyUr+bsKCfd3T13JTNNWesBZsMU2D/AD8y6kYPrGnRy8Oo9VtjPrVq6mgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765754763; c=relaxed/simple;
	bh=ytIvRCGVAErhhGZTkK0F22cG14yoSDn0gygX7FDAHWQ=;
	h=Date:To:From:Subject:Message-Id; b=W5Dn3ZBwwxzkH+Ub3QPlx8kVvwKi9SVJ02xtHys1lQb0pwed07DVqLplsmOxXgVy5f2TjHInJE1jM+3F8lNkxEpjKY6r9cOXu43AAu2/5wJ2+K4bY4hb3QVe6ROnduL/h545itR4P4Ic98PANDzZt4RNXbnTTQGoY4fERRvT1kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=on3WkIcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="on3WkIcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4A3C4CEF1;
	Sun, 14 Dec 2025 23:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765754762;
	bh=ytIvRCGVAErhhGZTkK0F22cG14yoSDn0gygX7FDAHWQ=;
	h=Date:To:From:Subject:From;
	b=on3WkIccy5SamSDM6d0EdZmJbiCRVMuzrlwSTMhlInuKkrdy66GSUnAQ8NvttdeJr
	 KC3n6eQSghwW4qM68rjMcbAnH9dbhlKHF2l9erLv22Hj9P2AdfGDYFEcCoPvUB+PJ2
	 pNsNKLj9DUCmeEEivI9rICDCD7g+cq7fUC4xjZYE=
Date: Sun, 14 Dec 2025 15:26:01 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-leafopsh-correct-kernel-doc-function-param-names.patch added to mm-hotfixes-unstable branch
Message-Id: <20251214232602.8D4A3C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: leafops.h: correct kernel-doc function param. names
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-leafopsh-correct-kernel-doc-function-param-names.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-leafopsh-correct-kernel-doc-function-param-names.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: leafops.h: correct kernel-doc function param. names
Date: Sun, 14 Dec 2025 12:15:17 -0800

Modify the kernel-doc function parameter names to prevent kernel-doc
warnings:

Warning: include/linux/leafops.h:135 function parameter 'entry' not
 described in 'leafent_type'
Warning: include/linux/leafops.h:540 function parameter 'pte' not
 described in 'pte_is_uffd_marker'

Link: https://lkml.kernel.org/r/20251214201517.2187051-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/leafops.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/leafops.h~mm-leafopsh-correct-kernel-doc-function-param-names
+++ a/include/linux/leafops.h
@@ -133,7 +133,7 @@ static inline bool softleaf_is_none(soft
 
 /**
  * softleaf_type() - Identify the type of leaf entry.
- * @enntry: Leaf entry.
+ * @entry: Leaf entry.
  *
  * Returns: the leaf entry type associated with @entry.
  */
@@ -534,7 +534,7 @@ static inline bool pte_is_uffd_wp_marker
 /**
  * pte_is_uffd_marker() - Does this PTE entry encode a userfault-specific marker
  * leaf entry?
- * @entry: Leaf entry.
+ * @pte: PTE entry.
  *
  * It's useful to be able to determine which leaf entries encode UFFD-specific
  * markers so we can handle these correctly.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-leafopsh-correct-kernel-doc-function-param-names.patch

