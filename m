Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1A34EB2C
	for <mm-commits@vger.kernel.org>; Mon, 12 Feb 2024 23:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707779921; cv=none; b=keZs80QLOaeStR0FlOOCrkbi6FWhCRZH8ePTdzGI2Y+V8GcWE0vslEq8mn4bBuQbcfW+U0NFPqXBA6cbUOrKS33/IqnECC7hwgLszYhR0fMPNxd+9qUtG9/C4/3t9aFMme4x7VxBwoxcnAMkLII0xB8/kmHnh/cXSi5CgDMGR7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707779921; c=relaxed/simple;
	bh=Udly5zOLVzvAAfUptgpYtvtEetLrjFfce+rrmqNECDM=;
	h=Date:To:From:Subject:Message-Id; b=Blvo4iGZSkAorKOONsj5WZ28MRJqZH/tQHfPgu3hOhP6hZzbbmvimB4ZGz1Q//7A8Nzzk5Me7MgveH8CIikujkM3Igu3jTfOrexSOTZrVp28pmhRmz2Byo1/eo8x/ZTb6Vw5LWye0zVPgU31ux3cYyCEIkekl48Pv5ePm5Td3BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AFiSNgx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AFiSNgx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1627C433F1;
	Mon, 12 Feb 2024 23:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707779920;
	bh=Udly5zOLVzvAAfUptgpYtvtEetLrjFfce+rrmqNECDM=;
	h=Date:To:From:Subject:From;
	b=AFiSNgx8/GBz1+VoScbgRXVi8Nk8AgOHEGX53MhYMHH8moSpA7iiRk18uczPQcbXJ
	 cEndofwzdhcsNcaWCcGmX0NLka2hsaH7bnQzGgxzo86WIEZb2VF5+h8S2Jt4X9OP9d
	 O90cT2wsqYrp07tjGBk3/WdDwRQVoof5iO8tf6lE=
Date: Mon, 12 Feb 2024 15:18:40 -0800
To: mm-commits@vger.kernel.org,lokeshgidra@google.com,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-use-per-vma-locks-in-userfaultfd-operations-fix.patch added to mm-unstable branch
Message-Id: <20240212231840.A1627C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd-use-per-vma-locks-in-userfaultfd-operations-fix
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-use-per-vma-locks-in-userfaultfd-operations-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-use-per-vma-locks-in-userfaultfd-operations-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: userfaultfd-use-per-vma-locks-in-userfaultfd-operations-fix
Date: Mon Feb 12 03:15:52 PM PST 2024

fix move_pages() kerneldoc

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202402101302.UF7G8Rr8-lkp@intel.com/
Cc: Lokesh Gidra <lokeshgidra@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/userfaultfd.c~userfaultfd-use-per-vma-locks-in-userfaultfd-operations-fix
+++ a/mm/userfaultfd.c
@@ -1449,7 +1449,6 @@ out_unlock:
 /**
  * move_pages - move arbitrary anonymous pages of an existing vma
  * @ctx: pointer to the userfaultfd context
- * @mm: the address space to move pages
  * @dst_start: start of the destination virtual memory range
  * @src_start: start of the source virtual memory range
  * @len: length of the virtual memory range
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix.patch
mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch
mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages-fix.patch
userfaultfd-use-per-vma-locks-in-userfaultfd-operations-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

