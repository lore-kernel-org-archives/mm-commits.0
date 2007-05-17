From: akpm@linux-foundation.org
Subject: + avoid-zero-size-allocation-in-cache_k8_northbridges.patch added to -mm tree
Date: Thu, 17 May 2007 11:47:05 -0700
Message-ID: <200705171847.l4HIl5Lh030308@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48811 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756146AbXEQSuQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 14:50:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben.collins@ubuntu.com, ak@suse.de, bcollins@ubuntu.com, davej@codemonkey.org.uk


The patch titled
     Avoid zero size allocation in cache_k8_northbridges()
has been added to the -mm tree.  Its filename is
     avoid-zero-size-allocation-in-cache_k8_northbridges.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Avoid zero size allocation in cache_k8_northbridges()
From: Ben Collins <ben.collins@ubuntu.com>

kmalloc for flush_words resulted in zero size allocation when no
k8_northbridges existed.  Short circuit the code path for this case.

Also remove uneeded zeroing of num_k8_northbridges just after checking if
it is zero.

Signed-off-by: Ben Collins <bcollins@ubuntu.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/k8.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/k8.c~avoid-zero-size-allocation-in-cache_k8_northbridges arch/x86_64/kernel/k8.c
--- a/arch/x86_64/kernel/k8.c~avoid-zero-size-allocation-in-cache_k8_northbridges
+++ a/arch/x86_64/kernel/k8.c
@@ -39,10 +39,10 @@ int cache_k8_northbridges(void)
 {
 	int i;
 	struct pci_dev *dev;
+
 	if (num_k8_northbridges)
 		return 0;
 
-	num_k8_northbridges = 0;
 	dev = NULL;
 	while ((dev = next_k8_northbridge(dev)) != NULL)
 		num_k8_northbridges++;
@@ -52,6 +52,11 @@ int cache_k8_northbridges(void)
 	if (!k8_northbridges)
 		return -ENOMEM;
 
+	if (!num_k8_northbridges) {
+		k8_northbridges[0] = NULL;
+		return 0;
+	}
+
 	flush_words = kmalloc(num_k8_northbridges * sizeof(u32), GFP_KERNEL);
 	if (!flush_words) {
 		kfree(k8_northbridges);
_

Patches currently in -mm which might be from ben.collins@ubuntu.com are

avoid-zero-size-allocation-in-cache_k8_northbridges.patch
