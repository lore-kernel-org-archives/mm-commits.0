From: akpm@linux-foundation.org
Subject: [merged]
 documentation-update-the-default-value-of-crashkernel-low.patch removed
 from -mm tree
Date: Mon, 28 Sep 2015 11:16:15 -0700
Message-ID: <560983ef.6DRY4VppAmb+GoOb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbbI1SQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 14:16:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, corbet@lwn.net, jroedel@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/kernel-parameters.txt: update the default value of crashkernel low
has been removed from the -mm tree.  Its filename was
     documentation-update-the-default-value-of-crashkernel-low.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: Documentation/kernel-parameters.txt: update the default value of crashkernel low

In 94fb9334182284e8e7e4 ("x86/crash: Allocate enough low memory when
crashkernel=high") the default value of crashkernel low memory is changed
to 256M.  In this patch update it accordingly.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN Documentation/kernel-parameters.txt~documentation-update-the-default-value-of-crashkernel-low Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~documentation-update-the-default-value-of-crashkernel-low
+++ a/Documentation/kernel-parameters.txt
@@ -789,8 +789,10 @@ bytes respectively. Such letter suffixes
 			is passed, kernel could allocate physical memory region
 			above 4G, that cause second kernel crash on system
 			that require some amount of low memory, e.g. swiotlb
-			requires at least 64M+32K low memory.  Kernel would
-			try to allocate 72M below 4G automatically.
+			requires at least 64M+32K low memory, also enough extra
+			low memory is needed to make sure DMA buffers for 32-bit
+			devices won't run out. Kernel would try to allocate at
+			at least 256M below 4G automatically.
 			This one let user to specify own low range under 4G
 			for second kernel instead.
 			0: to disable low allocation.
_

Patches currently in -mm which might be from bhe@redhat.com are


