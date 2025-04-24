Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AE01B040B
	for <mm-commits@vger.kernel.org>; Thu, 24 Apr 2025 21:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745531778; cv=none; b=GRLCmlCOSCQjYmdLL0WSd83BObr2XMBDUkyvaXVXZDYjBIEAvXRrKTB1RTpgAT1rtuiLrdOo5ivJPbJCiujDBElX4Qil1fjJdUHKAD+eq9LK0V8au6HFB65RgS1cLpKL5AG4/F4277sbqvDaMp0Va7LaAYObL1opkaLPO/M7UpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745531778; c=relaxed/simple;
	bh=lAS8v/0/MAJLlK3f4yg/6ZRma83+OUH2jkZDh5cmrww=;
	h=Date:To:From:Subject:Message-Id; b=em3iqv0RbP3YrJgTmhQBFZCm7ssj5FisTWk9R9E7pwYcW/zo94a4rbco0nSv2q065EDfnzw4dBYbZP9AZra27AArUq7t5HNXrNVZB5B/1hzEgJmRSEVEy114A2l+oIwKiaIz9Odb/2APSQkfzse2njpSq8ioIvNT1uovIOxeKRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UTuELIIP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UTuELIIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEB4C4CEE3;
	Thu, 24 Apr 2025 21:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745531776;
	bh=lAS8v/0/MAJLlK3f4yg/6ZRma83+OUH2jkZDh5cmrww=;
	h=Date:To:From:Subject:From;
	b=UTuELIIPMJdhtm1naixJRrvebfDdZBWVA3m4mATsWY6kbVfQe9BmUqLDCfuAGOsaW
	 9r7Fh3kmTdUMpvnN1w5N4bn6ypDnA1wsLIRbAJFIriko2QxYQUz9IaPuxsIwRd3Akh
	 Dd+zQP1yB7OeeFiSSEg8Muw1jg5H1bW/JFT/XYhE=
Date: Thu, 24 Apr 2025 14:56:16 -0700
To: mm-commits@vger.kernel.org,ubizjak@gmail.com,tony.ambardar@gmail.com,ojeda@kernel.org,kernel@jfarr.cc,kees@kernel.org,glider@google.com,elver@google.com,changbin.du@intel.com,Marc.Herbert@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + compiler_typesh-fix-unused-variable-in-__compiletime_assert.patch added to mm-nonmm-unstable branch
Message-Id: <20250424215616.CBEB4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: compiler_types.h: fix "unused variable" in __compiletime_assert()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     compiler_typesh-fix-unused-variable-in-__compiletime_assert.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compiler_typesh-fix-unused-variable-in-__compiletime_assert.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

 include/linux/compiler_types.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/compiler_types.h~compiler_typesh-fix-unused-variable-in-__compiletime_assert
+++ a/include/linux/compiler_types.h
@@ -525,6 +525,11 @@ struct ftrace_likely_data {
 	 sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
 
 #ifdef __OPTIMIZE__
+/* #ifdef __OPTIMIZE__ is only a good approximation; for instance "make
+ * CFLAGS_foo.o=-Og" defines __OPTIMIZE__, does not elide the
+ * conditional code and can break compilation with wrong error
+ * message(s). Combine with -U__OPTIMIZE__ when needed.
+ */
 # define __compiletime_assert(condition, msg, prefix, suffix)		\
 	do {								\
 		/*							\
@@ -538,7 +543,7 @@ struct ftrace_likely_data {
 			prefix ## suffix();				\
 	} while (0)
 #else
-# define __compiletime_assert(condition, msg, prefix, suffix) do { } while (0)
+# define __compiletime_assert(condition, msg, prefix, suffix) ((void)(condition))
 #endif
 
 #define _compiletime_assert(condition, msg, prefix, suffix) \
_

Patches currently in -mm which might be from Marc.Herbert@linux.intel.com are

compiler_typesh-fix-unused-variable-in-__compiletime_assert.patch

