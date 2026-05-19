Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7A33A6B91
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 16:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779208801; cv=none; b=GJGxJMfOsjb/pRUsUmwj6Q0c+IxJcgpTULerIx0pqZGOlLNa0pvGjBLuY7FdRAqLaL3oeAifMivp8Z3nQ7cDpbP2jN527wqbycB6ftkcLi9TTjaFNskCbTqZjoFpDrSPLPnvn/ScqpJ1T867XuLOAu5Xtr4Ii9pivAFYYRkM3bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779208801; c=relaxed/simple;
	bh=HZakGKYLxd/b1Jbt7hZYoz4iCT7ZE6+PbcAlG7aiui0=;
	h=Date:To:From:Subject:Message-Id; b=Rdupe+CNnxjnbK4meuNaK7lf5uyS7cTvRloWrLLy+p8CNDT5qSzIBk91HWX0lpozgR7hB6gV8xISGnnQbdjoSjdEd1ybja6PHvG7JNt2Duv1oUBIdYpm/3IOU6Luse/eCav8ZUL41qTKDpvmFW6ZXIGwjKQv2KFTEKb4BOQRaP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OxpJwQd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OxpJwQd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6765C2BCB3;
	Tue, 19 May 2026 16:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779208800;
	bh=HZakGKYLxd/b1Jbt7hZYoz4iCT7ZE6+PbcAlG7aiui0=;
	h=Date:To:From:Subject:From;
	b=OxpJwQd/Yg5OhDEzVLOBVN1pEFSgjEX9aVkWEMYDHEpweW+cfsoixiwc8TSkz+qKE
	 6Eg6i2ku0BRKI/MyQB7bv816FkUlrTbhajGrylqYaYNaj5bDFFHtkDMeb40vxIl8Gi
	 PARX+zd447VjzySaTJSMBcRas7cZC56iDjmcj1Bw=
Date: Tue, 19 May 2026 09:40:00 -0700
To: mm-commits@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260519164000.C6765C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kcov: update documentation on remote coverage collection
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix.patch

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
From: Jann Horn <jannh@google.com>
Subject: kcov: update documentation on remote coverage collection
Date: Tue, 19 May 2026 18:06:06 +0200

Adjust the docs on remote coverage collection to reflect the changes made
in "kcov: refactor common handle ID into kcov_common_handle_id" and "kcov:
allow simultaneous KCOV_ENABLE/KCOV_REMOTE_ENABLE".

Link: https://lore.kernel.org/20260519-kcov-docs-v1-1-5bb22f4cb20c@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Suggested-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kcov.rst |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/dev-tools/kcov.rst~kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix
+++ a/Documentation/dev-tools/kcov.rst
@@ -246,6 +246,8 @@ KCOV supports collecting remote coverage
 2. Local kernel background tasks. These are spawned when a userspace process
    interacts with some kernel interface and are usually killed when the process
    exits (e.g. vhost workers).
+   This can be combined with another KCOV instance that is configured for normal
+   coverage collection.
 
 3. Soft interrupts.
 
@@ -262,6 +264,9 @@ gets saved to the ``kcov_handle`` field
 needs to be passed to the newly spawned local tasks via custom kernel code
 modifications. Those tasks should in turn use the passed handle in their
 ``kcov_remote_start`` and ``kcov_remote_stop`` annotations.
+In the kernel, common handles are wrapped in a ``kcov_common_handle_id``, which
+consumes no space in builds without ``CONFIG_KCOV``; subsystems that integrate
+with this mechanism should not need to use any ``#ifdef CONFIG_KCOV`` or such.
 
 KCOV follows a predefined format for both global and common handles. Each
 handle is a ``u64`` integer. Currently, only the one top and the lower 4 bytes
_

Patches currently in -mm which might be from jannh@google.com are

kcov-refactor-common-handle-id-into-kcov_common_handle_id.patch
kcov-allow-simultaneous-kcov_enable-kcov_remote_enable.patch
kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-v2.patch
kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix.patch

