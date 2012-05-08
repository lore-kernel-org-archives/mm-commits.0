From: akpm@linux-foundation.org
Subject: + kernel-resourcec-correct-the-comment-of-allocate_resource.patch added to -mm tree
Date: Tue, 08 May 2012 16:30:15 -0700
Message-ID: <20120508233015.8FD0DA03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:64009 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab2EHXaR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 19:30:17 -0400
Received: by werf13 with SMTP id f13so38626wer.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 16:30:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyang@linux.vnet.ibm.com


The patch titled
     Subject: kernel/resource.c: correct the comment of allocate_resource()
has been added to the -mm tree.  Its filename is
     kernel-resourcec-correct-the-comment-of-allocate_resource.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: kernel/resource.c: correct the comment of allocate_resource()

In the comment of allocate_resource(), the explanation of parameter max
and min is not correct.

Actually, these two parameters are used to specify the range of the
resource that will be allocated, not the min/max size that will be
allocated.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/resource.c~kernel-resourcec-correct-the-comment-of-allocate_resource kernel/resource.c
--- a/kernel/resource.c~kernel-resourcec-correct-the-comment-of-allocate_resource
+++ a/kernel/resource.c
@@ -515,8 +515,8 @@ out:
  * @root: root resource descriptor
  * @new: resource descriptor desired by caller
  * @size: requested resource region size
- * @min: minimum size to allocate
- * @max: maximum size to allocate
+ * @min: minimum boundary to allocate
+ * @max: maximum boundary to allocate
  * @align: alignment requested, in bytes
  * @alignf: alignment function, optional, called if not NULL
  * @alignf_data: arbitrary data to pass to the @alignf function
_
Subject: Subject: kernel/resource.c: correct the comment of allocate_resource()

Patches currently in -mm which might be from weiyang@linux.vnet.ibm.com are

kernel-resourcec-correct-the-comment-of-allocate_resource.patch

