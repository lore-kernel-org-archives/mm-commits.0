From: akpm@linux-foundation.org
Subject: [merged] kernel-profilec-use-vzalloc-instead-of-vmallocmemset.patch removed from -mm tree
Date: Tue, 24 May 2011 11:55:23 -0700
Message-ID: <201105241853.p4OIruKQ008433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752563Ab1EXTDh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 15:03:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kernel/profile.c: use vzalloc instead of vmalloc+memset
has been removed from the -mm tree.  Its filename was
     kernel-profilec-use-vzalloc-instead-of-vmallocmemset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/profile.c: use vzalloc instead of vmalloc+memset
From: Rakib Mullick <rakib.mullick@gmail.com>

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/profile.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/profile.c~kernel-profilec-use-vzalloc-instead-of-vmallocmemset kernel/profile.c
--- a/kernel/profile.c~kernel-profilec-use-vzalloc-instead-of-vmallocmemset
+++ a/kernel/profile.c
@@ -126,11 +126,9 @@ int __ref profile_init(void)
 	if (prof_buffer)
 		return 0;
 
-	prof_buffer = vmalloc(buffer_bytes);
-	if (prof_buffer) {
-		memset(prof_buffer, 0, buffer_bytes);
+	prof_buffer = vzalloc(buffer_bytes);
+	if (prof_buffer)
 		return 0;
-	}
 
 	free_cpumask_var(prof_cpu_mask);
 	return -ENOMEM;
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

origin.patch
drivers-char-mspecc-use-kvzalloc-to-allocate-memory.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch

