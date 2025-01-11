Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2190C5C96;
	Sat, 11 Jan 2025 00:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736555609; cv=none; b=fFm0Ig+38M4ox+e+7LX65RL2puEdf6wsD/9PERw78Jy00+DBKR2WUXJV24RCsFKZ3keiIlObIv4/vPZ1uv2ngbTDEpWpW7aa2cu7hx3BJrINsRmiAvS7whb2npBz7vFryAQ5FsyvDtYiEXFfGlKi000IGiwSIk0H8pulWR1bk0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736555609; c=relaxed/simple;
	bh=NNpi/QIv4UBU2vxyZUyPXHVZCWRgX7q7A6/qOmyogjw=;
	h=Date:To:From:Subject:Message-Id; b=IALn8GJbCxEB0UVL6OyM9tY1XYYfhHbaW9uV3+adCyYQf/YUnNQi4YHpps+xy1QXEnV7NgNPXpzyFANqzeeC17Dotnkbphk2H16KJSWbXK01koVV4FeYe9B9w1XXMHHjD14BA5gWm1mV7MB/GXYjeIQi41YmpV3u3RsQfdI07bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bFFAflOm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bFFAflOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCEFC4CED6;
	Sat, 11 Jan 2025 00:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736555608;
	bh=NNpi/QIv4UBU2vxyZUyPXHVZCWRgX7q7A6/qOmyogjw=;
	h=Date:To:From:Subject:From;
	b=bFFAflOmeJTlgCoVdFjZfukKhop10P4Zp1xBVMODqzlerpn+ekcT3zOOSCCd/eZsR
	 0s6/DG7EEsMEjDa+OCnu3/izkL2sG/RBlCj3dQ20FkLielF7oWxariXk14f5Agm0qs
	 0P1RDgBdbZYx6lXdiBcK211rc4pWZwIhBkiCkgfQ=
Date: Fri, 10 Jan 2025 16:33:28 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kbingham@kernel.org,baohua@kernel.org,jan.kiszka@siemens.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-aarch64-userspace-detection-in-get_current_task.patch added to mm-hotfixes-unstable branch
Message-Id: <20250111003328.8BCEFC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: fix aarch64 userspace detection in get_current_task
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-gdb-fix-aarch64-userspace-detection-in-get_current_task.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-aarch64-userspace-detection-in-get_current_task.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: fix aarch64 userspace detection in get_current_task
Date: Fri, 10 Jan 2025 11:36:33 +0100

At least recent gdb releases (seen with 14.2) return SP_EL0 as signed long
which lets the right-shift always return 0.

Link: https://lkml.kernel.org/r/dcd2fabc-9131-4b48-8419-6444e2d67454@siemens.com
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/cpus.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/cpus.py~scripts-gdb-fix-aarch64-userspace-detection-in-get_current_task
+++ a/scripts/gdb/linux/cpus.py
@@ -167,7 +167,7 @@ def get_current_task(cpu):
             var_ptr = gdb.parse_and_eval("&pcpu_hot.current_task")
             return per_cpu(var_ptr, cpu).dereference()
     elif utils.is_target_arch("aarch64"):
-        current_task_addr = gdb.parse_and_eval("$SP_EL0")
+        current_task_addr = gdb.parse_and_eval("(unsigned long)$SP_EL0")
         if (current_task_addr >> 63) != 0:
             current_task = current_task_addr.cast(task_ptr_type)
             return current_task.dereference()
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

scripts-gdb-fix-aarch64-userspace-detection-in-get_current_task.patch

