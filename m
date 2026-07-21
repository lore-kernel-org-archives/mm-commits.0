Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908F23ED13B;
	Tue, 21 Jul 2026 00:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784594623; cv=none; b=ItqR4Q4CzglGGjpFlRXlhZi5kcfWm0mDQTb8OMlQnc80/ecluCGCfYoV+5+6UjWXvevlNbeNiwSB2PKLTVQA9CT5WnaMJSiz3eBDQhFzQDbjn/pMYRWho2d/2IsLOrSgxZO0DfJycrPsOVIvvUYB11JtofAmcwZ9uZYX4QYulOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784594623; c=relaxed/simple;
	bh=BVQ/bGYBhcs0VL5BQKZXoTA2GBPZ2zm6drsmjGOZVTY=;
	h=Date:To:From:Subject:Message-Id; b=adoLSVbgbIr4SCAZ9CDYlk4hnvIw3WdwNYeVRobioDDJVdhDeLNEV7h0bhnKj7o5kbEPWekmXK+HP30yWUjqkx3riWxlkjR7LzCAca6zEF0ylh3YSxhsolcF0hnAMfJq1ftEwKUpwGspbaJiz4hEMh/T3VCVZk/9ODu2VhhxBDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VRrhiPCo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VRrhiPCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A741F00A3A;
	Tue, 21 Jul 2026 00:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784594621;
	bh=V5ZqffmS6BWdNOzYYTc5GHfoSg2fUXO5dv3lP/YZ+Wg=;
	h=Date:To:From:Subject;
	b=VRrhiPCo1niPaL8Fbm9PJ5rP1avNuvDmIbKD0DAbiTkXJgwEWIWtwEGyWGpsVesbf
	 wjkOB+AzrJ7TOmPBnKy874oxc5V7FmbeWWWVjmJdqDI0Q5ByV1iad0XMDyE5Hnlivp
	 WZUdMf8d12Qu7H0g6mLPHMWubRpSKR2CpVrgRnYI=
Date: Mon, 20 Jul 2026 17:43:40 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,richard.weiyang@gmail.com,cyphar@cyphar.com,brauner@kernel.org,jkoolstra@xs4all.nl,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftest-fix-headers-in-fclogc.patch removed from -mm tree
Message-Id: <20260721004341.19A741F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest: fix headers in fclog.c
has been removed from the -mm tree.  Its filename was
     selftest-fix-headers-in-fclogc.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jori Koolstra <jkoolstra@xs4all.nl>
Subject: selftest: fix headers in fclog.c
Date: Fri, 10 Jul 2026 19:17:35 +0200

fclog.c does not compile because it is missing fcntl.h, needed for
O_RDONLY etc.

There are also some redundant includes that are also in
kselftest_harness.h.

Link: https://lore.kernel.org/20260710171741.837308-1-jkoolstra@xs4all.nl
Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filesystems/fclog.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/tools/testing/selftests/filesystems/fclog.c~selftest-fix-headers-in-fclogc
+++ a/tools/testing/selftests/filesystems/fclog.c
@@ -6,10 +6,8 @@
 
 #include <assert.h>
 #include <errno.h>
+#include <fcntl.h>
 #include <sched.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
 #include <unistd.h>
 #include <sys/mount.h>
 
_

Patches currently in -mm which might be from jkoolstra@xs4all.nl are


