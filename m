From: akpm@linux-foundation.org
Subject: + doc-add-the-documentation-for-mpol=local.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:10:51 -0700
Message-ID: <201003192310.o2JNAqhx017630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695Ab0CSXMc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:12:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kiran@scalex86.org, lee.schermerhorn@hp.com, mel@csn.ul.ie, stable@kernel.org


The patch titled
     doc: add the documentation for mpol=local
has been added to the -mm tree.  Its filename is
     doc-add-the-documentation-for-mpol=local.patch

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
Subject: doc: add the documentation for mpol=local
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 3f226aa1c (mempolicy: support mpol=local tmpfs mount option) added
new mpol=local mount option.  but it didn't add a documentation.

This patch does it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/tmpfs.txt |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/tmpfs.txt~doc-add-the-documentation-for-mpol=local Documentation/filesystems/tmpfs.txt
--- a/Documentation/filesystems/tmpfs.txt~doc-add-the-documentation-for-mpol=local
+++ a/Documentation/filesystems/tmpfs.txt
@@ -82,11 +82,13 @@ tmpfs has a mount option to set the NUMA
 all files in that instance (if CONFIG_NUMA is enabled) - which can be
 adjusted on the fly via 'mount -o remount ...'
 
-mpol=default             prefers to allocate memory from the local node
+mpol=default             use the process allocation policy
+                         (see set_mempolicy(2))
 mpol=prefer:Node         prefers to allocate memory from the given Node
 mpol=bind:NodeList       allocates memory only from nodes in NodeList
 mpol=interleave          prefers to allocate from each node in turn
 mpol=interleave:NodeList allocates from each node of NodeList in turn
+mpol=local		 prefers to allocate memory from the local node
 
 NodeList format is a comma-separated list of decimal numbers and ranges,
 a range being two hyphen-separated decimal numbers, the smallest and
@@ -134,3 +136,5 @@ Author:
    Christoph Rohland <cr@sap.com>, 1.12.01
 Updated:
    Hugh Dickins, 4 June 2007
+Updated:
+   KOSAKI Motohiro, 16 Mar 2010
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
tmpfs-fix-oops-on-mounts-with-mpol=default.patch
tmpfs-mpol=bind-0-dont-cause-mount-error.patch
tmpfs-handle-mpol_local-mount-option-properly.patch
tmpfs-cleanup-mpol_parse_str.patch
doc-add-the-documentation-for-mpol=local.patch
mm-remove-return-value-of-putback_lru_pages.patch
mempolicy-remove-redundant-code.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists-fix.patch
proc-cleanup-remove-unused-assignments.patch
reiser4.patch

