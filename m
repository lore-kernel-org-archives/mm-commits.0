Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C45782C8E
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 19:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718220205; cv=none; b=DxHkKnOgAL6qICCHtIEoznJIz26szsvHIZIcOcJ+6hP2pFXe2UAAO2oCBfuihre904m8QuTnStoPNNY9dPkarFovRLwNLHyvh/z3W7wVCeiAYhfVlO2FYQJGc9dAmI7HcToJmoc4j9r2vz0IVsAQL9+9r8IsE8Tw1oD+35c7X4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718220205; c=relaxed/simple;
	bh=N3cyZEsthyQutK6co8AKfbxiqaKMUchFtx1IFTGixms=;
	h=Date:To:From:Subject:Message-Id; b=rVfFF5zV6VOey4PpZnKRRN8eykA/D7qTyywoezYgPT9Td/Yd8DQ2yNtyskPoVRTExyFgLfz7WVYcMvRxd2QcgprYN7OWWkjcynFJkql82e5GNjDkUoi2uZBLWaxx8niv7PK5z9k2RtF3RVXghvSGv1R3yKFE6w0k8xP8pGWkpgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UVbahBhP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UVbahBhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009E0C116B1;
	Wed, 12 Jun 2024 19:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718220205;
	bh=N3cyZEsthyQutK6co8AKfbxiqaKMUchFtx1IFTGixms=;
	h=Date:To:From:Subject:From;
	b=UVbahBhP915eliD36TNC5rXYSlSYLuYAaYON7pNDzIodKbT3s4ekLnjCsfc9zM5FL
	 ZaEd4GuW8KVKepRe3Mf0uSWCRhXZ5Ex/ZC0e2l5F4h4LKLgKfZarwDLZejkFw4/7Nx
	 7Gy/0UJ5JWrgXcHvdurEzZEi7YZtleSt7NQRlTW4=
Date: Wed, 12 Jun 2024 12:23:24 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20240612192325.009E0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3.patch

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
From: Jeff Xu <jeffxu@chromium.org>
Subject: mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3
Date: Tue, 11 Jun 2024 23:14:08 +0000

Link: https://lkml.kernel.org/r/20240611231409.3899809-2-jeffxu@chromium.org
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/userspace-api/mfd_noexec.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/userspace-api/mfd_noexec.rst~mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3
+++ a/Documentation/userspace-api/mfd_noexec.rst
@@ -1,7 +1,7 @@
 .. SPDX-License-Identifier: GPL-2.0
 
 ==================================
-Introduction of non executable mfd
+Introduction of non-executable mfd
 ==================================
 :Author:
     Daniel Verkamp <dverkamp@chromium.org>
@@ -30,7 +30,7 @@ use of executable memfds and an attacker
 To address those above:
  - Let memfd_create() set X bit at creation time.
  - Let memfd be sealed for modifying X bit when NX is set.
- - Add a new pid namespace sysctl: vm.memfd_noexec to help applications to
+ - Add a new pid namespace sysctl: vm.memfd_noexec to help applications in
    migrating and enforcing non-executable MFD.
 
 User API
_

Patches currently in -mm which might be from jeffxu@chromium.org are

mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec.patch
mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v2.patch
mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3.patch

