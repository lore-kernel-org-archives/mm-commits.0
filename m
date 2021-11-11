Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECD3C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 154F761208
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbhKKCpn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:45:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234183AbhKKCpn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:45:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFEE96113B;
        Thu, 11 Nov 2021 02:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598575;
        bh=YxaPRzhHCzILv/cccGOiBOebaez1xcQsoAn7GS3EBWY=;
        h=Date:From:To:Subject:From;
        b=fF9m0q9x9R/WJz11Nh3o6DWW7c+XzRzWfG2h2vFVHrAfQdqhWozXGqq7kFy1NUj/a
         zX2wZZi+NzO2wqx6AL06/jPXa0YIIyPMi9KCLK88TVtUaeh0rUMcTANPNhPV0lEnIB
         Jc7v7ZR+h7hzQODxnCNkhItdSwKCEUC9lSuw8d+s=
Date:   Wed, 10 Nov 2021 18:42:54 -0800
From:   akpm@linux-foundation.org
To:     carl.waldspurger@nutanix.com, corbet@lwn.net, david@redhat.com,
        florian.schmidt@nutanix.com, ivan.teterevkov@nutanix.com,
        jonathan.davies@nutanix.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, tiberiu.georgescu@nutanix.com
Subject:  [merged]
 documentation-update-pagemap-with-shmem-exceptions.patch removed from -mm
 tree
Message-ID: <20211111024254.nkflEz00t%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: update pagemap with shmem exceptions
has been removed from the -mm tree.  Its filename was
     documentation-update-pagemap-with-shmem-exceptions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tiberiu A Georgescu <tiberiu.georgescu@nutanix.com>
Subject: Documentation: update pagemap with shmem exceptions

This patch follows the discussions on previous documentation patch threads
[1][2].  It presents the exception case of shared memory management from
the pagemap's point of view.  It briefly describes what is missing, why it
is missing and alternatives to the pagemap for page info retrieval in user
space.

In short, the kernel does not keep track of PTEs for swapped out shared
pages within the processes that references them.  Thus, the
proc/pid/pagemap tool cannot print the swap destination of the shared
memory pages, instead setting the pagemap entry to zero for both
non-allocated and swapped out pages.  This can create confusion for users
who need information on swapped out pages.

The reasons why maintaining the PTEs of all swapped out shared pages among
all processes while maintaining similar performance is not a trivial task,
or a desirable change, have been discussed extensively [1][3][4][5]. 
There are also arguments for why this arguably missing information should
eventually be exposed to the user in either a future pagemap patch, or by
an alternative tool.

[1]: https://marc.info/?m=162878395426774
[2]: https://lore.kernel.org/lkml/20210920164931.175411-1-tiberiu.georgescu@nutanix.com/
[3]: https://lore.kernel.org/lkml/20210730160826.63785-1-tiberiu.georgescu@nutanix.com/
[4]: https://lore.kernel.org/lkml/20210807032521.7591-1-peterx@redhat.com/
[5]: https://lore.kernel.org/lkml/20210715201651.212134-1-peterx@redhat.com/


Mention the current missing information in the pagemap and alternatives on
how to retrieve it, in case someone stumbles upon unexpected behaviour.

Link: https://lkml.kernel.org/r/20210923064618.157046-1-tiberiu.georgescu@nutanix.com
Link: https://lkml.kernel.org/r/20210923064618.157046-2-tiberiu.georgescu@nutanix.com
Signed-off-by: Tiberiu A Georgescu <tiberiu.georgescu@nutanix.com>
Reviewed-by: Ivan Teterevkov <ivan.teterevkov@nutanix.com>
Reviewed-by: Florian Schmidt <florian.schmidt@nutanix.com>
Reviewed-by: Carl Waldspurger <carl.waldspurger@nutanix.com>
Reviewed-by: Jonathan Davies <jonathan.davies@nutanix.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/pagemap.rst |   22 +++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/Documentation/admin-guide/mm/pagemap.rst~documentation-update-pagemap-with-shmem-exceptions
+++ a/Documentation/admin-guide/mm/pagemap.rst
@@ -196,6 +196,28 @@ you can go through every map in the proc
 in kpagecount, and tally up the number of pages that are only referenced
 once.
 
+Exceptions for Shared Memory
+============================
+
+Page table entries for shared pages are cleared when the pages are zapped or
+swapped out. This makes swapped out pages indistinguishable from never-allocated
+ones.
+
+In kernel space, the swap location can still be retrieved from the page cache.
+However, values stored only on the normal PTE get lost irretrievably when the
+page is swapped out (i.e. SOFT_DIRTY).
+
+In user space, whether the page is present, swapped or none can be deduced with
+the help of lseek and/or mincore system calls.
+
+lseek() can differentiate between accessed pages (present or swapped out) and
+holes (none/non-allocated) by specifying the SEEK_DATA flag on the file where
+the pages are backed. For anonymous shared pages, the file can be found in
+``/proc/pid/map_files/``.
+
+mincore() can differentiate between pages in memory (present, including swap
+cache) and out of memory (swapped out or none/non-allocated).
+
 Other notes
 ===========
 
_

Patches currently in -mm which might be from tiberiu.georgescu@nutanix.com are


