Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12157145329
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810148; cv=none; b=vCNYqUTE4ZKORowKKmtVvbj0XHVIYdKoGYEtXKRtYeQjXMs3aKuqQDOEOGKh4dnhPuzDyixMmdjk1SD5Dh+zCmkCxZK/B1p9yXOO8n29d2NA4CynVqaYOPkEnnxGNWQ5F/JxfRI73ucCLsKI3QERhHrbnz8+S3Azebl2eOG1kTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810148; c=relaxed/simple;
	bh=Iw+UkAWuUPh/ZAZEhqavZygZidJNVJ3Nec/Rtz2c2No=;
	h=Date:To:From:Subject:Message-Id; b=Kk6eTiZ7PSvzmlzB5c9cI2wWuPXedCjVaBwAks/SR94sSBnPr9IWJaCBm/7X3ldTF+FKwsyRhENXC6/KEgGbQvD4ac/HnFJ7TEsS7mHgjyRgf4X8mw1ZaY2HB5gRhBeNMijel6ctDjIlAOqkc/PAjGsRdtP7+3Pbr46ZCVPDANE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qoei99rz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qoei99rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5567C4CEEB;
	Sun, 14 Sep 2025 00:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810147;
	bh=Iw+UkAWuUPh/ZAZEhqavZygZidJNVJ3Nec/Rtz2c2No=;
	h=Date:To:From:Subject:From;
	b=Qoei99rz3XgU7VNwJeavnEz0GsyJmIvMgHrE0izrFFZvroRx3E9VtfakAL9NHp19d
	 VQuOltonVIdWdj/wvo4Tpuxd/d9rsAo54T9ge1uPmNywJGYnVxsURxoubXOxfzo1ug
	 +fEKPUIj/96t0Fc8sUm+8p9k/CbLPQdhAJb644RU=
Date: Sat, 13 Sep 2025 17:35:47 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,yangyicong@hisilicon.com,ville.syrjala@linux.intel.com,vgoyal@redhat.com,tzimmermann@suse.de,tony.luck@intel.com,tj@kernel.org,thorsten.blum@linux.dev,tglx@linutronix.de,sohil.mehta@intel.com,senozhatsky@chromium.org,rostedt@goodmis.org,qianqiang.liu@163.com,pmladek@suse.com,oushixiong@kylinos.cn,namcao@linutronix.de,mingo@kernel.org,max.kellermann@ionos.com,luogengkun@huaweicloud.com,lihuafei1@huawei.com,kees@kernel.org,Jonathan.Cameron@huawei.com,john.ogness@linutronix.de,joel.granados@kernel.org,jgg@ziepe.ca,gpiccoli@igalia.com,dyoung@redhat.com,djwong@kernel.org,dianders@chromium.org,deller@gmx.de,cuiyunhui@bytedance.com,bhe@redhat.com,anna.schumaker@oracle.com,wangjinchao600@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-skip-checks-when-panic-is-in-progress.patch removed from -mm tree
Message-Id: <20250914003547.D5567C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog: skip checks when panic is in progress
has been removed from the -mm tree.  Its filename was
     watchdog-skip-checks-when-panic-is-in-progress.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinchao Wang <wangjinchao600@gmail.com>
Subject: watchdog: skip checks when panic is in progress
Date: Mon, 25 Aug 2025 10:29:37 +0800

This issue was found when an EFI pstore was configured for kdump logging
with the NMI hard lockup detector enabled.  The efi-pstore write operation
was slow, and with a large number of logs, the pstore dump callback within
kmsg_dump() took a long time.

This delay triggered the NMI watchdog, leading to a nested panic.  The
call flow demonstrates how the secondary panic caused an
emergency_restart() to be triggered before the initial pstore operation
could finish, leading to a failure to dump the logs:

  real panic() {
	kmsg_dump() {
		...
		pstore_dump() {
			start_dump();
			... // long time operation triggers NMI watchdog
			nmi panic() {
				...
				emergency_restart(); // pstore unfinished
			}
			...
			finish_dump(); // never reached
		}
	}
  }

Both watchdog_buddy_check_hardlockup() and watchdog_overflow_callback()
may trigger during a panic.  This can lead to recursive panic handling.

Add panic_in_progress() checks so watchdog activity is skipped once a
panic has begun.

This prevents recursive panic and keeps the panic path more reliable.

Link: https://lkml.kernel.org/r/20250825022947.1596226-10-wangjinchao600@gmail.com
Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
Reviewed-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c      |    6 ++++++
 kernel/watchdog_perf.c |    4 ++++
 2 files changed, 10 insertions(+)

--- a/kernel/watchdog.c~watchdog-skip-checks-when-panic-is-in-progress
+++ a/kernel/watchdog.c
@@ -752,6 +752,12 @@ static enum hrtimer_restart watchdog_tim
 	if (!watchdog_enabled)
 		return HRTIMER_NORESTART;
 
+	/*
+	 * pass the buddy check if a panic is in process
+	 */
+	if (panic_in_progress())
+		return HRTIMER_NORESTART;
+
 	watchdog_hardlockup_kick();
 
 	/* kick the softlockup detector */
--- a/kernel/watchdog_perf.c~watchdog-skip-checks-when-panic-is-in-progress
+++ a/kernel/watchdog_perf.c
@@ -12,6 +12,7 @@
 
 #define pr_fmt(fmt) "NMI watchdog: " fmt
 
+#include <linux/panic.h>
 #include <linux/nmi.h>
 #include <linux/atomic.h>
 #include <linux/module.h>
@@ -108,6 +109,9 @@ static void watchdog_overflow_callback(s
 	/* Ensure the watchdog never gets throttled */
 	event->hw.interrupts = 0;
 
+	if (panic_in_progress())
+		return;
+
 	if (!watchdog_check_timestamp())
 		return;
 
_

Patches currently in -mm which might be from wangjinchao600@gmail.com are


