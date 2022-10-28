Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14ABC38A02
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiJ1VHS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiJ1VHP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:07:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40021EF063
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:07:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4087262A67
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8804FC433D6;
        Fri, 28 Oct 2022 21:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666991231;
        bh=ReJ9sR00q+m1KeKsq8swaWB7C9rO4Wd26MYWGB9MWrc=;
        h=Date:To:From:Subject:From;
        b=uYGLdg2c3lFxWR3aW5Sze7RoONxelPEzEM00SKBmkG7WkCRHfnRnxgsCpkldIcLlG
         4V87XVlhinMEtF6PrHu2L5CwAFw+9PaR/Fyn1qk2XTkMBpiu5TXlxJtC6eJ/ok0s06
         FYgoSax5SaYKsx70VMP4351psSk9fvUjgtiRmfSo=
Date:   Fri, 28 Oct 2022 14:07:10 -0700
To:     mm-commits@vger.kernel.org, tytso@mit.edu, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fs-ext4-superc-remove-unused-deprecated_msg.patch removed from -mm tree
Message-Id: <20221028210711.8804FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/ext4/super.c: remove unused `deprecated_msg'
has been removed from the -mm tree.  Its filename was
     fs-ext4-superc-remove-unused-deprecated_msg.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/ext4/super.c: remove unused `deprecated_msg'
Date: Fri Oct 21 08:05:49 AM PDT 2022

fs/ext4/super.c:1744:19: warning: 'deprecated_msg' defined but not used [-Wunused-const-variable=]

Reported-by: kernel test robot <lkp@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/ext4/super.c~fs-ext4-superc-remove-unused-deprecated_msg
+++ a/fs/ext4/super.c
@@ -1741,10 +1741,6 @@ static const struct fs_parameter_spec ex
 
 #define DEFAULT_JOURNAL_IOPRIO (IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 3))
 
-static const char deprecated_msg[] =
-	"Mount option \"%s\" will be removed by %s\n"
-	"Contact linux-ext4@vger.kernel.org if you think we should keep it.\n";
-
 #define MOPT_SET	0x0001
 #define MOPT_CLEAR	0x0002
 #define MOPT_NOSUPPORT	0x0004
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-hugetlb-convert-free_huge_page-to-folios-fix.patch
vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-gup-remove-foll_migration-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

