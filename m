From: akpm@linux-foundation.org
Subject: +
 mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix-2.patch added to -mm tree
Date: Fri, 20 Jan 2017 14:51:07 -0800
Message-ID: <5882945b.GfOhSTFF+m4eSXN7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34850 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752537AbdATWvJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2017 17:51:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imbrenda@linux.vnet.ibm.com, aarcange@redhat.com, borntraeger@de.ibm.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: documentation for coloured zero pages deduplication
has been added to the -mm tree.  Its filename is
     mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>
Subject: mm/ksm: documentation for coloured zero pages deduplication

This patch adds the needed documentation for the use_zero_pages property.

Link: http://lkml.kernel.org/r/1484927522-1964-1-git-send-email-imbrenda@linux.vnet.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/ksm.txt |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN Documentation/vm/ksm.txt~mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix-2 Documentation/vm/ksm.txt
--- a/Documentation/vm/ksm.txt~mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix-2
+++ a/Documentation/vm/ksm.txt
@@ -80,6 +80,20 @@ run              - set 0 to stop ksmd fr
                    Default: 0 (must be changed to 1 to activate KSM,
                                except if CONFIG_SYSFS is disabled)
 
+use_zero_pages   - specifies whether empty pages (i.e. allocated pages
+                   that only contain zeroes) should be treated specially.
+                   When set to 1, empty pages are merged with the kernel
+                   zero page(s) instead of with each other as it would
+                   happen normally. This can improve the performance on
+                   architectures with coloured zero pages, depending on
+                   the workload. Care should be taken when enabling this
+                   setting, as it can potentially degrade the performance
+                   of KSM for some workloads, for example if the checksums
+                   of pages candidate for merging match the checksum of
+                   an empty page. This setting can be changed at any time,
+                   it is only effective for pages merged after the change.
+                   Default: 0 (normal KSM behaviour as in earlier releases)
+
 The effectiveness of KSM and MADV_MERGEABLE is shown in /sys/kernel/mm/ksm/:
 
 pages_shared     - how many shared pages are being used
_

Patches currently in -mm which might be from imbrenda@linux.vnet.ibm.com are

mm-ksm-improve-deduplication-of-zero-pages-with-colouring.patch
mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix-2.patch

