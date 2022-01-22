Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4011C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbiAVBPS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiAVBPS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:15:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC243C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 17:15:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BE8D61AB6
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0E7C340E1;
        Sat, 22 Jan 2022 01:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642814116;
        bh=1H4m1TftHDGGVRCzmnDKRUGbY6yTWqh4tc1wwRVZ4NI=;
        h=Date:From:To:Subject:From;
        b=olbw/QyoJMt+nq0+327va68E8pxLSDYBKgy0mO9uET5/ixk9ffqrja4HOzjBIaL1l
         o6lfa1sXUW59q9yvAS1kC5Dff9u+jaKwKRQCyXgzIokFnQkTCkZBZ9P8qyp26m8UYD
         pm4+H1TQDbGDHEL3gsCMykdG3PRbuMHiOAHrtqUc=
Date:   Fri, 21 Jan 2022 17:15:16 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mcgrof@kernel.org,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch removed from
 -mm tree
Message-ID: <20220122011516.nyLjXv1rU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl-add-helper-to-register-a-sysctl-mount-point-fix
has been removed from the -mm tree.  Its filename was
     sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch

This patch was dropped because it was folded into sysctl-add-helper-to-register-a-sysctl-mount-point.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sysctl-add-helper-to-register-a-sysctl-mount-point-fix

export register_sysctl_mount_point() to modules

ERROR: modpost: "register_sysctl_mount_point" [fs/binfmt_misc.ko] undefined!

Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/proc_sysctl.c~sysctl-add-helper-to-register-a-sysctl-mount-point-fix
+++ a/fs/proc/proc_sysctl.c
@@ -47,6 +47,7 @@ struct ctl_table_header *register_sysctl
 {
 	return register_sysctl(path, sysctl_mount_point);
 }
+EXPORT_SYMBOL(register_sysctl_mount_point);
 
 static bool is_empty_dir(struct ctl_table_header *head)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

sysctl-add-helper-to-register-a-sysctl-mount-point.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mm-remove-cleancache-fix.patch
mm-simplify-try_to_unuse-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

