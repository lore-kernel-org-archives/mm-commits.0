Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA153EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905012; cv=none; b=WG+RB2Ob6lyoFDtddWZtviHNfLm7+gJ1tKwcasXpn+7fTelHNO0mI2StkVCzGobpiofJaC3RJwkPpieg9oHqgwqX0mPxkv2wE3S/A/rURuFoEPmjeCRXEhfJ4bNcjt9eV7gMymXDzniqCRz4onuKIh8cqSch3btD5EmSjx+h4fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905012; c=relaxed/simple;
	bh=JLuAigMLv08EIry69DVB7pJuBzrRZ08Oq0GgGkC+zZ4=;
	h=Date:To:From:Subject:Message-Id; b=R/56uQ/FWu6A3ZKldgv1OhFAE+aCYgbaXLo6nKNtPJQmJzzSHV2G3M+yRqsclDk4LVAx7mtjvQz/5pE2eLdYFVGmxBo1elS09IR2DiNKh2034m19VnMIwu26Yyd3aJsrou+kr2gGPA3at3Ns1hTioLkKw0vdU30hzecivgm66Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rsVbwRL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rsVbwRL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CE5C4CEF1;
	Sun,  1 Feb 2026 00:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905011;
	bh=JLuAigMLv08EIry69DVB7pJuBzrRZ08Oq0GgGkC+zZ4=;
	h=Date:To:From:Subject:From;
	b=rsVbwRL8AqjMqFOEiSB333+HY8zgL5GyVwgs6N3HqkJ59wrer6w1mkf8WWnxjv+gj
	 eK6lHEVR+edqAqHDd9sdwCw8TzrSAeglWNLR75ZlKVX848RIEPCW5/ykpKC2eLL+7X
	 NSAtkK2xy1T38dqIPMEpTSMgy6bNKfpEnYrriPLk=
Date: Sat, 31 Jan 2026 16:16:51 -0800
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,rdunlap@infradead.org,petr.pavlu@suse.com,joelagnelf@nvidia.com,jani.nikula@intel.com,gregkh@linuxfoundation.org,chleroy@kernel.org,atomlin@atomlin.com,andriy.shevchenko@linux.intel.com,andi.shyti@linux.intel.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernelh-include-linux-instruction_pointerh-explicitly.patch removed from -mm tree
Message-Id: <20260201001651.C5CE5C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel.h: include linux/instruction_pointer.h explicitly
has been removed from the -mm tree.  Its filename was
     kernelh-include-linux-instruction_pointerh-explicitly.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yury Norov <ynorov@nvidia.com>
Subject: kernel.h: include linux/instruction_pointer.h explicitly
Date: Thu, 15 Jan 2026 23:25:07 -0500

In preparation for decoupling linux/instruction_pointer.h and
linux/kernel.h, include instruction_pointer.h explicitly where needed.

Link: https://lkml.kernel.org/r/20260116042510.241009-5-ynorov@nvidia.com
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/processor.h |    1 +
 include/linux/ww_mutex.h          |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/s390/include/asm/processor.h~kernelh-include-linux-instruction_pointerh-explicitly
+++ a/arch/s390/include/asm/processor.h
@@ -31,6 +31,7 @@
 #include <linux/cpumask.h>
 #include <linux/linkage.h>
 #include <linux/irqflags.h>
+#include <linux/instruction_pointer.h>
 #include <linux/bitops.h>
 #include <asm/fpu-types.h>
 #include <asm/cpu.h>
--- a/include/linux/ww_mutex.h~kernelh-include-linux-instruction_pointerh-explicitly
+++ a/include/linux/ww_mutex.h
@@ -17,6 +17,7 @@
 #ifndef __LINUX_WW_MUTEX_H
 #define __LINUX_WW_MUTEX_H
 
+#include <linux/instruction_pointer.h>
 #include <linux/mutex.h>
 #include <linux/rtmutex.h>
 
_

Patches currently in -mm which might be from ynorov@nvidia.com are


