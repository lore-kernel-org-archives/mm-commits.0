From: akpm@linux-foundation.org
Subject: + mm-document-improved-handling-of-swappiness==0.patch added to
 -mm tree
Date: Fri, 24 Jan 2014 12:31:42 -0800
Message-ID: <52e2cdae.gNIQHKY+NibmsF55%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaAXUbn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 15:31:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, satoru.moriya@hds.com, riel@redhat.com, rdunlap@infradead.org, bmr@redhat.com, atomlin@redhat.com

Subject: + mm-document-improved-handling-of-swappiness==0.patch added to -mm tree
To: atomlin@redhat.com,bmr@redhat.com,rdunlap@infradead.org,riel@redhat.com,satoru.moriya@hds.com
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 12:31:42 -0800


The patch titled
     Subject: mm: document improved handling of swappiness==0
has been added to the -mm tree.  Its filename is
     mm-document-improved-handling-of-swappiness==0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-document-improved-handling-of-swappiness==0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-document-improved-handling-of-swappiness==0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aaron Tomlin <atomlin@redhat.com>
Subject: mm: document improved handling of swappiness==0

Prior to fe35004fbf9ea ("mm: avoid swapping out with swappiness==0")
setting swappiness to 0, reclaim code could still evict recently used user
anonymous memory to swap even though there is a significant amount of RAM
used for page cache.

The behaviour of setting swappiness to 0 has since changed.  When set, the
reclaim code does not initiate swap until the amount of free pages and
file-backed pages, is less than the high water mark in a zone.

Let's update the documentation to reflect this.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Bryn M. Reeves <bmr@redhat.com>
Cc: Satoru Moriya <satoru.moriya@hds.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN Documentation/sysctl/vm.txt~mm-document-improved-handling-of-swappiness==0 Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-document-improved-handling-of-swappiness==0
+++ a/Documentation/sysctl/vm.txt
@@ -696,7 +696,9 @@ swappiness
 
 This control is used to define how aggressive the kernel will swap
 memory pages.  Higher values will increase agressiveness, lower values
-decrease the amount of swap.
+decrease the amount of swap.  A value of 0 instructs the kernel not to
+initiate swap until the amount of free and file-backed pages, is less
+than the high water mark in a zone.
 
 The default value is 60.
 
_

Patches currently in -mm which might be from atomlin@redhat.com are

mm-document-improved-handling-of-swappiness==0.patch
mm-document-improved-handling-of-swappiness==0-fix.patch

