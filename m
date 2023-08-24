Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA28C88CB9
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236351AbjHXX0D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237807AbjHXXZk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:25:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B878EA1
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:25:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EA6162F03
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC3DC433C7;
        Thu, 24 Aug 2023 23:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919537;
        bh=PXOhsOyLU7pH+7AAGOtmooDW6ekVbf2q1YDFm7McBo4=;
        h=Date:To:From:Subject:From;
        b=JGEpl3lZgi37pvspb2yPS3iZMRDYx+UkyD/zsT0dsQWj/hjR5UdG9ePb7GJp+6bff
         pr/gQc43QAap4+1lh9zlDfU6COTJG7CoAAgANjb9PiqpexSXv+XkpTl6pFMtlbcPCB
         c3QvZbWEntdFGTDZB53Ev7C7ttLRAZgnlmrgD+Zg=
Date:   Thu, 24 Aug 2023 16:25:37 -0700
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
Subject: [merged mm-nonmm-stable] kexec-exclude-elfcorehdr-from-the-segment-digest.patch removed from -mm tree
Message-Id: <20230824232537.9EC3DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec: exclude elfcorehdr from the segment digest
has been removed from the -mm tree.  Its filename was
     kexec-exclude-elfcorehdr-from-the-segment-digest.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric DeVolder <eric.devolder@oracle.com>
Subject: kexec: exclude elfcorehdr from the segment digest
Date: Mon, 14 Aug 2023 17:44:41 -0400

When a crash kernel is loaded via the kexec_file_load() syscall, the
kernel places the various segments (ie crash kernel, crash initrd,
boot_params, elfcorehdr, purgatory, etc) in memory.  For those
architectures that utilize purgatory, a hash digest of the segments is
calculated for integrity checking.  The digest is embedded into the
purgatory image prior to placing in memory.

Updates to the elfcorehdr in response to CPU and memory changes would
cause the purgatory integrity checking to fail (at crash time, and no
vmcore created).  Therefore, the elfcorehdr segment is explicitly excluded
from the purgatory digest, enabling updates to the elfcorehdr while also
avoiding the need to recompute the hash digest and reload purgatory.

Link: https://lkml.kernel.org/r/20230814214446.6659-4-eric.devolder@oracle.com
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Suggested-by: Baoquan He <bhe@redhat.com>
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

 kernel/kexec_file.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/kexec_file.c~kexec-exclude-elfcorehdr-from-the-segment-digest
+++ a/kernel/kexec_file.c
@@ -726,6 +726,12 @@ static int kexec_calculate_store_digests
 	for (j = i = 0; i < image->nr_segments; i++) {
 		struct kexec_segment *ksegment;
 
+#ifdef CONFIG_CRASH_HOTPLUG
+		/* Exclude elfcorehdr segment to allow future changes via hotplug */
+		if (j == image->elfcorehdr_index)
+			continue;
+#endif
+
 		ksegment = &image->segment[i];
 		/*
 		 * Skip purgatory as it will be modified once we put digest
_

Patches currently in -mm which might be from eric.devolder@oracle.com are


