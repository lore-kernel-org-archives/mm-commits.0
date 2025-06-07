Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DB74C81
	for <mm-commits@vger.kernel.org>; Sat,  7 Jun 2025 21:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749333405; cv=none; b=klotKsUwX4eEsnuCW50hZKfJr792rgXpfz+xAvEdRJmTvZXYScuWDCZOY7iV0PkNMVasqzOEe7D4dxgDRufaVSGhilmj/UCDcugrV8Di7AvxWXLl5R8CDv79gwKaI492ZDaJsBFnypRsBICE8QN9PLcPOBsWuC0KMUdbK0tNUTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749333405; c=relaxed/simple;
	bh=s7rlvZC7eG8XDymqQ5sy87CVA3x6oXDRkLx5b/ddXDw=;
	h=Date:To:From:Subject:Message-Id; b=LiRVJFxpHHr+LQ6rZoCfPf8ugtlfiErgRpKFy5Q0cilkeCJpZ0Wss58HACfmzTTzySazv+pgYJf2Kmq/QhG0juGoari3j+qdpKJ1jNBJEEDBoTXCLzZbebwxg4LesEdAonvNNdW1UBjfryp9qcvwfUp1J7E2lpKg7sfk+s4BuYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KIsa1qpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KIsa1qpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535B4C4CEE4;
	Sat,  7 Jun 2025 21:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749333404;
	bh=s7rlvZC7eG8XDymqQ5sy87CVA3x6oXDRkLx5b/ddXDw=;
	h=Date:To:From:Subject:From;
	b=KIsa1qpDeMVtF3s88b58Ii788LkWkUpFjcQA69qBCwY9g9OC+dncaxQI6Z6ujqm9R
	 O2u1gqk/IKURt4y9XiXjb38+b1SDyIJuTzePTrZbreDhEgp5F1+aEJNXCfgr4Glob3
	 X6TNkZYELSMUmElCTAdQqljbi5ahAGHbqhqK7Oww=
Date: Sat, 07 Jun 2025 14:56:43 -0700
To: mm-commits@vger.kernel.org,ojeda@kernel.org,kees@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + compiler_types-remove-unnecessary-indirection-in-compiletime_assert.patch added to mm-nonmm-unstable branch
Message-Id: <20250607215644.535B4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: compiler_types: remove unnecessary indirection in compiletime_assert()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     compiler_types-remove-unnecessary-indirection-in-compiletime_assert.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compiler_types-remove-unnecessary-indirection-in-compiletime_assert.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: compiler_types: remove unnecessary indirection in compiletime_assert()
Date: Sat, 07 Jun 2025 03:23:55 -0400

compiletime_assert() is the only user of _compiletime_assert(), which uses
__compiletime_assert() directly with no modification to arguments.  Remove
_compiletime_assert() and use __compiletime_assert() directly.

Link: https://lkml.kernel.org/r/20250607-compiletime_assert-v1-1-a8991a9be729@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Cc: Kees Cook <kees@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler_types.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/include/linux/compiler_types.h~compiler_types-remove-unnecessary-indirection-in-compiletime_assert
+++ a/include/linux/compiler_types.h
@@ -552,9 +552,6 @@ struct ftrace_likely_data {
 # define __compiletime_assert(condition, msg, prefix, suffix) ((void)(condition))
 #endif
 
-#define _compiletime_assert(condition, msg, prefix, suffix) \
-	__compiletime_assert(condition, msg, prefix, suffix)
-
 /**
  * compiletime_assert - break build and emit msg if condition is false
  * @condition: a compile-time constant condition to check
@@ -565,7 +562,7 @@ struct ftrace_likely_data {
  * compiler has support to do so.
  */
 #define compiletime_assert(condition, msg) \
-	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
+	__compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
 
 #define compiletime_assert_atomic_type(t)				\
 	compiletime_assert(__native_word(t),				\
_

Patches currently in -mm which might be from tz2294@columbia.edu are

compiler_types-remove-unnecessary-indirection-in-compiletime_assert.patch

