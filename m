Return-Path: <SRS0=UFsa=EG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4841C388F7
	for <mm-commits@archiver.kernel.org>; Sat, 31 Oct 2020 20:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B17D20706
	for <mm-commits@archiver.kernel.org>; Sat, 31 Oct 2020 20:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604174806;
	bh=KJ8+KakUujZKhEz706QdjbvrzcitqTJSGfWSzIHpOg8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=SWJKNwPG2+4FogV6ThJ9wni6WjE2uDTC21zbZa0CbqVrJ4RpvRJKJHvylVbyPliXL
	 nSOXX440l/2zwJLlDzPCzAhxP6bGG/1hbPLVdIJHjtLcqamZlhcC9tL+5975qH5WMV
	 KbD82NEc6Hq05cAxGCKf7Y5bqBb30NKA45vGf3kU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbgJaUGq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 31 Oct 2020 16:06:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728533AbgJaUGp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 31 Oct 2020 16:06:45 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5CB8206F7;
        Sat, 31 Oct 2020 20:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604174805;
        bh=KJ8+KakUujZKhEz706QdjbvrzcitqTJSGfWSzIHpOg8=;
        h=Date:From:To:Subject:From;
        b=RpUn84dv2dzyhXgJ6g9WGHNPOXeiEgzbfjLDoYhN050jEK4J6aYQnVT6g4Ds1gE7h
         10eoNQRdZ8KmLovr88XqPc7n+3NCAo9weaObYu2JtTgaBaFhZ1Msxl6vsUUN/Sxftn
         YOJjKnEmoCK3Rq9pXCxCmyAXDP7rwkh760GBGCto=
Date:   Sat, 31 Oct 2020 13:06:44 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, amistry@google.com, asteinhauser@google.com,
        corbet@lwn.net, gladkov.alexey@gmail.com, keescook@chromium.org,
        mchehab+huawei@kernel.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de, peterz@infradead.org,
        rppt@kernel.org, tglx@linutronix.de
Subject:  +
 proc-provide-details-on-indirect-branch-speculation.patch added to -mm tree
Message-ID: <20201031200644.DQuLzHrRb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: provide details on indirect branch speculation
has been added to the -mm tree.  Its filename is
     proc-provide-details-on-indirect-branch-speculation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-provide-details-on-indirect-branch-speculation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-provide-details-on-indirect-branch-speculation.patch

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
Subject: proc: provide details on indirect branch speculation

Similar to speculation store bypass, show information about the indirect
branch speculation mode of a task in /proc/$pid/status.

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
+  Speculation_Indirect_Branch:    conditional enabled
   voluntary_ctxt_switches:        0
   nonvoluntary_ctxt_switches:     1
 
@@ -292,6 +293,7 @@ It's slow but very precise.
  NoNewPrivs                  no_new_privs, like prctl(PR_GET_NO_NEW_PRIV, ...)
  Seccomp                     seccomp mode, like prctl(PR_GET_SECCOMP, ...)
  Speculation_Store_Bypass    speculative store bypass mitigation status
+ Speculation_Indirect_Branch indirect branch speculation mode
  Cpus_allowed                mask of CPUs on which this process may run
  Cpus_allowed_list           Same as previous, but in "list format"
  Mems_allowed                mask of memory nodes allowed to this process
--- a/fs/proc/array.c~proc-provide-details-on-indirect-branch-speculation
+++ a/fs/proc/array.c
@@ -368,6 +368,34 @@ static inline void task_seccomp(struct s
 		seq_puts(m, "vulnerable");
 		break;
 	}
+
+	seq_puts(m, "\nSpeculation_Indirect_Branch:\t");
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

Patches currently in -mm which might be from amistry@google.com are

proc-provide-details-on-indirect-branch-speculation.patch

