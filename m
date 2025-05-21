Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEBF32C85
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 05:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747806617; cv=none; b=OjIuO5Nw4Txy+VEee1a5+vNFEVJ0zoVHEenuvRACfi3aqMz9bwUs4NKtKOo91gp41boen6zECwqBfSZaAP89iqQuYoaziiGrIHsgPVW2gOn4Ss4pBM2Q4+QhIYlT795OTxzWxA2Vz2odxWzS9QBBwFfxdv87ggeTi8HxMbicpnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747806617; c=relaxed/simple;
	bh=V9OaeaM2wrqwGIMz0HSQoLgCaMmvzz2OJ0MiIoI8OqA=;
	h=Date:To:From:Subject:Message-Id; b=QlPpSZkILZ/RLcLE2SrOrZztrQTEtrTJ9LCb8BsmapV29psUvJipPGsL48/YIAyT/FwSzUiHxYD/gV7g0E3TVRq1wz/wK5/xjku4AZM9OaFnvTcof8ZkQhybfyLIVCv8rW3mOxrvCJ3pTmpZ3Xfnc1suWfLcf9UDn20z2UqTIsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yvFR8W2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yvFR8W2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160D1C4CEEF;
	Wed, 21 May 2025 05:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747806617;
	bh=V9OaeaM2wrqwGIMz0HSQoLgCaMmvzz2OJ0MiIoI8OqA=;
	h=Date:To:From:Subject:From;
	b=yvFR8W2MQcSYTeLuHiAWK3+ceVXdjat1sqFCFgYvObnwoQ7w6O7x8II8WGiutjsJi
	 BCYuc2GXU+ezaPCJltOVrgJpx1vmkVrXuALhKXBGZ1yZq2NHW7jXSonzWz9gxZs48N
	 JrmgxpDDFKbRoHkAte2LkHaU4wjIDnxp0pE0Cuow=
Date: Tue, 20 May 2025 22:50:16 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,david@redhat.com,chengming.zhou@linux.dev,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-mm-ksm-section.patch removed from -mm tree
Message-Id: <20250521055017.160D1C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add mm ksm section
has been removed from the -mm tree.  Its filename was
     maintainers-add-mm-ksm-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add mm ksm section
Date: Thu, 15 May 2025 20:04:04 +0100

As part of the ongoing efforts to sub-divide memory management
maintainership and reviewership, establish a section for Kernel Samepage
Merging (KSM) and add appropriate maintainers and reviewers.

Link: https://lkml.kernel.org/r/20250515190404.203596-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: Xu Xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/MAINTAINERS~maintainers-add-mm-ksm-section
+++ a/MAINTAINERS
@@ -15562,6 +15562,21 @@ W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	mm/gup.c
 
+MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@redhat.com>
+R:	Xu Xin <xu.xin16@zte.com.cn>
+R:	Chengming Zhou <chengming.zhou@linux.dev>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/admin-guide/mm/ksm.rst
+F:	Documentation/mm/ksm.rst
+F:	include/linux/ksm.h
+F:	include/trace/events/ksm.h
+F:	mm/ksm.c
+
 MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-kernel-forkc-to-relevant-sections.patch
mm-remove-warn_on_once-in-file_has_valid_mmap_hooks.patch
memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix.patch

