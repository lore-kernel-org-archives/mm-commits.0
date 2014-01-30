From: akpm@linux-foundation.org
Subject: [merged] mm-document-improved-handling-of-swappiness==0.patch
 removed from -mm tree
Date: Thu, 30 Jan 2014 12:05:00 -0800
Message-ID: <52eab06c.Wzg+MeeTzaXqvLuw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbaA3UFB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jan 2014 15:05:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, satoru.moriya@hds.com, riel@redhat.com, rdunlap@infradead.org, bmr@redhat.com, atomlin@redhat.com

Subject: [merged] mm-document-improved-handling-of-swappiness==0.patch removed from -mm tree
To: atomlin@redhat.com,bmr@redhat.com,rdunlap@infradead.org,riel@redhat.com,satoru.moriya@hds.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 Jan 2014 12:05:00 -0800


The patch titled
     Subject: mm: document improved handling of swappiness==0
has been removed from the -mm tree.  Its filename was
     mm-document-improved-handling-of-swappiness==0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: remove comma, per Randy]
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
+initiate swap until the amount of free and file-backed pages is less
+than the high water mark in a zone.
 
 The default value is 60.
 
_

Patches currently in -mm which might be from atomlin@redhat.com are

origin.patch
linux-next.patch

