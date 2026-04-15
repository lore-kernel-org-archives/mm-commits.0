Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1575A30146C
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 01:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776217315; cv=none; b=umIKbBqvB3BdrypAeXr0rS89BQgh0pL2JKXz5iz3/BjFdfmulbUk1lXgLhFX3um5HKF8bnZTnzhRIaJcviFL0vvRkp2QhzVAmImwjuiEg3hn4gqko7TP7+oF3BnUxIIameyrXWttbHe5ZK5MfeTMU9ZW1G6/b3izTWsyIHbKLac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776217315; c=relaxed/simple;
	bh=5Crl2oAjOL2icc+SGjxB71RmA6t0uK9yhSTfVcgJ+l4=;
	h=Date:To:From:Subject:Message-Id; b=gC6c+WLNR+PEHbwLzk3LTYftxs7cHNtpoHm+BzcPQcOla/kV5zydnPXENpwNH/dR6XBT/a8LsZLQgUSTyHOBs3ZxwILUAWMMer+2QSek735utrfEY2WJWCocKVI+dg4xdebCaGb5VoGKeasfDzrR0G55uPvK5TIQuN6MF2xbYQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bg8wl3aX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bg8wl3aX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA0EC19425;
	Wed, 15 Apr 2026 01:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776217314;
	bh=5Crl2oAjOL2icc+SGjxB71RmA6t0uK9yhSTfVcgJ+l4=;
	h=Date:To:From:Subject:From;
	b=Bg8wl3aXnMI13ZBOSFjbn+Ej4ZU0/gvcm5tE/YuHsq+qbLnX8SsWpDZerI/tFDDTp
	 ifdSKJS6w9bTAOdJ6Bpth/vlOrSKW6rmmBdnYhZU0qo7tWTzUjYqWt4SMWo9963l4P
	 rUbBJnWB7bVwVdK5A554Z/02E8fzHdHuplz2rXCs=
Date: Tue, 14 Apr 2026 18:41:51 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,david@kernel.org,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-drop-include-linux-kho-abi-from-kho.patch added to mm-unstable branch
Message-Id: <20260415014154.4AA0EC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: drop include/linux/kho/abi/ from KHO
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-drop-include-linux-kho-abi-from-kho.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-drop-include-linux-kho-abi-from-kho.patch

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
Subject: MAINTAINERS: drop include/linux/kho/abi/ from KHO
Date: Tue, 14 Apr 2026 12:17:19 +0000

The KHO entry already includes include/linux/kho.  Listing its
subdirectory is redundant.

Link: https://lkml.kernel.org/r/20260414121752.1912847-3-pratyush@kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
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

maintainers-update-kho-and-live-update-maintainers.patch
maintainers-drop-include-linux-kho-abi-from-kho.patch
maintainers-drop-include-linux-liveupdate-from-live-update.patch

