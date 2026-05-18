Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D774F302CD5
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779141560; cv=none; b=vEpu0NcBH4ye6PTSb2tQAQDWaRIamdWgWn8zOn0mbecnkcG1zsCYacmznR8mLrhFmvotuV3veZo3eUEnat5KC5d87l48gg+yOXeCnrOEiIMyh33pNj9fkVLIFRyOwsY8h65LI/nGCxrjoDi/AnTyZJIPEyS2yvJkZODVhkVl8DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779141560; c=relaxed/simple;
	bh=kWjTOqg2HT4DPWiXZsycdHqowOD9sJuWIE1bMtd0+NA=;
	h=Date:To:From:Subject:Message-Id; b=nU8uI/WuCBoacnr6tEgS1f4LBXSAQmrMQ5F+peE60ciTMGuEEaIDaomTR1f1nYp3pI5SbVqw3gvKPBJ60Lj4XdgZ+cipt/miLCswmR6b2tYG9Is2LNEdz34GVE7qJJl8bBEP4Z+h7qy2OZo2TZq86DzQHJctdTKLY3OMzJw4YrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f0rk2ca6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f0rk2ca6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79456C2BCB7;
	Mon, 18 May 2026 21:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779141560;
	bh=kWjTOqg2HT4DPWiXZsycdHqowOD9sJuWIE1bMtd0+NA=;
	h=Date:To:From:Subject:From;
	b=f0rk2ca6WuqxAlZ+P9sAYTfLFNba7EQB2FFsnpuR6LLmJfWA/IuMEBJCrDeiBkVdk
	 yBuY5Stj87fiI0SaYT4vdOQ2sHXkFr5BmEkauVkC6m4ZePOIH1g7DTpeU29mAeivGq
	 NtzNOCHfE1FotsVl0hjBKsO6yCNL0MeGQprLUm60=
Date: Mon, 18 May 2026 14:59:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-remove-read_only_thp_for_fs-check-fix.patch removed from -mm tree
Message-Id: <20260518215920.79456C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fix mapping_pmd_folio_support() to represent its exact meaning
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-remove-read_only_thp_for_fs-check-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: fix mapping_pmd_folio_support() to represent its exact meaning
Date: Thu, 7 May 2026 02:02:28 -0400

Link: https://lore.kernel.org/73AB53AB-6EAA-4077-AFCA-90929F20D17A@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/pagemap.h~mm-khugepaged-remove-read_only_thp_for_fs-check-fix
+++ a/include/linux/pagemap.h
@@ -530,7 +530,8 @@ static inline bool mapping_pmd_folio_sup
 	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
 	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
 
-	return mapping_max_folio_order(mapping) >= PMD_ORDER;
+	return mapping_min_folio_order(mapping) <= PMD_ORDER &&
+	       mapping_max_folio_order(mapping) >= PMD_ORDER;
 }
 #else
 static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-khugepaged-add-folio-dirty-check-after-try_to_unmap.patch
mm-huge_memory-remove-read_only_thp_for_fs-from-file_thp_enabled.patch
mm-khugepaged-remove-read_only_thp_for_fs-check-in-hugepage_enabled.patch
mm-remove-read_only_thp_for_fs-kconfig-option.patch
mm-fs-remove-filemap_nr_thps-functions-and-their-users.patch
fs-remove-nr_thps-from-struct-address_space.patch
mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs.patch
mm-truncate-use-folio_split-in-truncate_inode_partial_folio.patch
fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix-2.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch
mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch
selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

