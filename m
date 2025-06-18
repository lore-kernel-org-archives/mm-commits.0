Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9611D63C2
	for <mm-commits@vger.kernel.org>; Wed, 18 Jun 2025 23:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750287668; cv=none; b=Hr04aiLewZ2eGy6+K4ZtsoiyF3BaISbRGcicRNLbD1dLsmZnJcTXnFsWcbV5uWkGby0VXFE4lxUbJjwe+DkOskes+/9xxQp8st9X5a2VzfejFCVsx+r6HtUqBq+4wvolpM+HPwt69HKRPKiLtKvaj34RDwS0HNba4TLKpXnY7iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750287668; c=relaxed/simple;
	bh=xXyzUidaqc/vGsr8Jw+ZSr+WM10LwnExHaN2N6ZgBTo=;
	h=Date:To:From:Subject:Message-Id; b=hc9tGbbJ4nZssGpTgUZjTwF65AK8hsNqX0FkwDfjmBW1QqVGhXDUuNhJ992mm1fhtAP+FUOtB07GC/ktqpabY0Y2rFyP97GIRbwiVWpXulMFX6oUsQsqd97IPMJ8bz3B67B02Zu9pTiENFNTVfLrgLNfuGaVRG55V/0DqxszpxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=12Nflze/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="12Nflze/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EEEC4CEE7;
	Wed, 18 Jun 2025 23:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750287668;
	bh=xXyzUidaqc/vGsr8Jw+ZSr+WM10LwnExHaN2N6ZgBTo=;
	h=Date:To:From:Subject:From;
	b=12Nflze/i/p9hUoSasPsZjyzgskAvgdgaJw3DiFhYm5qdxzIeNCoUOUXSYMqUo2Ob
	 RIzZHETOc6qw29bXs1YMT3k013UFubsjv672FDkPoWhWB7kyI485q3ueyWSN/rv0gZ
	 SUvIm48yqwhkRDijioBdmgR5xXIrYgeXjHRrLAXE=
Date: Wed, 18 Jun 2025 16:01:07 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-tree-entry-to-mm-init-block.patch added to mm-hotfixes-unstable branch
Message-Id: <20250618230108.61EEEC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add tree entry to mm init block
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-tree-entry-to-mm-init-block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-tree-entry-to-mm-init-block.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: MAINTAINERS: add tree entry to mm init block
Date: Wed, 18 Jun 2025 19:47:52 +0300

Link: https://lkml.kernel.org/r/aFLubPfiO5hqfhCe@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-tree-entry-to-mm-init-block
+++ a/MAINTAINERS
@@ -15678,6 +15678,8 @@ MEMBLOCK AND MEMORY MANAGEMENT INITIALIZ
 M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
 F:	Documentation/core-api/boot-time-mm.rst
 F:	Documentation/core-api/kho/bindings/memblock/*
 F:	include/linux/memblock.h
_

Patches currently in -mm which might be from rppt@kernel.org are

maintainers-add-tree-entry-to-mm-init-block.patch

