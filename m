Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150C6335082
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025874; cv=none; b=dn92YC1eaU4xXk7g1gaq0a6bmft698WyvlPn7dUjfzW5zCFySrNqhMiqSASBMg2yR3pkSIOF5rDUmo6A0DjMrKH7XBXSJ1nnM0x6fPQjyhny3UG7sQ0FH0n8+Tsd1HioVZiZW1ka52IxxlvUf+YV48j7waGUIQNQX4Hs5aH55Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025874; c=relaxed/simple;
	bh=uk2TV+jKMlCEtHHBCN2QqW8WC0dIQ2pauR1Yc84Hnvo=;
	h=Date:To:From:Subject:Message-Id; b=Mw028enF1wnOsdP6a8c/tJ4FrxwJ+ATQGa0WSdmxe37dJC7sliYyx1VFDeBgjbdePQWY1k7iegdGSiC1rcha2vuBU0CoaFSQClfUEFJGtOaWb6NKJ83lQtLKhvwxPlaKHVZZaNMWMdo/NkzJ9Vj2NakwMiqfi/PoxnJ9iySfg98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fg/6TCit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fg/6TCit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2BBC4CEF1;
	Mon, 24 Nov 2025 23:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025874;
	bh=uk2TV+jKMlCEtHHBCN2QqW8WC0dIQ2pauR1Yc84Hnvo=;
	h=Date:To:From:Subject:From;
	b=Fg/6TCitdWXhkZfnd0/zotLlRWPeDU6dmE9NngchYp5CqcwSw16GC55qQ7J24fJSn
	 csfZSLW8LRg6nb7uTejPhqeA9E5uVSSbUXNsvthaz/cNTva2/ySTDE9wTNA5GD1K6d
	 kNIPHSXAiSx1C4cbsc+zSg8HgEfK3Mcms88ZijBw=
Date: Mon, 24 Nov 2025 15:11:13 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch removed from -mm tree
Message-Id: <20251124231113.DE2BBC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/vma: add missing stub
has been removed from the -mm tree.  Its filename was
     tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/vma: add missing stub
Date: Fri, 21 Nov 2025 17:25:18 +0000

vm_flags_reset() is not available in the userland VMA tests, so add a stub
which const-casts vma->vm_flags and avoids the upcoming removal of the
vma->__vm_flags field.

Link: https://lkml.kernel.org/r/4aff8bf7-d367-4ba3-90ad-13eef7a063fa@lucifer.local
Fixes: c5c67c1de357 ("tools/testing/vma: eliminate dependency on vma->__vm_flags")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/vma_internal.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/vma/vma_internal.h~tools-testing-vma-eliminate-dependency-on-vma-__vm_flags
+++ a/tools/testing/vma/vma_internal.h
@@ -1549,4 +1549,11 @@ static inline int do_munmap(struct mm_st
 	return 0;
 }
 
+static inline void vm_flags_reset(struct vm_area_struct *vma, vm_flags_t flags)
+{
+	vm_flags_t *dst = (vm_flags_t *)(&vma->vm_flags);
+
+	*dst = flags;
+}
+
 #endif	/* __MM_VMA_INTERNAL_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


