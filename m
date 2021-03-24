Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AB8C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2209F619F2
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbhCXWfR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 18:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235337AbhCXWew (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 18:34:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EEA5619E4;
        Wed, 24 Mar 2021 22:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616625292;
        bh=GV0DU4k9BOG1qNM375CN+GlaOWo9Zg3up8XNP65j6rc=;
        h=Date:From:To:Subject:From;
        b=kuOFUK8v5Lhn+OmILbWyt0LHdF+L0cmoKpydsMVfexXHHF9CfX788gfHtEcreCEsp
         uAD4mybCx+CoewHHzdRCGueK7a05+B78kb/j1UmthCyqtR5rU/zifEs7LiIeTdcq66
         /1E6o/r8t/FqEOi7xLDH99FEIjq07IsBw95lme10=
Date:   Wed, 24 Mar 2021 15:34:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, sonnyrao@google.com,
        rppt@linux.vnet.ibm.com, peterx@redhat.com, mtk.manpages@gmail.com,
        mst@redhat.com, minchan@kernel.org, luto@amacapital.net,
        lokeshgidra@google.com, kirill@shutemov.name, hughd@google.com,
        dima@arista.com, axelrasmussen@google.com, alx.manpages@gmail.com,
        aarcange@redhat.com, bgeffon@google.com
Subject:  + selftests-add-a-mremap_dontunmap-selftest-for-shmem.patch
 added to -mm tree
Message-ID: <20210324223451.X8Rn9%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: add a MREMAP_DONTUNMAP selftest for shmem
has been added to the -mm tree.  Its filename is
     selftests-add-a-mremap_dontunmap-selftest-for-shmem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-add-a-mremap_dontunmap-selftest-for-shmem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-add-a-mremap_dontunmap-selftest-for-shmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Brian Geffon <bgeffon@google.com>
Subject: selftests: add a MREMAP_DONTUNMAP selftest for shmem

This test extends the current mremap tests to validate that the
MREMAP_DONTUNMAP operation can be performed on shmem mappings.

Link: https://lkml.kernel.org/r/20210323182520.2712101-3-bgeffon@google.com
Signed-off-by: Brian Geffon <bgeffon@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Dmitry Safonov <dima@arista.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Alejandro Colomar <alx.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mremap_dontunmap.c |   52 ++++++++++++++++
 1 file changed, 52 insertions(+)

--- a/tools/testing/selftests/vm/mremap_dontunmap.c~selftests-add-a-mremap_dontunmap-selftest-for-shmem
+++ a/tools/testing/selftests/vm/mremap_dontunmap.c
@@ -127,6 +127,57 @@ static void mremap_dontunmap_simple()
 	       "unable to unmap source mapping");
 }
 
+// This test validates that MREMAP_DONTUNMAP on a shared mapping works as expected.
+static void mremap_dontunmap_simple_shmem()
+{
+	unsigned long num_pages = 5;
+
+	int mem_fd = memfd_create("memfd", MFD_CLOEXEC);
+	BUG_ON(mem_fd < 0, "memfd_create");
+
+	BUG_ON(ftruncate(mem_fd, num_pages * page_size) < 0,
+			"ftruncate");
+
+	void *source_mapping =
+	    mmap(NULL, num_pages * page_size, PROT_READ | PROT_WRITE,
+		 MAP_FILE | MAP_SHARED, mem_fd, 0);
+	BUG_ON(source_mapping == MAP_FAILED, "mmap");
+
+	BUG_ON(close(mem_fd) < 0, "close");
+
+	memset(source_mapping, 'a', num_pages * page_size);
+
+	// Try to just move the whole mapping anywhere (not fixed).
+	void *dest_mapping =
+	    mremap(source_mapping, num_pages * page_size, num_pages * page_size,
+		   MREMAP_DONTUNMAP | MREMAP_MAYMOVE, NULL);
+	if (dest_mapping == MAP_FAILED && errno == EINVAL) {
+		// Old kernel which doesn't support MREMAP_DONTUNMAP on shmem.
+		BUG_ON(munmap(source_mapping, num_pages * page_size) == -1,
+			"unable to unmap source mapping");
+		return;
+	}
+
+	BUG_ON(dest_mapping == MAP_FAILED, "mremap");
+
+	// Validate that the pages have been moved, we know they were moved if
+	// the dest_mapping contains a's.
+	BUG_ON(check_region_contains_byte
+	       (dest_mapping, num_pages * page_size, 'a') != 0,
+	       "pages did not migrate");
+
+	// Because the region is backed by shmem, we will actually see the same
+	// memory at the source location still.
+	BUG_ON(check_region_contains_byte
+	       (source_mapping, num_pages * page_size, 'a') != 0,
+	       "source should have no ptes");
+
+	BUG_ON(munmap(dest_mapping, num_pages * page_size) == -1,
+	       "unable to unmap destination mapping");
+	BUG_ON(munmap(source_mapping, num_pages * page_size) == -1,
+	       "unable to unmap source mapping");
+}
+
 // This test validates MREMAP_DONTUNMAP will move page tables to a specific
 // destination using MREMAP_FIXED, also while validating that the source
 // remains intact.
@@ -300,6 +351,7 @@ int main(void)
 	BUG_ON(page_buffer == MAP_FAILED, "unable to mmap a page.");
 
 	mremap_dontunmap_simple();
+	mremap_dontunmap_simple_shmem();
 	mremap_dontunmap_simple_fixed();
 	mremap_dontunmap_partial_mapping();
 	mremap_dontunmap_partial_mapping_overwrite();
_

Patches currently in -mm which might be from bgeffon@google.com are

mm-extend-mremap_dontunmap-to-non-anonymous-mappings.patch
revert-mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio.patch
selftests-add-a-mremap_dontunmap-selftest-for-shmem.patch

