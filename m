Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3441BDC3
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824176; cv=none; b=PL1E5UQ23hwycbdS0c/imP72cdisWwUlDFiND9rFU9USzAu3obzKcHMTWJnLwb27scrURojLSxSPbMC/Oci9Nc1L1pMKDVII2I7DYKeYvA9/f8bJ5IosLMwlDaIjv079CoWEeY1efleYkvP6j22Kk76glfefaQMcAJNB3u6xaNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824176; c=relaxed/simple;
	bh=Uup1ZFTfQPREbtIbtWznX4BdaU57/XLB6uUmYd8KWzA=;
	h=Date:To:From:Subject:Message-Id; b=pYPeJQdenazuEv6eQ3RMVLLI59tjQ4mF/Uvgx+oE4xrw7yKeKnoTmziktft0VBqqj+MJhtVBHWYASZICGDAX1C6qZZL57fNOIkUpTzSQrxnllJhIdvAz0gqBYziO/55WBst9fspZH9XYdgnEdBT331rlCzGTf6XdOWesihiAXiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OO6YESsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OO6YESsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF60C32782;
	Fri, 12 Jul 2024 22:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824176;
	bh=Uup1ZFTfQPREbtIbtWznX4BdaU57/XLB6uUmYd8KWzA=;
	h=Date:To:From:Subject:From;
	b=OO6YESsLILPooVxzNuDZZNMBiJSxHI+cD+ifbPwCDOU+k35Znlx+fU1DC6FAVx4C6
	 GmK90llcReNJhbUwBA2KTUAR6Lp7EZkUQY9sXzTAmLv2V8v+admp/rVAbrqoquv30s
	 Sc8l1+Qbs2hePpGNbwXc/WbAv2IywMF+LPgncMz4=
Date: Fri, 12 Jul 2024 15:42:55 -0700
To: mm-commits@vger.kernel.org,syzbot+f1d7fb4f94764243d23e@syzkaller.appspotmail.com,muchun.song@linux.dev,kraxel@redhat.com,airlied@redhat.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-2.patch removed from -mm tree
Message-Id: <20240712224256.7EF60C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: RE: [fs?] [mm?] INFO: task hung in remove_inode_hugepages
has been removed from the -mm tree.  Its filename was
     mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-2.patch

This patch was dropped because it was folded into mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios.patch

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
udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap.patch
udmabuf-add-back-support-for-mapping-hugetlb-pages.patch
udmabuf-convert-udmabuf-driver-to-use-folios.patch
udmabuf-pin-the-pages-using-memfd_pin_folios-api.patch
selftests-udmabuf-add-tests-to-verify-data-after-page-migration.patch

