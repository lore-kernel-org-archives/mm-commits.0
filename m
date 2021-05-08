Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9380CC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7429B61432
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:55:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhEHW4H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhEHW4H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:56:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CF9B610FA;
        Sat,  8 May 2021 22:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514505;
        bh=jvP4+67B7NRHWkx2vk/UpcU6rqzZW7tYefgcdeysIVo=;
        h=Date:From:To:Subject:From;
        b=ItX227wOTlafKpH2VzyeAC3mnfd0TYZSy6aXwNiNE/N+7pugbpXziBs2PaEtYByU/
         4wEVAGzZtNRN+nvCQs9nQWpDaxHSHBhfzKoZfQ6rEtEWQhvfUFm9Viph1zA2h/xIcy
         5Ua/3gTLD8OMKOpBCt4oYpjsgLAMPahaCkSC8rj4=
Date:   Sat, 08 May 2021 15:55:05 -0700
From:   akpm@linux-foundation.org
To:     caoxiaofeng@yulong.com, cxfcosmos@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged] kernel-user_namespace-fix-typo-issue.patch
 removed from -mm tree
Message-ID: <20210508225505.e6VP4D8B8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/user_namespace.c: fix typos
has been removed from the -mm tree.  Its filename was
     kernel-user_namespace-fix-typo-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiaofeng Cao <cxfcosmos@gmail.com>
Subject: kernel/user_namespace.c: fix typos

change 'verifing' to 'verifying'
change 'certaint' to 'certain'
change 'approprpiate' to 'appropriate'

Link: https://lkml.kernel.org/r/20210317100129.12440-1-caoxiaofeng@yulong.com
Signed-off-by: Xiaofeng Cao <caoxiaofeng@yulong.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user_namespace.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/user_namespace.c~kernel-user_namespace-fix-typo-issue
+++ a/kernel/user_namespace.c
@@ -85,7 +85,7 @@ int create_user_ns(struct cred *new)
 	/*
 	 * Verify that we can not violate the policy of which files
 	 * may be accessed that is specified by the root directory,
-	 * by verifing that the root directory is at the root of the
+	 * by verifying that the root directory is at the root of the
 	 * mount namespace which allows all files to be accessed.
 	 */
 	ret = -EPERM;
@@ -1014,7 +1014,7 @@ static ssize_t map_write(struct file *fi
 			goto out;
 		ret = -EINVAL;
 	}
-	/* Be very certaint the new map actually exists */
+	/* Be very certain the new map actually exists */
 	if (new_map.nr_extents == 0)
 		goto out;
 
@@ -1169,7 +1169,7 @@ static bool new_idmap_permitted(const st
 
 	/* Allow the specified ids if we have the appropriate capability
 	 * (CAP_SETUID or CAP_SETGID) over the parent user namespace.
-	 * And the opener of the id file also had the approprpiate capability.
+	 * And the opener of the id file also has the appropriate capability.
 	 */
 	if (ns_capable(ns->parent, cap_setid) &&
 	    file_ns_capable(file, ns->parent, cap_setid))
_

Patches currently in -mm which might be from cxfcosmos@gmail.com are


