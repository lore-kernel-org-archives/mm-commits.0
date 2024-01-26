Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36836627FE;
	Fri, 26 Jan 2024 07:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255714; cv=none; b=eBI8l5Dabcf8OhxLjjcb49uz8b+giCZloag9X1cLmeVo/WIBANWYBRmtwOW9NCU+WjJ//6p2E5CEQLrviMfgGs4/YjdshEvy3rqleNhzHjh3G42XZYTmq8yvo0aBG6XByqzRQ7ZNfAukR5UYEbevmKr89ObDVk11DxosjIdVqAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255714; c=relaxed/simple;
	bh=7LT6I28vE3Q3ThgztmPKcYa/9OEcJN1asrmXLD68v44=;
	h=Date:To:From:Subject:Message-Id; b=cDNl1EBLPNh8Ekm8q77MAsbO8xY/j85FfFdd1ygDcwbMBv+AZBXBo0rNlWhLjVbugS5hvWwoIPwEDCIhIacqmqOvtQGD7ogEMLDi3wM0xOPUdcQ3E8N7f6hDkaYdKvlEcblu9a5pX+GA+DXkxLiekjT0AORtooJepdVO1arGjWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AgeQ1u4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AgeQ1u4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C05AC433F1;
	Fri, 26 Jan 2024 07:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255713;
	bh=7LT6I28vE3Q3ThgztmPKcYa/9OEcJN1asrmXLD68v44=;
	h=Date:To:From:Subject:From;
	b=AgeQ1u4sm6FqS1vS+YSax/mDEBwp6cH4P0m/whSD83vL8ef1ZwD5IejiOm08fwSj1
	 ieIuE4a6XSwB0SiBeKOPfcym33vkPu8ZJaW2Bu0jRQ8ge+RwH9Bhegn0zFTm4l20Gl
	 bD2zpznswow++aXfLNyk0Z4WWNnHs9CKI5+c0Spo=
Date: Thu, 25 Jan 2024 23:55:10 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,David.Laight@ACULAB.COM,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-switch-to-bash-from-sh.patch removed from -mm tree
Message-Id: <20240126075513.3C05AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: switch to bash from sh
has been removed from the -mm tree.  Its filename was
     selftests-mm-switch-to-bash-from-sh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch

