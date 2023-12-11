Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F247493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2NbXYxyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EDCC433C8;
	Mon, 11 Dec 2023 01:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257811;
	bh=/X8um1BwWD/Tc64zdfGixUNCX9jTP/0aFA337a9+iIk=;
	h=Date:To:From:Subject:From;
	b=2NbXYxyLsv2lNPFi2RsyDdbD52VjewK2beRx2RLPVm47t7eN2vXbZjbRxrSC0Nt54
	 vekd9mh9NOeU+IS+hRDmTT3W2FvUzbvjs1KcbUKKLDLAqUvk1tfjjptJ09F1UZuSOW
	 TJHNbRcrKV5qoGfKVMSMEYr2emeH7GPXYm/j7Cb0=
Date: Sun, 10 Dec 2023 17:23:30 -0800
To: mm-commits@vger.kernel.org,svens@linux.ibm.com,sth@linux.ibm.com,hoeppner@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,borntraeger@linux.ibm.com,arnd@arndb.de,agordeev@linux.ibm.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] s390-traps-only-define-is_valid_bugaddr-under-config_generic_bug.patch removed from -mm tree
Message-Id: <20231211012331.71EDCC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/traps: only define is_valid_bugaddr() under CONFIG_GENERIC_BUG
has been removed from the -mm tree.  Its filename was
     s390-traps-only-define-is_valid_bugaddr-under-config_generic_bug.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: s390/traps: only define is_valid_bugaddr() under CONFIG_GENERIC_BUG
Date: Thu, 30 Nov 2023 17:22:33 -0700

When building with -Wmissing-prototypes without CONFIG_GENERIC_BUG, there
is a warning about a missing prototype for is_valid_bugaddr():

  arch/s390/kernel/traps.c:46:5: warning: no previous prototype for 'is_valid_bugaddr' [-Wmissing-prototypes]
     46 | int is_valid_bugaddr(unsigned long addr)
        |     ^~~~~~~~~~~~~~~~

The prototype is only declared with CONFIG_GENERIC_BUG, so only define the
function under the same condition to clear up the warning, which matches
other architectures.

Link: https://lkml.kernel.org/r/20231130-s390-missing-prototypes-v1-2-799d3cf07fb7@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jan Höppner <hoeppner@linux.ibm.com>
Cc: Stefan Haberland <sth@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/traps.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/s390/kernel/traps.c~s390-traps-only-define-is_valid_bugaddr-under-config_generic_bug
+++ a/arch/s390/kernel/traps.c
@@ -43,10 +43,12 @@ static inline void __user *get_trap_ip(s
 	return (void __user *) (address - (regs->int_code >> 16));
 }
 
+#ifdef CONFIG_GENERIC_BUG
 int is_valid_bugaddr(unsigned long addr)
 {
 	return 1;
 }
+#endif
 
 void do_report_trap(struct pt_regs *regs, int si_signo, int si_code, char *str)
 {
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

