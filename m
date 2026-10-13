Received: from mail.mainlining.org (mail.mainlining.org [5.75.144.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCCF52842E
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 15:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.75.144.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791906272; cv=none; b=s0zXPHOLmap0aKW4yY4c7sfzi0Q7/nVv12Oj9p0PtL4/Mys70ejgHZddODostZokRnmdBYOCaDzv4Mp1p8ZXo9o2X6SMVajaV1Pz/co5eXE9M4b7VJV7tQ2Ukbehi9dpuCyHvotJNB2zzIuXbHV3Xk9kIt8VA9DJDAwp6UKdCUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791906272; c=relaxed/simple;
	bh=qGCUQZlIFtp9BvSqMlfAJeyZeEhKTu+/g2e/C4iJXlc=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=ZomlDZScu4OayBgU5pj0axfbl9ny6pK9njrMizkj58qp8DMQaDF0lA5DtDE8OcvjlaM4ypli+ByC0Bxt1AePISj5hbBNoECDkYr8YAadSSDdZR5bpan/7DO74TdVEVlYx0v/2QGOPckbU1MtDDK9hQEnQvbPqUK4i8vw7saQKL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org; spf=pass smtp.mailfrom=mainlining.org; dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=NM8WkWfb; dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=WW/GZZBg; arc=none smtp.client-ip=5.75.144.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mainlining.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="NM8WkWfb";
	dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="WW/GZZBg"
DKIM-Signature: v=1; a=rsa-sha256; s=202507r; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1791906250; bh=En/mkM6Owg6jh+td21VjF9X
	5Wz53vmoXU2+E/1SnQn4=; b=NM8WkWfbBAvIfyvfwcjMIzQC7SLuAKrrNpGAD57/jEc9sHshsY
	xyxBrvpHHLPztLlRNhhLcVEWJXCqJVB6L9UAht6JBwVBq7FCnsF92ChNGv9323h7ufSEweKf6wN
	Mcjbnbd3N2v/GBKVlLjlpsu8ylqscsfa8XcgvugqTdN7OimnxxbRtN7M1Z4Ajh6sPBJM7jFQt6w
	iStLglXzvgr6KoV3h8EQ6P1C8FemEMkXfFM57emm4MVyRe7vYmbQD3Pm9PzqeQJ//ryM42+9H5k
	RdXckEXqHOEDHX8SwJhwUDsj6aMzUmyrgBYqfQ8G+sUsG6nVTNwq4jN6hWYSDswWkJw==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202507e; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1791906250; bh=En/mkM6Owg6jh+td21VjF9X
	5Wz53vmoXU2+E/1SnQn4=; b=WW/GZZBg1EZMv67vhekH1ChucMv3rvoAv5UqdGgFF1neg3tg9G
	nnX8A3bBQBDiDto52OVK6eO4SWpdZKt0IJAQ==;
Date: Tue, 13 Oct 2026 16:44:10 +0100
From: Bradley Morgan <brads@mainlining.org>
To: akpm@linux-foundation.org
CC: anshuman.khandual@arm.com, baoquan.he@linux.dev, david@kernel.org,
 devnexen@gmail.com, kazuhito.hagio@nec.com, mm-commits@vger.kernel.org,
 ruirui.yang@linux.dev
Subject: =?US-ASCII?Q?Re=3A_+_vmcoreinfo-export-section=5Fhas=5Fme?=
 =?US-ASCII?Q?m=5Fmap=2Epatch_added_to_mm-unstable_branch?=
In-Reply-To: <20261013152640.920CC1F00898@smtp.kernel.org>
Message-ID: <9A6224A8-B499-44C4-A6B3-1F9A5753955B@mainlining.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 13 October 2026 16:26:40 BST, Andrew Morton <akpm@linux-foundation.org>
wrote:
>
>The patch titled
>     Subject: vmcoreinfo: export SECTION_HAS_MEM_MAP
>has been added to the -mm mm-unstable branch.  Its filename is
>     vmcoreinfo-export-section_has_mem_map.patch
>
>This patch will shortly appear at
>     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmcoreinfo-export-section_has_mem_map.patch
>
>This patch will later appear in the mm-unstable branch at
>    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
>Before you just go and hit "reply", please:
>   a) Consider who else should be cc'ed
>   b) Prefer to cc a suitable mailing list as well
>   c) Ideally: find the original patch on the mailing list and do a
>      reply-to-all to that, adding suitable additional cc's
>
>*** Remember to use Documentation/process/submit-checklist.rst when
>testing your code ***
>
>The -mm tree is included into linux-next via various
>branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>and is updated there most days
>
>------------------------------------------------------
>From: "David Hildenbrand (Arm)" <david@kernel.org>
>Subject: vmcoreinfo: export SECTION_HAS_MEM_MAP
>Date: Mon, 28 Sep 2026 10:48:21 +0200
>
>The crash tool currently hardcodes SECTION_HAS_MEM_MAP, and makedumpfile
>needs similar information (although still relying on
>SECTION_MARKED_PRESENT, it should switch to SECTION_HAS_MEM_MAP).
>
>Let's just export the value instead, so tools that work on vmcoreinfo
>will not have to guess.
>
>Link: https://lore.kernel.org/20260928-section_has_mem_map-v1-1-4129f6ba2838@kernel.org
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>Acked-by: Baoquan He <baoquan.he@linux.dev>
>Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

