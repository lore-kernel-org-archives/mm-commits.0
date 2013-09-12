From: akpm@linux-foundation.org
Subject: [merged] fix-mistake-in-the-description-of-committed_as.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:48:31 -0700
Message-ID: <52321a8f.inPJ4x28wCVBZ6uC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587Ab3ILTsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:48:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mvaliyav@redhat.com

Subject: [merged] fix-mistake-in-the-description-of-committed_as.patch removed from -mm tree
To: mvaliyav@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:48:31 -0700


The patch titled
     Subject: Documentation/filesystems/proc.txt: fix mistake in the description of Committed_AS
has been removed from the -mm tree.  Its filename was
     fix-mistake-in-the-description-of-committed_as.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minto Joseph <mvaliyav@redhat.com>
Subject: Documentation/filesystems/proc.txt: fix mistake in the description of Committed_AS

Fix mistake in the description of Committed_AS in kernel documentation.

Signed-off-by: Minto Joseph <mvaliyav@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN Documentation/filesystems/proc.txt~fix-mistake-in-the-description-of-committed_as Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~fix-mistake-in-the-description-of-committed_as
+++ a/Documentation/filesystems/proc.txt
@@ -854,16 +854,15 @@ Committed_AS: The amount of memory prese
               The committed memory is a sum of all of the memory which
               has been allocated by processes, even if it has not been
               "used" by them as of yet. A process which malloc()'s 1G
-              of memory, but only touches 300M of it will only show up
-              as using 300M of memory even if it has the address space
-              allocated for the entire 1G. This 1G is memory which has
-              been "committed" to by the VM and can be used at any time
-              by the allocating application. With strict overcommit
-              enabled on the system (mode 2 in 'vm.overcommit_memory'),
-              allocations which would exceed the CommitLimit (detailed
-              above) will not be permitted. This is useful if one needs
-              to guarantee that processes will not fail due to lack of
-              memory once that memory has been successfully allocated.
+              of memory, but only touches 300M of it will show up as
+	      using 1G. This 1G is memory which has been "committed" to
+              by the VM and can be used at any time by the allocating
+              application. With strict overcommit enabled on the system
+              (mode 2 in 'vm.overcommit_memory'),allocations which would
+              exceed the CommitLimit (detailed above) will not be permitted.
+              This is useful if one needs to guarantee that processes will
+              not fail due to lack of memory once that memory has been
+              successfully allocated.
 VmallocTotal: total size of vmalloc memory area
  VmallocUsed: amount of vmalloc area which is used
 VmallocChunk: largest contiguous block of vmalloc area which is free
_

Patches currently in -mm which might be from mvaliyav@redhat.com are

origin.patch

