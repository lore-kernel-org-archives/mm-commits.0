Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE943D669E
	for <mm-commits@vger.kernel.org>; Thu, 12 Mar 2026 21:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350632; cv=none; b=PSXaQZqdSRNkOJkWWkMCaLLLupeEenLfULh0AfF7W2aIrS2krh4G8IQrTzcgSU0/zMHVInvqihB6XbRK5U1RwDeBl+AQVCBSUfs0KDd+D+LGmzK9muqbUV9fN/OBnLYF17kbGcbLHR7Gr2e/4XQeCV6A2KJ19SPdfixnaXc+uhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350632; c=relaxed/simple;
	bh=zJH4VK61HwCn7kUhCwgGWv9lS9ywXoc2hamEVnnv3og=;
	h=Date:To:From:Subject:Message-Id; b=E58EFAnV6qc7GdKBQ07HxyprLGcA4GdUKdy7uhuiTFjurn6Q7CSt9mzuRS+FZ/6KQEtHUxME4B6H6neuB74UOQHrqKIkiWNravs2BB8qta/yYYTfnk7hkeaWw/N8HvYYZOxS1ul3EDCKdFYJshXeoXWDElspIZt++7IRsVYoWkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VOa2U2sZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VOa2U2sZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546BCC4CEF7;
	Thu, 12 Mar 2026 21:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773350631;
	bh=zJH4VK61HwCn7kUhCwgGWv9lS9ywXoc2hamEVnnv3og=;
	h=Date:To:From:Subject:From;
	b=VOa2U2sZKW1MIt9XniqitbIlcHMrtPQk6QbxpV6DtJPwsXyJJiSwejLtedO1jP/2v
	 tUKDeF3JtASyRWHzSAzlo5oXJOR3qDCnDpx4OYVMGr3GzuYagG6TB3lQmWBlt9s8s5
	 xlB9wyezhMGAazsfKjsLP5b5HSk9NOTtEz8/TPHY=
Date: Thu, 12 Mar 2026 14:23:50 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,viro@zeniv.linux.org.uk,vigneshr@ti.com,vbabka@kernel.org,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,richard@nod.at,pfalcato@suse.de,miquel.raynal@bootlin.com,mhocko@suse.com,mcoquelin.stm32@gmail.com,martin.petersen@oracle.com,marc.dionne@auristor.com,longli@microsoft.com,ljs@kernel.org,liam.howlett@oracle.com,kys@microsoft.com,jannh@google.com,jack@suse.cz,haiyangz@microsoft.com,gregkh@linuxfoundation.org,dhowells@redhat.com,decui@microsoft.com,david@kernel.org,corbet@lwn.net,clemens@ladisch.de,brauner@kernel.org,bostroesser@gmail.com,arnd@arndb.de,alexandre.torgue@foss.st.com,alexander.shishkin@linux.intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-various-small-mmap_prepare-cleanups-fix.patch added to mm-new branch
Message-Id: <20260312212351.546BCC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-various-small-mmap_prepare-cleanups-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-various-small-mmap_prepare-cleanups-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-various-small-mmap_prepare-cleanups-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-various-small-mmap_prepare-cleanups-fix
Date: Thu Mar 12 02:11:42 PM PDT 2026

fix build

mm/util.c: In function 'mmap_action_prepare':
mm/util.c:1451:1: error: control reaches end of non-void function [-Werror=return-type]
 1451 | }


Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bodo Stroesser <bostroesser@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Long Li <longli@microsoft.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Richard Weinberger <richard@nod.at>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/util.c~mm-various-small-mmap_prepare-cleanups-fix
+++ a/mm/util.c
@@ -1356,6 +1356,8 @@ int mmap_action_prepare(struct vm_area_d
 		return remap_pfn_range_prepare(desc, action);
 	case MMAP_IO_REMAP_PFN:
 		return io_remap_pfn_range_prepare(desc, action);
+	default:
+		BUG();
 	}
 }
 EXPORT_SYMBOL(mmap_action_prepare);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
mm-various-small-mmap_prepare-cleanups-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
decode_stacktrace-decode-caller-address-checkpatch-fixes.patch

