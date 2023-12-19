Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2091F39AEA
	for <mm-commits@vger.kernel.org>; Tue, 19 Dec 2023 20:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aKcbfRTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3A2C433C8;
	Tue, 19 Dec 2023 20:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703019548;
	bh=K5xaA7eWmfy0qC+Pv5SieikVHXNpXRjT2XF4F4qNO2c=;
	h=Date:To:From:Subject:From;
	b=aKcbfRTgDLuRsumQOUWzyooF3GR3dy7AlTeTM+p4sSdniEfC1h1JC5QCpChm03/mU
	 K8ZdD+/2q1kxbehtr54Ob3rOKYzZHR7Ji0DohFNoTOwCrQS1f0LTS/f1ySWjy7mvHp
	 ARszv0d9JGv+bem60h/BwvhW8oTVCc3ejS+R7YgY=
Date: Tue, 19 Dec 2023 12:59:08 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,yangtiezhu@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-checkstackpl-match-all-stack-sizes-for-some-archs.patch added to mm-nonmm-unstable branch
Message-Id: <20231219205908.AF3A2C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/checkstack.pl: match all stack sizes for some archs
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-checkstackpl-match-all-stack-sizes-for-some-archs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-checkstackpl-match-all-stack-sizes-for-some-archs.patch

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
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: scripts/checkstack.pl: match all stack sizes for some archs
Date: Tue, 19 Dec 2023 20:49:59 +0800

For some unknown reason the regular expression for checkstack only matches
three digit numbers starting with the number "3", or any higher number. 
Which means that it skips any stack sizes smaller than 304 bytes.  This
makes the checkstack script a bit less useful than it could be.

Change the script to match any number.  To be filtered out stack sizes can
be configured with the min_stack variable, which omits any stack frame
sizes smaller than 100 bytes by default.

This is similar with commit aab1f809d754 ("scripts/checkstack.pl: match
all stack sizes for s390").

Link: https://lkml.kernel.org/r/20231219125008.23007-4-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/scripts/checkstack.pl~scripts-checkstackpl-match-all-stack-sizes-for-some-archs
+++ a/scripts/checkstack.pl
@@ -74,16 +74,16 @@ my (@stack, $re, $dre, $sub, $x, $xs, $f
 		$re = qr/.*(?:linkw %fp,|addaw )#-([0-9]{1,4})(?:,%sp)?$/o;
 	} elsif ($arch eq 'mips64') {
 		#8800402c:       67bdfff0        daddiu  sp,sp,-16
-		$re = qr/.*daddiu.*sp,sp,-(([0-9]{2}|[3-9])[0-9]{2})/o;
+		$re = qr/.*daddiu.*sp,sp,-([0-9]{1,8})/o;
 	} elsif ($arch eq 'mips') {
 		#88003254:       27bdffe0        addiu   sp,sp,-32
-		$re = qr/.*addiu.*sp,sp,-(([0-9]{2}|[3-9])[0-9]{2})/o;
+		$re = qr/.*addiu.*sp,sp,-([0-9]{1,8})/o;
 	} elsif ($arch eq 'nios2') {
 		#25a8:	defffb04 	addi	sp,sp,-20
-		$re = qr/.*addi.*sp,sp,-(([0-9]{2}|[3-9])[0-9]{2})/o;
+		$re = qr/.*addi.*sp,sp,-([0-9]{1,8})/o;
 	} elsif ($arch eq 'openrisc') {
 		# c000043c:       9c 21 fe f0     l.addi r1,r1,-272
-		$re = qr/.*l\.addi.*r1,r1,-(([0-9]{2}|[3-9])[0-9]{2})/o;
+		$re = qr/.*l\.addi.*r1,r1,-([0-9]{1,8})/o;
 	} elsif ($arch eq 'parisc' || $arch eq 'parisc64') {
 		$re = qr/.*ldo ($x{1,8})\(sp\),sp/o;
 	} elsif ($arch eq 'powerpc' || $arch =~ /^ppc(64)?(le)?$/ ) {
@@ -97,10 +97,10 @@ my (@stack, $re, $dre, $sub, $x, $xs, $f
 		$re = qr/.*(?:lay|ag?hi).*\%r15,-([0-9]+)(?:\(\%r15\))?$/o;
 	} elsif ($arch eq 'sparc' || $arch eq 'sparc64') {
 		# f0019d10:       9d e3 bf 90     save  %sp, -112, %sp
-		$re = qr/.*save.*%sp, -(([0-9]{2}|[3-9])[0-9]{2}), %sp/o;
+		$re = qr/.*save.*%sp, -([0-9]{1,8}), %sp/o;
 	} elsif ($arch =~ /^riscv(64)?$/) {
 		#ffffffff8036e868:	c2010113          	addi	sp,sp,-992
-		$re = qr/.*addi.*sp,sp,-(([0-9]{2}|[3-9])[0-9]{2})/o;
+		$re = qr/.*addi.*sp,sp,-([0-9]{1,8})/o;
 	} elsif ($arch =~ /^loongarch(32|64)?$/) {
 		#9000000000224708:	02ff4063		addi.d  $sp, $sp, -48(0xfd0)
 		$re = qr/.*addi\..*sp, .*sp, -([0-9]{1,8}).*/o;
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

scripts-checkstackpl-remove-ia64-support.patch
scripts-checkstackpl-add-min_stack-to-the-usage-comment.patch
scripts-checkstackpl-match-all-stack-sizes-for-some-archs.patch
scripts-checkstackpl-change-min_stack-to-512-by-default.patch
docs-submit-checklist-remove-all-of-make-namespacecheck.patch

