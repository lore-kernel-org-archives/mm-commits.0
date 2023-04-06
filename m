Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B0EC7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbjDFCyb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235043AbjDFCxc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA179900C
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:53:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41D5364227
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9933BC433EF;
        Thu,  6 Apr 2023 02:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749593;
        bh=NnPLxOzFw/cuB07TdmemFkL7yVqq6yoHEdz0AyXVnHg=;
        h=Date:To:From:Subject:From;
        b=pZxjlLiQEXH8gHa54kh2hI3ed662oO9ZFmAsDZMxLbxM03N+ndI65/EwJCNcCus3x
         U3NaJWt72Hm0NTLok5CpiQJxwLEmlDQMFOLxmG7fr+HHMLANtMFQoJ9uXwaWFq+Ruo
         9Z6/K5nU8kEo7mrV18Vx313SV69NLzUpszNQwnY4=
Date:   Wed, 05 Apr 2023 19:53:13 -0700
To:     mm-commits@vger.kernel.org, kbingham@kernel.org,
        jan.kiszka@siemens.com, liupeng17@lenovo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-fix-lx-timerlist-for-python3.patch removed from -mm tree
Message-Id: <20230406025313.9933BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: fix lx-timerlist for Python3
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-lx-timerlist-for-python3.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


