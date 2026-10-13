Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5F652B1C5
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 15:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791905202; cv=none; b=cAHq28n4gsHfgL3hPLS/KAfBt6Dlz+vDo1EYg/C6VTswf8Z/unVk9zhK1bFb0/4taEWHa01mL8bBJQNeQstUtpSW7RtUuJ5/HwMgbpuAGO4qOniFwENU+1bzj7I64b5zh/0rOxX1MG0foNETYoguCpaU3/1FYZ3galeO1ov+HiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791905202; c=relaxed/simple;
	bh=TNqix3YqXEDwhHNv+xlkco6u5V8Wsf2A+tuhde228QE=;
	h=Date:To:From:Subject:Message-Id; b=NpLrsu9HZ23bh7F55OOpCwN4DZB238Db+EIzjppcmuHxs53zL569jzw6ok+8FsNhBi9wgU+0SLAVe0UsnksXqjmhLhLzgZQ7AGOUZk3FK+zAPJica5Be3EyWtA7ZLz8L454sZJz4egT7PguFGjBxklb9ccfbYtWDyT6WpbjshFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Foy+97Vb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Foy+97Vb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920CC1F00898;
	Tue, 13 Oct 2026 15:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791905200;
	bh=kHfO5oa2ou84uRIgwPOR5LBwPa5IR/EBA8mjV7dr18k=;
	h=Date:To:From:Subject;
	b=Foy+97VbbGS8Ie1hSl0bJS/Zurw06jsmJVQk5ZTbq39t9GRoASQ7Ynh1XwDEVFjRZ
	 5gUTrhR5W6ik2ojwDqOQjBFll+hYE4pDnoicHTBgIvfVjtQ6tKjFQU7vdBIHoNw5DW
	 Ux3y0ixkWGfUBlkAfRoP8CIJVGh2nLepUyk9sva8=
Date: Tue, 13 Oct 2026 08:26:40 -0700
To: mm-commits@vger.kernel.org,ruirui.yang@linux.dev,kazuhito.hagio@nec.com,devnexen@gmail.com,baoquan.he@linux.dev,anshuman.khandual@arm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmcoreinfo-export-section_has_mem_map.patch added to mm-unstable branch
Message-Id: <20261013152640.920CC1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmcoreinfo: export SECTION_HAS_MEM_MAP
has been added to the -mm mm-unstable branch.  Its filename is
     vmcoreinfo-export-section_has_mem_map.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmcoreinfo-export-section_has_mem_map.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: vmcoreinfo: export SECTION_HAS_MEM_MAP
Date: Mon, 28 Sep 2026 10:48:21 +0200

The crash tool currently hardcodes SECTION_HAS_MEM_MAP, and makedumpfile
needs similar information (although still relying on
SECTION_MARKED_PRESENT, it should switch to SECTION_HAS_MEM_MAP).

Let's just export the value instead, so tools that work on vmcoreinfo
will not have to guess.

Link: https://lore.kernel.org/20260928-section_has_mem_map-v1-1-4129f6ba2838@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Carlier <devnexen@gmail.com>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: Kazuhito Hagio <kazuhito.hagio@nec.com>
---

 kernel/vmcore_info.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/vmcore_info.c~vmcoreinfo-export-section_has_mem_map
+++ a/kernel/vmcore_info.c
@@ -182,6 +182,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_STRUCT_SIZE(mem_section);
 	VMCOREINFO_OFFSET(mem_section, section_mem_map);
 	VMCOREINFO_NUMBER(SECTION_SIZE_BITS);
+	VMCOREINFO_NUMBER(SECTION_HAS_MEM_MAP);
 	VMCOREINFO_NUMBER(MAX_PHYSMEM_BITS);
 #endif
 	VMCOREINFO_STRUCT_SIZE(page);
_

Patches currently in -mm which might be from david@kernel.org are

arm64-mm-move-__check_safe_pte_update-fix.patch
mm-sparse-move-mem_section-init-to-sparse_extreme_init.patch
mm-sparse-refactor-sparse_sections_init.patch
mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init.patch
mm-sparse-rename-and-cleanup-sparse_init_nid.patch
mm-sparse-cleanup-sparse_init_one_section.patch
mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr.patch
mm-sparse-remove-pfn_in_present_section.patch
mm-sparse-move-__highest_used_section_nr-handling.patch
scripts-gdb-mmpy-remove-fallbacks-for-section_has_mem_map-and-section_is_early.patch
mm-sparse-remove-section_marked_present.patch
mm-sparse-remove-flags-parameter-from-sparse_init_one_section.patch
fs-proc-page-clarify-comment-in-get_max_dump_pfn.patch
mm-memory_hotplug-drop-config_have_arch_pfn_valid-handling-from-pfn_to_online_page.patch
vmcoreinfo-export-section_has_mem_map.patch

