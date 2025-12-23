Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8D52F3C02
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 19:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517853; cv=none; b=tmgvuM0y/PNggPdYy4EgwoRcAQf7NQEF4jy7FaoTYvRtIIW7gkkCHaxkGbuSRLxx4wtu9d9zCEqK+dbKWWFuN2CLpsLK9C7o6morFebEztsAG34PR8AtrqzMgCGfSEZ91BsPGBxy0Y6wxDz9lK8ndY+Lp095inft2A7wbx7xVOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517853; c=relaxed/simple;
	bh=UxIq2JgcU7Hav1Zk+0y96aYy0COpMzCAuUrJDv3pM9o=;
	h=Date:To:From:Subject:Message-Id; b=u09NlxF0vTmO08+sElss5mX7cjeaVpnmxFbOpoCS2psSPqWCVNZuqQio0JvDlow+QWMbBUV33afVaL4xEu8w3libfrcEfaqg42tF49LDhlLUzSpT2HvSXaquKef7gyaP54g01MZCPVQSj9qip6lbGtm6V+FCqBhcnmqD6jrn5g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wGYBRGZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wGYBRGZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D1EC113D0;
	Tue, 23 Dec 2025 19:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517852;
	bh=UxIq2JgcU7Hav1Zk+0y96aYy0COpMzCAuUrJDv3pM9o=;
	h=Date:To:From:Subject:From;
	b=wGYBRGZsiJ/dFFH0MKyJPWN7DVRwAjtygbNT2Po2wqPmiEufI6HFEzOUjhCAKRQjL
	 L3ElgUdByCM+w1B0+KYI96qLoWadf4V/IzsHy1rikxOc5TLZGHG+nDGgR3WM8snvmf
	 H9/LB5Yl1GfiUq6g7nePmrISjFlu54qIpc18iWoM=
Date: Tue, 23 Dec 2025 11:24:12 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-abi-headers-to-kho-and-live-update.patch removed from -mm tree
Message-Id: <20251223192412.94D1EC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add ABI headers to KHO and LIVE UPDATE
has been removed from the -mm tree.  Its filename was
     maintainers-add-abi-headers-to-kho-and-live-update.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pratyush Yadav <pratyush@kernel.org>
Subject: MAINTAINERS: add ABI headers to KHO and LIVE UPDATE
Date: Fri, 12 Dec 2025 16:12:02 +0900

include/linux/kho is supposed to hold KHO headers.  Add it to KHO's
MAINTAINERS entry so the right people can get patches to it.

include/linux/kho/abi contains the live update ABI headers for LUO core
and memfd.  It will also hold ABI headers for other upcoming file types as
well.  Add it to live update entry so live update maintainers can get
changes for it (currently they happen to be the same people).

Link: https://lkml.kernel.org/r/20251212071204.398788-1-pratyush@kernel.org
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-abi-headers-to-kho-and-live-update
+++ a/MAINTAINERS
@@ -13959,6 +13959,7 @@ S:	Maintained
 F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
+F:	include/linux/kho/
 F:	kernel/liveupdate/kexec_handover*
 F:	lib/test_kho.c
 F:	tools/testing/selftests/kho/
@@ -14637,6 +14638,7 @@ S:	Maintained
 F:	Documentation/core-api/liveupdate.rst
 F:	Documentation/mm/memfd_preservation.rst
 F:	Documentation/userspace-api/liveupdate.rst
+F:	include/linux/kho/abi/
 F:	include/linux/liveupdate.h
 F:	include/linux/liveupdate/
 F:	include/uapi/linux/liveupdate.h
_

Patches currently in -mm which might be from pratyush@kernel.org are

kho-simplify-page-initialization-in-kho_restore_page.patch

