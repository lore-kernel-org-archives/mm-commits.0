Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB0B3C07E9D
	for <mm-commits@archiver.kernel.org>; Fri, 23 Sep 2022 23:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbiIWXCo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Sep 2022 19:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIWXCn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Sep 2022 19:02:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D69128A22
        for <mm-commits@vger.kernel.org>; Fri, 23 Sep 2022 16:02:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84A3B61CE8
        for <mm-commits@vger.kernel.org>; Fri, 23 Sep 2022 23:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A633FC433C1;
        Fri, 23 Sep 2022 23:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663974161;
        bh=HZY9IBKYnlYGqpe1EtnMsuCj5J8tHQ7n1LBae9biGtU=;
        h=Date:To:From:Subject:From;
        b=HNXDY15JBGCSG9L+oVsBSbB6sasx9fAEXxc8xEneKNI3xiuF5gxExw2M6dczytPIJ
         trDU/cOQCziJsrKy9GG6xkbESsaygqwDnNBpP/iCE43S/XBRO1S1Mfdzc74nRd/lOa
         /HLeVQLDaZ756Oko47JyX3CTDxJVQwo6UchTBbUA=
Date:   Fri, 23 Sep 2022 16:02:39 -0700
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com, npiggin@gmail.com,
        mpe@ellerman.id.au, mingo@kernel.org, lukas.bulwahn@gmail.com,
        joe@perches.com, jani.nikula@linux.intel.com, dyoung@redhat.com,
        dwaipayanray1@gmail.com, David.Laight@ACULAB.COM, corbet@lwn.net,
        christophe.leroy@csgroup.eu, bhe@redhat.com, apw@canonical.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] coding-stylerst-document-bug-and-warn-rules-do-not-crash-the-kernel.patch removed from -mm tree
Message-Id: <20220923230240.A633FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: coding-style.rst: document BUG() and WARN() rules ("do not crash the kernel")
has been removed from the -mm tree.  Its filename was
     coding-stylerst-document-bug-and-warn-rules-do-not-crash-the-kernel.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: coding-style.rst: document BUG() and WARN() rules ("do not crash the kernel")
Date: Tue, 20 Sep 2022 14:23:00 +0200

Linus notes [1] that the introduction of new code that uses VM_BUG_ON()
is just as bad as BUG_ON(), because it will crash the kernel on
distributions that enable CONFIG_DEBUG_VM (like Fedora):

    VM_BUG_ON() has the exact same semantics as BUG_ON. It is literally
    no different, the only difference is "we can make the code smaller
    because these are less important". [2]

This resulted in a more generic discussion about usage of BUG() and
friends. While there might be corner cases that still deserve a BUG_ON(),
most BUG_ON() cases should simply use WARN_ON_ONCE() and implement a
recovery path if reasonable:

    The only possible case where BUG_ON can validly be used is "I have
    some fundamental data corruption and cannot possibly return an
    error". [2]

As a very good approximation is the general rule:

    "absolutely no new BUG_ON() calls _ever_" [2]

... not even if something really shouldn't ever happen and is merely for
documenting that an invariant always has to hold. However, there are sill
exceptions where BUG_ON() may be used:

    If you have a "this is major internal corruption, there's no way we can
    continue", then BUG_ON() is appropriate. [3]

There is only one good BUG_ON():

    Now, that said, there is one very valid sub-form of BUG_ON():
    BUILD_BUG_ON() is absolutely 100% fine. [2]

While WARN will also crash the machine with panic_on_warn set, that's
exactly to be expected:

    So we have two very different cases: the "virtual machine with good
    logging where a dead machine is fine" - use 'panic_on_warn'. And
    the actual real hardware with real drivers, running real loads by
    users. [4]

The basic idea is that warnings will similarly get reported by users
and be found during testing. However, in contrast to a BUG(), there is a
way to actually influence the expected behavior (e.g., panic_on_warn)
and to eventually keep the machine alive to extract some debug info.

