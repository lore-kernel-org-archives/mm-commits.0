Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13DB34D3B9;
	Thu,  8 Oct 2026 17:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791480344; cv=none; b=MsG1UeosOMF8YMc4L9BzynlX6xGYyxEEty7S2BLkiAgGENYwrgBoGPuZvwTxttM11fHx4E0j+z1Xjfov55s1feUmV9CmiyuKfCl27SplY94XR0rfO5FlmbQgQ+se/ow0UT9y5mNZ7zsmIR5H/KRq0xo+v1PQElAR0SqvmrFp+HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791480344; c=relaxed/simple;
	bh=xcCbjZE+84vuxI1NFNFVZdxjIBaSOjCjCUBKbVOwoHo=;
	h=Date:To:From:Subject:Message-Id; b=USR+G8Gx8OW7uLlMMojT5q1OMTh/flSfnP5C3jqqpn9vdaQtRU9CJoJEO1k+1AwNBXaS/Wi044vtlAKx8AuYi6whbOMMQhYTHGsW9uMFT3Ny3dTLk+lfrah4/u+ix2yBmh8GxSmOTGUxavieiqW93kFk64vymNgSkOYQ9TCFr+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=knJXivqe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="knJXivqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE231F000FF;
	Thu,  8 Oct 2026 17:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791480342;
	bh=U0g8TLh8UvF8bFazFwWckzVHrnAitp/hOgOw3F7c0C0=;
	h=Date:To:From:Subject;
	b=knJXivqeUIk8xfe4QB8CT8s8lYIaHTC8NPCkT2AsVoEO6rOaGDHGJ5o4lLD/Pwyb4
	 VsKVeFA0Bh9Y6NfuJiCufpo28yWcKx7jmMyvv+0Pfo0+zN4lRfG0eSe5s28x2yBtiO
	 RBMmJaGMnLDY/u/ULH3iSJSKpSgLDY/rztZQ5qTQ=
Date: Thu, 08 Oct 2026 10:25:41 -0700
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,stable@vger.kernel.org,ndesaulniers@google.com,morbo@google.com,justinstitt@google.com,409411716@gms.tku.edu.tw,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-base64-silence-clang-24-wconstant-conversion-with-diag-pragmas.patch added to mm-hotfixes-unstable branch
Message-Id: <20261008172542.3AE231F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/base64: silence clang-24 -Wconstant-conversion with diag pragmas
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-base64-silence-clang-24-wconstant-conversion-with-diag-pragmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-base64-silence-clang-24-wconstant-conversion-with-diag-pragmas.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
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

lib-base64-silence-clang-24-wconstant-conversion-with-diag-pragmas.patch

