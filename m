Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D3419DFAB
	for <mm-commits@vger.kernel.org>; Sun, 21 Dec 2025 00:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766276753; cv=none; b=fKBJMq3Hn5NEzDLe+2FGuPA4LMJkZxv+eVUDoE59gKvXSneiQ9eAr2vW4DDY7zDXRzBK29/uLY4BXcegnkggi1HSu4mLDDo65QzMHaN/3jyff6cFbUpXuuu4lkaPO9fmBFUoZuMDJ7h54k/0jF/YDqxK/TDhUmtsobH7IwIFySs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766276753; c=relaxed/simple;
	bh=UoO+u5Pm7ZNkhxdA8pBnBGhHsudaI6vA0XihZyoc+Z4=;
	h=Date:To:From:Subject:Message-Id; b=kz+OV+dEm/BC2gflgXkUWHxVnTwxwxmn63usSJaYmGPVpXIToPIEfucALthqJbZIudOJkY9zyX6uXU6wmVD4JxZM7HmnG/tpfngzB9tL3UiQ3DAkzcglKm24328Zpnlxj+Lw17gK2ZpmIpor1d1Dk48O1hkw1Cf93XOqTyah68M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2FsMpGOc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2FsMpGOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBC2C4CEF5;
	Sun, 21 Dec 2025 00:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766276752;
	bh=UoO+u5Pm7ZNkhxdA8pBnBGhHsudaI6vA0XihZyoc+Z4=;
	h=Date:To:From:Subject:From;
	b=2FsMpGOcLUZ7oa4xJdzGKX+LLPO0aFUH2a5ngfm0bhuSDMws9tvpn97wGJon+uKUf
	 y9TVjFdhuVYUPVTs7kX98Q9e6Wd2I2k2oLvlP0j43y77PPgd83Z/lEJV+7Czqe4NZs
	 l1GP9MFAsypFEepp+OMH8xEPW29Yxm0Ic3PV2ZFo=
Date: Sat, 20 Dec 2025 16:25:52 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,bagasdotme@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-fix-up-vrealloc_node_align-kernel-doc-macro-name.patch added to mm-hotfixes-unstable branch
Message-Id: <20251221002552.DBBC2C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: fix up vrealloc_node_align() kernel-doc macro name
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-fix-up-vrealloc_node_align-kernel-doc-macro-name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-fix-up-vrealloc_node_align-kernel-doc-macro-name.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: mm: vmalloc: fix up vrealloc_node_align() kernel-doc macro name
Date: Fri, 19 Dec 2025 08:40:06 +0700

Sphinx reports kernel-doc warning:

WARNING: ./mm/vmalloc.c:4284 expecting prototype for vrealloc_node_align_noprof(). Prototype was for vrealloc_node_align() instead

Fix the macro name in vrealloc_node_align_noprof() kernel-doc comment.

Link: https://lkml.kernel.org/r/20251219014006.16328-5-bagasdotme@gmail.com
Fixes: 4c5d3365882dbb ("mm/vmalloc: allow to set node and align in vrealloc")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-up-vrealloc_node_align-kernel-doc-macro-name
+++ a/mm/vmalloc.c
@@ -4248,7 +4248,7 @@ void *vzalloc_node_noprof(unsigned long
 EXPORT_SYMBOL(vzalloc_node_noprof);
 
 /**
- * vrealloc_node_align_noprof - reallocate virtually contiguous memory; contents
+ * vrealloc_node_align - reallocate virtually contiguous memory; contents
  * remain unchanged
  * @p: object to reallocate memory for
  * @size: the size to reallocate
_

Patches currently in -mm which might be from bagasdotme@gmail.com are

mm-describe-flags-parameter-in-memalloc_flags_save.patch
textsearch-describe-list-member-in-ts_ops-search.patch
mm-vmalloc-fix-up-vrealloc_node_align-kernel-doc-macro-name.patch
mm-kfence-describe-slab-parameter-in-__kfence_obj_info.patch

