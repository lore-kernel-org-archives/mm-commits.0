Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6672C6FA82
	for <mm-commits@archiver.kernel.org>; Wed, 21 Sep 2022 20:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiIUUHF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Sep 2022 16:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiIUUG7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2022 16:06:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46985A0632
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 13:06:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D09D9B832B5
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 20:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622FEC433D6;
        Wed, 21 Sep 2022 20:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663790814;
        bh=yAlOXwKDorcXnBEY5FxVY09XeDkpvpaQOTveXyjDDnE=;
        h=Date:To:From:Subject:From;
        b=VubJ4LC4LQ+Vthi6QSwNEjAYaJhov89bKVvL+I4H2eJXW1AZIvfyJ2eaKyneMu6AX
         ehhGcjboDNlNNAEzGUv0LKuAocrOvLr0y4A2czDgQ+aJhA3wD7cavJh20WNNKh6LGv
         eX1cWdmiMOgjQYs4WvT0KfwvUaukniGnn+kAVv7k=
Date:   Wed, 21 Sep 2022 13:06:52 -0700
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com, npiggin@gmail.com,
        mpe@ellerman.id.au, mingo@kernel.org, lukas.bulwahn@gmail.com,
        joe@perches.com, jani.nikula@linux.intel.com, dyoung@redhat.com,
        dwaipayanray1@gmail.com, David.Laight@ACULAB.COM, corbet@lwn.net,
        christophe.leroy@csgroup.eu, bhe@redhat.com, apw@canonical.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-warn-on-usage-of-vm_bug_on-and-other-bug-variants.patch added to mm-nonmm-unstable branch
Message-Id: <20220921200654.622FEC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on usage of VM_BUG_ON() and other BUG variants
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-warn-on-usage-of-vm_bug_on-and-other-bug-variants.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-warn-on-usage-of-vm_bug_on-and-other-bug-variants.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: checkpatch: warn on usage of VM_BUG_ON() and other BUG variants
Date: Tue, 20 Sep 2022 14:23:02 +0200

checkpatch does not point out that VM_BUG_ON() and friends should be
avoided, however, Linus notes:

    VM_BUG_ON() has the exact same semantics as BUG_ON. It is literally
    no different, the only difference is "we can make the code smaller
    because these are less important". [1]

So let's warn on VM_BUG_ON() and other BUG variants as well.  While at it,
make it clearer that the kernel really shouldn't be crashed.

As there are some subsystem BUG macros that actually don't end up crashing
the kernel -- for example, KVM_BUG_ON() -- exclude these manually.

[1] https://lore.kernel.org/r/CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com

Link: https://lkml.kernel.org/r/20220920122302.99195-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Young <dyoung@redhat.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/scripts/checkpatch.pl~checkpatch-warn-on-usage-of-vm_bug_on-and-other-bug-variants
+++ a/scripts/checkpatch.pl
@@ -4745,12 +4745,12 @@ sub process {
 			}
 		}
 
-# avoid BUG() or BUG_ON()
-		if ($line =~ /\b(?:BUG|BUG_ON)\b/) {
+# do not use BUG() or variants
+		if ($line =~ /\b(?!AA_|BUILD_|DCCP_|IDA_|KVM_|RWLOCK_|snd_|SPIN_)(?:[a-zA-Z_]*_)?BUG(?:_ON)?(?:_[A-Z_]+)?\s*\(/) {
 			my $msg_level = \&WARN;
 			$msg_level = \&CHK if ($file);
 			&{$msg_level}("AVOID_BUG",
-				      "Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()\n" . $herecurr);
+				      "Do not crash the kernel unless it is unavoidable - use WARN_ON_ONCE & recovery code (if reasonable) rather than BUG() or variants.\n" . $herecurr);
 		}
 
 # avoid LINUX_VERSION_CODE
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-replace-foll_numa-by-gup_can_follow_protnone.patch
mm-gup-use-gup_can_follow_protnone-also-in-gup-fast.patch
mm-fixup-documentation-regarding-pte_numa-and-prot_numa.patch
coding-stylerst-document-bug-and-warn-rules-do-not-crash-the-kernel.patch
checkpatch-warn-on-usage-of-vm_bug_on-and-other-bug-variants.patch

