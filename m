Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D885B23749;
	Wed, 17 Jan 2024 20:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705524935; cv=none; b=pHi+ll+H/IJ1VRij6HcIx9hRHaZruyKqgPpn1/GQLk5OBELtJHWT0WGeWB4LtYudlJsEbITkWR+K0fo6DXqUjc2NOwOq7uGUxsfDpnMWiveJSqgpyCTcwUJsCiXhpJYbW6OigDeF6UzgxwWjoZi6T3fM8S86t7vTUcq7hne1PNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705524935; c=relaxed/simple;
	bh=c8PqUmrFQvHd92wdr62GJ05MQiO+NDK6q6IeK4SXfOU=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=bthmIqE2muG9SqkaZeYTxyyeRyVr60pPpT0j4IU5OhBjBDfvQGjcbCFGX1QnZTh3fcnFjiVmWDcKFK82zMVNMoI7xijstAQP1U7brmTRy/2MarJHjdR5+L7vjJ6APrnKuOOEMZc+Ef9DJJaIeULUQdXYMQ5DzjqEGiuEWioNDSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pX80nk9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pX80nk9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5C7C433F1;
	Wed, 17 Jan 2024 20:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705524935;
	bh=c8PqUmrFQvHd92wdr62GJ05MQiO+NDK6q6IeK4SXfOU=;
	h=Date:To:From:Subject:From;
	b=pX80nk9cGFdJ/4dstoJrTHZ5SENI2R/ChaqTp+g3uZr2sLYLz/Efex/pK8fOrPjox
	 E5qYLeScTValnC2dZR+jsJp1IOW+nHvDjuNMeLlrVPb0z0ztFj9FXXjFHXkzLBk5S8
	 c9ECkE5iBTcGcpmLixXmVXORvYC5HtKv172Gqq1c=
Date: Wed, 17 Jan 2024 12:55:32 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,David.Laight@ACULAB.COM,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-switch-to-bash-from-sh.patch added to mm-hotfixes-unstable branch
Message-Id: <20240117205534.DB5C7C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: switch to bash from sh
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-switch-to-bash-from-sh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-switch-to-bash-from-sh.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: switch to bash from sh
Date: Tue, 16 Jan 2024 14:04:54 +0500

Running charge_reserved_hugetlb.sh generates errors if sh is set to
dash:

./charge_reserved_hugetlb.sh: 9: [[: not found
./charge_reserved_hugetlb.sh: 19: [[: not found
./charge_reserved_hugetlb.sh: 27: [[: not found
./charge_reserved_hugetlb.sh: 37: [[: not found
./charge_reserved_hugetlb.sh: 45: Syntax error: "(" unexpected

Switch to using /bin/bash instead of /bin/sh.  Make the switch for
write_hugetlb_memory.sh as well which is called from
charge_reserved_hugetlb.sh.

Link: https://lkml.kernel.org/r/20240116090455.3407378-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh |    2 +-
 tools/testing/selftests/mm/write_hugetlb_memory.sh    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-switch-to-bash-from-sh
+++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
 # Kselftest framework requirement - SKIP code is 4.
--- a/tools/testing/selftests/mm/write_hugetlb_memory.sh~selftests-mm-switch-to-bash-from-sh
+++ a/tools/testing/selftests/mm/write_hugetlb_memory.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
 set -e
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-mremap_test-fix-build-warning.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-switch-to-bash-from-sh.patch

