Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0838DC77B72
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 01:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjDRBYn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Apr 2023 21:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjDRBYm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Apr 2023 21:24:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50BA44AE
        for <mm-commits@vger.kernel.org>; Mon, 17 Apr 2023 18:24:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B33062B83
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 01:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC29C4339E;
        Tue, 18 Apr 2023 01:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681781078;
        bh=HrrTY6uSYwFDlfOD4X5lQbp9yBF2S3bTsfmqci+qKqU=;
        h=Date:To:From:Subject:From;
        b=hzmAKODK6qZUCFHipsLYmBNjIOfOgIavkUBzZYuwqwu+3NsL6BA4dRuB7/V+WIUzw
         Bq3WoHpeTfIDsmtVUrauaeJB7wohb5TeMiS+7C/yEBKaK5f1vINLQ5Cg6H2RCxkYoq
         DWH2FFPjkucX41RFSSdK8im7p9qrjg/gTzb38vMc=
Date:   Mon, 17 Apr 2023 18:24:37 -0700
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, corbet@lwn.net,
        adobriyan@gmail.com, fullspring2018@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-add-kthread-flag-to-proc-pid-status.patch added to mm-nonmm-unstable branch
Message-Id: <20230418012438.8DC29C4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc: add Kthread flag to /proc/$pid/status
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-proc-add-kthread-flag-to-proc-pid-status.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-add-kthread-flag-to-proc-pid-status.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Chunguang Wu <fullspring2018@gmail.com>
Subject: fs/proc: add Kthread flag to /proc/$pid/status
Date: Sun, 16 Apr 2023 13:24:04 +0800

The command `ps -ef ` and `top -c` mark kernel thread by '[' and ']', but
sometimes the result is not correct.  The task->flags in /proc/$pid/stat
is good, but we need remember the value of PF_KTHREAD is 0x00200000 and
convert dec to hex.  If we have no binary program and shell script which
read /proc/$pid/stat, we can know it directly by `cat /proc/$pid/status`.

Link: https://lkml.kernel.org/r/20230416052404.2920-1-fullspring2018@gmail.com
Signed-off-by: Chunguang Wu <fullspring2018@gmail.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    2 ++
 fs/proc/array.c                    |    2 ++
 2 files changed, 4 insertions(+)

--- a/Documentation/filesystems/proc.rst~fs-proc-add-kthread-flag-to-proc-pid-status
+++ a/Documentation/filesystems/proc.rst
@@ -179,6 +179,7 @@ read the file /proc/PID/status::
   Gid:    100     100     100     100
   FDSize: 256
   Groups: 100 14 16
+  Kthread:    0
   VmPeak:     5004 kB
   VmSize:     5004 kB
   VmLck:         0 kB
@@ -256,6 +257,7 @@ It's slow but very precise.
  NSpid                       descendant namespace process ID hierarchy
  NSpgid                      descendant namespace process group ID hierarchy
  NSsid                       descendant namespace session ID hierarchy
+ Kthread                     kernel thread flag, 1 is yes, 0 is no
  VmPeak                      peak virtual memory size
  VmSize                      total program size
  VmLck                       locked memory size
--- a/fs/proc/array.c~fs-proc-add-kthread-flag-to-proc-pid-status
+++ a/fs/proc/array.c
@@ -219,6 +219,8 @@ static inline void task_state(struct seq
 		seq_put_decimal_ull(m, "\t", task_session_nr_ns(p, pid->numbers[g].ns));
 #endif
 	seq_putc(m, '\n');
+
+	seq_printf(m, "Kthread:\t%c\n", p->flags & PF_KTHREAD ? '1' : '0');
 }
 
 void render_sigset_t(struct seq_file *m, const char *header,
_

Patches currently in -mm which might be from fullspring2018@gmail.com are

fs-proc-add-kthread-flag-to-proc-pid-status.patch

