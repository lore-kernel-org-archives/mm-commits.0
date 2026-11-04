Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812759;
	b=I4JeaY+1pn6IdljZMukH4rARpIF345SIbaD0MV4c81veXR+6B3jBrS+9fSwkgB6hEdVl
	 mgrUfH9Ywy5e2fY3+arw2hTQjITFPkx1bWmd0PbVA5IdSiRfpxAAC0AKRicx3zV7SF8Ec
	 ZN3inoDn4MI7om/NYx9oTyI5nYk25XPp00sUFvhpK+GmZi3/ES5wdpw1/EuTJzixIruMP
	 Za+bPFSSgxq4AO+OFSF24SC1fbgWv2jt9Iz8u8Xoge+TyW7OoNNr5I5aCyLVfUZpUWSwr
	 ZhuzC92LHTvX8Slo8mUIwY1y6rMb2UkgHi4nwHGEE3R73aC/HXJncT1caZVmwT0u1Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812759;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=iGtPnHmxDTu/sylp4m/nmDcZVLkuEEM53Rc9Gy9kIIU=;
	b=Ljy42tvQDGAbsUlAEp6sgATaD4A45qpFaro3nbKxD+EaYnkiCOS2Ne+KsfNzuKwfLRD3
	 1GhNJaj3qwUGqq7ZbTmAAcfh+yTq1C8KkzPx2UTJueu+7IPa1fEnnIR9VoqEKXLfijkWg
	 ryLMubukEy+NzYxKiGSVbsKEsxk4m/9UulmpJpYFyheG2w4zPn9jtLZA1LnXlvVNR4D9u
	 3rhLf3VC3RugNmTubHXTTJDMtUwERE2zn2poeYi/3YQ2uA4l83zKOly1Nh+FWtuY+/8zr
	 wfO8XhtSs9Vt2QZdHyYxvCuNuEGiP/yR9eNqCdNA5UipCmszfg8uPaRtbpzcH0wsLiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Hc/tYWTy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57AE606A328
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 17:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Hc/tYWTy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F5B1F000C1;
	Wed,  4 Nov 2026 17:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793812758;
	bh=iGtPnHmxDTu/sylp4m/nmDcZVLkuEEM53Rc9Gy9kIIU=;
	h=Date:To:From:Subject;
	b=Hc/tYWTySYkl45K0PTOs1sSR4nM62n9CizSaZH63Gr6QOTuvA+q9ULApeRosHUXQE
	 ziO1XluudWnsN+72/7rxaVUyVt19CoC6Ojj5LKimSSfIyj4kSWidC4fZ1Uowehhv7x
	 5gT41RX+qGdUwni8ENsUgZmc0zuOPLFijGjOGKSA=
Date: Wed, 04 Nov 2026 09:19:17 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,
	akpm@linux-foundation.org,gubin@cmss.chinamobile.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-laptop-dslm-fix-inverted-open-error-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261104171918.47F5B1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: tools/laptop/dslm: fix inverted open() error check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-laptop-dslm-fix-inverted-open-error-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-laptop-dslm-fix-inverted-open-error-check.patch

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
From: Gu Bin <gubin@cmss.chinamobile.com>
Subject: tools/laptop/dslm: fix inverted open() error check
Date: Wed,  4 Nov 2026 14:48:37 +0800

open() returns -1 on failure and a non-negative fd on success, but the
check

	if (!(fd = open(disk, O_RDONLY|O_NONBLOCK)))

treats only fd == 0 as an error, which is wrong in both directions:

  - on a real failure (fd == -1) the condition is false, so the
    program continues with fd = -1: measure() runs check_powermode()
    on the invalid fd, ioctl() fails with EBADF, and the tool reports
    the drive state as "unknown" instead of printing the intended
    "Can't open" message.
  - when open() succeeds and returns fd 0 (e.g. stdin was closed, so
    the lowest free descriptor is 0), the condition is true and the
    tool wrongly prints "Can't open" and exits.

Test with fd < 0 instead, which handles both cases correctly.

Link: https://lore.kernel.org/20261104064839.1790-1-gubin@cmss.chinamobile.com
Fixes: d49129accc21 ("Documentation/laptop/: split txt and source files")
Signed-off-by: Gu Bin <gubin@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
---

 tools/laptop/dslm/dslm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/laptop/dslm/dslm.c~tools-laptop-dslm-fix-inverted-open-error-check
+++ a/tools/laptop/dslm/dslm.c
@@ -144,7 +144,8 @@ int main(int argc, char **argv)
     } else
 	usage();
 
-    if (!(fd = open(disk, O_RDONLY|O_NONBLOCK))) {
+    fd = open(disk, O_RDONLY|O_NONBLOCK);
+    if (fd < 0) {
 	printf("Can't open %s, because: %s\n", disk, strerror(errno));
 	exit(-1);
     }
_

Patches currently in -mm which might be from gubin@cmss.chinamobile.com are

tools-laptop-dslm-fix-inverted-open-error-check.patch

