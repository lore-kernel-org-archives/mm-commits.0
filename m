Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0F434B19F
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 19:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517845; cv=none; b=RNRmWV5V+dr1/uuBrV3cAPmF5PfhG3/jNg3dNjtdmKN6o1FINVarfF963l0ZEjrDP0Jl40Pp3baPMh9lE7x3bFcVGmJgb8KD263pOkuwIV6ObAqL5+aZCDsVqU6kh5DN+r50ewQ3Wq0hraoFdTQvnY6pS1U5HG6twKuQJPHGSC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517845; c=relaxed/simple;
	bh=KHud6YPl9Mf1kKz1atkz+Cy/jwnWgixcqTugvCM5opE=;
	h=Date:To:From:Subject:Message-Id; b=qIgjiHJFKuHMDMqyZ4xMhyKt5AVPzZAOSQRo1PFW/qCDtb36fpVAX7578iczflgEZfdNQ/pd9RWFJenNsyg3sWFBKRSzsiEtANpwpvuVTY8Ccue9U/1sf90EaMnFhlcCPWnSj6SIw2zWaZ/vikXereeKkNJjpTagSeTJKOaMHOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UyxlCamX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UyxlCamX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790EFC113D0;
	Tue, 23 Dec 2025 19:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517845;
	bh=KHud6YPl9Mf1kKz1atkz+Cy/jwnWgixcqTugvCM5opE=;
	h=Date:To:From:Subject:From;
	b=UyxlCamXrIfXQW9ih8aycLhUfH6udPGoCvuthQBzGr3hn/EYnxUGXpf58KClAwF+I
	 2ghEtqlWmEE1l9FAYsGwUmMBtcH8oDOODnO9kEtIEsOyZji6vVxIth5voJPShzZqzP
	 tBTtypBeOj7ie9sx2CebOrpR320lcdJZp+x7/Cf4=
Date: Tue, 23 Dec 2025 11:24:04 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-leafopsh-correct-kernel-doc-function-param-names.patch removed from -mm tree
Message-Id: <20251223192405.790EFC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: leafops.h: correct kernel-doc function param. names
has been removed from the -mm tree.  Its filename was
     mm-leafopsh-correct-kernel-doc-function-param-names.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
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

kernelh-drop-hexh-and-update-all-hexh-users.patch
kfifo-fix-kmalloc_array_node-argument-order.patch

