Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6F6C6FA82
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiI0C4E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiI0CzI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:55:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92421205C6
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:50:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1133161552
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DBBC433B5;
        Tue, 27 Sep 2022 02:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664247004;
        bh=MQD7zk8lUXiiny5U4wTIzjGX+rF64sDsLQyKbsFLkNA=;
        h=Date:To:From:Subject:From;
        b=cFEzAQNYCC5yjmBAm3VQvYNgbaF6/6bhaFjgyG7k+WKoEmZO/n1UyBJm0bpdenjRX
         zrtkGwBgZZF3o4LxQxJr1viNkOznyo3+i3HnHth7FuQfXBNr8DjEtC4BPKmETRTg3z
         kRwOvXqlZyx7Jam3dNZOfTJHiaGd87BkDNV66iOw=
Date:   Mon, 26 Sep 2022 19:50:03 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, Liam.Howlett@oracle.com, dhowells@redhat.com,
        david@redhat.com, dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmapc-pass-in-mapping-to-__vma_link_file.patch removed from -mm tree
Message-Id: <20220927025004.68DBBC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap.c: pass in mapping to __vma_link_file()
has been removed from the -mm tree.  Its filename was
     mm-mmapc-pass-in-mapping-to-__vma_link_file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap.c: pass in mapping to __vma_link_file()
Date: Tue, 6 Sep 2022 19:49:06 +0000

__vma_link_file() resolves the mapping from the file, if there is one.
Pass through the mapping and check the vm_file externally since most
places already have the required information and check of vm_file.

Link: https://lkml.kernel.org/r/20220906194824.2110408-71-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

--- a/mm/mmap.c~mm-mmapc-pass-in-mapping-to-__vma_link_file
+++ a/mm/mmap.c
@@ -407,21 +407,15 @@ static unsigned long count_vma_pages_ran
 	return nr_pages;
 }
 
-static void __vma_link_file(struct vm_area_struct *vma)
+static void __vma_link_file(struct vm_area_struct *vma,
+			    struct address_space *mapping)
 {
-	struct file *file;
+	if (vma->vm_flags & VM_SHARED)
+		mapping_allow_writable(mapping);
 
-	file = vma->vm_file;
-	if (file) {
-		struct address_space *mapping = file->f_mapping;
-
-		if (vma->vm_flags & VM_SHARED)
-			mapping_allow_writable(mapping);
-
-		flush_dcache_mmap_lock(mapping);
-		vma_interval_tree_insert(vma, &mapping->i_mmap);
-		flush_dcache_mmap_unlock(mapping);
-	}
+	flush_dcache_mmap_lock(mapping);
+	vma_interval_tree_insert(vma, &mapping->i_mmap);
+	flush_dcache_mmap_unlock(mapping);
 }
 
 /*
@@ -488,10 +482,11 @@ static int vma_link(struct mm_struct *mm
 	}
 
 	vma_mas_store(vma, &mas);
-	__vma_link_file(vma);
 
-	if (mapping)
+	if (mapping) {
+		__vma_link_file(vma, mapping);
 		i_mmap_unlock_write(mapping);
+	}
 
 	mm->map_count++;
 	validate_mm(mm);
@@ -730,14 +725,14 @@ int __vma_adjust(struct vm_area_struct *
 			uprobe_munmap(next, next->vm_start, next->vm_end);
 
 		i_mmap_lock_write(mapping);
-		if (insert) {
+		if (insert && insert->vm_file) {
 			/*
 			 * Put into interval tree now, so instantiated pages
 			 * are visible to arm/parisc __flush_dcache_page
 			 * throughout; but we cannot insert into address
 			 * space until vma start or end is updated.
 			 */
-			__vma_link_file(insert);
+			__vma_link_file(insert, insert->vm_file->f_mapping);
 		}
 	}
 
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


