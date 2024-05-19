Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF241094E
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154653; cv=none; b=TfL9A+O4wd0k1Dtx5eXV0omr/3FUt7hjqbBNlDguYlW4X4jBW+vwkk7zfsVGkwZ+0SXCdUM1+8/8xeBd78ZJgOBZ27ULMV/QeV/tHLcJbFXsD4+K5CeWdenAexbFQufFsqrVEBodiEi8CQejBquoYdy00ZvpL9DkNKGuddoFq7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154653; c=relaxed/simple;
	bh=dyUPc7ALz7rkYgXAJ2PRSSiZujGojwMppMTFl1yLLEs=;
	h=Date:To:From:Subject:Message-Id; b=imZutzVut+gK5FsPeItiUxDNXqGf/StrRsBVTWC8yRpL1jvDgLmqGg0mAuS2rv7Wc/ra8/k4rKVUeEQiqBzgnVZ7LXI3zRB5n4nsHLu3qdFhN3xR9X09kjBVf84ezPnRk6HyOTurO219z8ac3eiprcwtrBzRf70DaIscT++8Vh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k0hzHllg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k0hzHllg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE81C32781;
	Sun, 19 May 2024 21:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154653;
	bh=dyUPc7ALz7rkYgXAJ2PRSSiZujGojwMppMTFl1yLLEs=;
	h=Date:To:From:Subject:From;
	b=k0hzHllgvRTxAQAClZRF0B7CbE9HOvUxwK/dlPTErr6T5OMIPXP2RFTauRcBvAJRE
	 k+kp0ccRzb5vqDzuYEikGI7RIZvZAebhCnK6M6vW2MnZUUTczO68wTi8m4BJlMVcR2
	 faerKzHn2Au+N2X2QmSbpLN7Ed9wOz4VRKVkZtVQ=
Date: Sun, 19 May 2024 14:37:32 -0700
To: mm-commits@vger.kernel.org,tiwai@suse.com,shuah@kernel.org,seanjc@google.com,perex@perex.cz,pbonzini@redhat.com,pabeni@redhat.com,kuba@kernel.org,jarkko@kernel.org,ivan.orlov0322@gmail.com,horms@kernel.org,edumazet@google.com,edliaw@google.com,davem@davemloft.net,dave.hansen@linux.intel.com,broonie@kernel.org,bongsu.jeon@samsung.com,alexandre.belloni@bootlin.com,tao1.su@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-harness-use-1024-in-place-of-line_max.patch removed from -mm tree
Message-Id: <20240519213733.2AE81C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/harness: use 1024 in place of LINE_MAX
has been removed from the -mm tree.  Its filename was
     selftests-harness-use-1024-in-place-of-line_max.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Simon Horman <horms@kernel.org>
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
@@ -56,7 +56,6 @@ static_assert(0, "kselftest harness requ
 #include <asm/types.h>
 #include <ctype.h>
 #include <errno.h>
-#include <limits.h>
 #include <stdbool.h>
 #include <stdint.h>
 #include <stdio.h>
@@ -1217,7 +1216,7 @@ void __run_test(struct __fixture_metadat
 		struct __test_metadata *t)
 {
 	struct __test_xfail *xfail;
-	char test_name[LINE_MAX];
+	char test_name[1024];
 	const char *diagnostic;
 
 	/* reset test struct */
_

Patches currently in -mm which might be from tao1.su@linux.intel.com are


