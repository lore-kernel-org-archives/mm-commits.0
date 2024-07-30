Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D993B1917D3
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 22:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722378318; cv=none; b=EEkLR5koZB/hF+hIELMuUHCT/mPDEahMjeQSpwXrG1x5tYNQuu3NyR45SGN96jAz1y65dJUgfx4zQkgFIPT8HSM1c2rZIW2LWV9nmdHfqo9jIPLaJvpgE7TcXzBfPB75IE7swJXZX+HCpHD8547gno6SR/e8RiGxcNDLSlJcPGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722378318; c=relaxed/simple;
	bh=9iTUqsAHi8/Ts9XqYULxjqGMqXRdgfCRAZda/dpn9dY=;
	h=Date:To:From:Subject:Message-Id; b=Gv3hS3kDpp+FsomtUolWXYwCOxgMT5xeD1uiS76aPUhO8gmJmv++9R35VX+3+vSxz4ZAwBL9UFcuKZ363xYS7/5fQJ0ewjDyPgCE86abmpca5eGa3o3c4auOBDwnUrn3f+PVi/UAJ2jsGJOpA6Qk4i5ZzRIqVdlr0uqu8UFJDvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gn2Iq3ui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gn2Iq3ui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF2EC32782;
	Tue, 30 Jul 2024 22:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722378318;
	bh=9iTUqsAHi8/Ts9XqYULxjqGMqXRdgfCRAZda/dpn9dY=;
	h=Date:To:From:Subject:From;
	b=gn2Iq3uiTXN3yWjZ2pY07Rk+UmfkGqaNCplJklw9f2ozzq1HcvM5vCniLlsf/JEsX
	 UJ0fu2uC/iL3Ag/1mhhqN4XIRDjwewGTFZqY+mksoIYC/goODG9ZxSFUe8ORfRpq7c
	 k2iHqGk1XggeS8d6yCXswXWdUhkagHFWL3QG9T7M=
Date: Tue, 30 Jul 2024 15:25:17 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,viresh.kumar@linaro.org,tglx@linutronix.de,rostedt@goodmis.org,rafael@kernel.org,ppaalanen@gmail.com,peterz@infradead.org,npiggin@gmail.com,nouveau@lists.freedesktop.org,naveen@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhiramat@kernel.org,mcoquelin.stm32@gmail.com,luto@kernel.org,longman@redhat.com,linux@armlinux.org.uk,karolherbst@gmail.com,joel@jms.id.au,jk@ozlabs.org,hpa@zytor.com,gregkh@linuxfoundation.org,eajames@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,andrew@codeconstruct.com.au,alistair@popple.id.au,alexandre.torgue@foss.st.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cpufreq-powerpc-add-missing-module_description-macros.patch added to mm-nonmm-unstable branch
Message-Id: <20240730222518.5FF2EC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cpufreq: powerpc: add missing MODULE_DESCRIPTION() macros
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     cpufreq-powerpc-add-missing-module_description-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cpufreq-powerpc-add-missing-module_description-macros.patch

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
Subject: cpufreq: powerpc: add missing MODULE_DESCRIPTION() macros
Date: Tue, 30 Jul 2024 07:43:20 -0700

With ARCH=powerpc, make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/cpufreq/ppc-cbe-cpufreq.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/cpufreq/powernv-cpufreq.o

Add the missing invocation of the MODULE_DESCRIPTION() macro to all files
which have a MODULE_LICENSE().

This includes three additional files which, although they did not produce
a warning with the powerpc allmodconfig configuration, may cause this
warning with specific options enabled in the kernel configuration.

Link: https://lkml.kernel.org/r/20240730-module_description_orphans-v1-3-7094088076c8@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
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
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nouveau <nouveau@lists.freedesktop.org>
Cc: Pekka Paalanen <ppaalanen@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/maple-cpufreq.c   |    1 +
 drivers/cpufreq/pasemi-cpufreq.c  |    1 +
 drivers/cpufreq/pmac64-cpufreq.c  |    1 +
 drivers/cpufreq/powernv-cpufreq.c |    1 +
 drivers/cpufreq/ppc_cbe_cpufreq.c |    1 +
 5 files changed, 5 insertions(+)

--- a/drivers/cpufreq/maple-cpufreq.c~cpufreq-powerpc-add-missing-module_description-macros
+++ a/drivers/cpufreq/maple-cpufreq.c
@@ -238,4 +238,5 @@ bail_noprops:
 module_init(maple_cpufreq_init);
 
 
+MODULE_DESCRIPTION("cpufreq driver for Maple 970FX/970MP boards");
 MODULE_LICENSE("GPL");
--- a/drivers/cpufreq/pasemi-cpufreq.c~cpufreq-powerpc-add-missing-module_description-macros
+++ a/drivers/cpufreq/pasemi-cpufreq.c
@@ -269,5 +269,6 @@ static void __exit pas_cpufreq_exit(void
 module_init(pas_cpufreq_init);
 module_exit(pas_cpufreq_exit);
 
+MODULE_DESCRIPTION("cpufreq driver for PA Semi PWRficient");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Egor Martovetsky <egor@pasemi.com>, Olof Johansson <olof@lixom.net>");
--- a/drivers/cpufreq/pmac64-cpufreq.c~cpufreq-powerpc-add-missing-module_description-macros
+++ a/drivers/cpufreq/pmac64-cpufreq.c
@@ -671,4 +671,5 @@ static int __init g5_cpufreq_init(void)
 module_init(g5_cpufreq_init);
 
 
+MODULE_DESCRIPTION("cpufreq driver for SMU & 970FX based G5 Macs");
 MODULE_LICENSE("GPL");
--- a/drivers/cpufreq/powernv-cpufreq.c~cpufreq-powerpc-add-missing-module_description-macros
+++ a/drivers/cpufreq/powernv-cpufreq.c
@@ -1160,5 +1160,6 @@ static void __exit powernv_cpufreq_exit(
 }
 module_exit(powernv_cpufreq_exit);
 
+MODULE_DESCRIPTION("cpufreq driver for IBM/OpenPOWER powernv systems");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Vaidyanathan Srinivasan <svaidy at linux.vnet.ibm.com>");
--- a/drivers/cpufreq/ppc_cbe_cpufreq.c~cpufreq-powerpc-add-missing-module_description-macros
+++ a/drivers/cpufreq/ppc_cbe_cpufreq.c
@@ -168,5 +168,6 @@ static void __exit cbe_cpufreq_exit(void
 module_init(cbe_cpufreq_init);
 module_exit(cbe_cpufreq_exit);
 
+MODULE_DESCRIPTION("cpufreq driver for Cell BE processors");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Christian Krafft <krafft@de.ibm.com>");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

lib-test_objpool-add-missing-module_description-macro.patch
crypto-arm-xor-add-missing-module_description-macro.patch
x86-mm-add-testmmiotrace-module_description.patch
cpufreq-powerpc-add-missing-module_description-macros.patch
fsi-add-missing-module_description-macros.patch
locking-ww_mutex-test-add-module_description.patch

