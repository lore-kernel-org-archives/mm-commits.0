Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 827E3C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiJCVMk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiJCVLN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2194A51420
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA105B81610
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4738BC433D6;
        Mon,  3 Oct 2022 21:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831215;
        bh=hlx9rqLqewExbHtPSsDVY9ZMYuK66OjCMDZeOMNzDrs=;
        h=Date:To:From:Subject:From;
        b=c5pM4bM1BylR1hhECfvV2wqpsgvRkNBr8P5grxMakwHtBtoiLBUCASbULJ0If/jsm
         YpriJoIQ9QyFf5HIRo9lHaLd5IJe+Is/VGmq+W/8Gn8aDcE8AD/TB0sZtem7bC7UfU
         X2DK39SZuA4mMCK3iSRIEBVW+u2SmodHE727SBu4=
Date:   Mon, 03 Oct 2022 14:06:54 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, ppbuk5246@gmail.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-start-mention-the-dependency-as-sysfs-instead-of-debugfs.patch removed from -mm tree
Message-Id: <20221003210655.4738BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/start: mention the dependency as sysfs instead of debugfs
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-start-mention-the-dependency-as-sysfs-instead-of-debugfs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

