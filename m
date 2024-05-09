Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6485D77108
	for <mm-commits@vger.kernel.org>; Thu,  9 May 2024 18:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715280881; cv=none; b=enI2Xglkd7lsIaVE5UzxgJX3QhQqivB/48kxPn83DSu5ZQiThSO+1UWwRwJkkvlNkXDv279HLfcrCpTypiyrtOx04ukcRNIAUzWMrN3NOSuAmJoATqAACvTKtGNSnTxxN4zFrN3LoNSCxvzkdgPbJw/FH3DPeZZvZ5vWdCiIgDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715280881; c=relaxed/simple;
	bh=R5RRkYgo6KYYC8ZO4z+mtrp7Mlbtsa+ISGnoX7IOgdc=;
	h=Date:To:From:Subject:Message-Id; b=XVNuQC9SHWFzQ04BiYAGkLjBHVct9/hlAFqC15op42yxg0YS6uJ3oYA5VEeiC4PSdePVXKeXdlZJBrrOvSXAacO7jnpey/hN8p+MBNpuGijsxL36FY3jamEeGhkiCKtV7fAIQzGeGRrIoLDgNw88hMmbjq4XU+Q7AACbfHXMdQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RcmQ9V6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RcmQ9V6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10DAC116B1;
	Thu,  9 May 2024 18:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715280880;
	bh=R5RRkYgo6KYYC8ZO4z+mtrp7Mlbtsa+ISGnoX7IOgdc=;
	h=Date:To:From:Subject:From;
	b=RcmQ9V6pzAM34B8UK7eEkWZSrnqEwe5en8j94ub758XjcB3ZPFJEZhHN7dDSzBqUR
	 gLx91gXt1cnJBTTVQ2uKDZqAQHwT9NFlD2A2IKbrGIDMnGNYHIolWGziv8sLX+Bye+
	 xwb9pcmNurpnfLboBjoRo/YgRg+s3iNC1UsuAi6A=
Date: Thu, 09 May 2024 11:54:40 -0700
To: mm-commits@vger.kernel.org,tiwai@suse.com,shuah@kernel.org,seanjc@google.com,perex@perex.cz,pbonzini@redhat.com,pabeni@redhat.com,kuba@kernel.org,jarkko@kernel.org,ivan.orlov0322@gmail.com,edumazet@google.com,edliaw@google.com,davem@davemloft.net,dave.hansen@linux.intel.com,broonie@kernel.org,bongsu.jeon@samsung.com,alexandre.belloni@bootlin.com,tao1.su@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-harness-use-1024-in-place-of-line_max.patch added to mm-nonmm-unstable branch
Message-Id: <20240509185440.C10DAC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/harness: use 1024 in place of LINE_MAX
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-harness-use-1024-in-place-of-line_max.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-harness-use-1024-in-place-of-line_max.patch

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
From: Tao Su <tao1.su@linux.intel.com>
Subject: selftests/harness: use 1024 in place of LINE_MAX
Date: Thu, 9 May 2024 13:31:13 +0800

Android was seeing a compilation error because its C library does not
define LINE_MAX.  Since LINE_MAX is only used to determine the size of
test_name[] and 1024 should be enough for the test name, use 1024 instead
of LINE_MAX.

Link: https://lkml.kernel.org/r/20240509053113.43462-3-tao1.su@linux.intel.com
Fixes: 38c957f07038 ("selftests: kselftest_harness: generate test name once")
Signed-off-by: Tao Su <tao1.su@linux.intel.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Edward Liaw <edliaw@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ivan Orlov <ivan.orlov0322@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Mark Brown <broonie@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kselftest_harness.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/tools/testing/selftests/kselftest_harness.h~selftests-harness-use-1024-in-place-of-line_max
+++ a/tools/testing/selftests/kselftest_harness.h
@@ -56,7 +56,6 @@
 #include <asm/types.h>
 #include <ctype.h>
 #include <errno.h>
-#include <limits.h>
 #include <stdbool.h>
 #include <stdint.h>
 #include <stdio.h>
@@ -1156,7 +1155,7 @@ void __run_test(struct __fixture_metadat
 		struct __test_metadata *t)
 {
 	struct __test_xfail *xfail;
-	char test_name[LINE_MAX];
+	char test_name[1024];
 	const char *diagnostic;
 
 	/* reset test struct */
_

Patches currently in -mm which might be from tao1.su@linux.intel.com are

revert-selftests-harness-remove-use-of-line_max.patch
selftests-harness-use-1024-in-place-of-line_max.patch

