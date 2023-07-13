Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F05E0C001E0
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 17:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjGMRLn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 13:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjGMRLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 13:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D1C1BF3
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 10:11:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97B2B61B07
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 17:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7916C433C7;
        Thu, 13 Jul 2023 17:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689268297;
        bh=rKwkNLaXzfshNvoxxtljQaBNF8j7Q4Zve1YuJ2Mq5mI=;
        h=Date:To:From:Subject:From;
        b=Py0yMVWcTx2RDUuMJl4o4/l+Fm6q7nx6+X4Yk5FAAVmcIP2PFIVK3dQzt0eRXaweC
         MB219FO+A8StxRVwXsBZaNpJdjXauyq77+kR/MkdU1/1/FFWhDrrNEaqRErg4vXJCe
         2mnyY+79CcPQJgMlH7RIektcmlmEk/ydbA7aS2uY=
Date:   Thu, 13 Jul 2023 10:11:36 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        lczerner@redhat.com, hughd@google.com, djwong@kernel.org,
        cmaiolino@redhat.com, brauner@kernel.org, jack@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + quota-check-presence-of-quota-operation-structures-instead-of-quota_read-and-quota_write-callbacks.patch added to mm-unstable branch
Message-Id: <20230713171136.E7916C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: quota: check presence of quota operation structures instead of ->quota_read and ->quota_write callbacks
has been added to the -mm mm-unstable branch.  Its filename is
     quota-check-presence-of-quota-operation-structures-instead-of-quota_read-and-quota_write-callbacks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/quota-check-presence-of-quota-operation-structures-instead-of-quota_read-and-quota_write-callbacks.patch

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
From: Jan Kara <jack@suse.cz>
Subject: quota: check presence of quota operation structures instead of ->quota_read and ->quota_write callbacks
Date: Thu, 13 Jul 2023 15:48:45 +0200

Currently we check whether superblock has ->quota_read and ->quota_write
operations to check whether filesystem supports quotas.  However for
example for shmfs we will not read or write dquots so check whether quota
operations are set in the superblock instead.

Link: https://lkml.kernel.org/r/20230713134848.249779-4-cem@kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/quota/dquot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/quota/dquot.c~quota-check-presence-of-quota-operation-structures-instead-of-quota_read-and-quota_write-callbacks
+++ a/fs/quota/dquot.c
@@ -2367,7 +2367,7 @@ int dquot_load_quota_sb(struct super_blo
 
 	if (!fmt)
 		return -ESRCH;
-	if (!sb->s_op->quota_write || !sb->s_op->quota_read ||
+	if (!sb->dq_op || !sb->s_qcop ||
 	    (type == PRJQUOTA && sb->dq_op->get_projid == NULL)) {
 		error = -EINVAL;
 		goto out_fmt;
_

Patches currently in -mm which might be from jack@suse.cz are

quota-check-presence-of-quota-operation-structures-instead-of-quota_read-and-quota_write-callbacks.patch

