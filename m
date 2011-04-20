From: akpm@linux-foundation.org
Subject: + kernel-profilec-use-vzalloc-instead-of-vmallocmemset.patch added to -mm tree
Date: Wed, 20 Apr 2011 14:29:53 -0700
Message-ID: <201104202129.p3KLTrus028214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123Ab1DTV35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 17:29:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, mingo@elte.hu


The patch titled
     kernel/profile.c: use vzalloc instead of vmalloc+memset
has been added to the -mm tree.  Its filename is
     kernel-profilec-use-vzalloc-instead-of-vmallocmemset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
kernel-profilec-use-vzalloc-instead-of-vmallocmemset.patch

