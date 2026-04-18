Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE916DDCD
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499180; cv=none; b=f0K/ceLoM7qZWuaRbVFUfA1xyE3PaDR7aht+iParJ1VyUZsooXC6KPfS9y7TpZyWSUM5F+S4YfFGC1M3fzpuUHZGZHhZxRa7/+4u+sEms9TyMjbfgu5PP0AxVyczTNmGC0nmfxT0EsYFgVCsK3mTBIq3oPZDlLczo5pZR5ZYnco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499180; c=relaxed/simple;
	bh=4wlfVxgH3KNEEthDNJeg2W/3HicZTZshOvr3V9AWN3o=;
	h=Date:To:From:Subject:Message-Id; b=pvzIAqKVpU6gP4xJNPP4w2NfRYlubIvKDXP/wP528AVO5XhhLAkfKhHNuYkOrPqpO29f7lAGiZ8hud7BRgPc2Q3O2KMgDhFg2A4G6PWJDaixRC0/hWRUSZQ5V8FWD9/PRLNT5FKqHG2sdR7JU/tSOltw1NcNsrk+dHpr+OdkwGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HLWt73bW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HLWt73bW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CBDC19424;
	Sat, 18 Apr 2026 07:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499180;
	bh=4wlfVxgH3KNEEthDNJeg2W/3HicZTZshOvr3V9AWN3o=;
	h=Date:To:From:Subject:From;
	b=HLWt73bWe/h3SIJ3EKjjCG63BgLgH0R2JibkatXMdISF2H0IWEPLsS5qB4bMtZdQB
	 CGiGYU2zOrAAitK7KGLG8UZo5uuG/ID1SQzsoQRp6y20Vn4BC8RYTFF2nncZh+ccVs
	 Flm6QKCM6tXj+HBT3oUQOzfXEQk2zIj1czrxNtqQ=
Date: Sat, 18 Apr 2026 00:59:35 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,david@kernel.org,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-update-kho-and-live-update-maintainers.patch removed from -mm tree
Message-Id: <20260418075939.C0CBDC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update KHO and LIVE UPDATE maintainers
has been removed from the -mm tree.  Its filename was
     maintainers-update-kho-and-live-update-maintainers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260414121752.1912847-1-pratyush@kernel.org
Link: https://lore.kernel.org/20260414121752.1912847-2-pratyush@kernel.org
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


