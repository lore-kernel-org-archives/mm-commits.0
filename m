Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBADF41C63
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 20:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744922477; cv=none; b=jxH3CT1S2CugjOJUPrQM35LpLlF+OHQbXH4hWbW479mC4iEdhnUNZSFOJvuvUPhM6h7rmv7bxc+wXw2mk4B7d1jJppE+g846YyQHD+kl0cATwgD3HomVTTmibvsFb6auIWAA0ioubZ8CImD0FW9OKGWQPb/6OLsVPYxwccf2lNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744922477; c=relaxed/simple;
	bh=2IIU+XXOrQRIN0YdQrPjRDOtX3WlfNCj0bBD73A52w0=;
	h=Date:To:From:Subject:Message-Id; b=F2c88+P4cs0qO0JNylmblio0GNq2AREQGZDX7XAHqc9KiMDxI3ze3zhkAQ29oyufyy8EoNGoTSJMwwhmwLkUxM7T/Ewq82IbpW95BCP0MH6NigWX8sAmWoIgBzVvYg+lEGRq6kFX2qcIPPgt+xHUzl0ptcjTvDmsUAOBxE7JS9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ur49WgIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ur49WgIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F28C4CEE4;
	Thu, 17 Apr 2025 20:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744922477;
	bh=2IIU+XXOrQRIN0YdQrPjRDOtX3WlfNCj0bBD73A52w0=;
	h=Date:To:From:Subject:From;
	b=ur49WgIJDQgUogOQcbse22VU1l39w5Eivyo1E2MeGJf4ecajXvTiTXXYK/KM6a55k
	 4/xYehWGZQHLvVl6dGW5rgepfXIih//9KuejITnRgePybtsuDTEkzlQMMYxY14y01X
	 ekHQC237I1SLE2zKdg8dOCfkmGAx4b1NrVYhiO1Q=
Date: Thu, 17 Apr 2025 13:41:16 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,andrii@kernel.org,yatsenko@meta.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maccess-fix-strncpy_from_user_nofault-empty-string-handling.patch added to mm-nonmm-unstable branch
Message-Id: <20250417204117.21F28C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maccess: fix strncpy_from_user_nofault empty string handling
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maccess-fix-strncpy_from_user_nofault-empty-string-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maccess-fix-strncpy_from_user_nofault-empty-string-handling.patch

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
From: Mykyta Yatsenko <yatsenko@meta.com>
Subject: maccess: fix strncpy_from_user_nofault empty string handling
Date: Thu, 17 Apr 2025 16:28:08 +0100

strncpy_from_user_nofault() should return the length of the copied string
including the trailing NUL, but if the argument unsafe_addr points to an
empty string ({'\0'}), the return value is 0.

This happens as strncpy_from_user() copies terminal symbol into dst and
returns 0 (as expected), but strncpy_from_user_nofault does not modify ret
as it is not equal to count and not greater than 0, so 0 is returned,
which contradicts the contract.

Link: https://lkml.kernel.org/r/20250417152808.722409-1-mykyta.yatsenko5@gmail.com
Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/trace_events_filter.c |   10 ++++++++--
 mm/maccess.c                       |    2 +-
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/kernel/trace/trace_events_filter.c~maccess-fix-strncpy_from_user_nofault-empty-string-handling
+++ a/kernel/trace/trace_events_filter.c
@@ -800,6 +800,7 @@ static __always_inline char *test_string
 {
 	struct ustring_buffer *ubuf;
 	char *kstr;
+	int cnt;
 
 	if (!ustring_per_cpu)
 		return NULL;
@@ -808,7 +809,9 @@ static __always_inline char *test_string
 	kstr = ubuf->buffer;
 
 	/* For safety, do not trust the string pointer */
-	if (!strncpy_from_kernel_nofault(kstr, str, USTRING_BUF_SIZE))
+	cnt = strncpy_from_kernel_nofault(kstr, str, USTRING_BUF_SIZE);
+	/* Return null if empty string or error */
+	if (cnt <= 1)
 		return NULL;
 	return kstr;
 }
@@ -818,6 +821,7 @@ static __always_inline char *test_ustrin
 	struct ustring_buffer *ubuf;
 	char __user *ustr;
 	char *kstr;
+	int cnt;
 
 	if (!ustring_per_cpu)
 		return NULL;
@@ -827,7 +831,9 @@ static __always_inline char *test_ustrin
 
 	/* user space address? */
 	ustr = (char __user *)str;
-	if (!strncpy_from_user_nofault(kstr, ustr, USTRING_BUF_SIZE))
+	cnt = strncpy_from_user_nofault(kstr, ustr, USTRING_BUF_SIZE);
+	/* Return null if empty string or error */
+	if (cnt <= 1)
 		return NULL;
 
 	return kstr;
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

maccess-fix-strncpy_from_user_nofault-empty-string-handling.patch

