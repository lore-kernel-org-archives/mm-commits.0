Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2889B3019B2;
	Sun,  8 Feb 2026 08:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770538458; cv=none; b=ustYZkG81Bn0lwZ1eTmrrwsuqDFm0DhF1wqns0Bc/OHxWHlvee01QOKwozTOrbVHRCRM0QRqDigf/ST7G+2/EtO0fdJExOouHsa1HKqzfo2b/QlaiZCYdaVYV3BmXfMCPP3X9V5sQNin2jM/vVVL4E6rkJnZ5OUXTjDFE3wjyJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770538458; c=relaxed/simple;
	bh=osmIWeG6nO+OKfrWV5NdR42mSwcp2dt7RPXhfBm3yHw=;
	h=Date:To:From:Subject:Message-Id; b=eI6JE6t/Sl/JBAggsUUiMJpSDxjalq0CVYRWjJeHk/KbRy7Ik5urhWclJcMSZtm5C/TwQl0cvRQ9ltcUHFB7IBlKAZD68BcoqaTBKish+HMKOH4qn4jqQ4XUIQpslIEDrqoqxRWTcixd0auJqYwBlc2ZeagFc+so82P5r74yDng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QZcxX1CF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QZcxX1CF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB961C4CEF7;
	Sun,  8 Feb 2026 08:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770538457;
	bh=osmIWeG6nO+OKfrWV5NdR42mSwcp2dt7RPXhfBm3yHw=;
	h=Date:To:From:Subject:From;
	b=QZcxX1CFtfwh6jDU+nXH2cvVtoHE+6u6oDrnd3IHu6GjaZ7AgYObGRyksDe+h2Lef
	 5Cl2Po24Q82LSomeCcIJp1mCVcRK0D0n2jh07g1QW510nQoC47LdIkESqi9H0pbVdJ
	 2hNMu9U6UpITLyk+NnK9OG9cAPR6Y/XnOxMf751A=
Date: Sun, 08 Feb 2026 00:14:17 -0800
To: mm-commits@vger.kernel.org,yonghong.song@linux.dev,ubizjak@gmail.com,stable@vger.kernel.org,sdf@fomichev.me,peterz@infradead.org,paulmck@kernel.org,ojeda@kernel.org,nilay@linux.ibm.com,nathan@kernel.org,namjain@linux.microsoft.com,martin.lau@linux.dev,kpsingh@kernel.org,kees@kernel.org,jolsa@kernel.org,john.fastabend@gmail.com,jason@zx2c4.com,hpa@zytor.com,hca@linux.ibm.com,haoluo@google.com,elver@google.com,eddyz87@gmail.com,daniel@iogearbox.net,bvanassche@acm.org,ast@kernel.org,andrii.nakryiko@gmail.com,alan.maguire@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kcsan-compiler_types-avoid-duplicate-type-issues-in-bpf-type-format.patch removed from -mm tree
Message-Id: <20260208081417.CB961C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcsan, compiler_types: avoid duplicate type issues in BPF Type Format
has been removed from the -mm tree.  Its filename was
     kcsan-compiler_types-avoid-duplicate-type-issues-in-bpf-type-format.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alan Maguire <alan.maguire@oracle.com>
Subject: kcsan, compiler_types: avoid duplicate type issues in BPF Type Format
Date: Fri, 16 Jan 2026 09:17:30 +0000

Enabling KCSAN is causing a large number of duplicate types in BTF for
core kernel structs like task_struct [1].  This is due to the definition
in include/linux/compiler_types.h

`#ifdef __SANITIZE_THREAD__
...
`#define __data_racy volatile
..
`#else
...
`#define __data_racy
...
`#endif

Because some objects in the kernel are compiled without KCSAN flags
(KCSAN_SANITIZE) we sometimes get the empty __data_racy annotation for
objects; as a result we get multiple conflicting representations of the
associated structs in DWARF, and these lead to multiple instances of core
kernel types in BTF since they cannot be deduplicated due to the
additional modifier in some instances.

Moving the __data_racy definition under CONFIG_KCSAN avoids this problem,
since the volatile modifier will be present for both KCSAN and
KCSAN_SANITIZE objects in a CONFIG_KCSAN=y kernel.

Link: https://lkml.kernel.org/r/20260116091730.324322-1-alan.maguire@oracle.com
Fixes: 31f605a308e6 ("kcsan, compiler_types: Introduce __data_racy type qualifier")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Reported-by: Nilay Shroff <nilay@linux.ibm.com>
Tested-by: Nilay Shroff <nilay@linux.ibm.com>
Suggested-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Bart van Assche <bvanassche@acm.org>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Naman Jain <namjain@linux.microsoft.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Uros Bizjak <ubizjak@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler_types.h |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/include/linux/compiler_types.h~kcsan-compiler_types-avoid-duplicate-type-issues-in-bpf-type-format
+++ a/include/linux/compiler_types.h
@@ -303,6 +303,22 @@ struct ftrace_likely_data {
 # define __no_kasan_or_inline __always_inline
 #endif
 
+#ifdef CONFIG_KCSAN
+/*
+ * Type qualifier to mark variables where all data-racy accesses should be
+ * ignored by KCSAN. Note, the implementation simply marks these variables as
+ * volatile, since KCSAN will treat such accesses as "marked".
+ *
+ * Defined here because defining __data_racy as volatile for KCSAN objects only
+ * causes problems in BPF Type Format (BTF) generation since struct members
+ * of core kernel data structs will be volatile in some objects and not in
+ * others.  Instead define it globally for KCSAN kernels.
+ */
+# define __data_racy volatile
+#else
+# define __data_racy
+#endif
+
 #ifdef __SANITIZE_THREAD__
 /*
  * Clang still emits instrumentation for __tsan_func_{entry,exit}() and builtin
@@ -314,16 +330,9 @@ struct ftrace_likely_data {
  * disable all instrumentation. See Kconfig.kcsan where this is mandatory.
  */
 # define __no_kcsan __no_sanitize_thread __disable_sanitizer_instrumentation
-/*
- * Type qualifier to mark variables where all data-racy accesses should be
- * ignored by KCSAN. Note, the implementation simply marks these variables as
- * volatile, since KCSAN will treat such accesses as "marked".
- */
-# define __data_racy volatile
 # define __no_sanitize_or_inline __no_kcsan notrace __maybe_unused
 #else
 # define __no_kcsan
-# define __data_racy
 #endif
 
 #ifdef __SANITIZE_MEMORY__
_

Patches currently in -mm which might be from alan.maguire@oracle.com are


