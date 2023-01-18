Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 170DBC678D4
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 23:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjARXvg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 18:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjARXvF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 18:51:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47584A1EC
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 15:49:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72A9F61831
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 23:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23F3C433D2;
        Wed, 18 Jan 2023 23:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674085796;
        bh=Nr8y2i77IxJjchN2dtt9ltSCvY5BTWux9kebV9rzYBQ=;
        h=Date:To:From:Subject:From;
        b=st3uRx5rdHlHRRCeMi8z6UDsYNisANZZ6cj0FDi80WOnkhH5ABELMa2bAOW/hsjTV
         bJEs+CkXYSfWNCL/T3RDHgImIK9mskm6KvnnLNNXGdeYaPpcUp3U+LgpawZp9z+iYR
         9zbdw2T01UZ014DmpAVnaIJqo4FJKX91A4Z5yLQM=
Date:   Wed, 18 Jan 2023 15:49:56 -0800
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        keescook@chromium.org, jorgelo@chromium.org, jeffxu@google.com,
        jannh@google.com, hughd@google.com, dverkamp@chromium.org,
        dmitry.torokhov@gmail.com, dh.herrmann@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch removed from -mm tree
Message-Id: <20230118234956.D23F3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3
has been removed from the -mm tree.  Its filename was
     mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch

This patch was dropped because it was folded into mm-memfd-add-mfd_noexec_seal-and-mfd_exec.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3
Date: Fri Dec 16 02:04:18 PM PST 2022

s/pr_warn_ratelimited/pr_warn_once/, per review

Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memfd.c~mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3
+++ a/mm/memfd.c
@@ -308,7 +308,7 @@ SYSCALL_DEFINE2(memfd_create,
 			flags |= MFD_NOEXEC_SEAL;
 			break;
 		default:
-			pr_warn_ratelimited(
+			pr_warn_once(
 				"memfd_create(): MFD_NOEXEC_SEAL is enforced, pid=%d '%s'\n",
 				task_pid_nr(current), get_task_comm(comm, current));
 			return -EINVAL;
@@ -316,7 +316,7 @@ SYSCALL_DEFINE2(memfd_create,
 #else
 		flags |= MFD_EXEC;
 #endif
-		pr_warn_ratelimited(
+		pr_warn_once(
 			"memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL, pid=%d '%s'\n",
 			task_pid_nr(current), get_task_comm(comm, current));
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch
mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch
mm-memcontrol-deprecate-charge-moving-fix.patch
mm-swap-convert-deactivate_page-to-folio_deactivate-fix.patch
mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch

