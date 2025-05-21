Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7692C2222C8
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846607; cv=none; b=M8OkDlwDBHeIWADFVV0YaMIu2y1gRM/mEQqhqQyCooR4+70otgJAcEyX1i0MkJWanfXdYQ1XA1gEQOPEJPNkQVC53YTSyQTR7AxebeuOFLpDTg9UsJz7mlIW/0hgs7ejrLDWtwg80NhQngViJMBUjH2oMP/HJxZ9BEc4AWfadmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846607; c=relaxed/simple;
	bh=ap4m2Klk83ZMLAOi3lys7D7CpGselBt/R/5YbyyFRPQ=;
	h=Date:To:From:Subject:Message-Id; b=ak+cyRcVWZO9wUaB1LU97NT/GJK+KKXtfy960wbBCIAVTRV09P0CTuh/fjAhEzFmvY1Fh0iKJ6WUWJLpRydfz3dllAmPjUnNfS48lFeGHVh5oxWJu9U1AQCP4uaueurUMptdXms9xmJDpFVOWiVk8Qhynp16V5VSmISre2xuMic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b6hc+/SV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b6hc+/SV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25C7C4CEE4;
	Wed, 21 May 2025 16:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846606;
	bh=ap4m2Klk83ZMLAOi3lys7D7CpGselBt/R/5YbyyFRPQ=;
	h=Date:To:From:Subject:From;
	b=b6hc+/SVXS8dJrM+yDbov4X3aYnFDDR1bnovvDisEi4ntFUnXDamOBexwEvWoWnFO
	 yqXV57dlGbif3ca4CYoH5nT8eiRfOFgjYcdBhmILuuJ9EVLTKw7JFCt7vA3+BQoaDZ
	 ITVbpCuSol/dXNoevNfIxTAXOVw92GQINY/LqcfE=
Date: Wed, 21 May 2025 09:56:45 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,iii@linux.ibm.com,elver@google.com,dvyukov@google.com,bvanassche@acm.org,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-apply-clang-format-to-files-mm-kmsan.patch removed from -mm tree
Message-Id: <20250521165646.B25C7C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: apply clang-format to files mm/kmsan/
has been removed from the -mm tree.  Its filename was
     kmsan-apply-clang-format-to-files-mm-kmsan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: apply clang-format to files mm/kmsan/
Date: Wed, 7 May 2025 18:00:08 +0200

KMSAN source files are expected to be formatted with clang-format, fix
some nits that slipped in.  No functional change.

Link: https://lkml.kernel.org/r/20250507160012.3311104-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Bart van Assche <bvanassche@acm.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Macro Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/core.c   |    4 ++--
 mm/kmsan/hooks.c  |    4 +---
 mm/kmsan/init.c   |    3 +--
 mm/kmsan/shadow.c |    3 +--
 4 files changed, 5 insertions(+), 9 deletions(-)

--- a/mm/kmsan/core.c~kmsan-apply-clang-format-to-files-mm-kmsan
+++ a/mm/kmsan/core.c
@@ -159,8 +159,8 @@ depot_stack_handle_t kmsan_internal_chai
 	 * Make sure we have enough spare bits in @id to hold the UAF bit and
 	 * the chain depth.
 	 */
-	BUILD_BUG_ON(
-		(1 << STACK_DEPOT_EXTRA_BITS) <= (KMSAN_MAX_ORIGIN_DEPTH << 1));
+	BUILD_BUG_ON((1 << STACK_DEPOT_EXTRA_BITS) <=
+		     (KMSAN_MAX_ORIGIN_DEPTH << 1));
 
 	extra_bits = stack_depot_get_extra_bits(id);
 	depth = kmsan_depth_from_eb(extra_bits);
--- a/mm/kmsan/hooks.c~kmsan-apply-clang-format-to-files-mm-kmsan
+++ a/mm/kmsan/hooks.c
@@ -114,9 +114,7 @@ void kmsan_kfree_large(const void *ptr)
 	kmsan_enter_runtime();
 	page = virt_to_head_page((void *)ptr);
 	KMSAN_WARN_ON(ptr != page_address(page));
-	kmsan_internal_poison_memory((void *)ptr,
-				     page_size(page),
-				     GFP_KERNEL,
+	kmsan_internal_poison_memory((void *)ptr, page_size(page), GFP_KERNEL,
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
 }
--- a/mm/kmsan/init.c~kmsan-apply-clang-format-to-files-mm-kmsan
+++ a/mm/kmsan/init.c
@@ -35,8 +35,7 @@ static void __init kmsan_record_future_s
 	KMSAN_WARN_ON(future_index == NUM_FUTURE_RANGES);
 	KMSAN_WARN_ON((nstart >= nend) ||
 		      /* Virtual address 0 is valid on s390. */
-		      (!IS_ENABLED(CONFIG_S390) && !nstart) ||
-		      !nend);
+		      (!IS_ENABLED(CONFIG_S390) && !nstart) || !nend);
 	nstart = ALIGN_DOWN(nstart, PAGE_SIZE);
 	nend = ALIGN(nend, PAGE_SIZE);
 
--- a/mm/kmsan/shadow.c~kmsan-apply-clang-format-to-files-mm-kmsan
+++ a/mm/kmsan/shadow.c
@@ -207,8 +207,7 @@ void kmsan_free_page(struct page *page,
 	if (!kmsan_enabled || kmsan_in_runtime())
 		return;
 	kmsan_enter_runtime();
-	kmsan_internal_poison_memory(page_address(page),
-				     page_size(page),
+	kmsan_internal_poison_memory(page_address(page), page_size(page),
 				     GFP_KERNEL,
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
_

Patches currently in -mm which might be from glider@google.com are


