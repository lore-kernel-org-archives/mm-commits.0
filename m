From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-selftest-only-warn-if-__nr_userfaultfd-is-undefined.patch
 removed from -mm tree
Date: Mon, 28 Sep 2015 11:15:46 -0700
Message-ID: <560983d2.Bh538DzE95k3J+mH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37756 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295AbbI1SPr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 14:15:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpe@ellerman.id.au, aarcange@redhat.com, dgilbert@redhat.com, shuahkh@osg.samsung.com, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: selftest: only warn if __NR_userfaultfd is undefined
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftest-only-warn-if-__nr_userfaultfd-is-undefined.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: userfaultfd: selftest: only warn if __NR_userfaultfd is undefined

If __NR_userfaultfd is not yet defined by the arch, warn but still
build and run the userfaultfd selftest successfully.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-only-warn-if-__nr_userfaultfd-is-undefined tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-only-warn-if-__nr_userfaultfd-is-undefined
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -66,9 +66,7 @@
 #include <pthread.h>
 #include <linux/userfaultfd.h>
 
-#ifndef __NR_userfaultfd
-#error "missing __NR_userfaultfd definition"
-#endif
+#ifdef __NR_userfaultfd
 
 static unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size;
 
@@ -631,3 +629,15 @@ int main(int argc, char **argv)
 	       nr_pages, nr_pages_per_cpu);
 	return userfaultfd_stress();
 }
+
+#else /* __NR_userfaultfd */
+
+#warning "missing __NR_userfaultfd definition"
+
+int main(void)
+{
+	printf("skip: Skipping userfaultfd test (missing __NR_userfaultfd)\n");
+	return 0;
+}
+
+#endif /* __NR_userfaultfd */
_

Patches currently in -mm which might be from mpe@ellerman.id.au are


