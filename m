Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D4A2EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011373; cv=none; b=U1IAR4T0bHaVwfMzFbpAN2AeWFa1oNMGaArCvUniZJBVmSbzTrGeIzAohZ4buq+4HwAfqZSZXPfibkwUNjBLntTBCXgCmR2i9PKC5tViSlef58z4wA+tEiUNaDaCCBbR/KIemLcPRa8wQfDoKYVVSMbrc+WLmIvr4q7355Md7Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011373; c=relaxed/simple;
	bh=O79QE/A41dLuwTBL0v8W3FheD6m1Z5qVD43bFNle0Uk=;
	h=Date:To:From:Subject:Message-Id; b=jnpEvAR6tyxM8vcyfVLULVB59BeEe5Ds3lQb24Hm57gNQx2O9OQaCa8b1Slrz06rPW32LQ7iRrWmLqnOFGWaTlRh5zuCPfPT5lwMPM/PvEf7dT2shg5shG67el2JNg9sI2KLfQE1rhGEaKIFft7hCOLUakUWaJ5601O7QKiXJME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I5zKqEgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I5zKqEgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9124EC4CEE4;
	Mon, 12 May 2025 00:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011372;
	bh=O79QE/A41dLuwTBL0v8W3FheD6m1Z5qVD43bFNle0Uk=;
	h=Date:To:From:Subject:From;
	b=I5zKqEgBVkc2r3M4LxQlhqQiq01xDZn08V8yntiIiao4qzWOMHE7RF2Pju1/3KsxN
	 00RxkPJCS/OXGWWgjTKWtBQsZgpIZHaV2a4ZMoty81+hhSAlc9VQcvR7KhZUGD8Vpk
	 Rny0TIn/JsX9etk4gvZSFQNZ/r7h5+aCYE8Fuvms=
Date: Sun, 11 May 2025 17:56:12 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,keescook@chromium.org,andrii@kernel.org,yatsenko@meta.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maccess-fix-strncpy_from_user_nofault-empty-string-handling.patch removed from -mm tree
Message-Id: <20250512005612.9124EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maccess: fix strncpy_from_user_nofault() empty string handling
has been removed from the -mm tree.  Its filename was
     maccess-fix-strncpy_from_user_nofault-empty-string-handling.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mykyta Yatsenko <yatsenko@meta.com>
Subject: maccess: fix strncpy_from_user_nofault() empty string handling
Date: Tue, 22 Apr 2025 14:14:49 +0100

strncpy_from_user_nofault() should return the length of the copied string
including the trailing NUL, but if the argument unsafe_addr points to an
empty string ({'\0'}), the return value is 0.

This happens as strncpy_from_user() copies terminal symbol into dst and
returns 0 (as expected), but strncpy_from_user_nofault does not modify ret
as it is not equal to count and not greater than 0, so 0 is returned,
which contradicts the contract.

Link: https://lkml.kernel.org/r/20250422131449.57177-1-mykyta.yatsenko5@gmail.com
Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Reviewed-by: Andrii Nakryiko <andrii@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/maccess.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/maccess.c~maccess-fix-strncpy_from_user_nofault-empty-string-handling
+++ a/mm/maccess.c
@@ -196,7 +196,7 @@ long strncpy_from_user_nofault(char *dst
 	if (ret >= count) {
 		ret = count;
 		dst[ret - 1] = '\0';
-	} else if (ret > 0) {
+	} else if (ret >= 0) {
 		ret++;
 	}
 
_

Patches currently in -mm which might be from yatsenko@meta.com are


