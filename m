Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879F855884;
	Mon, 10 Jun 2024 17:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718041548; cv=none; b=rHHhohJzSDqxWljt0FKluLG0xqSPNTxa2XRQ9Zm4qkA25yeOCO7pc9J8LfFRW4gIpqu59CQU+GLYqTjDoqYPGLV75tbltzMgXiL9G1VnzXEiWe/sa52W9HP5w5caLKtwVxrB7pIcXpRNxBiE2m82RqTGNjMwAuBiSNL074ywdG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718041548; c=relaxed/simple;
	bh=dA9SLXGLQ6dnPUlGgz+DRHA3lr4MxM2Rg0B9hSXyhiw=;
	h=Date:To:From:Subject:Message-Id; b=uzRE08QBeydaBjZEt4cdFMZnLNlLApggptghtllcqRlCMPsn7+Vzi5niByB30dAwTS75HOKB2wJ60l8P3+1yn4Ia8nPVqHjLAI3z8hHDBD8PYvrJZM7uvQp4BSUwZWZ9/anAB1d3g/yLOlNAiBQM5FoKtYg+t73fr4V+LriJ1k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BcG/wyhS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BcG/wyhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115E6C2BBFC;
	Mon, 10 Jun 2024 17:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718041548;
	bh=dA9SLXGLQ6dnPUlGgz+DRHA3lr4MxM2Rg0B9hSXyhiw=;
	h=Date:To:From:Subject:From;
	b=BcG/wyhSlWHWeDHnUpfPApAHlwcMt3XA5SaqDxeBqUF3TaFA7YV4fzZqzj3x4ESCj
	 78ftnxcM60QlFdhH7gNIqjUNiE4/KyNFNzr6Yf14BDjEmHRqWEqWIJAQbXGV04Zwac
	 ua57YwdLgB3j6OI78tV6LnTe6p0mEvgTY86pzUGs=
Date: Mon, 10 Jun 2024 10:45:47 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,chuck.lever@oracle.com,allison.henderson@oracle.com,oberpar@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + gcov-add-support-for-gcc-14.patch added to mm-hotfixes-unstable branch
Message-Id: <20240610174548.115E6C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: gcov: add support for GCC 14
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     gcov-add-support-for-gcc-14.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gcov-add-support-for-gcc-14.patch

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

gcov-add-support-for-gcc-14.patch