Ingo notes that not all WARN_ON_ONCE cases need recovery. If we don't ever
expect this code to trigger in any case, recovery code is not really
helpful.

    I'd prefer to keep all these warnings 'simple' - i.e. no attempted
    recovery & control flow, unless we ever expect these to trigger.
    [5]

There have been different rules floating around that were never properly
documented. Let's try to clarify.

[1] https://lkml.kernel.org/r/CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com
[2] https://lore.kernel.org/r/CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com
[2] https://lkml.kernel.org/r/CAHk-=wit-DmhMfQErY29JSPjFgebx_Ld+pnerc4J2Ag990WwAA@mail.gmail.com
[4] https://lore.kernel.org/r/CAHk-=wgF7K2gSSpy=m_=K3Nov4zaceUX9puQf1TjkTJLA2XC_g@mail.gmail.com
[5] https://lore.kernel.org/r/YwIW+mVeZoTOxn%2F4@gmail.com

Link: https://lkml.kernel.org/r/20220920122302.99195-2-david@redhat.com
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


--- a/Documentation/process/coding-style.rst~coding-stylerst-document-bug-and-warn-rules-do-not-crash-the-kernel
+++ a/Documentation/process/coding-style.rst
@@ -1186,6 +1186,67 @@ expression used.  For instance:
 	#endif /* CONFIG_SOMETHING */
 
 
+22) Do not crash the kernel
+---------------------------
+
+In general, it is not the kernel developer's decision to crash the kernel.
+
+Avoid panic()
+=============
+
+panic() should be used with care and primarily only during system boot.
+panic() is, for example, acceptable when running out of memory during boot and
+not being able to continue.
+
+Use WARN() rather than BUG()
+============================
+
+Do not add new code that uses any of the BUG() variants, such as BUG(),
+BUG_ON(), or VM_BUG_ON(). Instead, use a WARN*() variant, preferably
+WARN_ON_ONCE(), and possibly with recovery code. Recovery code is not
+required if there is no reasonable way to at least partially recover.
+
+"I'm too lazy to do error handling" is not an excuse for using BUG(). Major
+internal corruptions with no way of continuing may still use BUG(), but need
+good justification.
+
+Use WARN_ON_ONCE() rather than WARN() or WARN_ON()
+**************************************************
+
+WARN_ON_ONCE() is generally preferred over WARN() or WARN_ON(), because it
+is common for a given warning condition, if it occurs at all, to occur
+multiple times. This can fill up and wrap the kernel log, and can even slow
+the system enough that the excessive logging turns into its own, additional
+problem.
+
+Do not WARN lightly
+*******************
+
+WARN*() is intended for unexpected, this-should-never-happen situations.
+WARN*() macros are not to be used for anything that is expected to happen
+during normal operation. These are not pre- or post-condition asserts, for
+example. Again: WARN*() must not be used for a condition that is expected
+to trigger easily, for example, by user space actions. pr_warn_once() is a
+possible alternative, if you need to notify the user of a problem.
+
+Do not worry about panic_on_warn users
+**************************************
+
+A few more words about panic_on_warn: Remember that ``panic_on_warn`` is an
+available kernel option, and that many users set this option. This is why
+there is a "Do not WARN lightly" writeup, above. However, the existence of
+panic_on_warn users is not a valid reason to avoid the judicious use
+WARN*(). That is because, whoever enables panic_on_warn has explicitly
+asked the kernel to crash if a WARN*() fires, and such users must be
+prepared to deal with the consequences of a system that is somewhat more
+likely to crash.
+
+Use BUILD_BUG_ON() for compile-time assertions
+**********************************************
+
+The use of BUILD_BUG_ON() is acceptable and encouraged, because it is a
+compile-time assertion that has no effect at runtime.
+
 Appendix I) References
 ----------------------
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-replace-foll_numa-by-gup_can_follow_protnone.patch
mm-gup-use-gup_can_follow_protnone-also-in-gup-fast.patch
mm-fixup-documentation-regarding-pte_numa-and-prot_numa.patch
checkpatch-warn-on-usage-of-vm_bug_on-and-other-bug-variants.patch

