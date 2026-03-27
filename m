Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A386C2652AF
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 02:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774577377; cv=none; b=hVVxLddR7YLPRMveQVWoqZbV04hT9ycvhSx0BFhHKkcn5SYf+ZfBHs0dRwBNLc5pnfxWY4dkQQRMb+jsi/Te+mcqMIz2zSmW9FDEFfrXoBmg3yb0Po1w/SGJx2oL2p8HbJOxRpTKdeZDQ8u+EXRlqkxia3h7UKWUuO+Qq/r8IIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774577377; c=relaxed/simple;
	bh=dHpwvVWBtA5AbF9giPoxE4xT7s+OZQqkLn7SEJeG3mM=;
	h=Date:To:From:Subject:Message-Id; b=bh4oGhnNb2IezNO/eeN/nz0ZO5ZbzC3e9DZQzQoEcl+zHn3OkFgxpWBEy2MC1q1AAiKCjUGEpVF2IMQJgStce1UELrw+aLv0/G5wNa8CM0OKqBMOkuAAzQmxQ6is8kbpm+0A6K9+KoVJ7nNTiiXtYouXJop9VI4+DL77mZ8TpZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E0Elc8yE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E0Elc8yE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D7AC2BCB2;
	Fri, 27 Mar 2026 02:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774577377;
	bh=dHpwvVWBtA5AbF9giPoxE4xT7s+OZQqkLn7SEJeG3mM=;
	h=Date:To:From:Subject:From;
	b=E0Elc8yE8dXdyNGaznrg+NxTDhEHxCMdunSaNaOkwpPDJwTUdzheri5LC11nJjQg9
	 ajhEnFujJcTf15Zi2G0p3RtoRdl2ezMd33GufThb7l8t0IvmtihzMqXWtFLAl4cvus
	 8gZ6NNBBAoetklb98jFo9OoDpqC77xdjk1DGGJG8=
Date: Thu, 26 Mar 2026 19:09:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,nathan@kernel.org,morbo@google.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,justinstitt@google.com,david.laight.linux@gmail.com,david@kernel.org,qq570070308@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-debug-optimize-once-judgment-with-clang.patch removed from -mm tree
Message-Id: <20260327020937.18D7AC2BCB2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/debug: optimize once judgment with clang
has been removed from the -mm tree.  Its filename was
     mm-debug-optimize-once-judgment-with-clang.patch

This patch was dropped because it was nacked

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

