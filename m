Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119A5C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8B7C23137
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgLPEn7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:43:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgLPEn7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:43:59 -0500
Date:   Tue, 15 Dec 2020 20:42:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093757;
        bh=Iu7nGoAASVa0OLMEKHKmOarIpIf3q2k3cjkxq0RVYpU=;
        h=From:To:Subject:In-Reply-To:From;
        b=LIaBs/ViYi+gq/l5lQcmkjpbucQID/Rzyp4hU/awpXnfGbdCsov69iU2S6T6sAV2J
         xJ5/+2LPui3wLyKO8n3+OZRZCB29B2D2Qm05QHPkAjcM5vLsIQ0QJOuvkLLNZ7P6cO
         f9KrUD+DOc4lQFQBBzOyZmgWS/nsdg5xGR2Jx+Xc=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, amistry@google.com,
        asteinhauser@google.com, corbet@lwn.net, gladkov.alexey@gmail.com,
        keescook@chromium.org, linux-mm@kvack.org,
        mchehab+huawei@kernel.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de, peterz@infradead.org,
        rppt@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org
Subject:  [patch 05/95] proc: provide details on indirect branch
 speculation
Message-ID: <20201216044236.C5qdRtOt_%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Anand K Mistry <amistry@google.com>
Subject: proc: provide details on indirect branch speculation

Similar to speculation store bypass, show information about the indirect
branch speculation mode of a task in /proc/$pid/status.

For testing/benchmarking, I needed to see whether IB (Indirect Branch)
speculation (see Spectre-v2) is enabled on a task, to see whether an
IBPB instruction should be executed on an address space switch. 
Unfortunately, this information isn't available anywhere else and
currently the only way to get it is to hack the kernel to expose it
(like this change).  It also helped expose a bug with conditional IB
speculation on certain CPUs.

Another place this could be useful is to audit the system when using
sanboxing.  With this change, I can confirm that seccomp-enabled
process have IB speculation force disabled as expected when the kernel
command line parameter `spectre_v2_user=seccomp`.

Since there's already a 'Speculation_Store_Bypass' field, I used that
as precedent for adding this one.

[amistry@google.com: remove underscores from field name to workaround documentation issue]
  Link: https://lkml.kernel.org/r/20201106131015.v2.1.I7782b0cedb705384a634cfd8898eb7523562da99@changeid
Link: https://lkml.kernel.org/r/20201030172731.1.I7782b0cedb705384a634cfd8898eb7523562da99@changeid
Signed-off-by: Anand K Mistry <amistry@google.com>
Cc: Anthony Steinhauser <asteinhauser@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Anand K Mistry <amistry@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    2 +
 fs/proc/array.c                    |   28 +++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

--- a/Documentation/filesystems/proc.rst~proc-provide-details-on-indirect-branch-speculation
+++ a/Documentation/filesystems/proc.rst
@@ -210,6 +210,7 @@ read the file /proc/PID/status::
   NoNewPrivs:     0
   Seccomp:        0
   Speculation_Store_Bypass:       thread vulnerable
+  SpeculationIndirectBranch:      conditional enabled
   voluntary_ctxt_switches:        0
   nonvoluntary_ctxt_switches:     1
 
@@ -292,6 +293,7 @@ It's slow but very precise.
  NoNewPrivs                  no_new_privs, like prctl(PR_GET_NO_NEW_PRIV, ...)
  Seccomp                     seccomp mode, like prctl(PR_GET_SECCOMP, ...)
  Speculation_Store_Bypass    speculative store bypass mitigation status
+ SpeculationIndirectBranch   indirect branch speculation mode
  Cpus_allowed                mask of CPUs on which this process may run
  Cpus_allowed_list           Same as previous, but in "list format"
  Mems_allowed                mask of memory nodes allowed to this process
--- a/fs/proc/array.c~proc-provide-details-on-indirect-branch-speculation
+++ a/fs/proc/array.c
@@ -369,6 +369,34 @@ static inline void task_seccomp(struct s
 		seq_puts(m, "vulnerable");
 		break;
 	}
+
+	seq_puts(m, "\nSpeculationIndirectBranch:\t");
+	switch (arch_prctl_spec_ctrl_get(p, PR_SPEC_INDIRECT_BRANCH)) {
+	case -EINVAL:
+		seq_puts(m, "unsupported");
+		break;
+	case PR_SPEC_NOT_AFFECTED:
+		seq_puts(m, "not affected");
+		break;
+	case PR_SPEC_PRCTL | PR_SPEC_FORCE_DISABLE:
+		seq_puts(m, "conditional force disabled");
+		break;
+	case PR_SPEC_PRCTL | PR_SPEC_DISABLE:
+		seq_puts(m, "conditional disabled");
+		break;
+	case PR_SPEC_PRCTL | PR_SPEC_ENABLE:
+		seq_puts(m, "conditional enabled");
+		break;
+	case PR_SPEC_ENABLE:
+		seq_puts(m, "always enabled");
+		break;
+	case PR_SPEC_DISABLE:
+		seq_puts(m, "always disabled");
+		break;
+	default:
+		seq_puts(m, "unknown");
+		break;
+	}
 	seq_putc(m, '\n');
 }
 
_
