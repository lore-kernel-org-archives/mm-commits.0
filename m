Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B40149C69;
	Mon,  2 Sep 2024 03:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248785; cv=none; b=HeHjFhgFDlaCv/Jw84FILwQPikAKRDvWYZitcZ5Nvc/OU5ZxPMSNaR6i0tW3Q/LA1PpUV6r9SSMXauIc2i5EqQpWkrwD1c0Gi7JXu8RB9enYTbq1zOv0zZ2PERgKvoGfSFKZXpcRanlvNMZ4BlzUNQjkmU9IMWBfG+V+KBCm0kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248785; c=relaxed/simple;
	bh=x+bcvbZkG757CNKuZt90iGpdSojdnNJunkJf3IVnZP0=;
	h=Date:To:From:Subject:Message-Id; b=pYX1OCgZelbTK9k5MErY350kKxAQPnuEzTsDl1TQbTF7DjSU+qKarJoJVnHl/zQ1vscRhv3tFDvU9PVgOA/VIFfuPtDYoHmke5AfmF7EnA0xa+1S7u2t9I8vSKaZNNJKMBde4IEuAL25LgUJzA0gg0eZEj+/rClavHUQSWFNWlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P49izUIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P49izUIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F1BC4CEC2;
	Mon,  2 Sep 2024 03:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248783;
	bh=x+bcvbZkG757CNKuZt90iGpdSojdnNJunkJf3IVnZP0=;
	h=Date:To:From:Subject:From;
	b=P49izUIwtNRGy/kpMSbTF0jC5Ab9uCsL08Pd7sHrkLH2WDxjOarGU47VxtwOtLRcY
	 WmYyxAdAHKl/DcUn/W3/ZKV1X1+8bUN1H+5MZgCy5R7wGCAoczhfIWsLF93Ffdl09D
	 2kTjcI2zLlnCsxq8QbVlZIbILpG82akrwVIlZmW4=
Date: Sun, 01 Sep 2024 20:46:22 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-fix-timerlist-parsing-issue.patch removed from -mm tree
Message-Id: <20240902034623.71F1BC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: fix timerlist parsing issue
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-timerlist-parsing-issue.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Subject: scripts/gdb: fix timerlist parsing issue
Date: Tue, 23 Jul 2024 14:48:57 +0800

Patch series "Fix some GDB command error and add some GDB commands", v3.

Fix some GDB command errors and add some useful GDB commands.


This patch (of 5):

Commit 7988e5ae2be7 ("tick: Split nohz and highres features from
nohz_mode") and commit 7988e5ae2be7 ("tick: Split nohz and highres
features from nohz_mode") move 'tick_stopped' and 'nohz_mode' to flags
field which will break the gdb lx-mounts command:

(gdb) lx-timerlist
Python Exception <class 'gdb.error'>: There is no member named nohz_mode.
Error occurred in Python: There is no member named nohz_mode.

(gdb) lx-timerlist
Python Exception <class 'gdb.error'>: There is no member named tick_stopped.
Error occurred in Python: There is no member named tick_stopped.

We move 'tick_stopped' and 'nohz_mode' to flags field instead.

Link: https://lkml.kernel.org/r/20240723064902.124154-1-kuan-ying.lee@canonical.com
Link: https://lkml.kernel.org/r/20240723064902.124154-2-kuan-ying.lee@canonical.com
Fixes: a478ffb2ae23 ("tick: Move individual bit features to debuggable mask accesses")
Fixes: 7988e5ae2be7 ("tick: Split nohz and highres features from nohz_mode")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/timerlist.py |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/scripts/gdb/linux/timerlist.py~scripts-gdb-fix-timerlist-parsing-issue
+++ a/scripts/gdb/linux/timerlist.py
@@ -87,21 +87,22 @@ def print_cpu(hrtimer_bases, cpu, max_cl
             text += "\n"
 
         if constants.LX_CONFIG_TICK_ONESHOT:
-            fmts = [("  .{}      : {}", 'nohz_mode'),
-                    ("  .{}      : {} nsecs", 'last_tick'),
-                    ("  .{}   : {}", 'tick_stopped'),
-                    ("  .{}   : {}", 'idle_jiffies'),
-                    ("  .{}     : {}", 'idle_calls'),
-                    ("  .{}    : {}", 'idle_sleeps'),
-                    ("  .{} : {} nsecs", 'idle_entrytime'),
-                    ("  .{}  : {} nsecs", 'idle_waketime'),
-                    ("  .{}  : {} nsecs", 'idle_exittime'),
-                    ("  .{} : {} nsecs", 'idle_sleeptime'),
-                    ("  .{}: {} nsecs", 'iowait_sleeptime'),
-                    ("  .{}   : {}", 'last_jiffies'),
-                    ("  .{}     : {}", 'next_timer'),
-                    ("  .{}   : {} nsecs", 'idle_expires')]
-            text += "\n".join([s.format(f, ts[f]) for s, f in fmts])
+            TS_FLAG_STOPPED = 1 << 1
+            TS_FLAG_NOHZ = 1 << 4
+            text += f"  .{'nohz':15s}: {int(bool(ts['flags'] & TS_FLAG_NOHZ))}\n"
+            text += f"  .{'last_tick':15s}: {ts['last_tick']}\n"
+            text += f"  .{'tick_stopped':15s}: {int(bool(ts['flags'] & TS_FLAG_STOPPED))}\n"
+            text += f"  .{'idle_jiffies':15s}: {ts['idle_jiffies']}\n"
+            text += f"  .{'idle_calls':15s}: {ts['idle_calls']}\n"
+            text += f"  .{'idle_sleeps':15s}: {ts['idle_sleeps']}\n"
+            text += f"  .{'idle_entrytime':15s}: {ts['idle_entrytime']} nsecs\n"
+            text += f"  .{'idle_waketime':15s}: {ts['idle_waketime']} nsecs\n"
+            text += f"  .{'idle_exittime':15s}: {ts['idle_exittime']} nsecs\n"
+            text += f"  .{'idle_sleeptime':15s}: {ts['idle_sleeptime']} nsecs\n"
+            text += f"  .{'iowait_sleeptime':15s}: {ts['iowait_sleeptime']} nsecs\n"
+            text += f"  .{'last_jiffies':15s}: {ts['last_jiffies']}\n"
+            text += f"  .{'next_timer':15s}: {ts['next_timer']}\n"
+            text += f"  .{'idle_expires':15s}: {ts['idle_expires']} nsecs\n"
             text += "\njiffies: {}\n".format(jiffies)
 
         text += "\n"
_

Patches currently in -mm which might be from kuan-ying.lee@canonical.com are


