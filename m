Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5846E2DECCC
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 23:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749771844; cv=none; b=RloGFlhzE/rPl5fjjZAvU9AHEJeyw19vZbhIcBA8Y4o/vVFn/9aTOqNUtm1BI/tdtPkBZBPoL4fKQ5sjBAuFu8XO8RWvEaFMU6hgnTEyXn1XUMFRma68Y+RNQwhkFim3svH/KEwqXDkDi91BnfGccXQF9pckTvt6ZBHp7VyGrXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749771844; c=relaxed/simple;
	bh=ilaRNrx5rXG2ItL81jI0abKlZomMUX3Rdt6eHvie7xE=;
	h=Date:To:From:Subject:Message-Id; b=ss17DAUOMVhevfuYDjj7cX040GrZSVfNwoMT7X+zTZw7x+VsIOj66Ke03deU/zitET+C6jf8P06aWabK5a3/IDowAI2gx0vtp5vL6GHLQKPW4S9pCEwmVqFVjEitYGKfQ7kWQ3qlKftiJHoj/RP2MCFHMfFD7Hr19146SywhLGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tVi5Wu+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tVi5Wu+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3199C4CEEA;
	Thu, 12 Jun 2025 23:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749771843;
	bh=ilaRNrx5rXG2ItL81jI0abKlZomMUX3Rdt6eHvie7xE=;
	h=Date:To:From:Subject:From;
	b=tVi5Wu+WVbeFPnNN+YnVOndCkGZOkxBLvKF83Q6WTzHuxHQfDBdUrOo+KRCft4ILI
	 7yn2gGbDT6KBL1fVp0J0L+SLxEri+ItcqJwrBwQ6LQHLxxxba4jgVu1cXK93j78lpw
	 TP0YLNn/+xrAQTcRpjiOZ1Yznxqck/aZ9ALN+PMQ=
Date: Thu, 12 Jun 2025 16:44:03 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,prudo@redhat.com,piliu@redhat.com,mhocko@suse.cz,ltao@redhat.com,dyoung@redhat.com,ddutile@redhat.com,david@redhat.com,bhe@redhat.com,jbohac@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kdump-documentation-describe-craskernel-cma-reservation.patch added to mm-nonmm-unstable branch
Message-Id: <20250612234403.C3199C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kdump, documentation: describe craskernel CMA reservation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kdump-documentation-describe-craskernel-cma-reservation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kdump-documentation-describe-craskernel-cma-reservation.patch

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

add-a-new-optional-cma-suffix-to-the-crashkernel=-command-line-option.patch
kdump-implement-reserve_crashkernel_cma.patch
kdump-documentation-describe-craskernel-cma-reservation.patch
kdump-wait-for-dma-to-finish-when-using-cma.patch
x86-implement-crashkernel-cma-reservation.patch

