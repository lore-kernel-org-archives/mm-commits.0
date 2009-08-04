From: akpm@linux-foundation.org
Subject: + documentation-update-stale-definition-of-file-nr-in-fstxt.patch added to -mm tree
Date: Tue, 04 Aug 2009 00:43:57 -0700
Message-ID: <200908040743.n747hv37007278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932493AbZHDHoX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 03:44:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dfeng@redhat.com, randy.dunlap@oracle.com


The patch titled
     Documentation: update stale definition of file-nr in fs.txt
has been added to the -mm tree.  Its filename is
     documentation-update-stale-definition-of-file-nr-in-fstxt.patch

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
