Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DBC12FF69
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597493; cv=none; b=OXbQbvoD4oobGLgVo0rzqjaiAhwm+6zzLH7iY4o9fBB2gEtb3WMPt/ZFjdTQ8MdoFX2UJj7ogqN+QJvqEY9SXfVrZGlVqs3I3SHVRvyDa2afrsz73UWsVkrdMsOaa7PmvcfykAlthlICUFHaVTrT1vICHYKpuv4WW87diBNuiKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597493; c=relaxed/simple;
	bh=f5tMUBugRHMWw1CZ5MDhWps4DvjSrSqv8rUMpGJeTDg=;
	h=Date:To:From:Subject:Message-Id; b=BBMAkucUq73+7BYhtd5+yIFL1NFaO/ZENxMNJfCImWUGQ9GWFlZTBZ9/q0NLNHukPsg229EunogmTMDpXNrbvBV55DZzCQE3gg6nKPrVw29O0dY09xfp09WSeWwbiReE8UhiwW/qySGgDaHAnxT4jOK8c5YdejBDLqSOQSnVuXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JXqpbJA7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JXqpbJA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B84C4CEF0;
	Tue, 23 Sep 2025 03:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597493;
	bh=f5tMUBugRHMWw1CZ5MDhWps4DvjSrSqv8rUMpGJeTDg=;
	h=Date:To:From:Subject:From;
	b=JXqpbJA7ikjiFoP80q1o9I6nxPTgwfY2zHbiesC0d2kVCXV8WznHSqVzsuevekPK3
	 Y8bFVABQg1dEIydr59QUYcDlyyYvoC8FHVhIJZU9b0IZpVtgC1VvAfqkRHOkam5eqs
	 9aCVsxMSp/33396QGKCmXsAmoH0aEQE1cQyoyc24=
Date: Mon, 22 Sep 2025 20:18:12 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,viro@zeniv.linux.org.uk,vgoyal@redhat.com,vbabka@suse.cz,urezki@gmail.com,tsbogend@alpha.franken.de,tony.luck@intel.com,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,robin.murphy@arm.com,reinette.chatre@intel.com,pfalcato@suse.de,osalvador@suse.de,nico@fluxnic.net,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,kevin.tian@intel.com,jgg@nvidia.com,jannh@google.com,james.morse@arm.com,jack@suse.cz,hughd@google.com,hca@linux.ibm.com,guoren@kernel.org,gregkh@linuxfoundation.org,gor@linux.ibm.com,dyoung@redhat.com,dvyukov@google.com,david@redhat.com,davem@davemloft.net,dave.martin@arm.com,dave.jiang@intel.com,dan.j.williams@intel.com,corbet@lwn.net,brauner@kernel.org,borntraeger@linux.ibm.com,bhe@redhat.com,baolin.wang@linux.alibaba.com,arnd@arndb.de,andreyknvl@gmail.com,andreas@gaisler.com,almaz.alexandrovich@paragon-software.com,agordeev@linux.ibm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch removed from -mm tree
Message-Id: <20250923031813.02B84C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: doc: update porting, vfs documentation for mmap_prepare actions
has been removed from the -mm tree.  Its filename was
     doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: doc: update porting, vfs documentation for mmap_prepare actions
Date: Wed, 17 Sep 2025 20:11:12 +0100

Now we have introduced the ability to specify that actions should be taken
after a VMA is established via the vm_area_desc->action field as specified
in mmap_prepare, update both the VFS documentation and the porting guide
to describe this.

Link: https://lkml.kernel.org/r/269f7675d0924fff58c427bc8f4e37487e985539.1758135681.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chatre, Reinette <reinette.chatre@intel.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Martin <dave.martin@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/porting.rst |    5 +++++
 Documentation/filesystems/vfs.rst     |    4 ++++
 2 files changed, 9 insertions(+)

--- a/Documentation/filesystems/porting.rst~doc-update-porting-vfs-documentation-for-mmap_prepare-actions
+++ a/Documentation/filesystems/porting.rst
@@ -1285,3 +1285,8 @@ rather than a VMA, as the VMA at this st
 The vm_area_desc provides the minimum required information for a filesystem
 to initialise state upon memory mapping of a file-backed region, and output
 parameters for the file system to set this state.
+
+In nearly all cases, this is all that is required for a filesystem. However, if
+a filesystem needs to perform an operation such a pre-population of page tables,
+then that action can be specified in the vm_area_desc->action field, which can
+be configured using the mmap_action_*() helpers.
--- a/Documentation/filesystems/vfs.rst~doc-update-porting-vfs-documentation-for-mmap_prepare-actions
+++ a/Documentation/filesystems/vfs.rst
@@ -1236,6 +1236,10 @@ otherwise noted.
 	file-backed memory mapping, most notably establishing relevant
 	private state and VMA callbacks.
 
+	If further action such as pre-population of page tables is required,
+	this can be specified by the vm_area_desc->action field and related
+	parameters.
+
 Note that the file operations are implemented by the specific
 filesystem in which the inode resides.  When opening a device node
 (character or block special) most filesystems will call special
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


