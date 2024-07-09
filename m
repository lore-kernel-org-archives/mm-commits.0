Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D671B86D4
	for <mm-commits@vger.kernel.org>; Tue,  9 Jul 2024 21:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561392; cv=none; b=LdrYzA1FKnA1ad2663Trl7MHO9eeZQJxAPR7W+LbQE2AJoOW3odrBYopHFXvTLI/YNtnX3XilLlpZlQJ9y05wHgyiMIWMUNWCcT2egY5X4SWAbNo6McMpSmLG80chRHOrGCEn/nruINGPrhvT+Dz29aMKVvMUydykKZy9fpMwFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561392; c=relaxed/simple;
	bh=uy8P0wSnrvFhS4Z+9pNi9kSJN+bhufymPAbGrrIw0VI=;
	h=Date:To:From:Subject:Message-Id; b=GGbU0lmzXSCxq3aH0gCQ4v8cBM9KA0+BiQVSYO+i84xYzMsxlg0StaZ8EhitfHfA7Fs1B3M5kGxcqL2c0sMrLQ/TK2fqFqXYneKzaHC2DI1l5OPG6BzjhixTJ4WUWiSmlV6neSQCAi8mI8rVdKZTACqAEnHpfmPVkT2Kp22odvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FmLL4lMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FmLL4lMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA45C3277B;
	Tue,  9 Jul 2024 21:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720561392;
	bh=uy8P0wSnrvFhS4Z+9pNi9kSJN+bhufymPAbGrrIw0VI=;
	h=Date:To:From:Subject:From;
	b=FmLL4lMc4tuoBaHkdjhsWMeaCfbSaEq5+nQop26jsNWlqsUG8KwuedcD626LC1mt5
	 8tTD5oFL0ojhTWWxBIwDm6qCfn9ccX1BY/mOSopOcb77R+QEf1dXHzTnYn/kGsrr/I
	 FS8IYWTVKMfLxQ07+rQz23YMeIa4DLIGg/v0SN/U=
Date: Tue, 09 Jul 2024 14:43:11 -0700
To: mm-commits@vger.kernel.org,syzbot+f1d7fb4f94764243d23e@syzkaller.appspotmail.com,muchun.song@linux.dev,kraxel@redhat.com,airlied@redhat.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-2.patch added to mm-unstable branch
Message-Id: <20240709214312.5CA45C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: RE: [fs?] [mm?] INFO: task hung in remove_inode_hugepages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-2.patch

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
From: "Kasireddy, Vivek" <vivek.kasireddy@intel.com>
Subject: RE: [fs?] [mm?] INFO: task hung in remove_inode_hugepages
Date:   Mon Jul 8 23:04:48 2024 -0700


return -EINVAL if the end offset is greater than the size of memfd

Link: https://lkml.kernel.org/r/IA0PR11MB71850525CBC7D541CAB45DF1F8DB2@IA0PR11MB7185.namprd11.prod.outlook.com
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Reported-by: <syzbot+f1d7fb4f94764243d23e@syzkaller.appspotmail.com>
Testted-by: <syzbot+f1d7fb4f94764243d23e@syzkaller.appspotmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/gup.c~mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-2
+++ a/mm/gup.c
@@ -3814,6 +3814,9 @@ long memfd_pin_folios(struct file *memfd
 	if (!shmem_file(memfd) && !is_file_hugepages(memfd))
 		return -EINVAL;
 
+	if (end >= i_size_read(file_inode(memfd)))
+		return -EINVAL;
+
 	if (is_file_hugepages(memfd)) {
 		h = hstate_file(memfd);
 		pgshift = huge_page_shift(h);
_

Patches currently in -mm which might be from vivek.kasireddy@intel.com are

mm-gup-introduce-unpin_folio-unpin_folios-helpers.patch
mm-gup-introduce-check_and_migrate_movable_folios.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-2.patch
udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap.patch
udmabuf-add-back-support-for-mapping-hugetlb-pages.patch
udmabuf-convert-udmabuf-driver-to-use-folios.patch
udmabuf-pin-the-pages-using-memfd_pin_folios-api.patch
selftests-udmabuf-add-tests-to-verify-data-after-page-migration.patch

