From: akpm@linux-foundation.org
Subject: +
 mm-improve-the-description-for-dirty_background_ratio-dirty_ratio-sysctl.patch added to -mm tree
Date: Mon, 04 Nov 2013 13:44:48 -0800
Message-ID: <52781550.fL2B1/6DlgmzU2pb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab3KDVot (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 16:44:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, wenqing.lz@taobao.com

Subject: + mm-improve-the-description-for-dirty_background_ratio-dirty_ratio-sysctl.patch added to -mm tree
To: wenqing.lz@taobao.com,rob@landley.net
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 13:44:48 -0800


The patch titled
     Subject: mm: improve the description for dirty_background_ratio/dirty_ratio sysctl
has been added to the -mm tree.  Its filename is
     mm-improve-the-description-for-dirty_background_ratio-dirty_ratio-sysctl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-improve-the-description-for-dirty_background_ratio-dirty_ratio-sysctl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-improve-the-description-for-dirty_background_ratio-dirty_ratio-sysctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zheng Liu <wenqing.lz@taobao.com>
Subject: mm: improve the description for dirty_background_ratio/dirty_ratio sysctl

Now dirty_background_ratio/dirty_ratio contains a percentage of total
avaiable memory, which contains free pages and reclaimable pages.  The
number of these pages is not equal to the number of total system memory. 
But they are described as a percentage of total system memory in
Documentation/sysctl/vm.txt.  So we need to fix them to avoid
misunderstanding.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-improve-the-description-for-dirty_background_ratio-dirty_ratio-sysctl Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-improve-the-description-for-dirty_background_ratio-dirty_ratio-sysctl
+++ a/Documentation/sysctl/vm.txt
@@ -119,8 +119,11 @@ other appears as 0 when read.
 
 dirty_background_ratio
 
-Contains, as a percentage of total system memory, the number of pages at which
-the background kernel flusher threads will start writing out dirty data.
+Contains, as a percentage of total available memory that contains free pages
+and reclaimable pages, the number of pages at which the background kernel
+flusher threads will start writing out dirty data.
+
+The total avaiable memory is not equal to total system memory.
 
 ==============================================================
 
@@ -151,9 +154,11 @@ interval will be written out next time a
 
 dirty_ratio
 
-Contains, as a percentage of total system memory, the number of pages at which
-a process which is generating disk writes will itself start writing out dirty
-data.
+Contains, as a percentage of total available memory that contains free pages
+and reclaimable pages, the number of pages at which a process which is
+generating disk writes will itself start writing out dirty data.
+
+The total avaiable memory is not equal to total system memory.
 
 ==============================================================
 
_

Patches currently in -mm which might be from wenqing.lz@taobao.com are

mm-improve-the-description-for-dirty_background_ratio-dirty_ratio-sysctl.patch

