Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD574299928
	for <mm-commits@vger.kernel.org>; Tue, 11 Nov 2025 19:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762888219; cv=none; b=e0+BRzIitlVbYTPVEW95Oi05lLSThaXyALOdhM9qxL9NXAKhnWY3PWKjK+NlyKpj1kZE5XV2LrKa4Di3+JHoY81Yo/jXhcs3evDtlslHgDvTAN+e4GAAXzbpVT5reC16Tn+9dMOHvOMC7fEY4vpOC7j070mcSLsO5R5rfg4/qwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762888219; c=relaxed/simple;
	bh=T6Z7qr+nbqdkAtrWlGMk3tzJGY/hIgkQKXypD2Jh13A=;
	h=Date:To:From:Subject:Message-Id; b=RietsweRDKg4IpnJ5HoqmWCIWueZuUmDUXD0MKj6hD1H4HbWINWwI2pyT3w85w06gqD6gEhA+biZ2OOdE8A0MBXuHSUp7EyPJKZadfS/Oah4UrZY1g8fyznPi7lEJDDARd4vNkUliUfh7GU/ww29faUl9uWLW6XqBct98ltOPIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PmmKbPjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PmmKbPjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4227AC4CEF5;
	Tue, 11 Nov 2025 19:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762888219;
	bh=T6Z7qr+nbqdkAtrWlGMk3tzJGY/hIgkQKXypD2Jh13A=;
	h=Date:To:From:Subject:From;
	b=PmmKbPjJF+z0bRwogq66Eb0yAIdfP2VeTgXo70H44Gpxxyj5aU+ziguzCou7K96VS
	 LxU8haa//OZEaKwb/j2j9XRgZOSpzBpptwUgyWaV8knOLs8fKJP4NgsAWs+IHcztKW
	 SknJhw/l9UhDA/RF3f1LtgalX0rMxmMJVwmK5138=
Date: Tue, 11 Nov 2025 11:10:18 -0800
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-luo_file-implement-file-systems-callbacks-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251111191019.4227AC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate-luo_file-implement-file-systems-callbacks-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     liveupdate-luo_file-implement-file-systems-callbacks-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-luo_file-implement-file-systems-callbacks-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: liveupdate-luo_file-implement-file-systems-callbacks-fix
Date: Tue Nov 11 11:07:32 AM PST 2025

luo_file.c needs linux/fs.h

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511120222.vMZm9rD4-lkp@intel.com/
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/liveupdate/luo_file.c~liveupdate-luo_file-implement-file-systems-callbacks-fix
+++ a/kernel/liveupdate/luo_file.c
@@ -102,6 +102,7 @@
 #include <linux/liveupdate/abi/luo.h>
 #include <linux/module.h>
 #include <linux/rwsem.h>
+#include <linux/fs.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/string.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
drivers-base-node-fold-register_node-into-register_one_node-fix.patch
mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch
memcg-manually-uninline-__memcg_memory_event-fix.patch
mm-change-type-of-state-in-struct-memory_block-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix-fix.patch
init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch
liveupdate-luo_file-implement-file-systems-callbacks-fix.patch
mm-shmem-use-shmem_f_-flags-instead-of-vm_-flags-fix.patch

