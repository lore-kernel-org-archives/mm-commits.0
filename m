Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4989BEE49B4
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240451AbjHXX0H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238067AbjHXXZt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:25:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E868A1
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8FD562F9A
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E163C433C7;
        Thu, 24 Aug 2023 23:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919546;
        bh=60vjB+39N+sY7hwLD/oyTV8HyxFTrc+UzBw70T1Ac4A=;
        h=Date:To:From:Subject:From;
        b=MdwqvFHmtJw6QGD5Qv0iF2oITCnlVFLoyBtI19uufOqIINQY/RoCiziTQt4KzR2zc
         jd6rlp1jWOLLXu5geXHnspBZo9DxwR0LagmKKUYWmGbjXhhmF2FbCMRZjKR0vgdQEJ
         SPk47dCOKGIv8ow1kp4zKk1GqpR2jNuty+wTwhsA=
Date:   Thu, 24 Aug 2023 16:25:45 -0700
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
Subject: [merged mm-nonmm-stable] x86-crash-optimize-cpu-changes.patch removed from -mm tree
Message-Id: <20230824232546.3E163C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86/crash: optimize CPU changes
has been removed from the -mm tree.  Its filename was
     x86-crash-optimize-cpu-changes.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric DeVolder <eric.devolder@oracle.com>
Subject: x86/crash: optimize CPU changes
Date: Mon, 14 Aug 2023 17:44:46 -0400

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

Link: https://lkml.kernel.org/r/20230814214446.6659-9-eric.devolder@oracle.com
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
@@ -470,6 +470,16 @@ void arch_crash_handle_hotplug_event(str
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


