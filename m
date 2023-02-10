Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E52C61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjBJAwu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjBJAwq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E3D6D8FD
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F60EB82395
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DF9C4339B;
        Fri, 10 Feb 2023 00:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990360;
        bh=WudD2futJwyvXfCFSKqVLJvv3xggO8AxM45GwtFB5MY=;
        h=Date:To:From:Subject:From;
        b=CCexyaKjJT2X3UvvdLJosR4AgnJ9Zzc6TtX4J2UdETjFnXQF85TgQ+Z/dgFdirz7Q
         Dx30gbY6O/8Hbg4o71y1iQDeo2/5jZGyKEZGGdNxqkEj7YFAYElNhsO3D6F/6XFTz7
         FvK9PLV8431fk3UMJq/r3Us6mw8hpzxbuFKRV8Ho=
Date:   Thu, 09 Feb 2023 16:52:40 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma.patch removed from -mm tree
Message-Id: <20230210005240.D1DF9C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add temporary vma iterator versions of vma_merge(), split_vma(), and __split_vma()
has been removed from the -mm tree.  Its filename was
     mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: add temporary vma iterator versions of vma_merge(), split_vma(), and __split_vma()
Date: Fri, 20 Jan 2023 11:26:15 -0500

These wrappers are short-lived in this patch set so that each user can be
converted on its own.  In the end, these functions are renamed in one
commit.

Link: https://lkml.kernel.org/r/20230120162650.984577-15-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   11 +++++++++-
 mm/mmap.c          |   44 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma
+++ a/include/linux/mm.h
@@ -2843,11 +2843,20 @@ extern struct vm_area_struct *vma_merge(
 	struct vm_area_struct *prev, unsigned long addr, unsigned long end,
 	unsigned long vm_flags, struct anon_vma *, struct file *, pgoff_t,
 	struct mempolicy *, struct vm_userfaultfd_ctx, struct anon_vma_name *);
+extern struct vm_area_struct *vmi_vma_merge(struct vma_iterator *vmi,
+	struct mm_struct *, struct vm_area_struct *prev, unsigned long addr,
+	unsigned long end, unsigned long vm_flags, struct anon_vma *,
+	struct file *, pgoff_t, struct mempolicy *, struct vm_userfaultfd_ctx,
+	struct anon_vma_name *);
 extern struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *);
 extern int __split_vma(struct mm_struct *, struct vm_area_struct *,
-	unsigned long addr, int new_below);
+			       unsigned long addr, int new_below);
+extern int vmi__split_vma(struct vma_iterator *vmi, struct mm_struct *,
+	struct vm_area_struct *, unsigned long addr, int new_below);
 extern int split_vma(struct mm_struct *, struct vm_area_struct *,
 	unsigned long addr, int new_below);
+extern int vmi_split_vma(struct vma_iterator *vmi, struct mm_struct *,
+		struct vm_area_struct *, unsigned long addr, int new_below);
 extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void unlink_file_vma(struct vm_area_struct *);
 extern struct vm_area_struct *copy_vma(struct vm_area_struct **,
--- a/mm/mmap.c~mm-add-temporary-vma-iterator-versions-of-vma_merge-split_vma-and-__split_vma
+++ a/mm/mmap.c
@@ -1091,6 +1091,25 @@ struct vm_area_struct *vma_merge(struct
 	return res;
 }
 
+struct vm_area_struct *vmi_vma_merge(struct vma_iterator *vmi,
+			struct mm_struct *mm,
+			struct vm_area_struct *prev, unsigned long addr,
+			unsigned long end, unsigned long vm_flags,
+			struct anon_vma *anon_vma, struct file *file,
+			pgoff_t pgoff, struct mempolicy *policy,
+			struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
+			struct anon_vma_name *anon_name)
+{
+	struct vm_area_struct *tmp;
+
+	tmp = vma_merge(mm, prev, addr, end, vm_flags, anon_vma, file, pgoff,
+			policy, vm_userfaultfd_ctx, anon_name);
+	if (tmp)
+		vma_iter_set(vmi, end);
+
+	return tmp;
+}
+
 /*
  * Rough compatibility check to quickly see if it's even worth looking
  * at sharing an anon_vma.
@@ -2276,6 +2295,18 @@ int __split_vma(struct mm_struct *mm, st
 	validate_mm_mt(mm);
 	return err;
 }
+int vmi__split_vma(struct vma_iterator *vmi, struct mm_struct *mm,
+		   struct vm_area_struct *vma, unsigned long addr, int new_below)
+{
+	int ret;
+	unsigned long end = vma->vm_end;
+
+	ret = __split_vma(mm, vma, addr, new_below);
+	if (!ret)
+		vma_iter_set(vmi, end);
+
+	return ret;
+}
 
 /*
  * Split a vma into two pieces at address 'addr', a new vma is allocated
@@ -2290,6 +2321,19 @@ int split_vma(struct mm_struct *mm, stru
 	return __split_vma(mm, vma, addr, new_below);
 }
 
+int vmi_split_vma(struct vma_iterator *vmi, struct mm_struct *mm,
+		  struct vm_area_struct *vma, unsigned long addr, int new_below)
+{
+	int ret;
+	unsigned long end = vma->vm_end;
+
+	ret = split_vma(mm, vma, addr, new_below);
+	if (!ret)
+		vma_iter_set(vmi, end);
+
+	return ret;
+}
+
 static inline int munmap_sidetree(struct vm_area_struct *vma,
 				   struct ma_state *mas_detach)
 {
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


