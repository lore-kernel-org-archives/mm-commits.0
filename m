Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEAD2A1BF
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 00:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756167992; cv=none; b=V+W3mL7/a/EYrgxAjTCbO0Vmby0+uSdFHzcVMgxZJAp7Hh3eFciq4uis3OCkmyYqSHr1U1tGlRmXqtioXXqInJE2DB1M4mZQxRdnS08cA5uvgsvrM/cosL+C6X6DTyYJe04hYjEdHvCpOKm41PyYK1Hgvt7/YqJxa/z+UPj54OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756167992; c=relaxed/simple;
	bh=xlW8KQPrld/ltIL4MjF0wj+zvMbEP+rZDplo3VihJb8=;
	h=Date:To:From:Subject:Message-Id; b=JmLMbfMZ4Xfr2Hu+ZZtwMLAOYybJhXE5LLunROsptq6jcRoiuzuso8YU3paUmYfpDI5FJaoMcX+hY7kAY+qFf2Z5T8MNGxpqmjiOxCKh9d0AUJcXk40jfX371gfRoDaPZHAeHv5WkosKZaNbCFmMi1HAIjxmTGs8QbTcVs89RlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AsQue3X+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AsQue3X+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD4BC4CEF4;
	Tue, 26 Aug 2025 00:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756167992;
	bh=xlW8KQPrld/ltIL4MjF0wj+zvMbEP+rZDplo3VihJb8=;
	h=Date:To:From:Subject:From;
	b=AsQue3X+QsRUvdkTiHPt4NKC7oZz8n2gFKjTWLfSSIfG/oFkNAZxWJT52CsH4LaQy
	 t492ryFKZaPOlfdBj/OO8/SryATM+IUsT/je37ObnaSJ2O5Q+/rsUZDbuNlHZi3I/8
	 e+mMXmnQoq27gmK6oeQioFLfp3QRig11dfNpuWc4=
Date: Mon, 25 Aug 2025 17:26:31 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,yangyicong@hisilicon.com,ville.syrjala@linux.intel.com,vgoyal@redhat.com,tzimmermann@suse.de,tony.luck@intel.com,tj@kernel.org,thorsten.blum@linux.dev,tglx@linutronix.de,sohil.mehta@intel.com,senozhatsky@chromium.org,rostedt@goodmis.org,qianqiang.liu@163.com,pmladek@suse.com,oushixiong@kylinos.cn,namcao@linutronix.de,mingo@kernel.org,max.kellermann@ionos.com,luogengkun@huaweicloud.com,lihuafei1@huawei.com,kees@kernel.org,Jonathan.Cameron@huawei.com,john.ogness@linutronix.de,joel.granados@kernel.org,jgg@ziepe.ca,gpiccoli@igalia.com,dyoung@redhat.com,djwong@kernel.org,dianders@chromium.org,deller@gmx.de,cuiyunhui@bytedance.com,bhe@redhat.com,anna.schumaker@oracle.com,wangjinchao600@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-use-panic_try_start-in-vpanic.patch added to mm-nonmm-unstable branch
Message-Id: <20250826002632.5AD4BC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: use panic_try_start() in vpanic()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-use-panic_try_start-in-vpanic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-use-panic_try_start-in-vpanic.patch

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
Subject: panic: use panic_try_start() in vpanic()
Date: Mon, 25 Aug 2025 10:29:33 +0800

vpanic() had open-coded logic to claim panic_cpu with atomic_try_cmpxchg. 
This is already handled by panic_try_start().

Switch to panic_try_start() and use panic_on_other_cpu() for the fallback
path.

This removes duplicate code and makes panic handling consistent across
functions.

Link: https://lkml.kernel.org/r/20250825022947.1596226-6-wangjinchao600@gmail.com
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

 kernel/panic.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/kernel/panic.c~panic-use-panic_try_start-in-vpanic
+++ a/kernel/panic.c
@@ -420,7 +420,6 @@ void vpanic(const char *fmt, va_list arg
 	static char buf[1024];
 	long i, i_next = 0, len;
 	int state = 0;
-	int old_cpu, this_cpu;
 	bool _crash_kexec_post_notifiers = crash_kexec_post_notifiers;
 
 	if (panic_on_warn) {
@@ -457,13 +456,10 @@ void vpanic(const char *fmt, va_list arg
 	 * `old_cpu == this_cpu' means we came from nmi_panic() which sets
 	 * panic_cpu to this CPU.  In this case, this is also the 1st CPU.
 	 */
-	old_cpu = PANIC_CPU_INVALID;
-	this_cpu = raw_smp_processor_id();
-
 	/* atomic_try_cmpxchg updates old_cpu on failure */
-	if (atomic_try_cmpxchg(&panic_cpu, &old_cpu, this_cpu)) {
+	if (panic_try_start()) {
 		/* go ahead */
-	} else if (old_cpu != this_cpu)
+	} else if (panic_on_other_cpu())
 		panic_smp_self_stop();
 
 	console_verbose();
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

