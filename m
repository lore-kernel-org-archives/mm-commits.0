Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2072C2A1BF
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 00:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756167995; cv=none; b=aKLoPNKRIbU782hlvgP147WeM6IOhw1qQZSomuMojycQQ5rde6I80HpRxanEDdPt0Ga/2SazRPjBxbuStxzyGh/NdTBwUEv42SMGrYuU9sNHRUeOlbRB/khJv7fZjhSI+unWxWPhCgoJpPiXebM7XbmD3p/9Dw51PZhRV0JpudU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756167995; c=relaxed/simple;
	bh=ROAH+mDKm12b55XwWptx9bbEuvUSbYLV3fqddrAm8AE=;
	h=Date:To:From:Subject:Message-Id; b=BHytXYXrh3IPPIKhqgkYme8H6wHZ4BW2dQAFg9/9HxKb7Jkk6UTebtWbGJELUyCEeNBzmKQ9g04trbernsT9/yTOKVyUpouKG7HGefD4/a8gTHbVzxhOnVP0dU1FkNrW/x9NizeC+2fS/XoxJUd54X3k1XKCdQMxf6wqejgSfUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=encR1ypu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="encR1ypu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E91C116B1;
	Tue, 26 Aug 2025 00:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756167994;
	bh=ROAH+mDKm12b55XwWptx9bbEuvUSbYLV3fqddrAm8AE=;
	h=Date:To:From:Subject:From;
	b=encR1ypu3oBJBGGtSJ6G0vmNIg55psPDNO2TGcEdRQRnVvjYXKoxRITerqv1Md1mT
	 t5VgjhaYh9d46EtWGoDDPzR0qEmJUxoiUEoPL2KbnPmFOJSsZMQuSX+nh8SVjXTodF
	 cZverCxpdaFvYjlE90HUAynDUq3012xUNV44xQQ4=
Date: Mon, 25 Aug 2025 17:26:34 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,yangyicong@hisilicon.com,ville.syrjala@linux.intel.com,vgoyal@redhat.com,tzimmermann@suse.de,tony.luck@intel.com,tj@kernel.org,thorsten.blum@linux.dev,tglx@linutronix.de,sohil.mehta@intel.com,senozhatsky@chromium.org,rostedt@goodmis.org,qianqiang.liu@163.com,pmladek@suse.com,oushixiong@kylinos.cn,namcao@linutronix.de,mingo@kernel.org,max.kellermann@ionos.com,luogengkun@huaweicloud.com,lihuafei1@huawei.com,kees@kernel.org,Jonathan.Cameron@huawei.com,john.ogness@linutronix.de,joel.granados@kernel.org,jgg@ziepe.ca,gpiccoli@igalia.com,dyoung@redhat.com,djwong@kernel.org,dianders@chromium.org,deller@gmx.de,cuiyunhui@bytedance.com,bhe@redhat.com,anna.schumaker@oracle.com,wangjinchao600@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + printk-nbcon-use-panic_on_this_cpu-helper.patch added to mm-nonmm-unstable branch
Message-Id: <20250826002634.97E91C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: printk/nbcon: use panic_on_this_cpu() helper
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     printk-nbcon-use-panic_on_this_cpu-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/printk-nbcon-use-panic_on_this_cpu-helper.patch

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

panic-introduce-helper-functions-for-panic-state.patch
fbdev-use-panic_in_progress-helper.patch
crash_core-use-panic_try_start-in-crash_kexec.patch
panic-use-panic_try_start-in-nmi_panic.patch
panic-use-panic_try_start-in-vpanic.patch
printk-nbcon-use-panic_on_this_cpu-helper.patch
panic-printk-replace-this_cpu_in_panic-with-panic_on_this_cpu.patch
panic-printk-replace-other_cpu_in_panic-with-panic_on_other_cpu.patch
watchdog-skip-checks-when-panic-is-in-progress.patch

