Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404373644B7
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 17:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806686; cv=none; b=nx+bWwHcBswxjr+vt5O5mdc7MM43iSKnFTWA17fjg1DKDfh7xyIFNNfY2D8EKcT3pI+ETa98Q09sHRcnCeVAtdmX+aaaZImaCVlpXvUD5iiv5KMaZBgnVVblnAotcA9SxG9VtlSHF9l/HhAhBNJzvzSsy+vloy/5Doqa6KFpNAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806686; c=relaxed/simple;
	bh=25CvT+Gsw51ja9moD7gmgKFq35Kwy9N0RMWWvinxeLo=;
	h=Date:To:From:Subject:Message-Id; b=sNoibdReZPD8n5ANkVEy9eoAa8fLX2SRAv2n/rI5xFt7lB25xbNKLvWusMhTXWtLMXMmInxMINZBskdUATlG/YO/4ut2PKclNsNCo4tYC3s5o8D+m7kwLjNbssX6zlhC7Esy8oKH1q2gHEcZK/n4pxRwwISYYIw1mdZMj5L8D9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KnFs8HnS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KnFs8HnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19680C4CEF1;
	Wed,  7 Jan 2026 17:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767806685;
	bh=25CvT+Gsw51ja9moD7gmgKFq35Kwy9N0RMWWvinxeLo=;
	h=Date:To:From:Subject:From;
	b=KnFs8HnSl4UtEvAXz8RiHk2Br8uIkWzFfGjiLzcZTBQybrcasMpUWQOJBZ30ZWcdP
	 v4X45stp1kpjgw8PMPOTVBRpjFtVbN7ohoVVnHaXBsmSmb1z2uT9Dznmx35yzIl9ih
	 7MStsZf1TobN+xoxeJlChek7O8hF5Hz6sWx1r0S0=
Date: Wed, 07 Jan 2026 09:24:44 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,lukas.bulwahn@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-abi-add-memblock-abi-header-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260107172445.19680C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: adjust file entry in MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-abi-add-memblock-abi-header-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-abi-add-memblock-abi-header-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: MAINTAINERS: adjust file entry in MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
Date: Wed, 7 Jan 2026 10:04:38 +0100

Commit e8d87911a204 ("kho/abi: add memblock ABI header") removes the files
in Documentation/core-api/kho/bindings/memblock/ and adds the
corresponding content in include/linux/kho/abi/memblock.h, but misses to
adjust the file entry in the MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
section of the MAINTAINERS file.

Adjust the file entry in accordance with the changes of the commit above.

Link: https://lkml.kernel.org/r/20260107090438.22901-1-lukas.bulwahn@redhat.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~kho-abi-add-memblock-abi-header-fix
+++ a/MAINTAINERS
@@ -16389,7 +16389,7 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
 F:	Documentation/core-api/boot-time-mm.rst
-F:	Documentation/core-api/kho/bindings/memblock/*
+F:	include/linux/kho/abi/memblock.h
 F:	include/linux/memblock.h
 F:	mm/bootmem_info.c
 F:	mm/memblock.c
_

Patches currently in -mm which might be from lukas.bulwahn@redhat.com are

lib-tests-convert-test_uuid-module-to-kunit-fix.patch
kho-abi-add-memblock-abi-header-fix.patch

