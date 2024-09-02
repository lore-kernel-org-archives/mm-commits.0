Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6FC143C6C
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248798; cv=none; b=HGaP0Uo0vSmG9l0NU6kRt1hcYGuHPoy4eSi9mpPLwHfKM8pmEht3XCDynlxsRkAcpFtPqOlzExJbOUXtC+9vqCU2AsZX4ikO4/rZa++FuMfhr7BNh5+nFdF9MiR8+YIthVTSPB9FBV8NYlAbTjyl8+FvJaiSh9gfLjZFVR7m92I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248798; c=relaxed/simple;
	bh=PNOzmO1QH8Af8OuYWyeizaECkC93PEYootFjLItvj4E=;
	h=Date:To:From:Subject:Message-Id; b=sxEXDuI67XFHwepfztQNIST3oX/AmOVDhXNKdfStTh+EkINf/yUU9Fwt/o4YPIaguXV/Ftjur2O4JHivkUfoA34ka4o/cIgIxMXHH61wB3gbqD4cqeIQIaxV0oD8/RI5vqac945cqsQmv6dAirQN33Ur2t4odkla152jmDy6fyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tqSBgUSp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tqSBgUSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA091C4CEC2;
	Mon,  2 Sep 2024 03:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248798;
	bh=PNOzmO1QH8Af8OuYWyeizaECkC93PEYootFjLItvj4E=;
	h=Date:To:From:Subject:From;
	b=tqSBgUSpt0NC+zzrqbvmbmFZcHKg5elzI+j4EJsNL8UX7eB7+FSLaBQidAPxh7yUK
	 Xey+x6tBbKaVZeZrtgYNjQ9l6dQN+3AB5k7YHvbqMVthXqTKFfejBXy+szZOfSIJJp
	 h9nwu/UkciG4o7pGBSEF8clQ/E0pOOhaJC0ODBTU=
Date: Sun, 01 Sep 2024 20:46:38 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,viresh.kumar@linaro.org,tglx@linutronix.de,rostedt@goodmis.org,rafael@kernel.org,ppaalanen@gmail.com,peterz@infradead.org,npiggin@gmail.com,nouveau@lists.freedesktop.org,naveen@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhiramat@kernel.org,mcoquelin.stm32@gmail.com,luto@kernel.org,longman@redhat.com,linux@armlinux.org.uk,karolherbst@gmail.com,joel@jms.id.au,jk@ozlabs.org,hpa@zytor.com,gregkh@linuxfoundation.org,eajames@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,andrew@codeconstruct.com.au,alistair@popple.id.au,alexandre.torgue@foss.st.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] x86-mm-add-testmmiotrace-module_description.patch removed from -mm tree
Message-Id: <20240902034638.AA091C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm: add testmmiotrace MODULE_DESCRIPTION()
has been removed from the -mm tree.  Its filename was
     x86-mm-add-testmmiotrace-module_description.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