Sigh... :(

https://lore.kernel.org/all/E7FBE134-976C-4FAE-A25F-52225118557F@mainlining.org/


>Cc: David Carlier <devnexen@gmail.com>
>Cc: Dave Young <ruirui.yang@linux.dev>
>Cc: Kazuhito Hagio <kazuhito.hagio@nec.com>
>---
>
> kernel/vmcore_info.c |    1 +
> 1 file changed, 1 insertion(+)
>
>--- a/kernel/vmcore_info.c~vmcoreinfo-export-section_has_mem_map
>+++ a/kernel/vmcore_info.c
>@@ -182,6 +182,7 @@ static int __init crash_save_vmcoreinfo_
> 	VMCOREINFO_STRUCT_SIZE(mem_section);
> 	VMCOREINFO_OFFSET(mem_section, section_mem_map);
> 	VMCOREINFO_NUMBER(SECTION_SIZE_BITS);
>+	VMCOREINFO_NUMBER(SECTION_HAS_MEM_MAP);
> 	VMCOREINFO_NUMBER(MAX_PHYSMEM_BITS);
> #endif
> 	VMCOREINFO_STRUCT_SIZE(page);
>_
>
>Patches currently in -mm which might be from david@kernel.org are
>
>arm64-mm-move-__check_safe_pte_update-fix.patch
>mm-sparse-move-mem_section-init-to-sparse_extreme_init.patch
>mm-sparse-refactor-sparse_sections_init.patch
>mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init.patch
>mm-sparse-rename-and-cleanup-sparse_init_nid.patch
>mm-sparse-cleanup-sparse_init_one_section.patch
>mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr.patch
>mm-sparse-remove-pfn_in_present_section.patch
>mm-sparse-move-__highest_used_section_nr-handling.patch
>scripts-gdb-mmpy-remove-fallbacks-for-section_has_mem_map-and-section_is_early.patch
>mm-sparse-remove-section_marked_present.patch
>mm-sparse-remove-flags-parameter-from-sparse_init_one_section.patch
>fs-proc-page-clarify-comment-in-get_max_dump_pfn.patch
>mm-memory_hotplug-drop-config_have_arch_pfn_valid-handling-from-pfn_to_online_page.patch
>vmcoreinfo-export-section_has_mem_map.patch
>
>
>

--- Thanks!
"I'm not a very positive person" - Linus torvalds
