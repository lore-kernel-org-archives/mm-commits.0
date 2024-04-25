Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19185240
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 02:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714012091; cv=none; b=oUO2+MWP04VO0B1MQOaXb8fHm0eSYRCGLERT5gCMV6Ba7cyDMBmLWkuQ9D/OgSYh1JtFZ54AlUcB+zYMNfxn6OdQMmbeoAUoApAHmF0akGj/bUrViHFKFNp4BRtRWWLPc2iX4XQ/njFZlT9nBXRuUcQvIe2JFty4/Ybc37ntaa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714012091; c=relaxed/simple;
	bh=tGYbpdtQrTNwy8uzz3Hfz6lRHGy06wnKrkAvN8jd7xE=;
	h=Date:To:From:Subject:Message-Id; b=nWmRjCOy0/8xTJ94KTvnSVmF72Nv797ixu1naCjjVYxPF8ISGpM9EEFFshuHjXOL10ZAhzkulS37CfKt7wlEI73DypxECAk5VjlBRhw30VOT6itn61IgmT/g8OPtgF83PEfsNl9oGc/l4t2UMtLq30RiXm0NpkgllXRcsUl0B4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NZI+GNVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NZI+GNVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1E8C113CE;
	Thu, 25 Apr 2024 02:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714012091;
	bh=tGYbpdtQrTNwy8uzz3Hfz6lRHGy06wnKrkAvN8jd7xE=;
	h=Date:To:From:Subject:From;
	b=NZI+GNVviSBhjRRWHumxpE5tP3LaFTdZci8kmDKP3j0U6nGCA0Yvm4OJ6UelCtwol
	 p3LYbsSo6+XAkGT3ugzEk/zSRRz6aQOAa3lfIhGf//xRTxs52SGn2MGVY3StacbaGO
	 bI2VAwPrRXrW52H0OFVFdzY8wvC0hXhsgpS/KCbI=
Date: Wed, 24 Apr 2024 19:28:10 -0700
To: mm-commits@vger.kernel.org,wad@chromium.org,usama.anjum@collabora.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,luto@amacapital.net,keescook@chromium.org,justinstitt@google.com,edliaw@google.com,david@redhat.com,axelrasmussen@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-harness-remove-use-of-line_max-fix.patch removed from -mm tree
Message-Id: <20240425022811.1D1E8C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-harness-remove-use-of-line_max-fix
has been removed from the -mm tree.  Its filename was
     selftests-harness-remove-use-of-line_max-fix.patch

This patch was dropped because it was folded into selftests-harness-remove-use-of-line_max.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-harness-remove-use-of-line_max-fix
Date: Fri Apr 12 03:53:51 PM PDT 2024

remove limits.h include, per Edward

Cc: Edward Liaw <edliaw@google.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kselftest_harness.h |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/kselftest_harness.h~selftests-harness-remove-use-of-line_max-fix
+++ a/tools/testing/selftests/kselftest_harness.h
@@ -56,7 +56,6 @@
 #include <asm/types.h>
 #include <ctype.h>
 #include <errno.h>
-#include <limits.h>
 #include <stdbool.h>
 #include <stdint.h>
 #include <stdio.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

selftests-harness-remove-use-of-line_max.patch
selftests-harness-remove-use-of-line_max-fix-fix.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch
binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes.patch

