Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5533E14B097
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 23:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722469863; cv=none; b=e7zyZrrNtbfsHmOKg9Ks8pJ8q+WGYGak+SZfNYEYsAS/gfWYyhKMr9Pp8ntRnZW48VzHR5rySubItFY4upHCjDU86rHPTzBV8CnRU+WsJ5DEzoOIdiNRuLV/bMpUUliQg9iXzPs+jlS7HlfM+nkbHQZECBDX64qJn6hM8dk2ABI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722469863; c=relaxed/simple;
	bh=0Dj2ydsOO6t87/JTUAzoYcCRApWF8xKRchbHNH9J5Zo=;
	h=Date:To:From:Subject:Message-Id; b=ZYQA9lyBms7gMgnNp1Yc3MskiDnfxcoY9VmVcsnLdfQ1aVLksaaiqTNp1am6TKSO2g7E/AA4HAF2TqjZyR5ngM5s4bc7GGCbBnNuA9vGkq6AIt69WqbnhyPT+Cf6hjfeGWRF8ziIZOJ5eJGxis+2uVG1D8YkHZJ5R57dSz3jqok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uixrXseM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uixrXseM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0226C116B1;
	Wed, 31 Jul 2024 23:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722469862;
	bh=0Dj2ydsOO6t87/JTUAzoYcCRApWF8xKRchbHNH9J5Zo=;
	h=Date:To:From:Subject:From;
	b=uixrXseMlLD/GXJQdlNiEyIbHk2G2vLatMZ+MXSTssSX2/g2CrL8QSQJLh1OQYZna
	 YNPuJC2+P5POSjn4wdXfA0MJOCfkTWH4nGf/RB/Y8QxTWJcB09qIv4wLF3S9SrXUOl
	 ndNYWYMOZkm3hibgVvDbV7hyCuDfT/DlGjDdwQFM=
Date: Wed, 31 Jul 2024 16:51:01 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,viresh.kumar@linaro.org,tglx@linutronix.de,rostedt@goodmis.org,rafael@kernel.org,ppaalanen@gmail.com,peterz@infradead.org,npiggin@gmail.com,nouveau@lists.freedesktop.org,naveen@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhiramat@kernel.org,mcoquelin.stm32@gmail.com,luto@kernel.org,longman@redhat.com,linux@armlinux.org.uk,karolherbst@gmail.com,joel@jms.id.au,jk@ozlabs.org,hpa@zytor.com,gregkh@linuxfoundation.org,eajames@linux.ibm.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,boqun.feng@gmail.com,arnd@arndb.de,andrew@codeconstruct.com.au,alistair@popple.id.au,alexandre.torgue@foss.st.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] fsi-add-missing-module_description-macros.patch removed from -mm tree
Message-Id: <20240731235101.E0226C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fsi: add missing MODULE_DESCRIPTION() macros
has been removed from the -mm tree.  Its filename was
     fsi-add-missing-module_description-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: fsi: add missing MODULE_DESCRIPTION() macros
Date: Tue, 30 Jul 2024 07:43:21 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/fsi/fsi-core.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/fsi/fsi-master-hub.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/fsi/fsi-master-aspeed.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/fsi/fsi-master-gpio.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/fsi/fsi-master-ast-cf.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/fsi/fsi-scom.o

Add the missing invocations of the MODULE_DESCRIPTION() macro, and fix the
copy/paste of the module description comment in fsi-master-ast-cf.c.

Link: https://lkml.kernel.org/r/20240730-module_description_orphans-v1-4-7094088076c8@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: Eddie James <eajames@linux.ibm.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Alistar Popple <alistair@popple.id.au>
Cc: Andrew Jeffery <andrew@codeconstruct.com.au>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
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

 drivers/fsi/fsi-core.c          |    1 +
 drivers/fsi/fsi-master-aspeed.c |    1 +
 drivers/fsi/fsi-master-ast-cf.c |    3 ++-
 drivers/fsi/fsi-master-gpio.c   |    1 +
 drivers/fsi/fsi-master-hub.c    |    1 +
 drivers/fsi/fsi-scom.c          |    1 +
 6 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/fsi/fsi-core.c~fsi-add-missing-module_description-macros
+++ a/drivers/fsi/fsi-core.c
@@ -1444,5 +1444,6 @@ static void fsi_exit(void)
 }
 module_exit(fsi_exit);
 module_param(discard_errors, int, 0664);
+MODULE_DESCRIPTION("FSI core driver");
 MODULE_LICENSE("GPL");
 MODULE_PARM_DESC(discard_errors, "Don't invoke error handling on bus accesses");
--- a/drivers/fsi/fsi-master-aspeed.c~fsi-add-missing-module_description-macros
+++ a/drivers/fsi/fsi-master-aspeed.c
@@ -670,4 +670,5 @@ static struct platform_driver fsi_master
 };
 
 module_platform_driver(fsi_master_aspeed_driver);
+MODULE_DESCRIPTION("FSI master driver for AST2600");
 MODULE_LICENSE("GPL");
--- a/drivers/fsi/fsi-master-ast-cf.c~fsi-add-missing-module_description-macros
+++ a/drivers/fsi/fsi-master-ast-cf.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0+
 // Copyright 2018 IBM Corp
 /*
- * A FSI master controller, using a simple GPIO bit-banging interface
+ * A FSI master based on Aspeed ColdFire coprocessor
  */
 
 #include <linux/crc4.h>
@@ -1438,5 +1438,6 @@ static struct platform_driver fsi_master
 };
 
 module_platform_driver(fsi_master_acf);
+MODULE_DESCRIPTION("A FSI master based on Aspeed ColdFire coprocessor");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(FW_FILE_NAME);
--- a/drivers/fsi/fsi-master-gpio.c~fsi-add-missing-module_description-macros
+++ a/drivers/fsi/fsi-master-gpio.c
@@ -892,4 +892,5 @@ static struct platform_driver fsi_master
 };
 
 module_platform_driver(fsi_master_gpio_driver);
+MODULE_DESCRIPTION("A FSI master controller, using a simple GPIO bit-banging interface");
 MODULE_LICENSE("GPL");
--- a/drivers/fsi/fsi-master-hub.c~fsi-add-missing-module_description-macros
+++ a/drivers/fsi/fsi-master-hub.c
@@ -295,4 +295,5 @@ static struct fsi_driver hub_master_driv
 };
 
 module_fsi_driver(hub_master_driver);
+MODULE_DESCRIPTION("FSI hub master driver");
 MODULE_LICENSE("GPL");
--- a/drivers/fsi/fsi-scom.c~fsi-add-missing-module_description-macros
+++ a/drivers/fsi/fsi-scom.c
@@ -625,4 +625,5 @@ static void scom_exit(void)
 
 module_init(scom_init);
 module_exit(scom_exit);
+MODULE_DESCRIPTION("SCOM FSI Client device driver");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

lib-test_objpool-add-missing-module_description-macro.patch
crypto-arm-xor-add-missing-module_description-macro.patch
x86-mm-add-testmmiotrace-module_description.patch
cpufreq-powerpc-add-missing-module_description-macros.patch
locking-ww_mutex-test-add-module_description.patch

