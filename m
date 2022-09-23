Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5307CC07E9D
	for <mm-commits@archiver.kernel.org>; Fri, 23 Sep 2022 23:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbiIWXCr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Sep 2022 19:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIWXCp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Sep 2022 19:02:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0684C1288B8
        for <mm-commits@vger.kernel.org>; Fri, 23 Sep 2022 16:02:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97AAF61CE8
        for <mm-commits@vger.kernel.org>; Fri, 23 Sep 2022 23:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA69C433C1;
        Fri, 23 Sep 2022 23:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663974163;
        bh=400XN+5rldSSBnWjzX6lwjoYZmFMxpaZZV/4h/0u8Ec=;
        h=Date:To:From:Subject:From;
        b=JS9FJbMAiC5NA1gtb0jrcwSVdub9vuOlhYadnURUFbVvNrMugGYe7HgyjHc4nc1tl
         Lo5ume8G43GOTKehWm5uRRipcQ7Tu9lQkjt3MRLVNSG1hOLfxJpmuBH5YTQdlrUShc
         0e2Uc7CSw2K9cJTBHXiZzYHurWhU8mqN5KJhYWho=
Date:   Fri, 23 Sep 2022 16:02:41 -0700
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com, npiggin@gmail.com,
        mpe@ellerman.id.au, mingo@kernel.org, lukas.bulwahn@gmail.com,
        joe@perches.com, jani.nikula@linux.intel.com, dyoung@redhat.com,
        dwaipayanray1@gmail.com, David.Laight@ACULAB.COM, corbet@lwn.net,
        christophe.leroy@csgroup.eu, bhe@redhat.com, apw@canonical.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] checkpatch-warn-on-usage-of-vm_bug_on-and-other-bug-variants.patch removed from -mm tree
Message-Id: <20220923230242.CFA69C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: warn on usage of VM_BUG_ON() and other BUG variants
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-on-usage-of-vm_bug_on-and-other-bug-variants.patch

This patch was dropped because an updated version will be merged

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

