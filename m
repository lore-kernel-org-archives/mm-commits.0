Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F82D154BF5
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810142; cv=none; b=myjVQU1ro6cJL4Fmgm5/miOoBDY9I6/Cmwk3bVKrOx5eJ0VcQU7mZ+q0wh0MFSZ9UJwEr+cPJ5MFddf4u+6RnYVqTEhdfbzCZlma29f8PVtEU3QG8TjxTqI6LRCsEVVRvfNruu9MH4QWCgNs3TuxOhplRDCmStQqpd4jJNFBoRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810142; c=relaxed/simple;
	bh=hyyiXJaljtQpbLrmLUsY6Y3ojhZK2eJ6gC17B/40yIk=;
	h=Date:To:From:Subject:Message-Id; b=kNazoImwkzvjMhe6oXDt7lPpdNxGN8VYrhl/INIVn5ymYzZcqpjI/GnrbM0EzL96nsZwRpyBqVZbNJ2ycF4mGtMv3ZiIBn8VkR/xtHKisIDMY+Imp48EBb0UO5BlKxEmuTWOfMv6tr19TpefCa/YAZ6GkCtFamxVcZCBTodARHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TlffIAnS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TlffIAnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13C3C4CEEB;
	Sun, 14 Sep 2025 00:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810142;
	bh=hyyiXJaljtQpbLrmLUsY6Y3ojhZK2eJ6gC17B/40yIk=;
	h=Date:To:From:Subject:From;
	b=TlffIAnSnMXullJESXzNEd14If6wf/OJ4XXGzV5cHdwDCJFy16XycYdmZeAcMiDml
	 VJgbZ7Fdb3+WeRTI0lZb/fAH5I2XTeMoHjgiQrJbprte6ALORXuNSAEQVnKsD2wIwg
	 5SA757CJbBqWSgBAwzM4sZl6/b/b0/YVRpXmyJkU=
Date: Sat, 13 Sep 2025 17:35:41 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,yangyicong@hisilicon.com,ville.syrjala@linux.intel.com,vgoyal@redhat.com,tzimmermann@suse.de,tony.luck@intel.com,tj@kernel.org,thorsten.blum@linux.dev,tglx@linutronix.de,sohil.mehta@intel.com,senozhatsky@chromium.org,rostedt@goodmis.org,qianqiang.liu@163.com,pmladek@suse.com,oushixiong@kylinos.cn,namcao@linutronix.de,mingo@kernel.org,max.kellermann@ionos.com,luogengkun@huaweicloud.com,lihuafei1@huawei.com,kees@kernel.org,Jonathan.Cameron@huawei.com,john.ogness@linutronix.de,joel.granados@kernel.org,jgg@ziepe.ca,gpiccoli@igalia.com,dyoung@redhat.com,djwong@kernel.org,dianders@chromium.org,deller@gmx.de,cuiyunhui@bytedance.com,bhe@redhat.com,anna.schumaker@oracle.com,wangjinchao600@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-use-panic_try_start-in-vpanic.patch removed from -mm tree
Message-Id: <20250914003541.E13C3C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: use panic_try_start() in vpanic()
has been removed from the -mm tree.  Its filename was
     panic-use-panic_try_start-in-vpanic.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


