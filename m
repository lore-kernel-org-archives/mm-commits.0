Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AB92CA5
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 01:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714958105; cv=none; b=PcAVRnVyh3WB+6ZsyB20rR/e0V3OqJ6xHbiGnM61AuFNoODPSrEchUlhWyqw8CvewrIlx8GUfFRQVG+TESmUxOJ/KcfXTl7avKXWzTEYdhK3n48C6FB8m+PCVdXfptSymFy1SFuLN0Nv7qwoj0AKvfZsUP8GET139DZI/3TkWjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714958105; c=relaxed/simple;
	bh=PJsaIDgSX5D4XqS8wq2cqeMwL19iljHLvC03uB8V9iY=;
	h=Date:To:From:Subject:Message-Id; b=aME9R/okZCa7dqcR3SdnQ3VdZvH+btxQVnvkQMWhQwH3yMs0FA71SaVDKty0X1G8c+G+I/+8kZ1UstW69M9EXYSsDBRfAVuJOC0myE6uObqnsMFcod1dmH7L3tnV6VU29im+KOaY19Su5IOEb2+do8Pfn3jBSEx4XySMLtVVbsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZKeoU9Xd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZKeoU9Xd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E9DC113CC;
	Mon,  6 May 2024 01:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714958105;
	bh=PJsaIDgSX5D4XqS8wq2cqeMwL19iljHLvC03uB8V9iY=;
	h=Date:To:From:Subject:From;
	b=ZKeoU9XdmdwcRqQiE86x7klzi8mW3kWAPvZbruaMAnu98FpDBTotNzYv/aQIiXnly
	 2c1EUMI/SkJ9NGNBLODglnKrdS/V1if9ftnHh+VQ7Gn5INxd3AOU4oArIgTyUM9tQt
	 vpn8hZTCgIWD8uNbR1AqV7Rrbf4q5c9HDOvXJBEA=
Date: Sun, 05 May 2024 18:15:04 -0700
To: mm-commits@vger.kernel.org,palmer@rivosinc.com,Kuan-Ying.Lee@mediatek.com,kbingham@kernel.org,jan.kiszka@siemens.com,debug@rivosinc.com,ajones@ventanamicro.com,mail@florommel.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-fix-failing-kgdb-detection-during-probe.patch removed from -mm tree
Message-Id: <20240506011505.72E9DC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: fix failing KGDB detection during probe
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-failing-kgdb-detection-during-probe.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Florian Rommel <mail@florommel.de>
Subject: scripts/gdb: fix failing KGDB detection during probe
Date: Thu, 25 Apr 2024 17:34:58 +0200

Patch series "scripts/gdb: Fixes for $lx_current and $lx_per_cpu".

This series fixes several bugs in the GDB scripts related to the
$lx_current and $lx_per_cpu functions.  The changes were tested with GDB
10, 11, 12, 13, and 14.

Patch 1 fixes false-negative results when probing for KGDB

Patch 2 fixes the $lx_per_cpu function, which is currently non-functional
in QEMU-GDB and KGDB.

Patch 3 fixes an additional bug in $lx_per_cpu that occurs with KGDB.

Patch 4 fixes the incorrect detection of the current CPU number in KGDB,
which silently breaks $lx_per_cpu and $lx_current.


This patch (of 4):

The KGDB probe function sometimes failed to detect KGDB for SMP machines
as it assumed that task 2 (kthreadd) is running on CPU 0, which is not
necessarily the case.  Now, the detection is agnostic to kthreadd's CPU.

Link: https://lkml.kernel.org/r/20240425153501.749966-1-mail@florommel.de
Link: https://lkml.kernel.org/r/20240425153501.749966-2-mail@florommel.de
Signed-off-by: Florian Rommel <mail@florommel.de>
Cc: Andrew Jones <ajones@ventanamicro.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/utils.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/utils.py~scripts-gdb-fix-failing-kgdb-detection-during-probe
+++ a/scripts/gdb/linux/utils.py
@@ -196,7 +196,7 @@ def get_gdbserver_type():
     def probe_kgdb():
         try:
             thread_info = gdb.execute("info thread 2", to_string=True)
-            return "shadowCPU0" in thread_info
+            return "shadowCPU" in thread_info
         except gdb.error:
             return False
 
_

Patches currently in -mm which might be from mail@florommel.de are


