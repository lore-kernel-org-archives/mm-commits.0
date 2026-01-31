Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6F738A726
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898281; cv=none; b=lrrIFtTSjlpSkCub9s+l3jBm88212tXJq6qHLIbLEGtWlCv2F+5le7ESO4RF1KctCXPtp7vxdxnG55/5QAO7V6b8PxHOLBkPntkSdBHwKxQdT69zrsh0VWD0J0j9dl7irBkrQFsE/1t5SyMi/uOYktbFT3GzGWtfoRuCi1I12ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898281; c=relaxed/simple;
	bh=p/aTDp2VFieOhFqhJrJq3q/q13g4Sra9x4SMe+81dNg=;
	h=Date:To:From:Subject:Message-Id; b=jNlGfB9gpSckKyVbfKGoJ2oRScxP3H2KatUIHQuNuY+5QyqaDHc2wVg/HocitduzHIm7SU3SZ/3u8W15zvK/hZEQw4CW/IyLET8OSDRdsCC7wT33SrirWK3tjZd1ignqKngEOlqVJMPHDTJKGXsfYy/cDTd59lBo9ILP2sqLX5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UaZrco2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UaZrco2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27777C4CEF1;
	Sat, 31 Jan 2026 22:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898281;
	bh=p/aTDp2VFieOhFqhJrJq3q/q13g4Sra9x4SMe+81dNg=;
	h=Date:To:From:Subject:From;
	b=UaZrco2v7EJQBZThud6yEU9dfo1GfsDYyd9IIZpYq0+JmfzhhhBSrCfFu/itojQUk
	 uzljqyT1/eEDINeaDd4XPrjnwYZdOd/QO1eNkhAu8tHp9d5ggF3xPeqT/hsNJ4+vlt
	 Wa6ldeBPVSBLHHxkHohcrdPjulSUT6DtLj0Nx7aM=
Date: Sat, 31 Jan 2026 14:24:40 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mst@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,gregkh@linuxfoundation.org,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,arnd@arndb.de,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-move-memory-balloon-infrastructure-to-memory-management-balloon.patch removed from -mm tree
Message-Id: <20260131222441.27777C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: move memory balloon infrastructure to "MEMORY MANAGEMENT - BALLOON"
has been removed from the -mm tree.  Its filename was
     maintainers-move-memory-balloon-infrastructure-to-memory-management-balloon.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: MAINTAINERS: move memory balloon infrastructure to "MEMORY MANAGEMENT - BALLOON"
Date: Tue, 20 Jan 2026 00:01:32 +0100

Nowadays, there is nothing virtio-balloon specific anymore about these
files, the basic infrastructure is used by multiple memory balloon
drivers.

For now we'll route it through Andrew's tree, maybe in some future it
makes sense to route this through a separate tree.

Link: https://lkml.kernel.org/r/20260119230133.3551867-25-david@kernel.org
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-move-memory-balloon-infrastructure-to-memory-management-balloon
+++ a/MAINTAINERS
@@ -16458,6 +16458,17 @@ T:	quilt git://git.kernel.org/pub/scm/li
 F:	mm/
 F:	tools/mm/
 
+MEMORY MANAGEMENT - BALLOON
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@kernel.org>
+L:	linux-mm@kvack.org
+L:	virtualization@lists.linux.dev
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/balloon.h
+F:	mm/balloon.c
+
 MEMORY MANAGEMENT - CORE
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
@@ -27546,9 +27557,7 @@ M:	David Hildenbrand <david@kernel.org>
 L:	virtualization@lists.linux.dev
 S:	Maintained
 F:	drivers/virtio/virtio_balloon.c
-F:	include/linux/balloon.h
 F:	include/uapi/linux/virtio_balloon.h
-F:	mm/balloon.c
 
 VIRTIO BLOCK AND SCSI DRIVERS
 M:	"Michael S. Tsirkin" <mst@redhat.com>
_

Patches currently in -mm which might be from david@kernel.org are

mm-move-pte-table-reclaim-code-to-memoryc.patch
mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch

