Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C65B2F7AA3
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 22:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763503836; cv=none; b=srv51gRK1sTxrYt6FGP2+9qd5e6q/CgSnHVFj6Yx9qw4k9KQUH6xDFG7Px+KSeLJCKxT8zGE+nfA9LV98ZgXRXCutKbIewc0TpIDluOMPKjmL8vMQUL8uee+AqTsyfdoxhWV6RsrR2eLC0Be53Cv9Fu5df7KOf7jx7bC8wfeuBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763503836; c=relaxed/simple;
	bh=y7w9RUz4vLl8VXHqESw/q9cnKrgYXG30xoz9nZkuRMI=;
	h=Date:To:From:Subject:Message-Id; b=DIPumYObGuc7GJXeQt2utbWUs/ggOWpzDooF1wGg8NI/1xK9adWDqxcaGqpM1cOuhNk7namExKLAAQjx3202aLGzWCsaNhFgpUhVZItNoflg6EjR2UFYR6scVyEzfiCz0jhOL93/uWo/N1nD5HWnpmpMfX1yQ1m8ZNiJLWD3lKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ynl0znHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ynl0znHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E7DC2BCB1;
	Tue, 18 Nov 2025 22:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763503835;
	bh=y7w9RUz4vLl8VXHqESw/q9cnKrgYXG30xoz9nZkuRMI=;
	h=Date:To:From:Subject:From;
	b=ynl0znHqub7JlJc1QCgpKYODiHUIDdK1GFfN2KpV8fh3oNOU3YLbQdBuAWUAW38o4
	 sy3WIDFGlMwjM4PHRDowl4370g+L0yulTJnXRtc5djNne+njZAfTlH5FzewMkpzC4O
	 oJzNRWiQ/jIDy4/r5UUIjDjB6CKg1BiC+c4/I/5w=
Date: Tue, 18 Nov 2025 14:10:35 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-test_kho-to-khos-entry.patch added to mm-hotfixes-unstable branch
Message-Id: <20251118221035.C6E7DC2BCB1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add test_kho to KHO's entry
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-test_kho-to-khos-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-test_kho-to-khos-entry.patch

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
From: Pratyush Yadav <pratyush@kernel.org>
Subject: MAINTAINERS: add test_kho to KHO's entry
Date: Tue, 18 Nov 2025 19:24:15 +0100

Commit b753522bed0b7 ("kho: add test for kexec handover") introduced the
KHO test but missed adding it to KHO's MAINTAINERS entry.  Add it so the
KHO maintainers can get patches for its test.

Link: https://lkml.kernel.org/r/20251118182416.70660-1-pratyush@kernel.org
Fixes: b753522bed0b7 ("kho: add test for kexec handover")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-test_kho-to-khos-entry
+++ a/MAINTAINERS
@@ -13798,6 +13798,7 @@ F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
 F:	kernel/kexec_handover.c
+F:	lib/test_kho.c
 F:	tools/testing/selftests/kho/
 
 KEYS-ENCRYPTED
_

Patches currently in -mm which might be from pratyush@kernel.org are

maintainers-add-test_kho-to-khos-entry.patch
maintainers-add-myself-as-a-reviewer-for-kho.patch
liveupdate-luo_file-add-private-argument-to-store-runtime-state.patch

