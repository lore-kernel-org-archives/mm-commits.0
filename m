Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E601D14E2F2
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810144; cv=none; b=FUigy/XBvZKEjLLTu3FqZ5fZb2op0xuW8ZFyPGFw6VAO5M0sNmlxShlsNeIAiRMCCVUvGekv6BahpPqBKHZiwEg+Ctk5kiIorylsqqc432jgZ2Nqn2ivTYDN50o0Dh/lysDKm53GulsZS7Pa8zo7Vma3d+vyNxxTmZLOgXCIeRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810144; c=relaxed/simple;
	bh=t6k+0/sAf0pQACE2vfJgCfNisuBvUkMmFYhiLi9b+dw=;
	h=Date:To:From:Subject:Message-Id; b=SXxSuPML2wzKHaM1cRfYy3GsOLNFwNXmNKxirVNj+LtYa26TpMGPhpTHprss6arTTbebYwkjqKiwYqlJQffHDq2mCDr7EKnZBzLJpge2SRZZ/LmTWQ7NVT3Al17RnfnS4HKHqiP9T8vgCCMeacOPyIMmgQ0Q62J/RidgzJ8hlPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jhm8DgVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jhm8DgVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DECC4CEEB;
	Sun, 14 Sep 2025 00:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810143;
	bh=t6k+0/sAf0pQACE2vfJgCfNisuBvUkMmFYhiLi9b+dw=;
	h=Date:To:From:Subject:From;
	b=jhm8DgVl2o1hi8I4g2KIpxQY3qhrOvFQhbiEzW2yqyMIRkQy6SSOF4XiNTeMSVyT/
	 oIsiWKuC6LIF/0woKqg35lvT77REIPh/I/Ez2AenkrO6zC0ZFa4L8SNTmTw4TKvIcW
	 qeaUOOiwgPCWKoSQUWwd+A8Myi7VfXpwFEi0AI2c=
Date: Sat, 13 Sep 2025 17:35:42 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,yangyicong@hisilicon.com,ville.syrjala@linux.intel.com,vgoyal@redhat.com,tzimmermann@suse.de,tony.luck@intel.com,tj@kernel.org,thorsten.blum@linux.dev,tglx@linutronix.de,sohil.mehta@intel.com,senozhatsky@chromium.org,rostedt@goodmis.org,qianqiang.liu@163.com,pmladek@suse.com,oushixiong@kylinos.cn,namcao@linutronix.de,mingo@kernel.org,max.kellermann@ionos.com,luogengkun@huaweicloud.com,lihuafei1@huawei.com,kees@kernel.org,Jonathan.Cameron@huawei.com,john.ogness@linutronix.de,joel.granados@kernel.org,jgg@ziepe.ca,gpiccoli@igalia.com,dyoung@redhat.com,djwong@kernel.org,dianders@chromium.org,deller@gmx.de,cuiyunhui@bytedance.com,bhe@redhat.com,anna.schumaker@oracle.com,wangjinchao600@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] printk-nbcon-use-panic_on_this_cpu-helper.patch removed from -mm tree
Message-Id: <20250914003543.65DECC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: printk/nbcon: use panic_on_this_cpu() helper
has been removed from the -mm tree.  Its filename was
     printk-nbcon-use-panic_on_this_cpu-helper.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinchao Wang <wangjinchao600@gmail.com>
Subject: printk/nbcon: use panic_on_this_cpu() helper
Date: Mon, 25 Aug 2025 10:29:34 +0800

nbcon_context_try_acquire() compared panic_cpu directly with
smp_processor_id().  This open-coded check is now provided by
panic_on_this_cpu().

Switch to panic_on_this_cpu() to simplify the code and improve readability.

Link: https://lkml.kernel.org/r/20250825022947.1596226-7-wangjinchao600@gmail.com
Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Kees Cook <kees@kernel.org>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Luo Gengkun <luogengkun@huaweicloud.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Nam Cao <namcao@linutronix.de>
Cc: oushixiong <oushixiong@kylinos.cn>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Qianqiang Liu <qianqiang.liu@163.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Sohil Mehta <sohil.mehta@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/nbcon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/printk/nbcon.c~printk-nbcon-use-panic_on_this_cpu-helper
+++ a/kernel/printk/nbcon.c
@@ -2,6 +2,7 @@
 // Copyright (C) 2022 Linutronix GmbH, John Ogness
 // Copyright (C) 2022 Intel, Thomas Gleixner
 
+#include "linux/panic.h"
 #include <linux/atomic.h>
 #include <linux/bug.h>
 #include <linux/console.h>
@@ -589,7 +590,6 @@ static struct printk_buffers panic_nbcon
  */
 static bool nbcon_context_try_acquire(struct nbcon_context *ctxt, bool is_reacquire)
 {
-	unsigned int cpu = smp_processor_id();
 	struct console *con = ctxt->console;
 	struct nbcon_state cur;
 	int err;
@@ -614,7 +614,7 @@ out:
 	/* Acquire succeeded. */
 
 	/* Assign the appropriate buffer for this context. */
-	if (atomic_read(&panic_cpu) == cpu)
+	if (panic_on_this_cpu())
 		ctxt->pbufs = &panic_nbcon_pbufs;
 	else
 		ctxt->pbufs = con->pbufs;
_

Patches currently in -mm which might be from wangjinchao600@gmail.com are


