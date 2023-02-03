Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF40DC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbjBCGpc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbjBCGpT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:45:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0609C8F51D
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:42:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9866161DAB
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC86AC433EF;
        Fri,  3 Feb 2023 06:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406521;
        bh=PwHpITbrDUZpYWhZ7pxMmvnaMQVyB+Kx297L5A1DveE=;
        h=Date:To:From:Subject:From;
        b=iLXkqNZAt7OFRokYrIMdOG/jYrTU/GEYkA1EFXaqe2eDkGFUBH7G9gDJ2mKJxRjya
         inz1XhaAUDBrcD9GtR+SXbPRcOvHEw9S4R/TDO5n0+o/7F6q7Pgp3QGPy3w2ftTgdU
         de5rkeGP0cPDMPomK4rAAsCZmRBgb1pxtHcxPwoc=
Date:   Thu, 02 Feb 2023 22:42:00 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        mhiramat@kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] error-injection-remove-ei_etype_none-fix.patch removed from -mm tree
Message-Id: <20230203064200.EC86AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: error-injection-remove-ei_etype_none-fix
has been removed from the -mm tree.  Its filename was
     error-injection-remove-ei_etype_none-fix.patch

This patch was dropped because it was folded into error-injection-remove-ei_etype_none.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: error-injection-remove-ei_etype_none-fix
Date: Thu Dec 15 04:33:32 PM PST 2022

include/linux/error-injection.h needs errno.h
lib/error-inject.c

Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/error-injection.h~error-injection-remove-ei_etype_none-fix
+++ a/include/linux/error-injection.h
@@ -3,6 +3,7 @@
 #define _LINUX_ERROR_INJECTION_H
 
 #include <linux/compiler.h>
+#include <linux/errno.h>
 #include <asm-generic/error-injection.h>
 
 #ifdef CONFIG_FUNCTION_ERROR_INJECTION
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fsdax-dax_unshare_iter-should-return-a-valid-length-fix.patch
revert-squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
kasan-infer-allocation-size-by-scanning-metadata-fix.patch
mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix.patch
error-injection-remove-ei_etype_none.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

