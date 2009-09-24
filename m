From: akpm@linux-foundation.org
Subject: [merged] documentation-update-stale-definition-of-file-nr-in-fstxt.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:33:39 -0700
Message-ID: <200909241933.n8OJXd2u029219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754097AbZIXTeK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:34:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dfeng@redhat.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Documentation: update stale definition of file-nr in fs.txt
has been removed from the -mm tree.  Its filename was
     documentation-update-stale-definition-of-file-nr-in-fstxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation: update stale definition of file-nr in fs.txt
From: Xiaotian Feng <dfeng@redhat.com>

commit 760df9 merged /proc/sys/fs documentation in Documentation/sysctl/
fs.txt and Documentation/filesystem/proc.txt, but stale file-nr definition
is remained. This patch add back the right fs-nr definition for 2.6 kernel.

Signed-off-by: Xiaotian Feng<dfeng@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/fs.txt |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN Documentation/sysctl/fs.txt~documentation-update-stale-definition-of-file-nr-in-fstxt Documentation/sysctl/fs.txt
--- a/Documentation/sysctl/fs.txt~documentation-update-stale-definition-of-file-nr-in-fstxt
+++ a/Documentation/sysctl/fs.txt
@@ -96,13 +96,16 @@ handles that the Linux kernel will alloc
 of error messages about running out of file handles, you might
 want to increase this limit.
 
-The three values in file-nr denote the number of allocated
-file handles, the number of unused file handles and the maximum
-number of file handles. When the allocated file handles come
-close to the maximum, but the number of unused file handles is
-significantly greater than 0, you've encountered a peak in your 
-usage of file handles and you don't need to increase the maximum.
