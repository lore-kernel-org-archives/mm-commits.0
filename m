Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E1CD52A
	for <mm-commits@vger.kernel.org>; Sun, 28 Jan 2024 08:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706430496; cv=none; b=VhC25WlWq/EkM7m0daKGxhpxlJoXmLb89Kp9OjL7Vh0lujYEFU84IKXAp7ebzf6VDOTQmm9QHChB92ZpmqkekcQrIOsZzMFYbZAj3Ut2lTybzN1HpdzaKNClIu/7g1/ydLbIZ/2HlXDkigCBdo08y9YXX9VcbkhCpA8+18K2UkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706430496; c=relaxed/simple;
	bh=7DC9NmMBUBjv7s25IPsoF1Lyt5EbLfpp/+MSuPsPTVQ=;
	h=Date:To:From:Subject:Message-Id; b=qZ36A8fgko4fcT7rnH3Mq+wFif1njy5L/pQSTG54F+Q2lHhLDTTEt20c/UNrZc0em9rwcTQwshKT4vCfNC/qc4HZE0vENIgZ1GhiWXtOKS3XPoccD2WQR6yfxQoapWN+6zZa11iFpPqtk22tNTiZ0x7APu/5xwYXM9kX+KODWtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lufeEZsC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lufeEZsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23F0C433F1;
	Sun, 28 Jan 2024 08:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706430495;
	bh=7DC9NmMBUBjv7s25IPsoF1Lyt5EbLfpp/+MSuPsPTVQ=;
	h=Date:To:From:Subject:From;
	b=lufeEZsC65I98PhD9SeXh6h5W4CVp89WDFhVCnNM9/B/ID3rjctzFqVtLX3Y47+JL
	 Im8dwFqS4esV9gEYlTrSe43+oo+50F1VbXwJxuclf1YIx9NRyb/acRmATluKQrYjvD
	 g2eEUxFjwyR28wpbakE/FH/QdadSP0FYEmdtYHU4=
Date: Sun, 28 Jan 2024 00:28:12 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,rientjes@google.com,muchun.song@linux.dev,mike.kravetz@oracle.com,ligang.bdlg@bytedance.com,david@redhat.com,gang.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-have-config_hugetlbfs-select-config_padata.patch added to mm-unstable branch
Message-Id: <20240128082814.E23F0C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: have CONFIG_HUGETLBFS select CONFIG_PADATA
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-have-config_hugetlbfs-select-config_padata.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-have-config_hugetlbfs-select-config_padata.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Gang Li <gang.li@linux.dev>
Subject: hugetlb: have CONFIG_HUGETLBFS select CONFIG_PADATA
Date: Fri, 26 Jan 2024 23:24:09 +0800

Allow hugetlb use padata_do_multithreaded for parallel initialization. 
Select CONFIG_PADATA in this case.

Link: https://lkml.kernel.org/r/20240126152411.1238072-6-gang.li@linux.dev
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Tested-by: David Rientjes <rientjes@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/Kconfig~hugetlb-have-config_hugetlbfs-select-config_padata
+++ a/fs/Kconfig
@@ -262,6 +262,7 @@ menuconfig HUGETLBFS
 	depends on X86 || SPARC64 || ARCH_SUPPORTS_HUGETLBFS || BROKEN
 	depends on (SYSFS || SYSCTL)
 	select MEMFD_CREATE
+	select PADATA
 	help
 	  hugetlbfs is a filesystem backing for HugeTLB pages, based on
 	  ramfs. For architectures that support it, say Y here and read
_

Patches currently in -mm which might be from gang.li@linux.dev are

hugetlb-code-clean-for-hugetlb_hstate_alloc_pages.patch
hugetlb-split-hugetlb_hstate_alloc_pages.patch
padata-dispatch-works-on-different-nodes.patch
hugetlb-pass-next_nid_to_alloc-directly-to-for_each_node_mask_to_alloc.patch
hugetlb-have-config_hugetlbfs-select-config_padata.patch
hugetlb-parallelize-2m-hugetlb-allocation-and-initialization.patch
hugetlb-parallelize-1g-hugetlb-initialization.patch

