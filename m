Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB5619149E
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 22:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722378316; cv=none; b=FdyIvV+O3HALvvTEu1MynusAS/X82kjyHlCl7jgkJehZ24iQePbT+g876h4QadAy0eA7RvcKJvPrfM6BGCjxKJ94fjjO/knASTzzCdE5rsbkv7OSVYppB0CXEvGbkjcTI8Se9RhI3S0iYUqS2EsyzxS6oU5Bl6ROCks6tHjr2IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722378316; c=relaxed/simple;
	bh=uBUZeQiNOQ+B0d10Mqnd3d8m385KrJCGYsMgxGoodis=;
	h=Date:To:From:Subject:Message-Id; b=XBbXOpLiB9w0lcAF3fROLThL1+uXgYRDHpq0mnVodS2ioJJhVeD3yrJwZacHgkGaH171HhJOcCj0AQiutoUNr9yski5HyTqsaIEYtXdh2iEtp8TuTqjytlwsEBinVB04Se/nnEzlLU/q77DdPmpW5kxuAsktBKBICRXPv39uwWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i/Vr31CA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i/Vr31CA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2723CC32782;
	Tue, 30 Jul 2024 22:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722378316;
	bh=uBUZeQiNOQ+B0d10Mqnd3d8m385KrJCGYsMgxGoodis=;
	h=Date:To:From:Subject:From;
	b=i/Vr31CA5FIWUkbnN6yJUNgX+xlNDQzoQOxPg5gyv9X5itIJRA1zIS+1pNFZakvG2
	 Aan1mgL7v/aksbvlfGgY+tuIFCPUSz658eWClDXXbu5Gvi29iao0vkEHqCEtB/8qX0
	 VnpriTQWINiDoSVDT6bjH09oOtvHJNx25kHznBbQ=
Date: Tue, 30 Jul 2024 15:25:15 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,viresh.kumar@linaro.org,tglx@linutronix.de,rostedt@goodmis.org,rafael@kernel.org,ppaalanen@gmail.com,peterz@infradead.org,npiggin@gmail.com,nouveau@lists.freedesktop.org,naveen@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhiramat@kernel.org,mcoquelin.stm32@gmail.com,luto@kernel.org,longman@redhat.com,linux@armlinux.org.uk,karolherbst@gmail.com,joel@jms.id.au,jk@ozlabs.org,hpa@zytor.com,gregkh@linuxfoundation.org,eajames@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,andrew@codeconstruct.com.au,alistair@popple.id.au,alexandre.torgue@foss.st.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-add-testmmiotrace-module_description.patch added to mm-nonmm-unstable branch
Message-Id: <20240730222516.2723CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: add testmmiotrace MODULE_DESCRIPTION()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-mm-add-testmmiotrace-module_description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-add-testmmiotrace-module_description.patch

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
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: x86/mm: add testmmiotrace MODULE_DESCRIPTION()
Date: Tue, 30 Jul 2024 07:43:19 -0700

Fix the following 'make W=1' warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/mm/testmmiotrace.o

Link: https://lkml.kernel.org/r/20240730-module_description_orphans-v1-2-7094088076c8@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Alistar Popple <alistair@popple.id.au>
Cc: Andrew Jeffery <andrew@codeconstruct.com.au>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Eddie James <eajames@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Karol Herbst <karolherbst@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nouveau <nouveau@lists.freedesktop.org>
Cc: Pekka Paalanen <ppaalanen@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/testmmiotrace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/mm/testmmiotrace.c~x86-mm-add-testmmiotrace-module_description
+++ a/arch/x86/mm/testmmiotrace.c
@@ -144,3 +144,4 @@ static void __exit cleanup(void)
 module_init(init);
 module_exit(cleanup);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Test module for mmiotrace");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

lib-test_objpool-add-missing-module_description-macro.patch
crypto-arm-xor-add-missing-module_description-macro.patch
x86-mm-add-testmmiotrace-module_description.patch
cpufreq-powerpc-add-missing-module_description-macros.patch
fsi-add-missing-module_description-macros.patch
locking-ww_mutex-test-add-module_description.patch

