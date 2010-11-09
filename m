From: akpm@linux-foundation.org
Subject: [merged] kernel-profilec-use-vzalloc.patch removed from -mm tree
Date: Tue, 09 Nov 2010 10:54:02 -0800
Message-ID: <201011091856.oA9IuHfb000979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754495Ab0KIS5F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Nov 2010 13:57:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jj@chaosbits.net, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kernel/profile.c: use vzalloc()
has been removed from the -mm tree.  Its filename was
     kernel-profilec-use-vzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/profile.c: use vzalloc()
From: Jesper Juhl <jj@chaosbits.net>

There's no reason to memset() manually when we have vzalloc().

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc:  Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/profile.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/profile.c~kernel-profilec-use-vzalloc kernel/profile.c
--- a/kernel/profile.c~kernel-profilec-use-vzalloc
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

Patches currently in -mm which might be from jj@chaosbits.net are

origin.patch
linux-next.patch
memcg-use-zalloc-rather-than-mallocmemset.patch

