Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DCE9C77B78
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 21:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjDUVzV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 17:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbjDUVzU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 17:55:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA2010FF
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 14:55:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4053665343
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 21:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B521C433EF;
        Fri, 21 Apr 2023 21:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682114118;
        bh=NEcAgpQhVZLzOMj1YpEg0tmisJ7QdmcmY4hs43AdU8U=;
        h=Date:To:From:Subject:From;
        b=V1wwRnNyrUpS4xsVP3BRz/EmC1hM/Ws9Ak5Qt+ggZLIk5wLixb/h5eX+YSWrH0Gdd
         b6HNlpzCqhX4lOWybkfISGGazbMs+mNE5LKAn5KOoExaE4pTr4vxRu/k4SgaZKYV4M
         ZECXaBxUu0AabZcn9EnMll9jWQh9FOQqISA5GQ/s=
Date:   Fri, 21 Apr 2023 14:55:18 -0700
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, corbet@lwn.net,
        adobriyan@gmail.com, fullspring2018@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-proc-add-kthread-flag-to-proc-pid-status.patch removed from -mm tree
Message-Id: <20230421215518.9B521C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/proc: add Kthread flag to /proc/$pid/status
has been removed from the -mm tree.  Its filename was
     fs-proc-add-kthread-flag-to-proc-pid-status.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


