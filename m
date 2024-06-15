Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020B61EB3D;
	Sat, 15 Jun 2024 17:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473437; cv=none; b=l9MYMfU4kqqj/N1YBap39K+njajWGAYvFXmQ+tJbAqgCCbHgWX+lFPsyDw16STf8wKyC6LwwP2qeQ+9e4eaI244KFv7ZLZzBh5IWVgqlL1Uvlv5wIlknbRCEpcg8aT6ui1FwzdvC9p0KSvwf8g/Hl/FcvLTN/k6r/qoaHitCgKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473437; c=relaxed/simple;
	bh=45XS6GDb6HZlkLxI6h8fbTjR9cyMztqIJccZzQmlo88=;
	h=Date:To:From:Subject:Message-Id; b=GhquLda0L8bZd6R2X267NmCzOs2ovKs7W22XET8OBL65tQ+0Aft34hBpy4pJzOADGqnLtTdsOgXuxNCsEoDRFyeZ93mHla6kP0r9Kvah0TDqfKNt/hMUXnXUn3rxspTemfqsvZQdiHc7qBS0pMr8dLc2QnnXDpQIam05uaqffpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O1sTs5xX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O1sTs5xX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B764C3277B;
	Sat, 15 Jun 2024 17:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473436;
	bh=45XS6GDb6HZlkLxI6h8fbTjR9cyMztqIJccZzQmlo88=;
	h=Date:To:From:Subject:From;
	b=O1sTs5xX23+lrhryCwZtfepmFIggXifJ1VtMqqFPgEoVpyu43/Jv9NOhenAPRLPyU
	 dLb2iCfkVXQr48SWmnKqOXsTqML+YAbdPFnXrPCMoRUIJGWsyM+wo6w4AUeJ4PpDQn
	 Pu2xgNieyuAUYFOjwbmGBqXj12U4Y1l9WHW5Glkw=
Date: Sat, 15 Jun 2024 10:43:56 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,chuck.lever@oracle.com,allison.henderson@oracle.com,oberpar@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] gcov-add-support-for-gcc-14.patch removed from -mm tree
Message-Id: <20240615174356.8B764C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: gcov: add support for GCC 14
has been removed from the -mm tree.  Its filename was
     gcov-add-support-for-gcc-14.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Oberparleiter <oberpar@linux.ibm.com>
Subject: gcov: add support for GCC 14
Date: Mon, 10 Jun 2024 11:27:43 +0200

Using gcov on kernels compiled with GCC 14 results in truncated 16-byte
long .gcda files with no usable data.  To fix this, update GCOV_COUNTERS
to match the value defined by GCC 14.

Tested with GCC versions 14.1.0 and 13.2.0.

Link: https://lkml.kernel.org/r/20240610092743.1609845-1-oberpar@linux.ibm.com
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reported-by: Allison Henderson <allison.henderson@oracle.com>
Reported-by: Chuck Lever III <chuck.lever@oracle.com>
Tested-by: Chuck Lever <chuck.lever@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_4_7.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-14
+++ a/kernel/gcov/gcc_4_7.c
@@ -18,7 +18,9 @@
 #include <linux/mm.h>
 #include "gcov.h"
 
-#if (__GNUC__ >= 10)
+#if (__GNUC__ >= 14)
+#define GCOV_COUNTERS			9
+#elif (__GNUC__ >= 10)
 #define GCOV_COUNTERS			8
 #elif (__GNUC__ >= 7)
 #define GCOV_COUNTERS			9
_

Patches currently in -mm which might be from oberpar@linux.ibm.com are


