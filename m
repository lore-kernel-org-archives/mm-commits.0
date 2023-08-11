Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F00EEB64DD
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 17:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236852AbjHKRyi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 13:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235957AbjHKRyb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 13:54:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646492706
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 10:54:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 000BC67898
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 17:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485CAC433C8;
        Fri, 11 Aug 2023 17:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691776470;
        bh=i71HPLwTJhZLI4D5TbbKMpwFS2InEoB8QnqAZbcrpgg=;
        h=Date:To:From:Subject:From;
        b=WXaM5rwj3NX2BtabDrdNLav4dnP/UjA1nymNrvUcXISRWmKvoP3U4x49cLX0MzszZ
         2ax7fCnjVcI5rSOoW9pE1ERRdcEYaKysKC9X3AidLvYWwffRxMkqJJQ69ReFIYbrHo
         1cUmeeERw8SbTVL0hD3YFdIFjVC6Oyemf7ttKLS4=
Date:   Fri, 11 Aug 2023 10:54:29 -0700
To:     mm-commits@vger.kernel.org, zohar@linux.ibm.com,
        vschneid@redhat.com, vgoyal@redhat.com, vbabka@suse.cz,
        tiwai@suse.de, tglx@linutronix.de, sourabhjain@linux.ibm.com,
        seanjc@google.com, rafael@kernel.org, osalvador@suse.de,
        naveen.n.rao@linux.vnet.ibm.com, mingo@redhat.com,
        linux@weissschuh.net, lf32.dev@gmail.com, konrad.wilk@oracle.com,
        hpa@zytor.com, hbathini@linux.ibm.com, gregkh@linuxfoundation.org,
        ebiederm@xmission.com, dyoung@redhat.com, david@redhat.com,
        dave.hansen@linux.intel.com, corbet@lwn.net, bp@alien8.de,
        boris.ostrovsky@oracle.com, bhe@redhat.com, bhelgaas@google.com,
        eric.devolder@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-crash-optimize-cpu-changes.patch added to mm-nonmm-unstable branch
Message-Id: <20230811175430.485CAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/crash: optimize CPU changes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-crash-optimize-cpu-changes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-crash-optimize-cpu-changes.patch

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
Subject: x86/crash: optimize CPU changes
Date: Fri, 11 Aug 2023 13:06:42 -0400

crash_prepare_elf64_headers() writes into the elfcorehdr an ELF PT_NOTE
for all possible CPUs.  As such, subsequent changes to CPUs (ie.  hot
un/plug, online/offline) do not need to rewrite the elfcorehdr.

The kimage->file_mode term covers kdump images loaded via the
kexec_file_load() syscall.  Since crash_prepare_elf64_headers() wrote the
initial elfcorehdr, no update to the elfcorehdr is needed for CPU changes.

The kimage->elfcorehdr_updated term covers kdump images loaded via the
kexec_load() syscall.  At least one memory or CPU change must occur to
cause crash_prepare_elf64_headers() to rewrite the elfcorehdr. 
Afterwards, no update to the elfcorehdr is needed for CPU changes.

This code is intentionally *NOT* hoisted into crash_handle_hotplug_event()
as it would prevent the arch-specific handler from running for CPU
changes.  This would break PPC, for example, which needs to update other
information besides the elfcorehdr, on CPU changes.

Link: https://lkml.kernel.org/r/20230811170642.6696-9-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Acked-by: Hari Bathini <hbathini@linux.ibm.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Akhil Raj <lf32.dev@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/kernel/crash.c~x86-crash-optimize-cpu-changes
+++ a/arch/x86/kernel/crash.c
@@ -468,6 +468,16 @@ void arch_crash_handle_hotplug_event(str
 	unsigned long elfsz = 0;
 
 	/*
+	 * As crash_prepare_elf64_headers() has already described all
+	 * possible CPUs, there is no need to update the elfcorehdr
+	 * for additional CPU changes.
+	 */
+	if ((image->file_mode || image->elfcorehdr_updated) &&
+		((image->hp_action == KEXEC_CRASH_HP_ADD_CPU) ||
+		(image->hp_action == KEXEC_CRASH_HP_REMOVE_CPU)))
+		return;
+
+	/*
 	 * Create the new elfcorehdr reflecting the changes to CPU and/or
 	 * memory resources.
 	 */
_

Patches currently in -mm which might be from eric.devolder@oracle.com are

kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec.patch
x86-kexec-refactor-for-kernel-kconfigkexec.patch
arm-kexec-refactor-for-kernel-kconfigkexec.patch
ia64-kexec-refactor-for-kernel-kconfigkexec.patch
arm64-kexec-refactor-for-kernel-kconfigkexec.patch
loongarch-kexec-refactor-for-kernel-kconfigkexec.patch
m68k-kexec-refactor-for-kernel-kconfigkexec.patch
mips-kexec-refactor-for-kernel-kconfigkexec.patch
parisc-kexec-refactor-for-kernel-kconfigkexec.patch
powerpc-kexec-refactor-for-kernel-kconfigkexec.patch
riscv-kexec-refactor-for-kernel-kconfigkexec.patch
s390-kexec-refactor-for-kernel-kconfigkexec.patch
sh-kexec-refactor-for-kernel-kconfigkexec.patch
kexec-rename-arch_has_kexec_purgatory.patch
remove-arch_default_kexec-from-kconfigkexec.patch
crash-move-a-few-code-bits-to-setup-support-of-crash-hotplug.patch
crash-add-generic-infrastructure-for-crash-hotplug-support.patch
kexec-exclude-elfcorehdr-from-the-segment-digest.patch
crash-memory-and-cpu-hotplug-sysfs-attributes.patch
x86-crash-add-x86-crash-hotplug-support.patch
crash-hotplug-support-for-kexec_load.patch
crash-change-crash_prepare_elf64_headers-to-for_each_possible_cpu.patch
x86-crash-optimize-cpu-changes.patch

