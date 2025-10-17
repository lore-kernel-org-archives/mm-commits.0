Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58BE23184A
	for <mm-commits@vger.kernel.org>; Fri, 17 Oct 2025 21:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760737368; cv=none; b=afkZm5PFpiBA24rkOdhQvJawKYw+nIusbAEY5kxGfm/aBRfem9OoSmGmZb4GkN5pGrxewBpb85CMBOycfnU8GpK6npEtG6ygFcLfVmthk/lUldbDeGdUqralsf1iD9/fdFIG3SblMVh5q+kNSYLCGn06MTfRNeWgfQKh3WiCR60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760737368; c=relaxed/simple;
	bh=qd/3286wcH7Z3AuqufuBW6pTEq3RFPHGqNs7CHipVZw=;
	h=Date:To:From:Subject:Message-Id; b=PZil9TTrjQ49UbwZIawHaJfmd6DKq9iqmR518Rlk0/ysmK+3Cr+56NY/vdd3KoXtSk3zvf7LLZUx3EOFd4+UIuq3VzepWM3IMo27lQHhvPs0mrw21CtlI+pK3YYgEqH4BToq3N0BHj1y6t3BlMhOyfHUwowbwX2CwybwbHLFiWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x56o6aCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x56o6aCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75538C4CEE7;
	Fri, 17 Oct 2025 21:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760737367;
	bh=qd/3286wcH7Z3AuqufuBW6pTEq3RFPHGqNs7CHipVZw=;
	h=Date:To:From:Subject:From;
	b=x56o6aCElUt7q8Xx1Y0fOj6sKNt6Q5bc1Ir7K44ULabd5Obwa6oVaWOTMjrlahk+6
	 SQw8eSx+t6XwDM6mWhm1d84z4fCIOU6o6ND1eYk1jnQUgJMQrvn3WfVhBFuty3/zS8
	 F6YuYVBmUITWX+gdWoP/VbF7dhxO2iLhJhoRu/q4=
Date: Fri, 17 Oct 2025 14:42:46 -0700
To: mm-commits@vger.kernel.org,reddybalavignesh9979@gmail.com,broonie@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-complete-kselftest-include-centralization-fix.patch removed from -mm tree
Message-Id: <20251017214247.75538C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-complete-kselftest-include-centralization-fix
has been removed from the -mm tree.  Its filename was
     selftests-complete-kselftest-include-centralization-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-complete-kselftest-include-centralization-fix
Date: Fri Oct 17 02:27:53 PM PDT 2025

fix samples/vfs/test-list-all-mounts.c build

In file included from /tmp/next/build/samples/vfs/test-list-all-mounts.c:11:
/tmp/next/build/samples/vfs/../../tools/testing/selftests/pidfd/pidfd.h:28:10: fatal error: kselftest.h: No such file or directory
   28 | #include "kselftest.h"
      |          ^~~~~~~~~~~~~


Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lkml.kernel.org/r/aPJD4ANRWUDVDqKc@sirena.org.uk
Cc: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/vfs/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/samples/vfs/Makefile~selftests-complete-kselftest-include-centralization-fix
+++ a/samples/vfs/Makefile
@@ -1,4 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 userprogs-always-y += test-fsmount test-statx mountinfo test-list-all-mounts
 
+CFLAGS += -I../../tools/testing/selftests
+
 userccflags += -I usr/include
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-swap-do-not-choose-swap-device-according-to-numa-node-fix.patch
drivers-base-node-fold-register_node-into-register_one_node-fix.patch
liveupdate-kho-move-to-kernel-liveupdate-fix.patch

