Return-Path: <SRS0=pZAw=EM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F5FBC2D0A3
	for <mm-commits@archiver.kernel.org>; Fri,  6 Nov 2020 23:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC32120882
	for <mm-commits@archiver.kernel.org>; Fri,  6 Nov 2020 23:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604706622;
	bh=AjnK6XxwL68L6W9SNHZCL6ZLt+KrGO8eLiar10kKk6g=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=l1p1TyeRyTVJ2QyvmzU3OJcLlvJWWa3L+sX6TxrDeqb66bXTl8rNRU6fhaih+Myha
	 Wq+ScbIXJQuxUA9rufwQLJQxi0l98/rhHdUdrgP3rWmFiJiNOuUg7aIMHVUw/9j3XS
	 8yBoIwSKROyKHKD1Uzk6Fo7ba02WD1J4gakIXu88=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgKFXuW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Nov 2020 18:50:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgKFXuV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Nov 2020 18:50:21 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEDD620704;
        Fri,  6 Nov 2020 23:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604706621;
        bh=AjnK6XxwL68L6W9SNHZCL6ZLt+KrGO8eLiar10kKk6g=;
        h=Date:From:To:Subject:From;
        b=qo56TIwx5E/vy3Ld1eqKx7Uzbx2qEMrVqNA+LWaAHUvyzB7oqJFyWGATpph5VoiRu
         s/XLyA09bol/vsI3wMUO/N5fkH9pVYa/ORoM1nugwpwJKL2rDacn4hp0LWcqV4a4Gg
         eOmVj9yGnk0W7fHfkoWUNyOhOSUInO7f0vp9fFIs=
Date:   Fri, 06 Nov 2020 15:50:20 -0800
From:   akpm@linux-foundation.org
To:     amistry@google.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  +
 proc-provide-details-on-indirect-branch-speculation-v2.patch added to -mm
 tree
Message-ID: <20201106235020.0JpZcbcTg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-provide-details-on-indirect-branch-speculation-v2
has been added to the -mm tree.  Its filename is
     proc-provide-details-on-indirect-branch-speculation-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-provide-details-on-indirect-branch-speculation-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-provide-details-on-indirect-branch-speculation-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
proc-provide-details-on-indirect-branch-speculation-v2.patch

