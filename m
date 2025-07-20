Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB38C120
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977347; cv=none; b=YB04YSM4jfeUjiRyUWdJboPKLF9UFNh2otS2lqoPGYtyWJB1IjC5kHbM0vZ00OLXpqwTSnCbCM7HS602pM1iMIXBzDVwp38bGX4QUFUmJdy4/aKkWdrr5H1aYc7ut1DM49Wj+eDdCjpMojCWkG7HJDuNOxVaQStEyKa1uLvKDLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977347; c=relaxed/simple;
	bh=8jRS4Iyzs6c8kDY2dLjNwMgGKmibcUniA6eb/CM0tz8=;
	h=Date:To:From:Subject:Message-Id; b=ZGXyCvAfGyR6MjM5ei/RKuy/bf3uLu/PEDJWw+BuN5LExXpRyJ5yj+OMO9GEt8m19eFDnStoTP8KNzFv6dD0wkcFSDV8M6eQvSSp/V9miBohTQFKgR47pdO2vVMfonatPio23H0VBa2gCkGWyTjGUJs85f+LU+O01jTZG14Yeas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nqH1J1Ij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nqH1J1Ij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39296C4CEE3;
	Sun, 20 Jul 2025 02:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977347;
	bh=8jRS4Iyzs6c8kDY2dLjNwMgGKmibcUniA6eb/CM0tz8=;
	h=Date:To:From:Subject:From;
	b=nqH1J1Ij4cobHJpwsf358/v+LviW92BgcOBb6YxVum/SqiYjgUXyeOhb2YG9spfru
	 mN+MkpHR02DL/ca4ercRsUyLcWv/SKbZQCoMH4ewQ0KWkUwce1nxDnpiHL1TcKPmGh
	 eEGZnkOM24r7aiM2x9vAexSqDWp3ms+yjpGbInOo=
Date: Sat, 19 Jul 2025 19:09:06 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,prudo@redhat.com,piliu@redhat.com,mhocko@suse.cz,ltao@redhat.com,dyoung@redhat.com,ddutile@redhat.com,david@redhat.com,bhe@redhat.com,jbohac@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kdump-documentation-describe-craskernel-cma-reservation.patch removed from -mm tree
Message-Id: <20250720020907.39296C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kdump, documentation: describe craskernel CMA reservation
has been removed from the -mm tree.  Its filename was
     kdump-documentation-describe-craskernel-cma-reservation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiri Bohac <jbohac@suse.cz>
Subject: kdump, documentation: describe craskernel CMA reservation
Date: Thu, 12 Jun 2025 12:17:39 +0200

Describe the new crashkernel ",cma" suffix in Documentation/

Link: https://lkml.kernel.org/r/aEqpQwUy6gqSiUkV@dwarf.suse.cz
Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donald Dutile <ddutile@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Philipp Rudo <prudo@redhat.com>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Tao Liu <ltao@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/kdump.rst       |   21 +++++++++++++
 Documentation/admin-guide/kernel-parameters.txt |   22 ++++++++++++++
 2 files changed, 43 insertions(+)

--- a/Documentation/admin-guide/kdump/kdump.rst~kdump-documentation-describe-craskernel-cma-reservation
+++ a/Documentation/admin-guide/kdump/kdump.rst
@@ -311,6 +311,27 @@ crashkernel syntax
 
             crashkernel=0,low
 
+4) crashkernel=size,cma
+
+	Reserve additional crash kernel memory from CMA. This reservation is
+	usable by the first system's userspace memory and kernel movable
+	allocations (memory balloon, zswap). Pages allocated from this memory
+	range will not be included in the vmcore so this should not be used if
+	dumping of userspace memory is intended and it has to be expected that
+	some movable kernel pages may be missing from the dump.
+
+	A standard crashkernel reservation, as described above, is still needed
+	to hold the crash kernel and initrd.
+
+	This option increases the risk of a kdump failure: DMA transfers
+	configured by the first kernel may end up corrupting the second
+	kernel's memory.
+
+	This reservation method is intended for systems that can't afford to
+	sacrifice enough memory for standard crashkernel reservation and where
+	less reliable and possibly incomplete kdump is preferable to no kdump at
+	all.
+
 Boot into System Kernel
 -----------------------
 1) Update the boot loader (such as grub, yaboot, or lilo) configuration
--- a/Documentation/admin-guide/kernel-parameters.txt~kdump-documentation-describe-craskernel-cma-reservation
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -986,6 +986,28 @@
 			0: to disable low allocation.
 			It will be ignored when crashkernel=X,high is not used
 			or memory reserved is below 4G.
+	crashkernel=size[KMG],cma
+			[KNL, X86] Reserve additional crash kernel memory from
+			CMA. This reservation is usable by the first system's
+			userspace memory and kernel movable allocations (memory
+			balloon, zswap). Pages allocated from this memory range
+			will not be included in the vmcore so this should not
+			be used if dumping of userspace memory is intended and
+			it has to be expected that some movable kernel pages
+			may be missing from the dump.
+
+			A standard crashkernel reservation, as described above,
+			is still needed to hold the crash kernel and initrd.
+
+			This option increases the risk of a kdump failure: DMA
+			transfers configured by the first kernel may end up
+			corrupting the second kernel's memory.
+
+			This reservation method is intended for systems that
+			can't afford to sacrifice enough memory for standard
+			crashkernel reservation and where less reliable and
+			possibly incomplete kdump is preferable to no kdump at
+			all.
 
 	cryptomgr.notests
 			[KNL] Disable crypto self-tests
_

Patches currently in -mm which might be from jbohac@suse.cz are


