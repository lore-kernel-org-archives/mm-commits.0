Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795145059;
	b=XqiSywx5EcRWbYxYtCvf1d9vlE6hsoDzPpm7SOHua/Q0pKz00nCNW1hBRY1mSGx3OBqS
	 AyUowi2o4JQORdYW8UcyAcQmkp44vMmeBMdydC0FxzcbEK2Is9+z7y6J3SJ81HtlkgbXZ
	 3UrK8dp+LQXYfzp7zEmZoE6mfBJspbqTg5s968G+Aez6Kui8d8AZy6VXuLoppTif5ubMM
	 t8dI0PANPn4HIDJj6u/2CP8dpf0iqDatd/6crSLR119SvkOZlyfJAHNmgD/gUvzcHGllr
	 yWeSNiieRS+Y+N68aF3jpdKKjpUFU6D40LRzzZHVLDJjbtAGVXUuDgPMA6zA3+Rza0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795145059;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=ZtiwsG/EC76o/IYpF5aShJaSP8yvb2LaGdXGm/XonY0=;
	b=KmjKTy4T7lBgA1wsyjRhklGc2RZ/OqUeS/dTVlyki6VqzmX1xbP3+oKF99A8tGM8r8R5
	 pCRWMCKwFmJp/LnjKwufP/5Bs6Xf7H4ecjkGIhbqriRBMo2NbeAsxONV36OPV5qWXZ+VU
	 fvs/nTD6lBupXmMXPS07bZ/FlBSmJ/meFTmgMWULbnFXnyNJimP70cMY31Xk+WKDjL/5J
	 xLV+S17BV4t38ZRbz/CzzowzA+j585FZF6BYWq37fMCtux9/3E1s5MCb0LBFkBK8iI2xQ
	 YqZNxHuCyHNEFdDtBuU5uN+PBCBvhBzRc1QKl15AWnhRiKURQ3H09ZdnhJCOTIAmflQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tYbPalVF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26981606A331
	for <mm-commits@vger.kernel.org>; Fri, 20 Nov 2026 03:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tYbPalVF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6E01F000CA;
	Fri, 20 Nov 2026 03:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795145058;
	bh=ZtiwsG/EC76o/IYpF5aShJaSP8yvb2LaGdXGm/XonY0=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=tYbPalVFH5xeK6n//GZ9pvTTWrKRESij31hdi9Lrt1zAVSHJq7ccq/uiKHftVO1d0
	 abU6NFNMrF8CMMmms+H0lriY0uH9Naf8bVyuyWwy7eDg9t38oT3PkejspOTUuSm2jo
	 YKbxkL+F6p+qgordpxiqkBvSV6CcygbzzBn4/0+Q=
Date: Thu, 19 Nov 2026 19:24:18 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,shuah@kernel.org,
	reddybalavignesh9979@gmail.com,liam@infradead.org,kmehltretter@gmail.com,
	joe@perches.com,apw@canonical.com,fuqingshuang@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261120022710.1585112-1-fuqingshuang@kylinos.cn>
References: <20261120022710.1585112-1-fuqingshuang@kylinos.cn>
Subject: + selftests-proc-include-linux-mmanh-for-mremap_dontunmap.patch added to mm-new branch
Message-Id: <20261120032418.CB6E01F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/proc: include linux/mman.h for MREMAP_DONTUNMAP
has been added to the -mm mm-new branch.  Its filename is
     selftests-proc-include-linux-mmanh-for-mremap_dontunmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-include-linux-mmanh-for-mremap_dontunmap.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Qingshuang Fu <fuqingshuang@kylinos.cn>
Subject: selftests/proc: include linux/mman.h for MREMAP_DONTUNMAP
Date: Fri, 20 Nov 2026 10:27:10 +0800

glibc versions before 2.32 do not define MREMAP_DONTUNMAP in <sys/mman.h>,
so proc-maps-race fails to build against them (e.g.  glibc 2.31):

  $ make -C tools/testing/selftests TARGETS=proc
  ...
  proc-maps-race.c:691:58: error: 'MREMAP_DONTUNMAP' undeclared
    (first use in this function)

Include <linux/mman.h> to get the flag from the kernel UAPI headers
instead of depending on the libc version.  The proc Makefile already adds
those headers to the include path via $(TOOLS_INCLUDES).

Link: https://patch.msgid.link/20261120022710.1585112-1-fuqingshuang@kylinos.cn
Fixes: 6a45336b9b6f ("selftests/proc: extend /proc/pid/maps tearing test to include vma remapping")
Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>

 tools/testing/selftests/proc/proc-maps-race.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/proc/proc-maps-race.c~selftests-proc-include-linux-mmanh-for-mremap_dontunmap
+++ a/tools/testing/selftests/proc/proc-maps-race.c
@@ -33,6 +33,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <linux/fs.h>
+#include <linux/mman.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
_

Patches currently in -mm which might be from fuqingshuang@kylinos.cn are

selftests-proc-include-linux-mmanh-for-mremap_dontunmap.patch

