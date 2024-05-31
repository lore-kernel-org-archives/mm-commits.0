Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A62D81742
	for <mm-commits@vger.kernel.org>; Fri, 31 May 2024 22:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717193662; cv=none; b=aEDRC7KdILWN8at2AkhD3UzegWkERq2rgjy6Uou7jFQiwti/8h7JxqP3admQWqoM4gQciksNmyZ7ey5GD/GI09GL1JlHQiw+NRo2h8KtJRDQe/zu1V1VwWukUuDBqo0vNbqsfCQaoEi49x1QKrB3vmCjgDxrBIL+U1GOLX9dyG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717193662; c=relaxed/simple;
	bh=FWL1/2F9u9jU2u1q4N+zNOtL3xzFLafSxSQhgRAC6ts=;
	h=Date:To:From:Subject:Message-Id; b=TZ8aS4WJwfqnmwxCtJ5R11jjzltYBOHFyKu69g07V4FUFpMqUFhkXJjDrHgumM1syt9FESW74c3qXJYSYGJq4jHiPvFsT9SchBRd75Bbld1q0rz9hhRXnacriBhqtVU13DrRiQTWYoZvxdvkHd7u6DPJ6UxNNzJmn6OUK3Q0uY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ngyph//o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ngyph//o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1B9C4AF07;
	Fri, 31 May 2024 22:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717193661;
	bh=FWL1/2F9u9jU2u1q4N+zNOtL3xzFLafSxSQhgRAC6ts=;
	h=Date:To:From:Subject:From;
	b=ngyph//oA/56u1g+j42BMYwIZjJrEbjYgKSSYZ4KTH/HmePvqgVfkxZSuQjtG/88M
	 hyKaH3x1yZKNQKpR92YdbPOtlxdQaLFUR30RuVFUGTKqDzY035MlEgh9FsXa5YVxL2
	 flPZha9SkDucvW2GULhzXQY3FbkG8gbrhCWbqufc=
Date: Fri, 31 May 2024 15:14:20 -0700
To: mm-commits@vger.kernel.org,jim.cromie@gmail.com,jbaron@akamai.com,gregkh@linuxfoundation.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dyndbg-add-missing-module_description-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240531221421.8B1B9C4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dyndbg: add missing MODULE_DESCRIPTION() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     dyndbg-add-missing-module_description-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dyndbg-add-missing-module_description-macro.patch

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
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: dyndbg: add missing MODULE_DESCRIPTION() macro
Date: Fri, 31 May 2024 15:01:14 -0700

Make allmodconfig && make W=1 C=1 reports: WARNING: modpost: missing
MODULE_DESCRIPTION() in lib/test_dynamic_debug.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-md-test_dynamic_debug-v1-1-2194b477f55e@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_dynamic_debug.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_dynamic_debug.c~dyndbg-add-missing-module_description-macro
+++ a/lib/test_dynamic_debug.c
@@ -162,4 +162,5 @@ module_init(test_dynamic_debug_init);
 module_exit(test_dynamic_debug_exit);
 
 MODULE_AUTHOR("Jim Cromie <jim.cromie@gmail.com>");
+MODULE_DESCRIPTION("Kernel module for testing dynamic_debug");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

mm-hwpoison-add-module_description.patch
mm-dmapool-add-module_description.patch
mm-kfence-add-module_description.patch
mm-zsmalloc-add-module_description.patch
backtracetest-add-module_description.patch
dyndbg-add-missing-module_description-macro.patch

