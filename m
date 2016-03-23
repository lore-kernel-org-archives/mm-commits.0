From: akpm@linux-foundation.org
Subject: [merged]
 staging-lustre-switch-from-is_compat_task-to-in_compat_syscall.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:40:43 -0700
Message-ID: <56f2d51b.5HnAyfthJY6H/E4k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbcCWRkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:40:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, adilger.kernel@dilger.ca, oleg.drokin@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: staging/lustre: switch from is_compat_task to in_compat_syscall
has been removed from the -mm tree.  Its filename was
     staging-lustre-switch-from-is_compat_task-to-in_compat_syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: staging/lustre: switch from is_compat_task to in_compat_syscall

AFAICT, lustre is trying to determine syscall bitness.  Use the new
accessor.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lustre/llite/llite_internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/lustre/lustre/llite/llite_internal.h~staging-lustre-switch-from-is_compat_task-to-in_compat_syscall drivers/staging/lustre/lustre/llite/llite_internal.h
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h~staging-lustre-switch-from-is_compat_task-to-in_compat_syscall
+++ a/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -657,7 +657,7 @@ static inline int ll_need_32bit_api(stru
 #if BITS_PER_LONG == 32
 	return 1;
 #elif defined(CONFIG_COMPAT)
-	return unlikely(is_compat_task() || (sbi->ll_flags & LL_SBI_32BIT_API));
+	return unlikely(in_compat_syscall() || (sbi->ll_flags & LL_SBI_32BIT_API));
 #else
 	return unlikely(sbi->ll_flags & LL_SBI_32BIT_API);
 #endif
_

Patches currently in -mm which might be from luto@kernel.org are


