Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795041494D6;
	Tue, 23 Jul 2024 23:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721778039; cv=none; b=Ue9XLIsQ8m86A+xCCGPMLpg3vb1kv+wdxFfah+rNSN8oot7ZmBVg4HNZLgdm6yfBHM7obWorcPzzjvA7BnnQlUJy6sS6aT6ZIpo7kBCRAZg5sb2eGl9oEofR+sgylhEv7cp9ZTpU8+XUKjh1OEipEEaLODT/3kiHvRoeh8BYDYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721778039; c=relaxed/simple;
	bh=FKAxem+pnGcx+D/lyPGm78QGoUagqEr9ao35pFOmuIU=;
	h=Date:To:From:Subject:Message-Id; b=Y4i9/hmcJzipPOAhmHkJWSn9ovZqjMfS79F/EwPLwJCeIszSw9p8mcEWpNPgoTukfiPhelSegCfaPp56EDQ+rdaOqzeKNpzsfzeId83VY9yy0m6eY9n0VAdOlWxDQ50RLKq8m7v5Ii17Pmy5NSPTp2pSQEyg5n5EeyFt8UFoIzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tFNC4olP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tFNC4olP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CFEC4AF0A;
	Tue, 23 Jul 2024 23:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721778039;
	bh=FKAxem+pnGcx+D/lyPGm78QGoUagqEr9ao35pFOmuIU=;
	h=Date:To:From:Subject:From;
	b=tFNC4olPhOiI040JHZwceVBluiX89f+PU0+ed8vHx1ge766zadNYuwT2hCCnTnzCI
	 +isoM8i2K8Vxshq9A06/umqUpOq8BoyrLP4NUpC7SSpAcV1D5J0NPgjue0zV0QWCOm
	 3FmoZEsZtWJ3J8bYdeVWAMlzcFdq8qKteJgys4wM=
Date: Tue, 23 Jul 2024 16:40:38 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-timerlist-parsing-issue.patch added to mm-nonmm-unstable branch
Message-Id: <20240723234038.F1CFEC4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: fix timerlist parsing issue
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-fix-timerlist-parsing-issue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-timerlist-parsing-issue.patch

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

scripts-gdb-fix-timerlist-parsing-issue.patch
scripts-gdb-add-iteration-function-for-rbtree.patch
scripts-gdb-fix-lx-mounts-command-error.patch
scripts-gdb-add-lx-stack_depot_lookup-command.patch
scripts-gdb-add-lx-kasan_mem_to_shadow-command.patch

