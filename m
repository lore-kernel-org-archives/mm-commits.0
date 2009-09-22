From: akpm@linux-foundation.org
Subject: + build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix-fix.patch added to -mm tree
Date: Tue, 22 Sep 2009 14:59:55 -0700
Message-ID: <200909222222.n8MMMJci012411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752132AbZIVWWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 18:22:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, JBeulich@novell.com, andi@firstfloor.org, catalin.marinas@arm.com, davem@davemloft.net, jbeulich@novell.com, jmorris@namei.org, rusty@rustcorp.com.au, srajiv@linux.vnet.ibm.com, zohar@us.ibm.com


The patch titled
     build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix-fix
has been added to the -mm tree.  Its filename is
     build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Jan Beulich" <JBeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/tpm/tpm.c~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix-fix drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix-fix
+++ a/drivers/char/tpm/tpm.c
@@ -760,7 +760,7 @@ int tpm_pcr_extend(u32 chip_num, int pcr
 		return -ENODEV;
 
 	cmd.header.in = pcrextend_header;
-	BUILD_BUG_ON(be32_to_cpu(cmd.header.in.length) > EXTEND_PCR_SIZE);
+	BUG_ON(be32_to_cpu(cmd.header.in.length) > EXTEND_PCR_SIZE);
 	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
 	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
 	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-kmemcheckh-fix-a-trillion-warnings.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
generic-ipi-make-struct-call_function_data-lockless.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix-fix.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support.patch
sdio-add-mmc_quirk_lenient_fn0.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver.patch
mmc-core-sdio-suspend-resume-support.patch
procfs-provide-stack-information-for-threads-v08.patch
kcore-register-vmemmap-range.patch
rtc-add-driver-for-mxcs-internal-rtc-module.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4.patch
drivers-video-add-kmalloc-null-tests.patch
drivers-video-tmiofbc-fix-uninitialised-return-value.patch
v3-minixfs-add-missing-directory-type-checking.patch

