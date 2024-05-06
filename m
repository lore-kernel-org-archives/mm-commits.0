Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA532CA5
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 01:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714958106; cv=none; b=mR9KOaa2i4HCjdEUE6D3l5DX+aTWEuSTEK4ykNZmYpn864wSUvlknKctpYhwjedUigeuJ/rRWYRIpLKkTLqki9TY7HkoB6wAPqWe1rsFDa8MUx2xEv9SCS2t4kgWjtmvfwRI+RaGEzuAqc4L2EIkiAFIQJuNBIC35Y3Mi8+I4pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714958106; c=relaxed/simple;
	bh=4Noc0nvhxdP9mt0JQsjgYpxO3acYkjjMgl04HubeFAk=;
	h=Date:To:From:Subject:Message-Id; b=P8Ey3HHRLKJoUIC7W9Hob45GfUivVhBmODTrx+BEVQkhGt6C9+ZA6pWuWYX9iE+dOY+nc2sNaqvbzvTOqlPdGYlLVO392fV2OWXZcIjtv3OWk9d9N0BLYq7j0KAXcdS1FlqqyfQ9gMZBULSON64H/KFTnrfbTNcLUcF+C7PqbUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N8INywQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N8INywQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834B4C116B1;
	Mon,  6 May 2024 01:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714958106;
	bh=4Noc0nvhxdP9mt0JQsjgYpxO3acYkjjMgl04HubeFAk=;
	h=Date:To:From:Subject:From;
	b=N8INywQrJDjTqMb7dPgUFYqHcG9rNOFf17z2C70WohqXagJADUsKG3nKKNTPIEbI8
	 roa4NNToVQSRpvecJmX/+AURf3Zs0kb1tNPooftiKBKSOEh1NpjQOw+aF3NnrzX+P8
	 hXopNEpOxCQuth409VYOA+SO836MIcVH7zp2shio=
Date: Sun, 05 May 2024 18:15:06 -0700
To: mm-commits@vger.kernel.org,palmer@rivosinc.com,Kuan-Ying.Lee@mediatek.com,kbingham@kernel.org,jan.kiszka@siemens.com,debug@rivosinc.com,ajones@ventanamicro.com,mail@florommel.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-fix-parameter-handling-in-lx_per_cpu.patch removed from -mm tree
Message-Id: <20240506011506.834B4C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: fix parameter handling in $lx_per_cpu
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-parameter-handling-in-lx_per_cpu.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Florian Rommel <mail@florommel.de>
Subject: scripts/gdb: fix parameter handling in $lx_per_cpu
Date: Thu, 25 Apr 2024 17:34:59 +0200

Before, the script tried to get the address by constructing a pointer to
the parameter (by name).  However, since GDB now passes the parameter as a
GdbValue, we cannot get its name.  Instead, we retrieve the address
through GdbValue's address attribute.

Before:
>>> p $lx_per_cpu(cpu_info)
Traceback (most recent call last):
  File "./scripts/gdb/linux/cpus.py", line 152, in invoke
    var_ptr = gdb.parse_and_eval("&" + var_name.string())
                                       ^^^^^^^^^^^^^^^^^
gdb.error: Trying to read string with inappropriate type `struct cpuinfo_x86'.

Link: https://lkml.kernel.org/r/20240425153501.749966-3-mail@florommel.de
Signed-off-by: Florian Rommel <mail@florommel.de>
Cc: Andrew Jones <ajones@ventanamicro.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/cpus.py |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/scripts/gdb/linux/cpus.py~scripts-gdb-fix-parameter-handling-in-lx_per_cpu
+++ a/scripts/gdb/linux/cpus.py
@@ -152,9 +152,8 @@ Note that VAR has to be quoted as string
     def __init__(self):
         super(PerCpu, self).__init__("lx_per_cpu")
 
-    def invoke(self, var_name, cpu=-1):
-        var_ptr = gdb.parse_and_eval("&" + var_name.string())
-        return per_cpu(var_ptr, cpu)
+    def invoke(self, var, cpu=-1):
+        return per_cpu(var.address, cpu)
 
 
 PerCpu()
_

Patches currently in -mm which might be from mail@florommel.de are


