Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3AA14D456
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 05:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724478964; cv=none; b=IRf4kv9wnDunVsdKtH0rM1O2728POyQ5maXcU78ecUFncxzybzu8OWLjIwPQuKDgXM5poYCxanlgG3lStVoxcDrlsMmC7OBlDSUyMQWMxTyqcdM6X659bjEuF7pYC05tJnLU5PRHht+U4n5FqLdzaXWVfSNG3cBTc+bPz8sWmPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724478964; c=relaxed/simple;
	bh=Z8Sm3baGe4gE3DERFBIp2+kt2aH+5R0oBX9FlCExqNU=;
	h=Date:To:From:Subject:Message-Id; b=Rxe0dri09+4nf15e4HSIX781IA9d8pbk/0efir/+hjeoj+HJ9h7LHMvuKXuozqPK+HVMapSA5UvZvH6j97pLQngGCwV797CQAIK2fkgzD5uQPDaOz5VDphWliZZo3QFtiMR27gC8hRR2M0tELEioV8NNxMMT/GbtWff91yvAjDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LM4SLO5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LM4SLO5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A78EC32781;
	Sat, 24 Aug 2024 05:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724478963;
	bh=Z8Sm3baGe4gE3DERFBIp2+kt2aH+5R0oBX9FlCExqNU=;
	h=Date:To:From:Subject:From;
	b=LM4SLO5ARjr2BEiSu/HY2LBiRdm1SfFwA3WpOZHe5C7QiGQXQPJyjCU5/QLjvRkaS
	 erTrLRhtucYUhLJ0ayrXkfCoJAgxWOThUri357/hI1eny9ZZAmHi93Cwcw8cPwBV+j
	 g12MQ/PoKpiLXhQUoymkVpQKlsS+80kFa4xh0zhs=
Date: Fri, 23 Aug 2024 22:56:02 -0700
To: mm-commits@vger.kernel.org,thomas.petazzoni@bootlin.com,swboyd@chromium.org,sashal@kernel.org,koct9i@gmail.com,alexis.lothore@bootlin.com,luca.ceresoli@bootlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-decode_stacktracesh-clarify-command-line.patch added to mm-nonmm-unstable branch
Message-Id: <20240824055603.7A78EC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/decode_stacktrace.sh: clarify command line
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-decode_stacktracesh-clarify-command-line.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-decode_stacktracesh-clarify-command-line.patch

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
From: Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: scripts/decode_stacktrace.sh: clarify command line
Date: Fri, 23 Aug 2024 10:27:43 +0200

The syntax as expressed by usage() is not entirely correct: "<modules
path>" cannot be passed without "<base path>|auto".  Additionally human
reading of this syntax can be subject to misunderstanding due the mixture
of '|' and '[]'.

Improve readability in various ways:
 * rewrite using two lines for the two allowed usages
 * add square brackets around "<vmlinux>" as it is optional when using
   debuginfod-find
 * move "<modules path>" to inside the square brackets of the 2nd
   positional parameter
 * use underscores instead of spaces in <...> strings

Link: https://lkml.kernel.org/r/20240823-decode_stacktrace-find_module-improvements-v2-2-d7a57d35558b@bootlin.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Cc: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-clarify-command-line
+++ a/scripts/decode_stacktrace.sh
@@ -5,7 +5,8 @@
 
 usage() {
 	echo "Usage:"
-	echo "	$0 -r <release> | <vmlinux> [<base path>|auto] [<modules path>]"
+	echo "	$0 -r <release>"
+	echo "	$0 [<vmlinux> [<base_path>|auto [<modules_path>]]]"
 }
 
 # Try to find a Rust demangler
_

Patches currently in -mm which might be from luca.ceresoli@bootlin.com are

scripts-decode_stacktracesh-remove-find_module-recursion-and-improve-error-reporting.patch
scripts-decode_stacktracesh-clarify-command-line.patch
scripts-decode_stacktracesh-add-h-flag.patch

