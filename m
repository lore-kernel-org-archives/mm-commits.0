Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97384C5479D
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 01:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjAJBGb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 20:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjAJBGa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 20:06:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9E2B0E
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 17:06:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16FCEB810A8
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 01:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FA1C433EF;
        Tue, 10 Jan 2023 01:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673312786;
        bh=Hiy91c6KQdxRyKQpj5uuJnDOnk+Ya/QVP8VJBFk5yEM=;
        h=Date:To:From:Subject:From;
        b=VhhRpRm8PaOWQEJ+wL0iGNJU81WMcl4szDuNxjWIFc0lsCBo/Fag5bA0T30g6xM0o
         cY1/IDAjcvG8yd3hUqKy63gbrQkXVqtmbzv52+dAO6OYA9Q+p9l2C801iz13dbASCt
         4ovJ4KYGswsRajLQUA1n/bIXQZlDkJg9yo9n19Wk=
Date:   Mon, 09 Jan 2023 17:06:26 -0800
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userns-fix-a-structs-kernel-doc-notation.patch added to mm-nonmm-unstable branch
Message-Id: <20230110010626.B1FA1C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userns: fix a struct's kernel-doc notation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     userns-fix-a-structs-kernel-doc-notation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userns-fix-a-structs-kernel-doc-notation.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: userns: fix a struct's kernel-doc notation
Date: Sat, 7 Jan 2023 18:12:43 -0800

Use the 'struct' keyword for a struct's kernel-doc notation to avoid a
kernel-doc warning:

kernel/user_namespace.c:232: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * idmap_key struct holds the information necessary to find an idmapping in a

Link: https://lkml.kernel.org/r/20230108021243.16683-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user_namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/user_namespace.c~userns-fix-a-structs-kernel-doc-notation
+++ a/kernel/user_namespace.c
@@ -229,7 +229,7 @@ void __put_user_ns(struct user_namespace
 EXPORT_SYMBOL(__put_user_ns);
 
 /**
- * idmap_key struct holds the information necessary to find an idmapping in a
+ * struct idmap_key - holds the information necessary to find an idmapping in a
  * sorted idmap array. It is passed to cmp_map_id() as first argument.
  */
 struct idmap_key {
_

Patches currently in -mm which might be from rdunlap@infradead.org are

lib-win_minmax-use-notation-for-regular-comments.patch
freevxfs-fix-kernel-doc-warnings.patch
ntfs-fix-multiple-kernel-doc-warnings.patch
userns-fix-a-structs-kernel-doc-notation.patch

