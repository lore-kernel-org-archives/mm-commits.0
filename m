Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE5FC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:22:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC62C610A1
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346827AbhIBVXi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245379AbhIBVXi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:23:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38B3C61074;
        Thu,  2 Sep 2021 21:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617759;
        bh=6CZ22aeLHf69rALvE/KBh60QlrEWxuI8PYbWoDud788=;
        h=Date:From:To:Subject:From;
        b=0CCOKOqEcayrG7oSlwC0SiQ5Y8Wppe8w/nR6lwiSVYd+L+8EmwrpjQ/nV6+cJp4D7
         pzlx+GsISgOut+ml7bW61JoaA2X2Pk058osMdO/BfBbKuUnT/aXuNU6T3AH0/L8XIK
         CDXwEQoxWjyatn7QlD9s3SV3loLKdKNa8KCJ/ePs=
Date:   Thu, 02 Sep 2021 14:22:38 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, charante@codeaurora.org, corbet@lwn.net,
        dave.hansen@linux.intel.com, keescook@chromium.org,
        khalid.aziz@oracle.com, mcgrof@kernel.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        nigupta@nvidia.com, rientjes@google.com, rppt@kernel.org,
        vbabka@suse.cz, vinmenon@codeaurora.org, yzaikin@google.com
Subject:  [folded-merged]
 mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
 removed from -mm tree
Message-ID: <20210902212238.bZpNbtGfw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-support-triggering-of-proactive-compaction-by-user-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch

This patch was dropped because it was folded into mm-compaction-support-triggering-of-proactive-compaction-by-user.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-support-triggering-of-proactive-compaction-by-user-fix

tweak vm.rst, per Mike

Cc: Mike Rapoport <rppt@kernel.org>
Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Nitin Gupta <nigupta@nvidia.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/sysctl/vm.rst~mm-compaction-support-triggering-of-proactive-compaction-by-user-fix
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -118,7 +118,7 @@ compaction_proactiveness
 
 This tunable takes a value in the range [0, 100] with a default value of
 20. This tunable determines how aggressively compaction is done in the
-background. On write of non zero value to this tunable will immediately
+background. Write of a non zero value to this tunable will immediately
 trigger the proactive compaction. Setting it to 0 disables proactive compaction.
 
 Note that compaction has a non-trivial system-wide impact as pages
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-support-triggering-of-proactive-compaction-by-user.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-idle_page_tracking-make-pg_idle-reusable-fix-fix.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
checkpatch-improve-git_commit_id-test-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

