Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BFC26AC5
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 00:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788396747; cv=none; b=jj9s8r21zSHA+NvafbgCQanRTtVSu4PYzmAsldTqXqjRtuKOIrhHECwS26j9tmj0BoxClgjfETkZ3PiYrB/wlCABZGYkzi1+l73wNv9iff/rGJWLD2yARAM1kWXcACiz+SAkAv94LK8/tEE4fgVKs81wWWrde4waBsWryIuvz1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788396747; c=relaxed/simple;
	bh=7PJUgAGGVo7TLvcIpYtpqs2Lb+lrDX5VkkdUjhKRs2w=;
	h=Date:To:From:Subject:Message-Id; b=pkzGtN6RdRUD8GDGK9vag1YAzbqf1t6Uib747yx2GCsNyAxYp23zkdimGOcmm8GtyuJZZxuoxVAe94KYds32DlL/IqU6ZZfc+jGTT2jwCyMCYjfUj5xPuNbie75et5kdcSF7lLEDjGIJb4uihIcjwp/x9lxb+87n6ubWziffQvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oazMS1VP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oazMS1VP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF201F000E9;
	Thu,  3 Sep 2026 00:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788396745;
	bh=B064liZZsN0kN2v+hX+bRpRUwW3VbfpinASKtshvSlU=;
	h=Date:To:From:Subject;
	b=oazMS1VPkm+v4/ilFUDJFdUFSvZSyswCNWOmUjgApRUtrjJfGgVewJg13YCAjq68e
	 rRpqJ3V2mDf8kHABm0bUMsrk+IxyJ6YUVUStM92GG8Ndobz91fU7hlQHBomqysX8Co
	 3wVMy/41aVgvk7tXns2t1s33/Luqew/pqhoveDXk=
Date: Wed, 02 Sep 2026 17:52:25 -0700
To: mm-commits@vger.kernel.org,nathan@kernel.org,morbo@google.com,justinstitt@google.com,ndesaulniers@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-checkstackpl-support-llvm-objdump-disassembly-for-x86.patch added to mm-nonmm-unstable branch
Message-Id: <20260903005225.6AF201F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/checkstack.pl: support llvm-objdump disassembly for x86
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-checkstackpl-support-llvm-objdump-disassembly-for-x86.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-checkstackpl-support-llvm-objdump-disassembly-for-x86.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: scripts/checkstack.pl: support llvm-objdump disassembly for x86
Date: Wed, 02 Sep 2026 14:01:53 -0700

When running `make LLVM=1 checkstack`, OBJDUMP is set to llvm-objdump. 
llvm-objdump outputs disassembly with instruction size suffixes (such as
subq/addq/subl/addl), tabs/whitespace differences, spaces after commas,
and trailing comments (e.g.  `# imm = 0x...`).

Because scripts/checkstack.pl used rigid regular expressions specifically
tuned to GNU objdump format (e.g.  requiring exactly four spaces, no
suffix, and no space after comma), checkstack.pl failed to match any stack
adjustment instructions and yielded no output when using llvm-objdump on
x86.

Update the regular expressions for x86 to match optional suffixes,
variable whitespace, and trailing comments.

Link: https://lore.kernel.org/20260902-checkstack_llvm_objdump-v1-1-edb4eca5f163@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Assisted-by: LLM Gemini
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/scripts/checkstack.pl~scripts-checkstackpl-support-llvm-objdump-disassembly-for-x86
+++ a/scripts/checkstack.pl
@@ -66,8 +66,10 @@ my (@stack, $re, $dre, $sub, $x, $xs, $f
 		#c0105234:       81 ec ac 05 00 00       sub    $0x5ac,%esp
 		# or
 		#    2f60:    48 81 ec e8 05 00 00       sub    $0x5e8,%rsp
-		$re = qr/^.*[as][du][db]    \$(0x$x{1,8}),\%(e|r)sp$/o;
-		$dre = qr/^.*[as][du][db]    (%.*),\%(e|r)sp$/o;
+		# or
+		#       0: 48 81 ec e8 05 00 00          subq   $0x5e8, %rsp
+		$re = qr/^.*[as][du][db][ql]?\s+\$(0x$x{1,8}),\s*\%(e|r)sp/o;
+		$dre = qr/^.*[as][du][db][ql]?\s+(%.*),\s*\%(e|r)sp/o;
 	} elsif ($arch eq 'm68k') {
 		#    2b6c:       4e56 fb70       linkw %fp,#-1168
 		#  1df770:       defc ffe4       addaw #-28,%sp
_

Patches currently in -mm which might be from ndesaulniers@google.com are

scripts-checkstackpl-support-llvm-objdump-disassembly-for-x86.patch

