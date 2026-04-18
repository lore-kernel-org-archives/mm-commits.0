Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAE53750D5
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499186; cv=none; b=JgA8vpwryGQ42XhvdWRhEhce1X8VaLOUBbId45v5rI/ljygWNzRdbKDfG+h8M2Eq9yJdYrRxUpJM9gpw/4+8JyM3WcewvXbouiiwsyxRZkkub22OvK7uzKyskyMIDxS7rOh3J5s7oq9uhGiS02hw9GWbe706qKFf7w8IdC0YH9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499186; c=relaxed/simple;
	bh=qTArqjLSGI/Syms+PWnckyUGdypWl8kMWIqndEBnIes=;
	h=Date:To:From:Subject:Message-Id; b=QQ2gCx4rYfEznehCb72G7OQaz3m3SEhZ9hKn9jinK7O5lQICDmVd4bQE1P5z5hd2ZiWFqnblBQNVu80026Wo0+XQhSxrP3v7t3745qye1OUafa6A754ki/LGrD2QbZCb2LTeXbdnn06oLrQnZo5l2DcmXumEQh+QMXt46+nFq3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u6wB/6HO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u6wB/6HO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6095C19424;
	Sat, 18 Apr 2026 07:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499186;
	bh=qTArqjLSGI/Syms+PWnckyUGdypWl8kMWIqndEBnIes=;
	h=Date:To:From:Subject:From;
	b=u6wB/6HO0gmbv4yRAzeyZsv6Q4+UR3tKqVq/KhOVZjDlEkY1w1dQeu+Wsg78cNaDK
	 tVsh/CLYUslv63or+Jcbu0wnLR+sRDiHF65uOTib9AMS7AGJmvFQBDj16KhmacRcLV
	 N5ISzN1cTo//B35Rq/1BgIkI8EhXIHfy2koB9sPY=
Date: Sat, 18 Apr 2026 00:59:41 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,david@kernel.org,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-drop-include-linux-kho-abi-from-kho.patch removed from -mm tree
Message-Id: <20260418075945.A6095C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: drop include/linux/kho/abi/ from KHO
has been removed from the -mm tree.  Its filename was
     maintainers-drop-include-linux-kho-abi-from-kho.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: MAINTAINERS: drop include/linux/kho/abi/ from KHO
Date: Tue, 14 Apr 2026 12:17:19 +0000

The KHO entry already includes include/linux/kho.  Listing its
subdirectory is redundant.

Link: https://lore.kernel.org/20260414121752.1912847-3-pratyush@kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-drop-include-linux-kho-abi-from-kho
+++ a/MAINTAINERS
@@ -14126,7 +14126,6 @@ F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
 F:	include/linux/kho/
-F:	include/linux/kho/abi/
 F:	kernel/liveupdate/kexec_handover*
 F:	lib/test_kho.c
 F:	tools/testing/selftests/kho/
_

Patches currently in -mm which might be from pratyush@kernel.org are


