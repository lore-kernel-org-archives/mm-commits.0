Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E25E2EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011374; cv=none; b=UZdYSaIgc8kRPpJkZtrxlbIPPAp8448WLrv6F3CVImDPbHGbCIZhxpqXD03aAt/Ax7gacDTdCFGSyJZwnGizMERVe5qisnM5jlZGUMDR7q9wj5Jo4fdwXHNO4Rc7TXAyQaMiW1OFK+2XjMY9xKlHhhsM4x4eqOfITouQOqa/a7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011374; c=relaxed/simple;
	bh=8vnAUfMQmlBlI57NbD2IXjxWwxgZ98fAu78fYJ/tF8A=;
	h=Date:To:From:Subject:Message-Id; b=M3rt3rHRDm/+wGBiIypmIyFSrL1/ZESTPEsxh1NsTa+9ALEcFXntMjtulL412k7gv0IHSQ+mRCHfFD9BIc2yqViRWN/Ah1ao9o8D31fRFLFA50xSET6v/NPDbmVPWvMELXr66if1Ws41EplhOg5Zl9hx7VYVl5jcweUDnYNlsLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b8JOaSyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b8JOaSyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13603C4CEE4;
	Mon, 12 May 2025 00:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011374;
	bh=8vnAUfMQmlBlI57NbD2IXjxWwxgZ98fAu78fYJ/tF8A=;
	h=Date:To:From:Subject:From;
	b=b8JOaSyT7lti1KITO6gxCvDL2A8dYYSWhc34/rYfun2IrG8wsaLTFLC7PY+eHDIqK
	 1M83H/PK8xMHDa7vjZfxSxz4r+gG+11dKXCm54LCFx58iE2V09dOThd1/gIwfvbCMA
	 n/6eVVDIO354+/68DnHzCbkhRqwo3at/9lup5siA=
Date: Sun, 11 May 2025 17:56:13 -0700
To: mm-commits@vger.kernel.org,ubizjak@gmail.com,tony.ambardar@gmail.com,ojeda@kernel.org,kernel@jfarr.cc,kees@kernel.org,glider@google.com,elver@google.com,changbin.du@intel.com,Marc.Herbert@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] compiler_typesh-fix-unused-variable-in-__compiletime_assert.patch removed from -mm tree
Message-Id: <20250512005614.13603C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: compiler_types.h: fix "unused variable" in __compiletime_assert()
has been removed from the -mm tree.  Its filename was
     compiler_typesh-fix-unused-variable-in-__compiletime_assert.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Marc Herbert <Marc.Herbert@linux.intel.com>
Subject: compiler_types.h: fix "unused variable" in __compiletime_assert()
Date: Thu, 24 Apr 2025 19:40:35 +0000

This refines commit c03567a8e8d5 ("include/linux/compiler.h: don't perform
compiletime_assert with -O0") and restores #ifdef __OPTIMIZE__ symmetry by
evaluating the 'condition' variable in both compile-time variants of
__compiletimeassert().

As __OPTIMIZE__ is always true by default, this commit does not change
anything by default.  But it fixes warnings with _non-default_ CFLAGS like
for instance this:

 make  CFLAGS_tcp.o='-Og -U__OPTIMIZE__'

                 from net/ipv4/tcp.c:273:

 include/net/sch_generic.h: In function `qdisc_cb_private_validate':
 include/net/sch_generic.h:511:30:
            error: unused variable `qcb' [-Werror=unused-variable]

  {
     struct qdisc_skb_cb *qcb;

     BUILD_BUG_ON(sizeof(skb->cb) < sizeof(*qcb));
     ...
  }

[akpm@linux-foundation.org: regularize comment layout, reflow comment]
Link: https://lkml.kernel.org/r/20250424194048.652571-1-marc.herbert@linux.intel.com
Signed-off-by: Marc Herbert <Marc.Herbert@linux.intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Changbin Du <changbin.du@intel.com>
Cc: Jan Hendrik Farr <kernel@jfarr.cc>
Cc: Macro Elver <elver@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Tony Ambardar <tony.ambardar@gmail.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler_types.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/include/linux/compiler_types.h~compiler_typesh-fix-unused-variable-in-__compiletime_assert
+++ a/include/linux/compiler_types.h
@@ -525,6 +525,12 @@ struct ftrace_likely_data {
 	 sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
 
 #ifdef __OPTIMIZE__
+/*
+ * #ifdef __OPTIMIZE__ is only a good approximation; for instance "make
+ * CFLAGS_foo.o=-Og" defines __OPTIMIZE__, does not elide the conditional code
+ * and can break compilation with wrong error message(s). Combine with
+ * -U__OPTIMIZE__ when needed.
+ */
 # define __compiletime_assert(condition, msg, prefix, suffix)		\
 	do {								\
 		/*							\
@@ -538,7 +544,7 @@ struct ftrace_likely_data {
 			prefix ## suffix();				\
 	} while (0)
 #else
-# define __compiletime_assert(condition, msg, prefix, suffix) do { } while (0)
+# define __compiletime_assert(condition, msg, prefix, suffix) ((void)(condition))
 #endif
 
 #define _compiletime_assert(condition, msg, prefix, suffix) \
_

Patches currently in -mm which might be from Marc.Herbert@linux.intel.com are


