Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4E0272908
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 23:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739315439; cv=none; b=mP4lo7KMehvf1wWiGHXagqnJSEIJzg558efTkQE9Tn566jFE9PdJPV+hGEFC5v1k7EhhHxWMth8T+GTnVOjguuN5EUoS0lW7OVfo/S/ftUoiqWZ38EW6TvyGuphFPduOf0BCZoayKhkMPXjiehiKkH2pYl2Wpyjkx7gZ+jt1wug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739315439; c=relaxed/simple;
	bh=hbXq3EjJOcl775LDaw+stbaGJgCjcPzb9f1C3PkEeJo=;
	h=Date:To:From:Subject:Message-Id; b=Gy8FHLCCEUyHtx4FKAvqWldU/K0lyw7OdgXX/WQldEfSdFdD/TjmXHCS0vlqHAycHZHVupAKjmHv2w7kRqKD6jTsUIgX7WARuaTH2kdedTyxL0HKMIlU0V6dxOUzCN7Ekw9YAx8wKM2pF8s65JFqFWHJxLuvPYVMirdMDTcyO4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yc0VJcZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yc0VJcZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286F7C4CEDD;
	Tue, 11 Feb 2025 23:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739315439;
	bh=hbXq3EjJOcl775LDaw+stbaGJgCjcPzb9f1C3PkEeJo=;
	h=Date:To:From:Subject:From;
	b=yc0VJcZgw9fC3MkJuiZlI85l4yap4emDefKtwYFDN6hNQyKsXIhsypH0rrRMsZIay
	 9FtwDZmsZz5PXuvDje6FiWrcYmU0xxoMbJhVgYsIFO4FgMtNJcwcc9kzYWU0wjBLlE
	 VEoLF9iromrzQDYQEs4SDAHIXhMLXm8yg96Xbwdg=
Date: Tue, 11 Feb 2025 15:10:38 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,hannes@cmpxchg.org,david@redhat.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-damon-document-damos-sysfs-files-to-set-the-min-max-folio_size.patch added to mm-unstable branch
Message-Id: <20250211231039.286F7C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/ABI/damon: document DAMOS sysfs files to set the min/max folio_size
has been added to the -mm mm-unstable branch.  Its filename is
     docs-abi-damon-document-damos-sysfs-files-to-set-the-min-max-folio_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-document-damos-sysfs-files-to-set-the-min-max-folio_size.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: Docs/ABI/damon: document DAMOS sysfs files to set the min/max folio_size
Date: Tue, 11 Feb 2025 12:43:42 +0000

This will be used to decide the min and max folio size to operate on for
pa_stat.

Link: https://lkml.kernel.org/r/20250211124437.278873-4-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-damos-sysfs-files-to-set-the-min-max-folio_size
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -345,6 +345,20 @@ Description:	If 'addr' is written to the
 		from this file sets or gets the end address of the address
 		range for the filter.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/min
+Date:		Feb 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	If 'hugepage_size' is written to the 'type' file, writing to
+		or reading from this file sets or gets the minimum size of the
+		hugepage for the filter.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/max
+Date:		Feb 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	If 'hugepage_size' is written to the 'type' file, writing to
+		or reading from this file sets or gets the maximum size of the
+		hugepage for the filter.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/target_idx
 Date:		Dec 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-damon-ops-have-damon_get_folio-return-folio-even-for-tail-pages.patch
mm-damon-introduce-damos-filter-type-hugepage_size.patch
mm-damon-sysfs-schemes-add-files-for-setting-damos_filter-sz_range.patch
docs-abi-damon-document-damos-sysfs-files-to-set-the-min-max-folio_size.patch
docs-admin-guide-mm-damon-usage-document-hugepage_size-filter-type.patch

