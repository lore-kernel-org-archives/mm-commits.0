Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F517C43470
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7699861463
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhD3F6l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230132AbhD3F6k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:58:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8442D6147E;
        Fri, 30 Apr 2021 05:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762273;
        bh=7NRYA8KT42TvlBd2GD3j8q7TX6AQsPWu1v7ZUqkNeRE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WM6ZS5BWx+WDjyDlGwXqv43KKAtvyy7ochYJtqCffiddAmJeWx9VSRjlnnre9Jkvj
         wJaB9z6Oe1VGjzHwlJ2vovzV4NP5D37f5627jNmOVlV7//tWz1DneaZNnv6YdurVfh
         4o53/bk2QbFwBrM/tAk7r7xv8VT9+nD5quLRBi/o=
Date:   Thu, 29 Apr 2021 22:57:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        alx.manpages@gmail.com, axelrasmussen@google.com,
        bgeffon@google.com, dima@arista.com, hughd@google.com,
        kirill@shutemov.name, linux-mm@kvack.org, lokeshgidra@google.com,
        luto@amacapital.net, minchan@kernel.org,
        mm-commits@vger.kernel.org, mst@redhat.com, mtk.manpages@gmail.com,
        peterx@redhat.com, rppt@linux.vnet.ibm.com, sonnyrao@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 091/178] selftests: add a MREMAP_DONTUNMAP
 selftest for shmem
Message-ID: <20210430055752.Yq-i53YG9%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
