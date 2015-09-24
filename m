From: akpm@linux-foundation.org
Subject: + documentation-update-the-default-value-of-crashkernel-low.patch added to -mm tree
Date: Thu, 24 Sep 2015 14:01:24 -0700
Message-ID: <560464a4.c69IUUXpa9Y3SQm1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbbIXVBZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Sep 2015 17:01:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, corbet@lwn.net, jroedel@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/kernel-parameters.txt: update the default value of crashkernel low
has been added to the -mm tree.  Its filename is
     documentation-update-the-default-value-of-crashkernel-low.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-update-the-default-value-of-crashkernel-low.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-update-the-default-value-of-crashkernel-low.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

documentation-update-the-default-value-of-crashkernel-low.patch

