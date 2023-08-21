Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79F95EE4993
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 19:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjHUTBE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 15:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjHUTBE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 15:01:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBA1E7E
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 12:00:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49CDA614A5
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 19:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F5BC433C7;
        Mon, 21 Aug 2023 19:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692644431;
        bh=YVZr+3QWdn+6bGQp5X7U+taxrpD7Mi0w4mbixbs1gR4=;
        h=Date:To:From:Subject:From;
        b=FA0hECYFDRR/p1wd3qDO/Qkv2pmRRoDPMch2fWtqGNs5yDvwRxT1wflPO4K4sajnc
         QZMqPF5kWPkML5jj+5rBS5JwrABXiwoeJniyMmxFcr8j8G2nkVXGGf0SKsfDYwl7Id
         XvHySZ/A2Y5rU0ZsVv5Vdx9umKqq3QgTLxK8zyGU=
Date:   Mon, 21 Aug 2023 12:00:30 -0700
To:     mm-commits@vger.kernel.org, paulmck@kernel.org, bhe@redhat.com,
        eric.devolder@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-crash-add-x86-crash-hotplug-support-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230821190031.95F5BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/crash: correct unused function build error
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-crash-add-x86-crash-hotplug-support-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-crash-add-x86-crash-hotplug-support-fix.patch

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
From: Eric DeVolder <eric.devolder@oracle.com>
Subject: x86/crash: correct unused function build error
Date: Mon, 21 Aug 2023 14:26:44 -0400

In certain config scenarios, an unused-function build error occurs
relating to prepare_elf_headers(). Correct the ifdef guarding these
functions to eliminate the build error.

Link: https://lkml.kernel.org/r/20230821182644.2143-1-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Suggested-by: Baoquan He <bhe@redhat.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/crash.c~x86-crash-add-x86-crash-hotplug-support-fix
+++ a/arch/x86/kernel/crash.c
@@ -158,7 +158,7 @@ void native_machine_crash_shutdown(struc
 	crash_save_cpu(regs, safe_smp_processor_id());
 }
 
-#if defined(CONFIG_KEXEC_FILE) || defined(CONFIG_CRASH_DUMP)
+#if defined(CONFIG_KEXEC_FILE) || defined(CONFIG_CRASH_HOTPLUG)
 static int get_nr_ram_ranges_callback(struct resource *res, void *arg)
 {
 	unsigned int *nr_ranges = arg;
_

Patches currently in -mm which might be from eric.devolder@oracle.com are

crash-move-a-few-code-bits-to-setup-support-of-crash-hotplug.patch
crash-add-generic-infrastructure-for-crash-hotplug-support.patch
kexec-exclude-elfcorehdr-from-the-segment-digest.patch
crash-memory-and-cpu-hotplug-sysfs-attributes.patch
x86-crash-add-x86-crash-hotplug-support.patch
x86-crash-add-x86-crash-hotplug-support-fix.patch
crash-hotplug-support-for-kexec_load.patch
crash-change-crash_prepare_elf64_headers-to-for_each_possible_cpu.patch
x86-crash-optimize-cpu-changes.patch

