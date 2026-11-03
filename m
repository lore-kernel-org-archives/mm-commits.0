Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675974;
	b=VzNMOCdAFZ4fYqjzbM29MXHxbrwCHXNVItcskvYTbHXyaRDuhSy0M7Vo0PT9bo98h05X
	 /HwDy1Bovo7Il+LKOiBVxUJM5RbIibl01Lb7LeHPqG+MAAanNpU4FDq1Nx86DQJpDmf+o
	 LWMoJmKTWqTtfzNpMEc8aumJlsgnGhXAcOmpBZfQ7cFXIbKnLOVWqHWIwTKshsdWj0JLm
	 teGxofhYJmfLdyQFYW1X7q2pQX8OOrrbMVPxtPN/vSrg9EgKNAwZ37jh5v0SgF04c66qo
	 C7TkHraGLWPgax7w1RD70FF7W8qSyaKOx69plvxoa4omWdMR1w3xi5arWTXbkpwYjpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675974;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Mla6khfq2jyQEeGsiVFFFE3kwsjLtHk1U4I4TEeEGUY=;
	b=QqGZQ9lbnjg/5iamdMZByyRzUoPppX+0AZMuB6PbVgNv7SkL9cZn7QyeB93RaVo91pWt
	 +T18zHkISxVzVdQdZp80qTrnYwI9CCxRX4HLe1PeIyD6ut/LM3lhSs2khNvPWvgMUtE0i
	 hCm9QNkUff74Qh7nPWOMWrG/lVERsg40w/shZXJFjBSqVKvkNIB0wBJyOPoDJAmcVG8lR
	 BEkKxnkz7K4jCVlHXCd5YsZ4WteNKbebhB/yyRywWFmQE8vi1uQVLagFZ+ORgjm2rACtT
	 mw5b/DLiZukJZEPwKcGGL1up/5pNBW8VRTvhHHWQG6hDT/e58hkRqDxkM8cWU0C7r8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Cte4/G5b";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64084606A327;
	Tue,  3 Nov 2026 03:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Cte4/G5b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7981F000C1;
	Tue,  3 Nov 2026 03:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793675972;
	bh=Mla6khfq2jyQEeGsiVFFFE3kwsjLtHk1U4I4TEeEGUY=;
	h=Date:To:From:Subject;
	b=Cte4/G5bdTfhavoOcWb2/bdKlB89AH8nUG9nupmu3WEbI/aDGNHSs6uufH2P0mNAs
	 haZ2A8oxFDX5jo86d5hmoqsk147CduNXV7IZr+jcjKfeFBKVl59XrT/GIijtN2KDZm
	 RPrg9kcMlm60sSI62G02VEqGDWMSjARd3v28/FuI=
Date: Mon, 02 Nov 2026 19:19:32 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,stable@vger.kernel.org,
	ndesaulniers@google.com,morbo@google.com,justinstitt@google.com,
	409411716@gms.tku.edu.tw,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] lib-base64-silence-clang-24-wconstant-conversion-with-diag-pragmas.patch removed from -mm tree
Message-Id: <20261103031932.AE7981F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: lib/base64: silence clang-24 -Wconstant-conversion with diag pragmas
has been removed from the -mm tree.  Its filename was
     lib-base64-silence-clang-24-wconstant-conversion-with-diag-pragmas.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: lib/base64: silence clang-24 -Wconstant-conversion with diag pragmas
Date: Thu, 08 Oct 2026 13:08:49 +0200

After a recent change in clang to warn on signed char conversions within
array initializers [1], there are several instances of this warning from
base64_rev_maps in lib/base64.c, which can break the build with W=e or
CONFIG_WERROR=y:

  lib/base64.c:58:18: error: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 131 to -125 [-Werror,-Wconstant-conversion]
     58 |         [BASE64_IMAP] = BASE64_REV_INIT('+', ',')
        |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
  lib/base64.c:52:2: note: expanded from macro 'BASE64_REV_INIT'
     48 | #define BASE64_REV_INIT(ch_62, ch_63) { \
        |                                       ~
     49 |         [0 ... 0x1f] = -1, \
     50 |         INIT_32(0x20, ch_62, ch_63), \
     51 |         INIT_32(0x40, ch_62, ch_63), \
     52 |         INIT_32(0x60, ch_62, ch_63), \
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
  ...
  lib/base64.c:34:42: note: expanded from macro 'INIT_1'
     34 |                 : (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
        |                                              ~~~~~~~~~~^~~~
  lib/base64.c:58:18: error: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 130 to -126 [-Werror,-Wconstant-conversion]
     58 |         [BASE64_IMAP] = BASE64_REV_INIT('+', ',')
        |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
  lib/base64.c:52:2: note: expanded from macro 'BASE64_REV_INIT'
     48 | #define BASE64_REV_INIT(ch_62, ch_63) { \
        |                                       ~
     49 |         [0 ... 0x1f] = -1, \
     50 |         INIT_32(0x20, ch_62, ch_63), \
     51 |         INIT_32(0x40, ch_62, ch_63), \
     52 |         INIT_32(0x60, ch_62, ch_63), \
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
  ...
  lib/base64.c:34:42: note: expanded from macro 'INIT_1'
     34 |                 : (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
        |                                              ~~~~~~~~~~^~~~
  ...

These are false positives, as the branch where the wraparound could happen
is unreachable with the values that clang reports.  This is not considered
a bug by some clang folks [2][3], so silence the warnings using the __diag
macros the kernel has to workaround compiler warnings when necessary.

Link: https://lore.kernel.org/20261008-base64-silence-clang-24-constant-conversion-v1-1-0858b60b23c8@kernel.org
Link: https://github.com/llvm/llvm-project/commit/a5ef934a8d295dc03be3960f2b3744ec2e53238e [1]
Link: https://github.com/llvm/llvm-project/issues/223923#issuecomment-6056856245 [2]
Link: https://github.com/llvm/llvm-project/pull/226775#pullrequestreview-5454407389 [3]
Fixes: c4eb7ad32eab ("lib/base64: optimize base64_decode() with reverse lookup tables")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2181
Acked-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: <stable@vger.kernel.org>
---

 lib/base64.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/base64.c~lib-base64-silence-clang-24-wconstant-conversion-with-diag-pragmas
+++ a/lib/base64.c
@@ -52,11 +52,14 @@ static const char base64_tables[][65] =
 	INIT_32(0x60, ch_62, ch_63), \
 	[0x80 ... 0xff] = -1 }
 
+__diag_push();
+__diag_ignore(clang, all, "-Wconstant-conversion", "https://github.com/llvm/llvm-project/issues/223923");
 static const s8 base64_rev_maps[][256] = {
 	[BASE64_STD] = BASE64_REV_INIT('+', '/'),
 	[BASE64_URLSAFE] = BASE64_REV_INIT('-', '_'),
 	[BASE64_IMAP] = BASE64_REV_INIT('+', ',')
 };
+__diag_pop();
 
 #undef BASE64_REV_INIT
 #undef INIT_32
_

Patches currently in -mm which might be from nathan@kernel.org are


