Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A695A145329
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810140; cv=none; b=Y1WBrdUT+GOkZE4LsSKjEKocoP43Cc2PoD3IgxCkpCAS+nWQiabMc7uiqgEZ/zKjLbzSnY9gPdqKaPGttP/dQHG4ly5VvH3bpAArEcLqO7Ut2yxVhGX7FB0HyjwZ99d+pwyEPVIBQ4g+tgVNqxFK/dEcwu2lGWV0Oj4tXht49Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810140; c=relaxed/simple;
	bh=BYO8ZHh4x+kGC5Eh0y3vvsffmpIqQTdUvw1zfWgKs10=;
	h=Date:To:From:Subject:Message-Id; b=PSu0xIxqkpOzB9LJwM0RpXSHmEUwq2M3r9ZqJo4ORGLP1WxL6lqcM7zLCGnKwPf6XV0xTqo4IgnhM11wl7nIDIckTyBqOthLFUXFbTHArvLoS/CV2mJgiQuRbhOS2NQ3wpY22HugVZiNqCfTkUcffO3JIcBn+6pi9vLv75mfndQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UJ+STU+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UJ+STU+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760CDC4CEEB;
	Sun, 14 Sep 2025 00:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810140;
	bh=BYO8ZHh4x+kGC5Eh0y3vvsffmpIqQTdUvw1zfWgKs10=;
	h=Date:To:From:Subject:From;
	b=UJ+STU+Mxs0baC32tDHgGcSKzNPSsFRaz9kJBkMUS1aGTAUHtDd8SGxzkCqKknzlr
	 B9OzgIFKOn00Cr73esEkIShyIrTeTh2bUc2OXUv4D5ocpyD8tRlm7qJ9Jc9CLgfjJa
	 pewSuSn0fJOBcsS5wehwX9xIg286lN5E+Yc8vzg4=
Date: Sat, 13 Sep 2025 17:35:40 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,yangyicong@hisilicon.com,ville.syrjala@linux.intel.com,vgoyal@redhat.com,tzimmermann@suse.de,tony.luck@intel.com,tj@kernel.org,thorsten.blum@linux.dev,tglx@linutronix.de,sohil.mehta@intel.com,senozhatsky@chromium.org,rostedt@goodmis.org,qianqiang.liu@163.com,pmladek@suse.com,oushixiong@kylinos.cn,namcao@linutronix.de,mingo@kernel.org,max.kellermann@ionos.com,luogengkun@huaweicloud.com,lihuafei1@huawei.com,kees@kernel.org,Jonathan.Cameron@huawei.com,john.ogness@linutronix.de,joel.granados@kernel.org,jgg@ziepe.ca,gpiccoli@igalia.com,dyoung@redhat.com,djwong@kernel.org,dianders@chromium.org,deller@gmx.de,cuiyunhui@bytedance.com,bhe@redhat.com,anna.schumaker@oracle.com,wangjinchao600@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-use-panic_try_start-in-nmi_panic.patch removed from -mm tree
Message-Id: <20250914003540.760CDC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: use panic_try_start() in nmi_panic()
has been removed from the -mm tree.  Its filename was
     panic-use-panic_try_start-in-nmi_panic.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinchao Wang <wangjinchao600@gmail.com>
Subject: panic: use panic_try_start() in nmi_panic()
Date: Mon, 25 Aug 2025 10:29:32 +0800

nmi_panic() duplicated the logic to claim panic_cpu with
atomic_try_cmpxchg.  This is already wrapped in panic_try_start().

Replace the open-coded logic with panic_try_start(), and use
panic_on_other_cpu() for the fallback path.

This removes duplication and keeps panic handling code consistent.

Link: https://lkml.kernel.org/r/20250825022947.1596226-5-wangjinchao600@gmail.com
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

 kernel/panic.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/kernel/panic.c~panic-use-panic_try_start-in-nmi_panic
+++ a/kernel/panic.c
@@ -360,15 +360,9 @@ EXPORT_SYMBOL(panic_on_other_cpu);
  */
 void nmi_panic(struct pt_regs *regs, const char *msg)
 {
-	int old_cpu, this_cpu;
-
-	old_cpu = PANIC_CPU_INVALID;
-	this_cpu = raw_smp_processor_id();
-
-	/* atomic_try_cmpxchg updates old_cpu on failure */
-	if (atomic_try_cmpxchg(&panic_cpu, &old_cpu, this_cpu))
+	if (panic_try_start())
 		panic("%s", msg);
-	else if (old_cpu != this_cpu)
+	else if (panic_on_other_cpu())
 		nmi_panic_self_stop(regs);
 }
 EXPORT_SYMBOL(nmi_panic);
_

Patches currently in -mm which might be from wangjinchao600@gmail.com are


