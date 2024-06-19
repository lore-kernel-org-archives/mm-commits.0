Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4552815ADAF
	for <mm-commits@vger.kernel.org>; Wed, 19 Jun 2024 23:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718838749; cv=none; b=sWXWGvGQqOe0DQgzoRXynJdRc62u1+8pd+LmblvdLQjtIDi8vTFuSOct1dE6JAzBk8P900wpASQBxUsCyxQTCevmf4cyB3JFLx8MLszhDCalcNd2+ldpsHuTZT7r4v154PbQyWPm7aioSROOSHBoU2Ky6JvnMkhSo1Zcb4HX5gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718838749; c=relaxed/simple;
	bh=AmOzQqidWa908LDfdT+VXDRSs2u9ncfnaIRCCNnoE6U=;
	h=Date:To:From:Subject:Message-Id; b=bceRlBARQg96YwVDEom7wAwJo5WWfdbkT63maB/FZgC8ow5UralVsJ26h1gpCIfjliochBDUSi5GHl01nTqaiGq4b2aglF56GfipiStQYk6wZc71/r5VaGS7MHw2vpyUXNkO3tHoy6KhDjuyen3+ti9pMKUQSLjNtnK9H4mRHB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BdBTvmXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BdBTvmXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05CCC2BBFC;
	Wed, 19 Jun 2024 23:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718838748;
	bh=AmOzQqidWa908LDfdT+VXDRSs2u9ncfnaIRCCNnoE6U=;
	h=Date:To:From:Subject:From;
	b=BdBTvmXrxtHb7v/5uLWkpKa2CGwEcOEA5Yvso8fGfZyo31Tw+kE8Rob4B/xTptjHo
	 8tPn/SOm7sItCRePQqlqvWMMLe+DvPObVx35gaPoGWwvwWvye3S4+X+i65Ii6RTGyg
	 aeNgZSSlPQggKxzZFGofDmfHuDTXa0WkB9xovByo=
Date: Wed, 19 Jun 2024 16:12:28 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-2.patch added to mm-unstable branch
Message-Id: <20240619231228.C05CCC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix the missing doc for flags of folio_add_new_anon_rmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-2.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: fix the missing doc for flags of folio_add_new_anon_rmap()
Date: Thu, 20 Jun 2024 08:57:55 +1200

Fix mm/rmap.c:1413: warning: Function parameter or struct member
'flags' not described in 'folio_add_new_anon_rmap'.

Link: https://lkml.kernel.org/r/20240619210641.62542-1-21cnbao@gmail.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406200059.tVU9semU-lkp@intel.com/
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/rmap.c~mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-2
+++ a/mm/rmap.c
@@ -1401,6 +1401,7 @@ void folio_add_anon_rmap_pmd(struct foli
  * @folio:	The folio to add the mapping to.
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
+ * @flags:	The rmap flags
  *
  * Like folio_add_anon_rmap_*() but must only be called on *new* folios.
  * This means the inc-and-test can be bypassed.
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

cifs-drop-the-incorrect-assertion-in-cifs_swap_rw.patch
mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr.patch
mm-introduce-pte_move_swp_offset-helper-which-can-move-offset-bidirectionally.patch
mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages.patch
mm-swap-reuse-exclusive-folio-directly-instead-of-wp-page-faults.patch
mm-introduce-pmdpte_needs_soft_dirty_wp-helpers-for-softdirty-write-protect.patch
mm-set-pte-writable-while-pte_soft_dirty-is-true-in-do_swap_page.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-2.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch
mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap.patch

