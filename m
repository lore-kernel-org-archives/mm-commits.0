Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C8C5ECAAD5
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 21:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiIIVal (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 17:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiIIVai (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 17:30:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEC29F766
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 14:30:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEDA1620FF
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 21:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F23FC433D6;
        Fri,  9 Sep 2022 21:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662759036;
        bh=zOpTRMvDnfNvya2k3NSlram/DISMqiUfavzGvvExn10=;
        h=Date:To:From:Subject:From;
        b=VVJwveoqFEEV4/Za6wgDmPqnOzCSWUUwLrWDWg1sgJ4AkE5xu1FnGDDD6rm+K88rS
         RF2VEIvyzn9QCLKIgl54WVNcsnWow8+SbqA0w9Z/DbyAgm44Bzzx8QKQCDKCSIT1WT
         ISkl9Thw4+9st+E6uiQCN8NHN28Nb0BYdO7xS+4c=
Date:   Fri, 09 Sep 2022 14:30:35 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, ppbuk5246@gmail.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-start-mention-the-dependency-as-sysfs-instead-of-debugfs.patch added to mm-unstable branch
Message-Id: <20220909213036.4F23FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/start: mention the dependency as sysfs instead of debugfs
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-start-mention-the-dependency-as-sysfs-instead-of-debugfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-start-mention-the-dependency-as-sysfs-instead-of-debugfs.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/start: mention the dependency as sysfs instead of debugfs
Date: Fri, 9 Sep 2022 20:29:00 +0000

'Getting Started' document of DAMON says DAMON user-space tool, damo[1],
is using DAMON debugfs interface, and therefore it needs to ensure debugfs
is mounted.  However, the latest version of the tool is using DAMON sysfs
interface.  Moreover, DAMON debugfs interface is going to be deprecated as
announced by commit b18402726bd1 ("Docs/admin-guide/mm/damon/usage:
document DAMON sysfs interface").

This commit therefore update the document to tell readers about DAMON
sysfs interface dependency instead and never mention about debugfs
interface, which will be deprecated.

[1] https://github.com/awslabs/damo

Link: https://lkml.kernel.org/r/20220909202901.57977-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yun Levi <ppbuk5246@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/start.rst |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/Documentation/admin-guide/mm/damon/start.rst~docs-admin-guide-mm-damon-start-mention-the-dependency-as-sysfs-instead-of-debugfs
+++ a/Documentation/admin-guide/mm/damon/start.rst
@@ -29,16 +29,9 @@ called DAMON Operator (DAMO).  It is ava
 https://github.com/awslabs/damo.  The examples below assume that ``damo`` is on
 your ``$PATH``.  It's not mandatory, though.
 
-Because DAMO is using the debugfs interface (refer to :doc:`usage` for the
-detail) of DAMON, you should ensure debugfs is mounted.  Mount it manually as
-below::
-
-    # mount -t debugfs none /sys/kernel/debug/
-
-or append the following line to your ``/etc/fstab`` file so that your system
-can automatically mount debugfs upon booting::
-
-    debugfs /sys/kernel/debug debugfs defaults 0 0
+Because DAMO is using the sysfs interface (refer to :doc:`usage` for the
+detail) of DAMON, you should ensure :doc:`sysfs </filesystems/sysfs>` is
+mounted.
 
 
 Recording Data Access Patterns
_

Patches currently in -mm which might be from sj@kernel.org are

mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix.patch
selftest-damon-add-a-test-for-duplicate-context-dirs-creation.patch
mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges.patch
mm-damon-core-test-test-damon_set_regions.patch
docs-admin-guide-mm-damon-rename-the-title-of-the-document.patch
mm-damon-kconfig-notify-debugfs-deprecation-plan.patch
docs-admin-guide-mm-damon-start-mention-the-dependency-as-sysfs-instead-of-debugfs.patch
docs-admin-guide-mm-damon-usage-note-damon-debugfs-interface-deprecation-plan.patch

