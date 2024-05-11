Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CA017BA8
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467942; cv=none; b=KZZDAru5tuTq1769vg5lzmoa7ShU3mHq4hOcDLDeEtwUceiLIbr4nDVuXrgZAGng6Hiv9f5AxZx+BsvEKKGT8YEH9lC9tLVZj3XV9E9T72uaQU2v8XfZmXImqx9lVGY61CtOxu38wkh/U7aW+HlYQ31GojdqKs7t8AK0N3KMv7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467942; c=relaxed/simple;
	bh=/0hagFMvDX7XXD2kn3xzyfU+ippi6VjM3TKt/AqkwHM=;
	h=Date:To:From:Subject:Message-Id; b=XV/ARCLx/hreonSPESIdHt/ahJ4r4SWuVTrTNzePyoJAuLlUhj045itWRUBUsdmKCZXoytDGoRJR3COtOqCNF2ew85W+c5H6WUrfQIINqEpVwSwW7s6EWOjKymgtP3/yoon41vj9ecwguyzM29R/7fRtDQi1GL0I+YWCMvMTNi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hc9iogsy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hc9iogsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F8CC2BBFC;
	Sat, 11 May 2024 22:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467942;
	bh=/0hagFMvDX7XXD2kn3xzyfU+ippi6VjM3TKt/AqkwHM=;
	h=Date:To:From:Subject:From;
	b=Hc9iogsy9He4WmcsHnbsP81BZc995fy6PKTFA+Nl+13PNG9TnpfFTAGrsvI2/gRYv
	 FmcsgHYT+QiZx1ZGlPJKMOahse37FWklJAgCownPVaBS/TpYQe/NZrC5pPw1GBzwSW
	 F/wwd2cx6gakRZNNMs1xVVVyEqw/tSTfWhZoFtvk=
Date: Sat, 11 May 2024 15:52:21 -0700
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,sfr@canb.auug.org.au,quic_jjohnson@quicinc.com,lukas.bulwahn@gmail.com,linux@roeck-us.net,joe@perches.com,jcmvbkbc@gmail.com,herbert@gondor.apana.org.au,dwaipayanray1@gmail.com,corbet@lwn.net,chris@zankel.net,chenhuacai@loongson.cn,charlemagnelasse@gmail.com,broonie@kernel.org,apw@canonical.com,mac.xxn@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-checkpatch-check-unused-parameters-for-function-like-macro.patch removed from -mm tree
Message-Id: <20240511225221.F1F8CC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts: checkpatch: check unused parameters for function-like macro
has been removed from the -mm tree.  Its filename was
     scripts-checkpatch-check-unused-parameters-for-function-like-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xining Xu <mac.xxn@outlook.com>
Subject: scripts: checkpatch: check unused parameters for function-like macro
Date: Tue, 7 May 2024 15:27:57 +1200

If function-like macros do not utilize a parameter, it might result in a
build warning.  In our coding style guidelines, we advocate for utilizing
static inline functions to replace such macros.  This patch verifies
compliance with the new rule.

For a macro such as the one below,

 #define test(a) do { } while (0)

The test result is as follows.

 WARNING: Argument 'a' is not used in function-like macro
 #21: FILE: mm/init-mm.c:20:
 +#define test(a) do { } while (0)

 total: 0 errors, 1 warnings, 8 lines checked

Link: https://lkml.kernel.org/r/20240507032757.146386-3-21cnbao@gmail.com
Signed-off-by: Xining Xu <mac.xxn@outlook.com>
Tested-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@kernel.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Charlemagne Lasse <charlemagnelasse@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/checkpatch.rst |   14 ++++++++++++++
 scripts/checkpatch.pl                  |    6 ++++++
 2 files changed, 20 insertions(+)

--- a/Documentation/dev-tools/checkpatch.rst~scripts-checkpatch-check-unused-parameters-for-function-like-macro
+++ a/Documentation/dev-tools/checkpatch.rst
@@ -906,6 +906,20 @@ Macros, Attributes and Symbols
 
     See: https://lore.kernel.org/lkml/1399671106.2912.21.camel@joe-AO725/
 
+  **MACRO_ARG_UNUSED**
+    If function-like macros do not utilize a parameter, it might result
+    in a build warning. We advocate for utilizing static inline functions
+    to replace such macros.
+    For example, for a macro such as the one below::
+
+      #define test(a) do { } while (0)
+
+    there would be a warning like below::
+
+      WARNING: Argument 'a' is not used in function-like macro.
+
+    See: https://www.kernel.org/doc/html/latest/process/coding-style.html#macros-enums-and-rtl
+
   **SINGLE_STATEMENT_DO_WHILE_MACRO**
     For the multi-statement macros, it is necessary to use the do-while
     loop to avoid unpredictable code paths. The do-while loop helps to
--- a/scripts/checkpatch.pl~scripts-checkpatch-check-unused-parameters-for-function-like-macro
+++ a/scripts/checkpatch.pl
@@ -6040,6 +6040,12 @@ sub process {
 					CHK("MACRO_ARG_PRECEDENCE",
 					    "Macro argument '$arg' may be better as '($arg)' to avoid precedence issues\n" . "$herectx");
 				}
+
+# check if this is an unused argument
+				if ($define_stmt !~ /\b$arg\b/) {
+					WARN("MACRO_ARG_UNUSED",
+					     "Argument '$arg' is not used in function-like macro\n" . "$herectx");
+				}
 			}
 
 # check for macros with flow control, but without ## concatenation
_

Patches currently in -mm which might be from mac.xxn@outlook.com are


