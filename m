Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC1433D5
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725422115; cv=none; b=CYcxLTN3uCFeqsFQKRr7SOOSmfz4hAAfbUTeu/ghgCnaTYHqw8AXgaUbYkqRdL7hbcp4I+Lx4m6PhYQSFsQiva/7HxmBYBrfl2YfoRXNbgvND6DBc7XqTrVDfPX7WS5kFiFjupvleMRRrWj0hcGoBn5dGqNEIs8WhdSWY4Ydv4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725422115; c=relaxed/simple;
	bh=sXMxva9mRMk3wxtpEWlxeGJI3WRGQWIJ3VkA3A5/3Ws=;
	h=Date:To:From:Subject:Message-Id; b=RmD/9e6iUcdwBbFpu1+kXlgV/JuPfqUNWd8G0RPZXYn1uu6gBPTOlEf2cumnsV1L8oXah+8aE/Ha5behrBzvQ3dh6cleGvpUivTYxUeXvmmKGM7/+zFD3ZMnKAUjYfY9dHq7oCkGotYLrhz3g/B35etMBMqn5rriIFQgg3QMQOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l75teV3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l75teV3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7956EC4CEC2;
	Wed,  4 Sep 2024 03:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725422114;
	bh=sXMxva9mRMk3wxtpEWlxeGJI3WRGQWIJ3VkA3A5/3Ws=;
	h=Date:To:From:Subject:From;
	b=l75teV3JaZY6v/NTGnSqJ5svRKafHnipWffwzagslC+Bl7wHDzIV7ZSmLs9EMJ/rE
	 rpDQDGOBbsy3z+vfAS4EuDzW8mqwL2A5ZM1OjQzvYEmF/eRAzxYmGbfZe7DyWcFEb4
	 Q5Dp2HHfVHRqhS5Vi2k5Pif0cNoo6V69lvvwFeao=
Date: Tue, 03 Sep 2024 20:55:13 -0700
To: mm-commits@vger.kernel.org,ojeda@kernel.org,andreyknvl@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-simplify-and-clarify-makefile-v2.patch removed from -mm tree
Message-Id: <20240904035514.7956EC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan-simplify-and-clarify-makefile-v2
has been removed from the -mm tree.  Its filename was
     kasan-simplify-and-clarify-makefile-v2.patch

This patch was dropped because it was folded into kasan-simplify-and-clarify-makefile.patch

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@gmail.com>
Subject: kasan-simplify-and-clarify-makefile-v2
Date: Wed, 14 Aug 2024 18:10:52 +0200

comments fixes per Miguel

Link: https://lkml.kernel.org/r/20240814161052.10374-1-andrey.konovalov@linux.dev
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.kasan |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/scripts/Makefile.kasan~kasan-simplify-and-clarify-makefile-v2
+++ a/scripts/Makefile.kasan
@@ -34,13 +34,15 @@ endif
 # First, enable -fsanitize=kernel-address together with providing the shadow
 # mapping offset, as for GCC, -fasan-shadow-offset fails without -fsanitize
 # (GCC accepts the shadow mapping offset via -fasan-shadow-offset instead of
-# a normal --param). Instead of ifdef-checking the compiler, rely on cc-option.
+# a --param like the other KASAN parameters).
+# Instead of ifdef-checking the compiler, rely on cc-option.
 CFLAGS_KASAN := $(call cc-option, -fsanitize=kernel-address \
 		-fasan-shadow-offset=$(KASAN_SHADOW_OFFSET), \
 		$(call cc-option, -fsanitize=kernel-address \
 		-mllvm -asan-mapping-offset=$(KASAN_SHADOW_OFFSET)))
 
-# Now, add other parameters enabled in a similar way with GCC and Clang.
+# Now, add other parameters enabled similarly in both GCC and Clang.
+# As some of them are not supported by older compilers, use cc-param.
 CFLAGS_KASAN += $(call cc-param,asan-instrumentation-with-call-threshold=$(call_threshold)) \
 		$(call cc-param,asan-stack=$(stack_enable)) \
 		$(call cc-param,asan-instrument-allocas=1) \
_

Patches currently in -mm which might be from andreyknvl@gmail.com are

kasan-simplify-and-clarify-makefile.patch

