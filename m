Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA10418EAB
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 22:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718144478; cv=none; b=DAR+PNEG/gAhh8pTwTKJ+Vnke+IkWXaKcC2c8dVyYCDdiqDvcyaKPeywvwsUPf6pX6gTYD+Q4YKMhYmvTF49ntvBunJNbGV50ThC+7rvnrgaXux2u5tsx7FjU3P2rVzHf4InzTZJ0Bi0t+s6wW475CiFaCAHFmHzvpRbir956tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718144478; c=relaxed/simple;
	bh=Oq6xK+qLHh8M2fL5QaUhBiFDrCyTcWeIgtVPh8inQg0=;
	h=Date:To:From:Subject:Message-Id; b=J/SwAvmw2NN5CDRW5fAMKn1OYqwyfEwB3mUJDj3rgm+w+QrawQg9URHEiweq8XaJ8SrzPGFBnakCuaNnv8o8fLCnGYAqSLYlH0tOFIEeW2PC5lfR6TqgN4WpzcE0/E0mHxxYAMgdKpnSwdJeYSdve3nsq/sX7JrX62WIOqqCE0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZnxDmHqU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZnxDmHqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D197C2BD10;
	Tue, 11 Jun 2024 22:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718144478;
	bh=Oq6xK+qLHh8M2fL5QaUhBiFDrCyTcWeIgtVPh8inQg0=;
	h=Date:To:From:Subject:From;
	b=ZnxDmHqUJx4KXCLNpNygr9gHT3zAE98qo4FGfgB6fsv2VWfLoJ2oNfvgW6INclJ+z
	 QdNec02ZRTGpVGi4lBEPuorIVET5Ez/N2raXIRUn1rWeRvt/Z1q4/AEmP3CvS7LbXd
	 YO7TrN0P2WabcVQmZquOk0XPbONIOS8H6EnsZcX8=
Date: Tue, 11 Jun 2024 15:21:17 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,cmllamas@google.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-include-linux-mmanh.patch added to mm-unstable branch
Message-Id: <20240611222118.2D197C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: include linux/mman.h
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-include-linux-mmanh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-include-linux-mmanh.patch

This patch will later appear in the mm-unstable branch at
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
From: Edward Liaw <edliaw@google.com>
Subject: selftests/mm: include linux/mman.h
Date: Wed, 5 Jun 2024 22:36:34 +0000

thuge-gen defines MAP_HUGE_* macros that are provided by linux/mman.h
since 4.15. Removes the macros and includes linux/mman.h instead.

Link: https://lkml.kernel.org/r/20240605223637.1374969-2-edliaw@google.com
Signed-off-by: Edward Liaw <edliaw@google.com>
Reviewed-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/thuge-gen.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/thuge-gen.c~selftests-mm-include-linux-mmanh
+++ a/tools/testing/selftests/mm/thuge-gen.c
@@ -15,6 +15,7 @@
 
 #define _GNU_SOURCE 1
 #include <sys/mman.h>
+#include <linux/mman.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <sys/ipc.h>
@@ -28,10 +29,6 @@
 #include "vm_util.h"
 #include "../kselftest.h"
 
-#define MAP_HUGE_2MB    (21 << MAP_HUGE_SHIFT)
-#define MAP_HUGE_1GB    (30 << MAP_HUGE_SHIFT)
-#define MAP_HUGE_SHIFT  26
-#define MAP_HUGE_MASK   0x3f
 #if !defined(MAP_HUGETLB)
 #define MAP_HUGETLB	0x40000
 #endif
_

Patches currently in -mm which might be from edliaw@google.com are

selftests-mm-include-linux-mmanh.patch
selftests-mm-guard-defines-from-shm.patch

