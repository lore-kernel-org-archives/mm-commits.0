Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA05C761A6
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 20:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjCUUIq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 16:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjCUUIp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 16:08:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF8765BA
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 13:08:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32B73B81984
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 20:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5389C433EF;
        Tue, 21 Mar 2023 20:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679429319;
        bh=++//UDwTJXqCwHG+tDatNUGUD6s5H93eolbb2BjO7MQ=;
        h=Date:To:From:Subject:From;
        b=Vo2Ne3Wjtd9P8xUuhUfN/wGfKui+6Ldg0FAY8Xs5K4PBv2eeJKMGlP1ofUikoVA1l
         Xh11w5z9cL+HD9r248+/Yl7exP6tSBnEt56aLMYWDaElBYelryUxzTsRfnG38AMui/
         T18csDkU0FWNTzxF49v9Whe1kXMuk+SqRMni9Xfg=
Date:   Tue, 21 Mar 2023 13:08:39 -0700
To:     mm-commits@vger.kernel.org, kbingham@kernel.org,
        jan.kiszka@siemens.com, liupeng17@lenovo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-lx-timerlist-for-python3.patch added to mm-nonmm-unstable branch
Message-Id: <20230321200839.C5389C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix lx-timerlist for Python3
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-fix-lx-timerlist-for-python3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-lx-timerlist-for-python3.patch

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
From: Peng Liu <liupeng17@lenovo.com>
Subject: scripts/gdb: fix lx-timerlist for Python3
Date: Tue, 21 Mar 2023 14:19:29 +0800

Below incompatibilities between Python2 and Python3 made lx-timerlist fail
to run under Python3.

o xrange() is replaced by range() in Python3
o bytes and str are different types in Python3
o the return value of Inferior.read_memory() is memoryview object in
  Python3

Link: https://lkml.kernel.org/r/Message-ID:
Signed-off-by: Peng Liu <liupeng17@lenovo.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/timerlist.py |    4 +++-
 scripts/gdb/linux/utils.py     |    5 ++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/scripts/gdb/linux/timerlist.py~scripts-gdb-fix-lx-timerlist-for-python3
+++ a/scripts/gdb/linux/timerlist.py
@@ -72,7 +72,7 @@ def print_cpu(hrtimer_bases, cpu, max_cl
     ts = cpus.per_cpu(tick_sched_ptr, cpu)
 
     text = "cpu: {}\n".format(cpu)
-    for i in xrange(max_clock_bases):
+    for i in range(max_clock_bases):
         text += " clock {}:\n".format(i)
         text += print_base(cpu_base['clock_base'][i])
 
@@ -157,6 +157,8 @@ def pr_cpumask(mask):
     num_bytes = (nr_cpu_ids + 7) / 8
     buf = utils.read_memoryview(inf, bits, num_bytes).tobytes()
     buf = binascii.b2a_hex(buf)
+    if type(buf) is not str:
+        buf=buf.decode()
 
     chunks = []
     i = num_bytes
--- a/scripts/gdb/linux/utils.py~scripts-gdb-fix-lx-timerlist-for-python3
+++ a/scripts/gdb/linux/utils.py
@@ -88,7 +88,10 @@ def get_target_endianness():
 
 
 def read_memoryview(inf, start, length):
-    return memoryview(inf.read_memory(start, length))
+    m = inf.read_memory(start, length)
+    if type(m) is memoryview:
+        return m
+    return memoryview(m)
 
 
 def read_u16(buffer, offset):
_

Patches currently in -mm which might be from liupeng17@lenovo.com are

scripts-gdb-fix-lx-timerlist-for-struct-timequeue_head-change.patch
scripts-gdb-fix-lx-timerlist-for-python3.patch
scripts-gdb-fix-lx-timerlist-for-hrtimer_max_clock_bases-printing.patch

