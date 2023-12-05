Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7516CC4167B
	for <mm-commits@archiver.kernel.org>; Tue,  5 Dec 2023 19:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjLETwh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Dec 2023 14:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjLETwg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2023 14:52:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3529183
        for <mm-commits@vger.kernel.org>; Tue,  5 Dec 2023 11:52:42 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AF8C433C8;
        Tue,  5 Dec 2023 19:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701805962;
        bh=QVXvq0jBevRqQKWoMgEHTbfc4Hdd0jnKjvcE3KOH1TI=;
        h=Date:To:From:Subject:From;
        b=ZE3Oakye5YkO1XQgAkKMgtqaIaNGaZk9ug6L68ryyirlObQgTD9xHYcAgh5NWkVgO
         taMZTTjImOZOcq+V5ez+UH59BzmHvGTUE6YiyAC570ZfSf2/fK4orVGiM3gMIcs/lj
         +hGXWi0q5JiDvvVPoR6/ADRd0g62bBlksl6pSwUU=
Date:   Tue, 05 Dec 2023 11:52:41 -0800
To:     mm-commits@vger.kernel.org, dmaluka@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-add-config_transparent_hugepage_never-option.patch added to mm-unstable branch
Message-Id: <20231205195242.45AF8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: add CONFIG_TRANSPARENT_HUGEPAGE_NEVER option
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-add-config_transparent_hugepage_never-option.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-add-config_transparent_hugepage_never-option.patch

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
From: Dmytro Maluka <dmaluka@chromium.org>
Subject: mm/thp: add CONFIG_TRANSPARENT_HUGEPAGE_NEVER option
Date: Tue, 5 Dec 2023 18:02:44 +0100

Currently enabling THP support (CONFIG_TRANSPARENT_HUGEPAGE) requires
enabling either CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS or
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE, which both cause khugepaged starting
by default at kernel bootup.  Add the third choice
CONFIG_TRANSPARENT_HUGEPAGE_NEVER, in line with the existing kernel
command line setting transparent_hugepage=never, to disable THP by default
(in particular, to prevent starting khugepaged by default) but still allow
enabling it at runtime via sysfs.

Rationale: khugepaged has its own non-negligible memory cost even if it is
not used by any applications, since it bumps up vm.min_free_kbytes to its
own required minimum in set_recommended_min_free_kbytes().  For example,
on a machine with 4GB RAM, with 3 mm zones and pageblock_order ==
MAX_ORDER, starting khugepaged causes vm.min_free_kbytes increase from 8MB
to 132MB.

So if we use THP on machines with e.g.  >=8GB of memory for better
performance, but avoid using it on lower-memory machines to avoid its
memory overhead, then for the same reason we also want to avoid even
starting khugepaged on those <8GB machines.  So with
CONFIG_TRANSPARENT_HUGEPAGE_NEVER we can use the same kernel image on both
>=8GB and <8GB machines, with THP support enabled but khugepaged not
started by default.  The userspace can then decide to enable THP via sysfs
if needed, based on the total amount of memory.

This could also be achieved with the existing transparent_hugepage=never
setting in the kernel command line instead.  But it seems cleaner to avoid
tweaking the command line for such a basic setting.

P.S. I see that CONFIG_TRANSPARENT_HUGEPAGE_NEVER was already proposed
in the past [1] but without an explanation of the purpose.

[1] https://lore.kernel.org/all/202211301651462590168@zte.com.cn/

Link: https://lkml.kernel.org/r/20231205170244.2746210-1-dmaluka@chromium.org
Link: https://lore.kernel.org/all/20231204163254.2636289-1-dmaluka@chromium.org/
Signed-off-by: Dmytro Maluka <dmaluka@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/Kconfig~mm-thp-add-config_transparent_hugepage_never-option
+++ a/mm/Kconfig
@@ -873,6 +873,12 @@ choice
 	  madvise(MADV_HUGEPAGE) but it won't risk to increase the
 	  memory footprint of applications without a guaranteed
 	  benefit.
+
+	config TRANSPARENT_HUGEPAGE_NEVER
+		bool "never"
+	help
+	  Disable Transparent Hugepage by default. It can still be
+	  enabled at runtime via sysfs.
 endchoice
 
 config THP_SWAP
_

Patches currently in -mm which might be from dmaluka@chromium.org are

mm-thp-add-config_transparent_hugepage_never-option.patch

