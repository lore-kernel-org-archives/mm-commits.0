Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD31C7EE29
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 21:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbjFAVt1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 17:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233118AbjFAVtF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 17:49:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B2DE61
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 14:48:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE82664A2B
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 21:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E5DC433D2;
        Thu,  1 Jun 2023 21:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685656128;
        bh=hGz50dTB1MD8/f7P3SBtLljMSu4sDVuqIlm3hroJnKQ=;
        h=Date:To:From:Subject:From;
        b=l2xqwdb3CeUlVfLO7WvTNCcC2IgTbQ11S/lkR60B98wZCqNYkiK0Sesyf73A6Vb8e
         xW6o3K2zETW8OMJHjxwMvi/jaKD2TUySFaYok2kuJwdwpjsf/ZS33pNrExMgJBqzPU
         0+re6OdoQ4IMZz8KjxKb20sFbK5NSv4n6i+DQJ4Q=
Date:   Thu, 01 Jun 2023 14:48:47 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        tim.gardner@canonical.com, thomas.lendacky@amd.com,
        tglx@linutronix.de, seanjc@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, rppt@linux.ibm.com,
        rientjes@google.com, peterz@infradead.org, peterx@redhat.com,
        pbonzini@redhat.com, mingo@redhat.com, mgorman@techsingularity.net,
        marcelo.cerri@canonical.com, luto@kernel.org,
        liam.merwick@oracle.com, jroedel@suse.de, dfaggioli@suse.com,
        david@redhat.com, dave.hansen@linux.intel.com,
        dave.hansen@intel.com, bp@suse.de, bp@alien8.de, ardb@kernel.org,
        ak@linux.intel.com, aarcange@redhat.com,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + efi-unaccepted-avoid-load_unaligned_zeropad-stepping-into-unaccepted-memory.patch added to mm-unstable branch
Message-Id: <20230601214848.48E5DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: efi/unaccepted: avoid load_unaligned_zeropad() stepping into unaccepted memory
has been added to the -mm mm-unstable branch.  Its filename is
     efi-unaccepted-avoid-load_unaligned_zeropad-stepping-into-unaccepted-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/efi-unaccepted-avoid-load_unaligned_zeropad-stepping-into-unaccepted-memory.patch

This patch will later appear in the mm-unstable branch at
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
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: efi/unaccepted: avoid load_unaligned_zeropad() stepping into unaccepted memory
Date: Thu, 1 Jun 2023 21:25:40 +0300

load_unaligned_zeropad() can lead to unwanted loads across page
boundaries.  The unwanted loads are typically harmless.  But, they might
be made to totally unrelated or even unmapped memory. 
load_unaligned_zeropad() relies on exception fixup (#PF, #GP and now #VE)
to recover from these unwanted loads.

But, this approach does not work for unaccepted memory.  For TDX, a load
from unaccepted memory will not lead to a recoverable exception within the
guest.  The guest will exit to the VMM where the only recourse is to
terminate the guest.

There are two parts to fix this issue and comprehensively avoid access to
unaccepted memory.  Together these ensure that an extra "guard" page is
accepted in addition to the memory that needs to be used.

1. Implicitly extend the range_contains_unaccepted_memory(start, end)
   checks up to end+unit_size if 'end' is aligned on a unit_size
   boundary.
2. Implicitly extend accept_memory(start, end) to end+unit_size if 'end'
   is aligned on a unit_size boundary.

Side note: This leads to something strange. Pages which were accepted
	   at boot, marked by the firmware as accepted and will never
	   _need_ to be accepted might be on unaccepted_pages list
	   This is a cue to ensure that the next page is accepted
	   before 'page' can be used.

This is an actual, real-world problem which was discovered during TDX
testing.

Link: https://lkml.kernel.org/r/20230601182543.19036-7-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Dario Faggioli <dfaggioli@suse.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: Liam Merwick <liam.merwick@oracle.com>
Cc: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Gardner <tim.gardner@canonical.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/efi/unaccepted_memory.c |   35 +++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/drivers/firmware/efi/unaccepted_memory.c~efi-unaccepted-avoid-load_unaligned_zeropad-stepping-into-unaccepted-memory
+++ a/drivers/firmware/efi/unaccepted_memory.c
@@ -37,6 +37,34 @@ void accept_memory(phys_addr_t start, ph
 	start -= unaccepted->phys_base;
 	end -= unaccepted->phys_base;
 
+	/*
+	 * load_unaligned_zeropad() can lead to unwanted loads across page
+	 * boundaries. The unwanted loads are typically harmless. But, they
+	 * might be made to totally unrelated or even unmapped memory.
+	 * load_unaligned_zeropad() relies on exception fixup (#PF, #GP and now
+	 * #VE) to recover from these unwanted loads.
+	 *
+	 * But, this approach does not work for unaccepted memory. For TDX, a
+	 * load from unaccepted memory will not lead to a recoverable exception
+	 * within the guest. The guest will exit to the VMM where the only
+	 * recourse is to terminate the guest.
+	 *
+	 * There are two parts to fix this issue and comprehensively avoid
+	 * access to unaccepted memory. Together these ensure that an extra
+	 * "guard" page is accepted in addition to the memory that needs to be
+	 * used:
+	 *
+	 * 1. Implicitly extend the range_contains_unaccepted_memory(start, end)
+	 *    checks up to end+unit_size if 'end' is aligned on a unit_size
+	 *    boundary.
+	 *
+	 * 2. Implicitly extend accept_memory(start, end) to end+unit_size if
+	 *    'end' is aligned on a unit_size boundary. (immediately following
+	 *    this comment)
+	 */
+	if (!(end % unit_size))
+		end += unit_size;
+
 	/* Make sure not to overrun the bitmap */
 	if (end > unaccepted->size * unit_size * BITS_PER_BYTE)
 		end = unaccepted->size * unit_size * BITS_PER_BYTE;
@@ -84,6 +112,13 @@ bool range_contains_unaccepted_memory(ph
 	start -= unaccepted->phys_base;
 	end -= unaccepted->phys_base;
 
+	/*
+	 * Also consider the unaccepted state of the *next* page. See fix #1 in
+	 * the comment on load_unaligned_zeropad() in accept_memory().
+	 */
+	if (!(end % unit_size))
+		end += unit_size;
+
 	/* Make sure not to overrun the bitmap */
 	if (end > unaccepted->size * unit_size * BITS_PER_BYTE)
 		end = unaccepted->size * unit_size * BITS_PER_BYTE;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-add-support-for-unaccepted-memory.patch
efi-x86-get-full-memory-map-in-allocate_e820.patch
efi-libstub-implement-support-for-unaccepted-memory.patch
x86-boot-compressed-handle-unaccepted-memory.patch
efi-add-unaccepted-memory-support.patch
efi-unaccepted-avoid-load_unaligned_zeropad-stepping-into-unaccepted-memory.patch
x86-tdx-make-_tdx_hypercall-and-__tdx_module_call-available-in-boot-stub.patch
x86-tdx-refactor-try_accept_one.patch
x86-tdx-add-unaccepted-memory-support.patch

