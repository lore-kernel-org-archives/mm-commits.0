Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4042D3727
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 17:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773078385; cv=none; b=BnwP8JO+ok3yGxt+bFpo2vTf5tYJxZx5G1QRboXJSAspLvGeoaclKhIUMdV/P8x6vtVqqRcClCh4huGwClTrLZMv1O7feMt4y/JPWHKRJFAV/ndTMEnItcGRR+h4X4LYZK25Ng3SUworXIn9in9PIj0GB2tPPn1nHUIGMLYpKoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773078385; c=relaxed/simple;
	bh=mKXU+EYRRMu+XQOpAUZtHZlOS57P20OP/wzU9P762pE=;
	h=Date:To:From:Subject:Message-Id; b=B4iifxSAQGKDUYD+TgV+vCNCqT1vaCoIWcjsMTLwzxnQLp6NMyJA8YHqfmmhQlbaRkE5i7d5fORUK9pv0kvr+2jTMzCQpuc7Buz8nG4jg3CRBm7M3mCA8ULSGbRULewvH2g4g1EK2DU1USnh4p7zhBqo81Tx78sAgRpQz4zbFkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KSrBKfyq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KSrBKfyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943C2C4CEF7;
	Mon,  9 Mar 2026 17:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773078384;
	bh=mKXU+EYRRMu+XQOpAUZtHZlOS57P20OP/wzU9P762pE=;
	h=Date:To:From:Subject:From;
	b=KSrBKfyqBs2r6t2YbHTpMl1Kp2r4kYvi2sbPVO4L9WBaPKBwRGdl8hzAjp+6codg+
	 zDKZ4BwJFz+tn3fFUKihTynq+I3iApOQ1vxE6OITN7KJEtRoLOlNl3I5j1xMvdBv+C
	 GwCidAf5CWXIGwXsMBkesUSb1Ej1KjSPd/TW2nrc=
Date: Mon, 09 Mar 2026 10:46:24 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,nathan@kernel.org,morbo@google.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,justinstitt@google.com,david.laight.linux@gmail.com,david@kernel.org,qq570070308@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug-optimize-once-judgment-with-clang.patch added to mm-new branch
Message-Id: <20260309174624.943C2C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/debug: optimize once judgment with clang
has been added to the -mm mm-new branch.  Its filename is
     mm-debug-optimize-once-judgment-with-clang.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug-optimize-once-judgment-with-clang.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Xie Yuanbin <qq570070308@gmail.com>
Subject: mm/debug: optimize once judgment with clang
Date: Mon, 9 Mar 2026 23:34:05 +0800

commit 242b872239f6a7deacbc ("include/linux/once_lite.h: fix judgment in
WARN_ONCE with clang") helps optimize performance and size under the clang
compiler, but the modification is not complete.

Port the modification to VM_WARN_ON_ONCE_PAGE(), VM_WARN_ON_ONCE_FOLIO(),
VM_WARN_ON_ONCE_MM() and VM_WARN_ON_ONCE_VMA().

Link: https://lkml.kernel.org/r/20260309153405.20130-1-qq570070308@gmail.com
Signed-off-by: Xie Yuanbin <qq570070308@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Bill Wendling <morbo@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/mmdebug.h~mm-debug-optimize-once-judgment-with-clang
+++ a/include/linux/mmdebug.h
@@ -60,7 +60,7 @@ void vma_iter_dump_tree(const struct vma
 	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
-	if (unlikely(__ret_warn_once && !__warned)) {			\
+	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
 		dump_page(page, "VM_WARN_ON_ONCE_PAGE(" __stringify(cond)")");\
 		__warned = true;					\
 		WARN_ON(1);						\
@@ -80,7 +80,7 @@ void vma_iter_dump_tree(const struct vma
 	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
-	if (unlikely(__ret_warn_once && !__warned)) {			\
+	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
 		dump_page(&folio->page, "VM_WARN_ON_ONCE_FOLIO(" __stringify(cond)")");\
 		__warned = true;					\
 		WARN_ON(1);						\
@@ -91,7 +91,7 @@ void vma_iter_dump_tree(const struct vma
 	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
-	if (unlikely(__ret_warn_once && !__warned)) {			\
+	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
 		dump_mm(mm);						\
 		__warned = true;					\
 		WARN_ON(1);						\
@@ -102,7 +102,7 @@ void vma_iter_dump_tree(const struct vma
 	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
-	if (unlikely(__ret_warn_once && !__warned)) {			\
+	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
 		dump_vma(vma);						\
 		__warned = true;					\
 		WARN_ON(1);						\
_

Patches currently in -mm which might be from qq570070308@gmail.com are

mm-optimize-the-implementation-of-warn_on_once_gfp.patch
mm-debug-optimize-once-judgment-with-clang.patch

