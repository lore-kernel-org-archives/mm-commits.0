Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958052DF152
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 01:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776217310; cv=none; b=DbfhOz5Oak2mlE9f+frndIqdysXe5HedKZjqmuJOZ2wWnWtZh0NkIi7gOQVWnHXZv+QTf/n5LvFVej2M7ZlTaAHtj7t4mmob8pajLwxcPsyBohqxMcrS2CrpCXlDa3RyeCUBmeuPX+8nGA3N7q53/i3Rthp91fl3tEQ+svi768w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776217310; c=relaxed/simple;
	bh=RuV0KXWX3ayMUJUH4iS22bILnkfA/sh60KxKi4u9Jww=;
	h=Date:To:From:Subject:Message-Id; b=LpZls3NX01dZlnHwdJcZy9J/QC2vxZYe91d3jj0b4kWaP/rxvKnOl3XYnSZ+aryHVsbpugdFMuJVZUGJX66mjlJqCoUy+S4MxOfQpFkQ+P83ifF2EAG3/iSUIFp0/qe7obatjq7xtDulDf4c9ArIKNo7OEdUo6AMf3tj6hp3Khg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SX00dRuL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SX00dRuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89971C19425;
	Wed, 15 Apr 2026 01:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776217310;
	bh=RuV0KXWX3ayMUJUH4iS22bILnkfA/sh60KxKi4u9Jww=;
	h=Date:To:From:Subject:From;
	b=SX00dRuLDqs/iVW0gwEH26tPl4VN+xQ1CJbOB4kQDF1xV7ZxkPQ2Srrv4oGbtlsBC
	 Pf3ni/6x8fbrybwjV/0YVzFsnKYt14AJP9+eiaT5/94O63xL7E8uo5WRL7+6C0yjgx
	 EHIjKnkC+ceurxvz/zYAcyNeo2pNtPxtaniXDM3o=
Date: Tue, 14 Apr 2026 18:41:46 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,david@kernel.org,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-kho-and-live-update-maintainers.patch added to mm-unstable branch
Message-Id: <20260415014149.89971C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update KHO and LIVE UPDATE maintainers
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-update-kho-and-live-update-maintainers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-kho-and-live-update-maintainers.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: MAINTAINERS: update KHO and LIVE UPDATE maintainers
Date: Tue, 14 Apr 2026 12:17:18 +0000

Patch series "MAINTAINERS: update KHO and LIVE UPDATE entries".

This series contains some updates for the Kexec Handover (KHO) and Live
update entries.  Patch 1 updates the maintainers list and adds the
liveupdate tree.  Patches 2 and 3 clean up stale files in the list.


This patch (of 3):

I have been helping out with reviewing and developing KHO.  I would also
like to help maintain it.  Change my entry from R to M for KHO and live
update.  Alex has been inactive for a while, so to avoid over-crowding the
KHO entry and to keep the information up-to-date, move his entry from M to
R.

We also now have a tree for KHO and live update at liveupdate/linux.git
where we plan to start maintaining those subsystems and start queuing the
patches.  List that in the entries as well.

Link: https://lkml.kernel.org/r/20260414121752.1912847-1-pratyush@kernel.org
Link: https://lkml.kernel.org/r/20260414121752.1912847-2-pratyush@kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Alexander Graf <graf@amazon.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    8 +++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/CREDITS~maintainers-update-kho-and-live-update-maintainers
+++ a/CREDITS
@@ -1460,6 +1460,10 @@ N: Vivek Goyal
 E: vgoyal@redhat.com
 D: KDUMP, KEXEC, and VIRTIO FILE SYSTEM
 
+N: Alexander Graf
+E: graf@amazon.com
+D: Kexec Handover (KHO)
+
 N: Wolfgang Grandegger
 E: wg@grandegger.com
 D: Controller Area Network (device drivers)
--- a/MAINTAINERS~maintainers-update-kho-and-live-update-maintainers
+++ a/MAINTAINERS
@@ -14114,13 +14114,14 @@ F:	include/uapi/linux/kexec.h
 F:	kernel/kexec*
 
 KEXEC HANDOVER (KHO)
-M:	Alexander Graf <graf@amazon.com>
 M:	Mike Rapoport <rppt@kernel.org>
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
-R:	Pratyush Yadav <pratyush@kernel.org>
+M:	Pratyush Yadav <pratyush@kernel.org>
+R:	Alexander Graf <graf@amazon.com>
 L:	kexec@lists.infradead.org
 L:	linux-mm@kvack.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
 F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
@@ -14807,9 +14808,10 @@ F:	tools/testing/selftests/livepatch/
 LIVE UPDATE
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 M:	Mike Rapoport <rppt@kernel.org>
-R:	Pratyush Yadav <pratyush@kernel.org>
+M:	Pratyush Yadav <pratyush@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
 F:	Documentation/core-api/liveupdate.rst
 F:	Documentation/mm/memfd_preservation.rst
 F:	Documentation/userspace-api/liveupdate.rst
_

Patches currently in -mm which might be from pratyush@kernel.org are

maintainers-update-kho-and-live-update-maintainers.patch
maintainers-drop-include-linux-kho-abi-from-kho.patch
maintainers-drop-include-linux-liveupdate-from-live-update.patch

