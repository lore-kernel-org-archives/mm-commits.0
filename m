Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92830C2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5974523118
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbgLPEI4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:08:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:41150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPEI4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:08:56 -0500
Date:   Tue, 15 Dec 2020 20:08:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608091696;
        bh=tD7N7CbrrdDfSejl3ldCQBgkOoXiW7DoScSO9vod2fI=;
        h=From:To:Subject:From;
        b=GGMAgP4KklfzXjQP31NlxKFr69+XxnyYq6HlzItptYQ83VU7PIGZq4lr/LAc7cBh4
         zlZfMU1zENPIwvwPoOJmPYeYXdI13Irwy0nAy/2nGA+nWnbqZ4QnQVWL9Wqezd6gwp
         TYPVPp/USoiBLYyqf+Wm/UMUklb2tqWQYjFF4Oj0=
From:   akpm@linux-foundation.org
To:     amistry@google.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 proc-provide-details-on-indirect-branch-speculation-v2.patch removed from
 -mm tree
Message-ID: <20201216040815.47slU-P9O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-provide-details-on-indirect-branch-speculation-v2
has been removed from the -mm tree.  Its filename was
     proc-provide-details-on-indirect-branch-speculation-v2.patch

This patch was dropped because it was folded into proc-provide-details-on-indirect-branch-speculation.patch

------------------------------------------------------
From: Anand K Mistry <amistry@google.com>
Subject: proc-provide-details-on-indirect-branch-speculation-v2

remove underscores from field name to workaround documentation issue

Link: https://lkml.kernel.org/r/20201106131015.v2.1.I7782b0cedb705384a634cfd8898eb7523562da99@changeid
Signed-off-by: Anand K Mistry <amistry@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    4 ++--
 fs/proc/array.c                    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/filesystems/proc.rst~proc-provide-details-on-indirect-branch-speculation-v2
+++ a/Documentation/filesystems/proc.rst
@@ -210,7 +210,7 @@ read the file /proc/PID/status::
   NoNewPrivs:     0
   Seccomp:        0
   Speculation_Store_Bypass:       thread vulnerable
-  Speculation_Indirect_Branch:    conditional enabled
+  SpeculationIndirectBranch:      conditional enabled
   voluntary_ctxt_switches:        0
   nonvoluntary_ctxt_switches:     1
 
@@ -293,7 +293,7 @@ It's slow but very precise.
  NoNewPrivs                  no_new_privs, like prctl(PR_GET_NO_NEW_PRIV, ...)
  Seccomp                     seccomp mode, like prctl(PR_GET_SECCOMP, ...)
  Speculation_Store_Bypass    speculative store bypass mitigation status
- Speculation_Indirect_Branch indirect branch speculation mode
+ SpeculationIndirectBranch   indirect branch speculation mode
  Cpus_allowed                mask of CPUs on which this process may run
  Cpus_allowed_list           Same as previous, but in "list format"
  Mems_allowed                mask of memory nodes allowed to this process
--- a/fs/proc/array.c~proc-provide-details-on-indirect-branch-speculation-v2
+++ a/fs/proc/array.c
@@ -369,7 +369,7 @@ static inline void task_seccomp(struct s
 		break;
 	}
 
-	seq_puts(m, "\nSpeculation_Indirect_Branch:\t");
+	seq_puts(m, "\nSpeculationIndirectBranch:\t");
 	switch (arch_prctl_spec_ctrl_get(p, PR_SPEC_INDIRECT_BRANCH)) {
 	case -EINVAL:
 		seq_puts(m, "unsupported");
_

Patches currently in -mm which might be from amistry@google.com are

proc-provide-details-on-indirect-branch-speculation.patch

