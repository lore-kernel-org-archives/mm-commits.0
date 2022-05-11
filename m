Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1512FC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 11 May 2022 19:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346853AbiEKT3u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 May 2022 15:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346844AbiEKT3t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 May 2022 15:29:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3699AF136D
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 12:29:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C83EA616F6
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 19:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3D1C340EE;
        Wed, 11 May 2022 19:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652297387;
        bh=G+Ns5nTyz3k8l5CXXEWiH+wG2MHCwt9o1Lndb0OKO1M=;
        h=Date:To:From:Subject:From;
        b=hWhmtSEd5WCfwY6RZtijR3yrcCXTbMxtIEf9PGTBQpNrdXgOcunhx3aEthYmm4SzL
         oCNZNJe7dcDkavJOd2AvvU+0HMj1Ud4pNXsSG5GC4JphGGhQyrOyIKI8csMDTZgO4q
         W2F1eVdsrfuU9ZclF0Q8kOb6R1Q46ELiTPnJbyKE=
Date:   Wed, 11 May 2022 12:29:46 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-filesystems-proc-update-meminfo-section-fix-2.patch added to mm-unstable branch
Message-Id: <20220511192947.2E3D1C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Re: Documentation: filesystems: proc: update meminfo section
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-filesystems-proc-update-meminfo-section-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-filesystems-proc-update-meminfo-section-fix-2.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: Documentation: filesystems: proc: update meminfo section

change `Unevictable' wording, per David

Link: https://lkml.kernel.org/r/YnwFraZlVWQoCjz3@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/filesystems/proc.rst~documentation-filesystems-proc-update-meminfo-section-fix-2
+++ a/Documentation/filesystems/proc.rst
@@ -1035,8 +1035,8 @@ Inactive
               Memory which has been less recently used.  It is more
               eligible to be reclaimed for other purposes
 Unevictable
-              Memory that cannot be reclaimed, such as mlocked pages,
-              ramfs backing pages, secret memfd pages etc.
+              Memory allocated for userspace which cannot be reclaimed, such
+              as mlocked pages, ramfs backing pages, secret memfd pages etc.
 Mlocked
               Memory locked with mlock().
 HighTotal, HighFree
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

documentation-filesystems-proc-update-meminfo-section.patch
documentation-filesystems-proc-update-meminfo-section-fix.patch
documentation-filesystems-proc-update-meminfo-section-fix-2.patch
mm-kconfig-move-swap-and-slab-config-options-to-the-mm-section.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix.patch
mm-kconfig-simplify-zswap-configuration.patch
mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch
zswap-memcg-accounting.patch
zswap-memcg-accounting-fix.patch

