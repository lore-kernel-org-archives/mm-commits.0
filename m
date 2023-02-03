Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8456C63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbjBCGva (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbjBCGvN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5224DBE0
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8845161CC8
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A96C433EF;
        Fri,  3 Feb 2023 06:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407065;
        bh=l4S+5DVfPQzyYUVkCY2b6egVv5H5sYHm1Xib7CPHHwo=;
        h=Date:To:From:Subject:From;
        b=2r8PI3O4FouVzso03H+jt9MZPkSA27SDeJQH5JMb2Aajtl2fkEPh57dsDHvPTzrph
         HnpOTm6gEiLhSbFlLoicmUV3bKRqLXbBNdgIEexY9GqfLntikWZay+7a3QEh070Gxc
         OVcK3ho1OmEQIZv3xPwubPHhlLN37ILgQNOl/w5A=
Date:   Thu, 02 Feb 2023 22:51:04 -0800
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] userns-fix-a-structs-kernel-doc-notation.patch removed from -mm tree
Message-Id: <20230203065104.E2A96C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userns: fix a struct's kernel-doc notation
has been removed from the -mm tree.  Its filename was
     userns-fix-a-structs-kernel-doc-notation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


