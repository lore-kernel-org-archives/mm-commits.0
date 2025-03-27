Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDC41A3150
	for <mm-commits@vger.kernel.org>; Thu, 27 Mar 2025 17:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743097782; cv=none; b=CQzN9TjdZtuXm4P6q8VceNckWiEIZOyFeSxuATJKMW9EamC39Ad8z2WDdX3XSFtUR17DsNr0iYTKsJqu1ACno2ercYTBCFMQ2mUhdlBdsi020FUEgWwl17vJDzR6CnpKhgy3PoTKjY+78OzcshZtIBtUtXXX0KeT+ZT9soQw6PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743097782; c=relaxed/simple;
	bh=ato4H9pzD6/h2iIfiFbAqkg428+NSZEZtbT+il4P7IE=;
	h=Date:To:From:Subject:Message-Id; b=Ol2WWhsWSp1p4MztF1wa7r2OWOHIQGTmtv0L0hYd5Tn9fQq1GBMPRT1P7/MLYPa0dbFGbeNKIQkk/kTTlHj7GdF/+zpSBcnCsOEk8XDyHudwX2mtNyLCxpqNi3DJlyUwMLfOs4b8pZvXCE6sqPq1I5sKfAHPQrXALB5fGZG9t+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jhpZX77N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jhpZX77N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D91C4CEDD;
	Thu, 27 Mar 2025 17:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743097782;
	bh=ato4H9pzD6/h2iIfiFbAqkg428+NSZEZtbT+il4P7IE=;
	h=Date:To:From:Subject:From;
	b=jhpZX77N65h57o35OaalvIz7CmzINEh8dlQl5sZ/KmScmUPevcWFMLPbDl4yEonoh
	 /rNLY321QLFelTTPirrre4yRhHZcjeLDOBUBxGEQFLEcY+LlafkzzaMn4b/V5x/AYf
	 DVFYp5wNwZpYbQ2RkDOmMjOInik6FjSQRSPbh+1I=
Date: Thu, 27 Mar 2025 10:49:41 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,mhocko@suse.com,dan.j.williams@intel.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-fixup-userfaultfd-entry.patch added to mm-unstable branch
Message-Id: <20250327174942.21D91C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: fixup USERFAULTFD entry
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-fixup-userfaultfd-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-fixup-userfaultfd-entry.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MAINTAINERS: fixup USERFAULTFD entry
Date: Wed, 26 Mar 2025 23:55:38 +0200

Patch series "MAINTAINERS: add my isub-entries to MM part."

Following discussion at LSF/MM/BPF I'm adding execmem, secretmem and
numa memblocks sub-entries for MEMORY MANAGEMENT in MAINTAINERS.


This patch (of 4):

Change title to "MEMORY MANAGEMENT - USERFAULTFD" and make it sub-topic in
memory management and add missing include/linux/userfaultfd_k.h and
mailing list

Link: https://lkml.kernel.org/r/20250326215541.1809379-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20250326215541.1809379-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dan Willaims <dan.j.williams@intel.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/MAINTAINERS~maintainers-fixup-userfaultfd-entry
+++ a/MAINTAINERS
@@ -15200,6 +15200,19 @@ F:	tools/mm/
 F:	tools/testing/selftests/mm/
 N:	include/linux/page[-_]*
 
+MEMORY MANAGEMENT - USERFAULTFD
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Peter Xu <peterx@redhat.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	Documentation/admin-guide/mm/userfaultfd.rst
+F:	fs/userfaultfd.c
+F:	include/asm-generic/pgtable_uffd.h
+F:	include/linux/userfaultfd_k.h
+F:	include/uapi/linux/userfaultfd.h
+F:	mm/userfaultfd.c
+F:	tools/testing/selftests/mm/uffd-*.[ch]
+
 MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
@@ -15220,18 +15233,6 @@ F:	mm/vma.h
 F:	mm/vma_internal.h
 F:	tools/testing/vma/
 
-MEMORY USERFAULTFD
-M:	Andrew Morton <akpm@linux-foundation.org>
-R:	Peter Xu <peterx@redhat.com>
-S:	Maintained
-F:	Documentation/admin-guide/mm/userfaultfd.rst
-F:	fs/userfaultfd.c
-F:	include/asm-generic/pgtable_uffd.h
-F:	include/linux/userfaultfd_k.h
-F:	include/uapi/linux/userfaultfd.h
-F:	mm/userfaultfd.c
-F:	tools/testing/selftests/mm/uffd-*.[ch]
-
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
 M:	Richard Weinberger <richard@nod.at>
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-mm_init-init-holes-in-the-end-of-the-memory-map-for-flatmem.patch
memblock-dont-release-high-memory-to-page-allocator-when-highmem-is-off.patch
maintainers-fixup-userfaultfd-entry.patch
maintainers-mm-add-entry-for-execmem.patch
maintainers-mm-add-entry-for-numa-memblocks-and-numa-emulation.patch
maintainers-mm-add-entry-for-secretmem.patch

