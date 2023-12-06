Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08591C4167B
	for <mm-commits@archiver.kernel.org>; Wed,  6 Dec 2023 20:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379458AbjLFUD4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 15:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379442AbjLFUDy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 15:03:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58624C6
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 12:04:01 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82ACC433C7;
        Wed,  6 Dec 2023 20:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701893041;
        bh=oyYTUJmqWqDbDBFe62OF3hygfmlC//dELjRC41/ePA8=;
        h=Date:To:From:Subject:From;
        b=t2E8SYw5VCMYJCjZCZItpAscGc1KBx8xgjmoaO29r7DBJaLJWMOswL54mdMS6oCsr
         o4aZ7Sws0Xt6T6z6mH55kUSU7iPpZ/5Sqhw18bctAZqEAUz2MMAl5hmYD3WymDsXpj
         CM8CPMGQP+fxG8L8H5MNcULvi7NAZxaiXqMGrFTY=
Date:   Wed, 06 Dec 2023 12:04:00 -0800
To:     mm-commits@vger.kernel.org, longman@redhat.com,
        catalin.marinas@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kmemleak-avoid-rcu-stalls-when-freeing-metadata-for-per-cpu-pointers-v2.patch added to mm-unstable branch
Message-Id: <20231206200400.E82ACC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak-avoid-rcu-stalls-when-freeing-metadata-for-per-cpu-pointers-v2
has been added to the -mm mm-unstable branch.  Its filename is
     kmemleak-avoid-rcu-stalls-when-freeing-metadata-for-per-cpu-pointers-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmemleak-avoid-rcu-stalls-when-freeing-metadata-for-per-cpu-pointers-v2.patch

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
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: kmemleak-avoid-rcu-stalls-when-freeing-metadata-for-per-cpu-pointers-v2
Date: Wed, 6 Dec 2023 11:44:14 +0000

update the comment to include the *_percpu() callbacks, not just the *_phys()

Link: https://lkml.kernel.org/r/20231206114414.2085824-1-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Waiman Long <longman@redhat.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/r/20231127194153.289626-1-longman@redhat.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kmemleak.c~kmemleak-avoid-rcu-stalls-when-freeing-metadata-for-per-cpu-pointers-v2
+++ a/mm/kmemleak.c
@@ -21,8 +21,8 @@
  *   red black trees used to look-up metadata based on a pointer to the
  *   corresponding memory block. The kmemleak_object structures are added to
  *   the object_list and the object tree root in the create_object() function
- *   called from the kmemleak_alloc() (or kmemleak_alloc_phys()) callback and
- *   removed in delete_object() called from the kmemleak_free() callback
+ *   called from the kmemleak_alloc{,_phys,_percpu}() callback and removed in
+ *   delete_object() called from the kmemleak_free{,_phys,_percpu}() callback
  * - kmemleak_object.lock (raw_spinlock_t): protects a kmemleak_object.
  *   Accesses to the metadata (e.g. count) are protected by this lock. Note
  *   that some members of this structure may be protected by other means
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

kmemleak-avoid-rcu-stalls-when-freeing-metadata-for-per-cpu-pointers.patch
kmemleak-avoid-rcu-stalls-when-freeing-metadata-for-per-cpu-pointers-v2.patch

