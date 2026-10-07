Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD6D3546FC
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338686; cv=none; b=j/9UXyS6Bc9ILCkGPC2mUNmZugPOIBcoUnFxHu6Oe8P5g8UOW+62O3K10N3wKrZtmJbVRl0TcPRufMjNVjkqmHnCk84RTAJgGh0aPArz/CjO+RVL5SkLFGFllndbF3U8HbZFGucXKOsMR891iY7Oo94aUh85dg8stAzYg6DNXaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338686; c=relaxed/simple;
	bh=IXSTOgK3vm694ICjiy9rSK7CXia2MdcJREOQPxrDeuk=;
	h=Date:To:From:Subject:Message-Id; b=ajtRYC5qhBi6c3nUhrNXwu+/t3mqdUiJrqLsBXYvBisBUezkjgz9lUdBjlSY6UjQpsMTc38/WsbFV3A6ne03KoX9f1SJZ7uv85v++h6QEH4hlsfS50/GEdRc+pwR5FeL0JuLa0KL7jlg6pU1iU38eq0vU3YCXzAnYBrYtVLhpCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LtGaEl+f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LtGaEl+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3E71F0089B;
	Wed,  7 Oct 2026 02:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338684;
	bh=f86eTnY7gQKLIQ/owpk6kp3kiOBCxFCiuKpIefaKRpM=;
	h=Date:To:From:Subject;
	b=LtGaEl+flMUwJwZr2oPW7XCx3Tav97uFqdNordgyuP27yiCDSs8PkifHTzod7Dpx4
	 n8bGBo7o1mYXKaqACyLUCZ77YRxwB/tiZrc3bFZ/6UTIQUdE7jAF5gcUJYUAdxvgr3
	 xXd3usC7PWa596CBqadLd4eQKLzbG3o4LvnpQ+D0=
Date: Tue, 06 Oct 2026 19:04:44 -0700
To: mm-commits@vger.kernel.org,nathan@kernel.org,morbo@google.com,justinstitt@google.com,ndesaulniers@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-checkstackpl-support-llvm-objdump-disassembly-for-x86.patch removed from -mm tree
Message-Id: <20261007020444.8D3E71F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/checkstack.pl: support llvm-objdump disassembly for x86
has been removed from the -mm tree.  Its filename was
     scripts-checkstackpl-support-llvm-objdump-disassembly-for-x86.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM Gemini
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
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


